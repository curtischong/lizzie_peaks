//
//  FirstViewController.swift
//  lizzie_peaks
//
//  Created by Curtis Chong on 2019-01-31.
//  Copyright © 2019 Curtis Chong. All rights reserved.
//
//TODO: if there are partially filled out skills, lizzie will send a notification telling you to finish them ever 2 hours
//TODO: Sort the skills by red (need to be filled) then by blue (skills I need to review today)
import UIKit

protocol learningsProtocol {
    func reloadLearningsTable()
}

class FirstViewController: UIViewController , UITableViewDelegate, UITableViewDataSource, learningsProtocol{

    @IBOutlet weak var addNewSkillBtn: UIButton!
    
    @IBOutlet weak var skillsTableView: UITableView!
    @IBOutlet weak var leaningsCntLabel: UILabel!
    // These strings will be the data for the table view cells
    
    // These are the colors of the square views in our table view cells.
    // In a real project you might use UIImages.
    let colors = [UIColor.blue, UIColor.yellow, UIColor.magenta, UIColor.red, UIColor.brown]
    
    // Don't forget to enter this in IB also
    let cellReuseIdentifier = "skillCell"
    let dataManager = DataManager()
    let settingsManager = SettingsManager()
    let reviewScheduleManager = ReviewScheduleManager()
    var verboseLogs : Bool!
    var allSkills : [SkillObj] = []
    var scheduledTodaySkillsIdx = 999
    var otherSkillsIdx = 999
    let displayDateFormatter = DateFormatter()
    private let generator = UIImpactFeedbackGenerator(style: .light)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        verboseLogs = settingsManager.verboseLogs
        addNewSkillBtn.layer.zPosition = 1;
        displayDateFormatter.dateFormat = "MMM d, h:mm a"

        skillsTableView.delegate = self
        skillsTableView.dataSource = self
        skillsTableView.tableFooterView = UIView()
        skillsTableView.separatorColor = UIColor.white
    
        let permissionsManager = PermissionsManager()
        permissionsManager.requestPermissions()
    }

    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        allSkills = dataManager.getAllSkills()
        sortSkills()
        if (verboseLogs){
            NSLog("Found \(allSkills.count) skills")
        }
        leaningsCntLabel.text = String(allSkills.count)
        return allSkills.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:SkillTableViewCell = self.skillsTableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! SkillTableViewCell
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        if indexPath.row < allSkills.count {
            let cellData = allSkills[indexPath.row]
            
            let newDate = cellData.timeLearned
            
            cell.mainConceptLabel.text = (cellData.concept)
            cell.dateLearnedLabel.text = self.displayDateFormatter.string(from: newDate)
            if(indexPath.row >= otherSkillsIdx){
                cell.contentView.backgroundColor = settingsManager.defaultColor
            }else if(indexPath.row >= scheduledTodaySkillsIdx){
                cell.contentView.backgroundColor = UIColor(red:0.20, green:0.71, blue:0.78, alpha:1.0)
                //UIColor(red:1.0,green:0.0,blue:0.0,alpha:1.0)
            }else{
                cell.contentView.backgroundColor = UIColor(red:1.00, green:0.52, blue:0.52, alpha:1.0)
            }
            // cell.mainConceptLabel.text = self.allSkills[indexPath.row]
        }
        
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        generator.impactOccurred()
        performSegue(withIdentifier: "conceptSegue", sender: allSkills[indexPath.row])
        if(verboseLogs){
            print("You tapped cell number \(indexPath.row).")
        }
    }
    

    @IBAction func settingsBtn(_ sender: UIButton) {
        generator.impactOccurred()
        performSegue(withIdentifier: "settingsSegue", sender: self)
    }
    
    @IBAction func addConceptBtn(_ sender: UIButton) {
        generator.impactOccurred()
        let timeLearned = Date()
        let curSkill = SkillObj(timeLearned : timeLearned)
        dataManager.insertSkill(skill: curSkill)
        
        performSegue(withIdentifier: "conceptSegue", sender: curSkill)
    }
    
    func reloadLearningsTable(){
        NSLog("reloaded Table")
        allSkills = dataManager.getAllSkills()
        sortSkills()
        self.skillsTableView.reloadData()
    }
    
    func sortSkills(){
        // Sorts the skills for the tableView
        // the order goes from:
        // 1. incomplete
        // 2. review today
        // 3, other tasks
        
        var incompleteSkills : [SkillObj] = []
        var scheduledTodaySkills : [SkillObj] = []
        var otherSkills : [SkillObj] = []
        for skill in allSkills{

            if(skill.scheduledReviews.count == 0){
                incompleteSkills.append(skill)
            }else{
                let scheduledMorning = skill.scheduledReviews.last!
                
                let thisMorning = reviewScheduleManager.nextMorning(date : Date().addingTimeInterval(TimeInterval(-60.0 * 60.0 * 24.0)))
                //let thisMorning = reviewScheduleManager.nextMorning(date : Date())
                //NSLog("\(scheduledMorning)")
                NSLog("\(skill.reviews.count)")
                if(skill.reviews.count > 0){
                    let lastReview = reviewScheduleManager.nextMorning(date : skill.reviews.last!.addingTimeInterval(TimeInterval(-60.0 * 60.0 * 24.0)))
                    //let lastReview = reviewScheduleManager.nextMorning(date : skill.reviews.last!)
                    
                    if(scheduledMorning == thisMorning && lastReview < scheduledMorning){
                        scheduledTodaySkills.append(skill)
                    }else{
                        otherSkills.append(skill)
                    }
                    
                }else if(scheduledMorning == thisMorning){
                    scheduledTodaySkills.append(skill)
                }else{
                    otherSkills.append(skill)
                }
            }
        }
        allSkills = incompleteSkills
        scheduledTodaySkillsIdx = allSkills.count
        for skill in scheduledTodaySkills{
            allSkills.append(skill)
        }
        otherSkillsIdx = allSkills.count
        for skill in otherSkills{
            allSkills.append(skill)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let pop = segue.destination as? ConceptViewController {
            pop.skillData = sender as? SkillObj
            pop.learningsDelegate = self
        }
        if let pop = segue.destination as? SettingsViewController {
            pop.learningsDelegate = self
        }
    }
}

