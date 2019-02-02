//
//  SecondViewController.swift
//  lizzie_peaks
//
//  Created by Curtis Chong on 2019-01-31.
//  Copyright © 2019 Curtis Chong. All rights reserved.
//


// I think people should prematurely review concepts
import UIKit
import CoreData

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let dataManager = DataManager()
    var allReviews : [NSManagedObject] = []
    let cellReuseIdentifier = "reviewCell"
    let displayDateFormatter = DateFormatter()
    @IBOutlet weak var reviewTable: UITableView!
    @IBOutlet weak var reviewsCntLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayDateFormatter.dateFormat = "MMM d, h:mm a"

        reviewTable.delegate = self
        reviewTable.dataSource = self
        reviewTable.tableFooterView = UIView()
        reviewTable.separatorColor = UIColor.white
    }

    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        allReviews = dataManager.getAllEntities(entityName: "Review")
        reviewsCntLabel.text = String(allReviews.count)
        return allReviews.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:ReviewTableViewCell = self.reviewTable.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! ReviewTableViewCell
        if allReviews.count > indexPath.row{
            let cellData = allReviews[indexPath.row]
            
            let newDate = cellData.value(forKey: "timeLearned") as! Date
            
            cell.mainConceptLabel.text = (cellData.value(forKey: "concept") as! String)
            cell.scheduledDateLabel.text = self.displayDateFormatter.string(from: newDate)
            // cell.mainConceptLabel.text = self.allSkills[indexPath.row]
        }
        
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
    

}

