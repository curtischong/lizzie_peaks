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
    @IBOutlet weak var endBtn: UIButton!
    
    var timer : Timer!
    var skillData : SkillObj!
    var pressedStart = false
    var isTimerRunning = false
    var timePassed = 0
    var timeReviewed = Date()

    override func viewDidLoad() {
        super.viewDidLoad()
        endBtn.isEnabled = false
        

        // Don't know how to implement the recommended time
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
            endBtn.isEnabled = true
        }else{
            if(isTimerRunning){
                isTimerRunning = false
                startBtn.setTitle("Continue Timing", for: .normal)
                timer.invalidate()
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
    
    func timeString(time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    // Timer expects @objc selector
    @objc func updateTimer(timer: Timer!) {
        timePassed += 1
        curTime.text = timeString(time: TimeInterval(timePassed))
    }
    
    @IBAction func endTimer(_ sender: UIButton) {
        timer.invalidate()
        skillData.reviews.append(timeReviewed)
        skillData.reviewDurations.append(timePassed)
        performSegue(withIdentifier: "reviewSegue", sender: skillData)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let pop = segue.destination as? ReviewViewController {
            pop.skillData = sender as? SkillObj
        }
    }
    
    @IBAction func backBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
