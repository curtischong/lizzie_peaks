//
//  TimerViewController.swift
//  
//
//  Created by Curtis Chong on 2019-02-06.
//

import UIKit

class TimerViewController: UIViewController {
    
    
    @IBOutlet weak var recommendedDuration: UILabel!
    
    @IBOutlet weak var curTime: UILabel!
    var skillData : SkillObj!
    override func viewDidLoad() {
        super.viewDidLoad()
        NSLog("test")
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
