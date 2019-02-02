//
//  FirstViewController.swift
//  lizzie_peaks
//
//  Created by Curtis Chong on 2019-01-31.
//  Copyright © 2019 Curtis Chong. All rights reserved.
//

import UIKit
import CoreData
class FirstViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{

    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var addNewSkillBtn: UIButton!
    
    
    @IBOutlet weak var skillTableView: UITableView!
    
    // These strings will be the data for the table view cells
    let animals: [String] = ["Horse", "Cow", "Camel", "Sheep", "Goat"]
    
    // These are the colors of the square views in our table view cells.
    // In a real project you might use UIImages.
    let colors = [UIColor.blue, UIColor.yellow, UIColor.magenta, UIColor.red, UIColor.brown]
    
    // Don't forget to enter this in IB also
    let cellReuseIdentifier = "skillCell"
    let dataManager = DataManager()
    var allSkills : [NSManagedObject] = []
    let displayDateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayDateFormatter.dateFormat = "MMM d, h:mm a"
        // Do any additional setup after loading the view, typically from a nib.
        tableView.delegate = self
        tableView.dataSource = self
        addNewSkillBtn.layer.zPosition = 1;
        tableView.tableFooterView = UIView()
        tableView.separatorColor = UIColor.white
    
        allSkills = dataManager.getAllSkills()
    }

    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.animals.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:SkillTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! SkillTableViewCell
        let cellData = allSkills[indexPath.row]
        
        let newDate = Date(timeIntervalSince1970: (cellData.value(forKey: "timeLearned") as! Double))
        
        cell.mainConceptLabel.text = (cellData.value(forKey: "concept") as! String)
        cell.dateLearnedLabel.text = self.displayDateFormatter.string(from: newDate)
        // cell.mainConceptLabel.text = self.allSkills[indexPath.row]
        
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
    
    
    
    
    


    @IBAction func addConceptBtn(_ sender: UIButton) {
        performSegue(withIdentifier: "addConceptSegue", sender: self)
    }
}

