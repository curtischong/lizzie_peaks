//
//  AddConceptViewController.swift
//  lizzie_peaks
//
//  Created by Curtis Chong on 2019-01-31.
//  Copyright © 2019 Curtis Chong. All rights reserved.
//

import UIKit

class AddConceptViewController: UIViewController {

    @IBOutlet weak var timeSpentLearningLabel: UILabel!
    @IBOutlet weak var percentLearnedLabel: UILabel!
    @IBOutlet weak var timeSpentLearningSlider: UISlider!
    @IBOutlet weak var percentLearnedSlider: UISlider!
    
    @IBOutlet weak var mainConceptTextField: UITextField!
    @IBOutlet weak var skillsUsedTextView: UITextView!
    @IBOutlet weak var newConceptsTextView: UITextView!
    
    private let generator = UIImpactFeedbackGenerator(style: .light)
    private var timeSpentLearningRealVal = 0
    private var percentLearnedRealVal = 0
    
    let timeSpentLearningMax = Float(300)
    let percentLearnedMax = Float(100.0)

    override func viewDidLoad() {
        super.viewDidLoad()
        mainConceptTextField.layer.borderColor = UIColor(red:1.00, green:0.51, blue:0.28, alpha:1.0).cgColor
        mainConceptTextField.layer.cornerRadius = 5
        
        skillsUsedTextView.layer.borderColor = UIColor(red:1.00, green:0.51, blue:0.28, alpha:1.0).cgColor
        skillsUsedTextView.layer.borderWidth = 1.0
        skillsUsedTextView.layer.cornerRadius = 5
        
        newConceptsTextView.layer.borderColor = UIColor(red:1.00, green:0.51, blue:0.28, alpha:1.0).cgColor
        newConceptsTextView.layer.borderWidth = 1.0
        newConceptsTextView.layer.cornerRadius = 5
        // Do any additional setup after loading the view.
        
        // keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        //init toolbar
        let toolbar:UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: self.view.frame.size.width, height: 30))
        //create left side empty space so that done button set on right side
        let flexSpace = UIBarButtonItem(barButtonSystemItem:    .flexibleSpace, target: nil, action: nil)
        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonAction))
        toolbar.setItems([flexSpace, doneBtn], animated: false)
        toolbar.sizeToFit()
        //setting toolbar as inputAccessoryView
        self.mainConceptTextField.inputAccessoryView = toolbar
        self.skillsUsedTextView.inputAccessoryView = toolbar
        self.newConceptsTextView.inputAccessoryView = toolbar
    }

    @objc func doneButtonAction() {
        //skillsUsedTextView.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if(skillsUsedTextView.isFirstResponder || newConceptsTextView.isFirstResponder){
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                if self.view.frame.origin.y == 0 {
                    self.view.frame.origin.y -= keyboardSize.height
                }
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    @IBAction func timeSpentLearningSliderMoved(_ sender: UISlider) {
        let sliderPos = timeSpentLearningSlider.value
        let sliderVal = round(sliderPos * timeSpentLearningMax) / timeSpentLearningMax
        timeSpentLearningRealVal = Int(round(sliderPos * timeSpentLearningMax))
        sender.setValue(sliderVal, animated: true)
        if(timeSpentLearningLabel.text != String(timeSpentLearningRealVal) + " min"){
            timeSpentLearningLabel.text = String(timeSpentLearningRealVal) + " min"
            generator.impactOccurred()
        }
    }
    @IBAction func percentLearnedSliderMoved(_ sender: UISlider) {
        let sliderPos = percentLearnedSlider.value
        let sliderVal = round(sliderPos * percentLearnedMax) / percentLearnedMax
        percentLearnedRealVal = Int(round(sliderPos * percentLearnedMax))
        sender.setValue(sliderVal, animated: true)
        if(percentLearnedLabel.text != String(percentLearnedRealVal) + "%"){
            percentLearnedLabel.text = String(percentLearnedRealVal) + "%"
            generator.impactOccurred()
        }
    }
    
    @IBAction func backAddConceptBtn(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
