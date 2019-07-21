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
    let dataManager = DataManager()
    let reviewScheduleManager = ReviewScheduleManager()
    var conceptViewControllerRef : UIViewController!
    var conceptDelegate : conceptProtocol?
    private let generator = UIImpactFeedbackGenerator(style: .light)

    override func viewDidLoad() {
        super.viewDidLoad()
        endBtn.isEnabled = false
        

        // Don't know how to implement the recommended time
        /*for review in skillData.scheduledReviews{
            if reviewDate
        }*/

    }
    @IBAction func toggleTimer(_ sender: Any) {
        generator.impactOccurred()
        if(!pressedStart){
            pressedStart = true
            isTimerRunning = true
            startBtn.setTitle("Pause Timer", for: .normal)
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
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer(timer:)), userInfo: [], repeats: true)
    }
    
    // Timer expects @objc selector
    @objc func updateTimer(timer: Timer!) {
        timePassed += 1
        curTime.text = timeString(time: TimeInterval(timePassed))
    }
    
    @IBAction func endTimer(_ sender: UIButton) {
        generator.impactOccurred()
        timer.invalidate()
        skillData.reviews.append(timeReviewed)
        skillData.reviewDurations.append(timePassed)
        dataManager.updateSkill(skill: skillData)
        reviewScheduleManager.scheduleReview(skill: skillData)
        
        let reviewData = ReviewObj(
            concept : skillData.concept,
            timeReviewed : timeReviewed,
            reviewDuration : timePassed,
            timeLearned : skillData.timeLearned)
        dataManager.insertReview(review : reviewData)
        
        performSegue(withIdentifier: "reviewSegue", sender: reviewData)

    }
    
    func timeString(time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let pop = segue.destination as? ReviewViewController {
            pop.reviewData = sender as? ReviewObj
            pop.conceptDelegate = self.conceptDelegate
            pop.conceptViewControllerRef = self.conceptViewControllerRef
        }
    }
    
    @IBAction func backBtn(_ sender: Any) {
        generator.impactOccurred()
        dismiss(animated: true, completion: nil)
    }
}
