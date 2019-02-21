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
    var verboseLogs : Bool!
    var allSkills : [SkillObj] = []
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
            if(cellData.scheduledReviews.count == 0){
                cell.contentView.backgroundColor = UIColor(red:1.00, green:0.52, blue:0.52, alpha:1.0)
            }else{
                cell.contentView.backgroundColor = settingsManager.defaultColor
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
        self.skillsTableView.reloadData()
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

