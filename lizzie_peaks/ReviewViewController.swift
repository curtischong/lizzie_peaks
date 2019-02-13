//
//  ReviewViewController.swift
//  lizzie_peaks
//
//  Created by Curtis Chong on 2019-02-02.
//  Copyright © 2019 Curtis Chong. All rights reserved.
//

import UIKit

class ReviewViewController: UIViewController {

    @IBOutlet weak var mainConceptLabel: UILabel!
    @IBOutlet weak var newLearningsTextView: UITextView!
    
    var skillData : SkillObj!
    let dataManager = DataManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        mainConceptLabel.text = skillData.concept
        
        
        newLearningsTextView.layer.borderColor = UIColor(red:1.00, green:0.51, blue:0.28, alpha:1.0).cgColor
        newLearningsTextView.layer.borderWidth = 1.0
        newLearningsTextView.layer.cornerRadius = 5
        newLearningsTextView.isScrollEnabled = false
    }
    @IBAction func submitReview(_ sender: UIButton) {
        let curReviewIdx = skillData.reviews.count - 1
        let curReview = ReviewObj(
            concept : skillData.concept,
            dateReviewed : skillData.reviews[curReviewIdx],
            newLearnings : newLearningsTextView.text,
            reviewDuration : skillData.reviewDurations[curReviewIdx])
        dataManager.insertReview(review : curReview)
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
        if(newLearningsTextView.isFirstResponder){
            NSLog("saved newLearnings!")
            skillData.concept = newLearningsTextView.text!
            //dataManager.updateReview(skill: skillData)
            
        }
    }
    
}
