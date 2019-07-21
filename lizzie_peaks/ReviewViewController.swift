//
//  ReviewViewController.swift
//  lizzie_peaks
//
//  Created by Curtis Chong on 2019-02-02.
//  Copyright © 2019 Curtis Chong. All rights reserved.
//
// TODO: show the duration of the review and when the review took place at the top of the view controller
import UIKit

class ReviewViewController: UIViewController {

    @IBOutlet weak var mainConceptLabel: UILabel!
    @IBOutlet weak var newLearningsTextView: UITextView!
    
    let dataManager = DataManager()
    let networkManager = NetworkManager()
    
    var reviewData : ReviewObj!
    var conceptViewControllerRef : UIViewController!
    var conceptDelegate : conceptProtocol?
    private let generator = UIImpactFeedbackGenerator(style: .light)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainConceptLabel.text = reviewData.concept
        
        
        newLearningsTextView.layer.borderColor = UIColor(red:1.00, green:0.51, blue:0.28, alpha:1.0).cgColor
        newLearningsTextView.layer.borderWidth = 1.0
        newLearningsTextView.layer.cornerRadius = 5
        newLearningsTextView.isScrollEnabled = false
        newLearningsTextView.text = reviewData.newLearnings
        
        
        //NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
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
    
    func reviewFormFilled() -> Bool{
        if(newLearningsTextView.text != ""){
            return true
        }
        return false
    }
    
    @IBAction func deleteReviewBtn(_ sender: UIButton) {
        generator.impactOccurred()
        dataManager.deleteReview(timeReviewed: reviewData.timeReviewed)
        conceptDelegate?.reloadReviewTable()
        self.conceptViewControllerRef.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func done(_ sender: UIButton) {
        generator.impactOccurred()
        conceptDelegate?.reloadReviewTable()
        if(reviewFormFilled()){
            networkManager.uploadReview(review: reviewData)
        }
        self.conceptViewControllerRef.dismiss(animated: true, completion: nil)
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
        if(newLearningsTextView.isFirstResponder){
            NSLog("saved newLearnings!")
            reviewData.newLearnings = newLearningsTextView.text!
            dataManager.updateReview(review: reviewData)
            
        }
    }
    
}
