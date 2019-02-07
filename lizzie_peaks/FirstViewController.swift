//
//  FirstViewController.swift
//  lizzie_peaks
//
//  Created by Curtis Chong on 2019-01-31.
//  Copyright © 2019 Curtis Chong. All rights reserved.
//

import UIKit

protocol learningsProtocol {
    func reloadLearningsTable()
}

class FirstViewController: UIViewController , UITableViewDelegate, UITableViewDataSource, learningsProtocol{

    @IBOutlet var skillsTable: UITableView!
    @IBOutlet weak var addNewSkillBtn: UIButton!
    
    
    @IBOutlet weak var skillTableView: UITableView!
    
    @IBOutlet weak var leaningsCntLabel: UILabel!
    // These strings will be the data for the table view cells
    
    // These are the colors of the square views in our table view cells.
    // In a real project you might use UIImages.
    let colors = [UIColor.blue, UIColor.yellow, UIColor.magenta, UIColor.red, UIColor.brown]
    
    // Don't forget to enter this in IB also
    let cellReuseIdentifier = "skillCell"
    let dataManager = DataManager()
    var allSkills : [SkillObj] = []
    let displayDateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addNewSkillBtn.layer.zPosition = 1;
        displayDateFormatter.dateFormat = "MMM d, h:mm a"

        skillsTable.delegate = self
        skillsTable.dataSource = self
        skillsTable.tableFooterView = UIView()
        skillsTable.separatorColor = UIColor.white
    
        let permissionsManager = PermissionsManager()
        permissionsManager.requestPermissions()
    }

    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        allSkills = dataManager.getAllSkills(entityName: "Skill")
        leaningsCntLabel.text = String(allSkills.count)
        return allSkills.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:SkillTableViewCell = self.skillsTable.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! SkillTableViewCell
        if allSkills.count > indexPath.row{
            let cellData = allSkills[indexPath.row]
            
            let newDate = cellData.timeLearned
            
            cell.mainConceptLabel.text = (cellData.concept)
            cell.dateLearnedLabel.text = self.displayDateFormatter.string(from: newDate)
            // cell.mainConceptLabel.text = self.allSkills[indexPath.row]
        }
        
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
    

    @IBAction func settingsBtn(_ sender: UIButton) {
        performSegue(withIdentifier: "settingsSegue", sender: self)
    }
    
    @IBAction func addConceptBtn(_ sender: UIButton) {
        let concept = "New Concept"
        let newLearnings = ""
        let oldSkills = ""
        let percentNew = 0
        let timeLearned = Date()
        let timeSpentLearning = 0
        
        let curSkill = SkillObj(concept : concept,
                                newLearnings : newLearnings,
                                oldSkills : oldSkills,
                                percentNew : percentNew,
                                timeLearned : timeLearned,
                                timeSpentLearning : timeSpentLearning)
        
        dataManager.insertSkill(skill: curSkill)
        
        performSegue(withIdentifier: "addConceptSegue", sender: curSkill)
    }
    
    func reloadLearningsTable(){
        self.skillsTable.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let pop = segue.destination as? ConceptViewController {
            pop.skillData = sender as! SkillObj
            pop.learningsDelegate = self
        }
        if let pop = segue.destination as? SettingsViewController {
            pop.learningsDelegate = self
        }
    }
}

