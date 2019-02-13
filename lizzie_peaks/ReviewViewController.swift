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
    
    var reviewData : ReviewObj!
    let dataManager = DataManager()
    var conceptViewControllerRef : UIViewController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainConceptLabel.text = reviewData.concept
        
        
        newLearningsTextView.layer.borderColor = UIColor(red:1.00, green:0.51, blue:0.28, alpha:1.0).cgColor
        newLearningsTextView.layer.borderWidth = 1.0
        newLearningsTextView.layer.cornerRadius = 5
        newLearningsTextView.isScrollEnabled = false
        
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: self.view.frame.size.width, height: 30))
        //create left side empty space so that done button set on right side
        let flexSpace = UIBarButtonItem(barButtonSystemItem:    .flexibleSpace, target: nil, action: nil)
        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonAction))
        toolbar.setItems([flexSpace, doneBtn], animated: false)
        toolbar.sizeToFit()
        //setting toolbar as inputAccessoryView
        self.newLearningsTextView.inputAccessoryView = toolbar
    }
    
    @objc func doneButtonAction() {
        self.view.endEditing(true)
    }
    
    @IBAction func done(_ sender: UIButton) {
        // TODO: pass a reference to the concept view controller
       self.conceptViewControllerRef.dismiss(animated: true, completion: nil)
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
        if(newLearningsTextView.isFirstResponder){
            NSLog("saved newLearnings!")
            reviewData.concept = newLearningsTextView.text!
            dataManager.updateReview(review: reviewData)
            
        }
    }
    
}
