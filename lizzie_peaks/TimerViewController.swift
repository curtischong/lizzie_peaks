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
    
    @IBOutlet weak var startBtn: UIButton!
    
    
    var timer : Timer!
    var skillData : SkillObj!
    var pressedStart = false
    var isTimerRunning = false
    var timePassed = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        // Don't know how to implement this
        /*for review in skillData.scheduledReviews{
            if reviewDate
        }*/

    }
    @IBAction func toggleTimer(_ sender: Any) {
        if(!pressedStart){
            pressedStart = true
            isTimerRunning = true
            startBtn.setTitle("Timing", for: .normal)
            runTimer()
            
        }else{
            if(isTimerRunning){
                isTimerRunning = false
                startBtn.setTitle("Continue Timing", for: .normal)
            }else{
                isTimerRunning = true
                startBtn.setTitle("Pause Timer", for: .normal)
                runTimer()
            }
        }
    }
    
    func runTimer(){
        timer = Timer.scheduledTimer(timeInterval: 1.0,
                                     target: self,
                                     selector: #selector(updateTimer(timer:)),
                                     userInfo: [],
                                     repeats: true)
    }
    
    // Timer expects @objc selector
    @objc func updateTimer(timer: Timer!) {
        timePassed += 1
        curTime.text = String(timePassed)
    }
}
