//
//  AddConceptViewController.swift
//  lizzie_peaks
//
//  Created by Curtis Chong on 2019-01-31.
//  Copyright © 2019 Curtis Chong. All rights reserved.
//

import UIKit

class ConceptViewController: UIViewController {

    @IBOutlet weak var timeSpentLearningLabel: UILabel!
    @IBOutlet weak var percentLearnedLabel: UILabel!
    @IBOutlet weak var timeSpentLearningSlider: UISlider!
    @IBOutlet weak var percentLearnedSlider: UISlider!
    
    @IBOutlet weak var mainConceptTextField: UITextField!
    @IBOutlet weak var oldSkillsTextView: UITextView!
    @IBOutlet weak var newLearningsTextView: UITextView!
    @IBOutlet weak var timeLearnedLabel: UILabel!
    
    private let generator = UIImpactFeedbackGenerator(style: .light)
    private var timeSpentLearningRealVal = 0
    private var percentLearnedRealVal = 0
    
    var timeLearned : Date?
    let timeSpentLearningMax = Float(60.0)
    let percentLearnedMax = Float(20.0)
    let dataManager = DataManager()
    let reviewManager = ReviewManager()
    var learningsDelegate : learningsProtocol?
    let displayDateFormatter = DateFormatter()
    
    var skillData : SkillObj!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayDateFormatter.dateFormat = "MMM d, h:mm a"
        
        timeSpentLearningSlider.setValue(0.0, animated: true)
        percentLearnedSlider.setValue(0.0, animated: true)
        //timeLearned = Int(round(1000*Date().timeIntervalSince1970)/1000)
        
        mainConceptTextField.layer.borderColor = UIColor(red:1.00, green:0.51, blue:0.28, alpha:1.0).cgColor
        mainConceptTextField.layer.cornerRadius = 5
        
        oldSkillsTextView.layer.borderColor = UIColor(red:1.00, green:0.51, blue:0.28, alpha:1.0).cgColor
        oldSkillsTextView.layer.borderWidth = 1.0
        oldSkillsTextView.layer.cornerRadius = 5
        
        newLearningsTextView.layer.borderColor = UIColor(red:1.00, green:0.51, blue:0.28, alpha:1.0).cgColor
        newLearningsTextView.layer.borderWidth = 1.0
        newLearningsTextView.layer.cornerRadius = 5
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
        self.oldSkillsTextView.inputAccessoryView = toolbar
        self.newLearningsTextView.inputAccessoryView = toolbar
        
        
        //slider finished sliding
        timeSpentLearningSlider.addTarget(self, action: #selector(self.saveTimeSpent), for: .touchUpInside)
        percentLearnedSlider.addTarget(self, action: #selector(self.savePercentLearned), for: .touchUpInside)
        // Load skill Data
        
        
        
        
        // Note: the timeLearned is set before the seque occurs
        timeLearnedLabel.text = displayDateFormatter.string(from: skillData.timeLearned)
    }

    @objc func saveTimeSpent(sender: UISlider) {
        NSLog("saved timeSpent!")
        skillData.timeSpentLearning = timeSpentLearningRealVal
        dataManager.updateSkill(skill: skillData)
    }
    
    @objc func savePercentLearned(sender: UISlider) {
        
        NSLog("saved percentLearned!")
        skillData.percentNew = percentLearnedRealVal
        dataManager.updateSkill(skill: skillData)
    }
    
    @objc func doneButtonAction() {
        //skillsUsedTextView.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if(oldSkillsTextView.isFirstResponder || newLearningsTextView.isFirstResponder){
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
        if(mainConceptTextField.isFirstResponder){
            NSLog("saved mainConcept!")
            skillData.concept = mainConceptTextField.text!
            dataManager.updateSkill(skill: skillData)
            
        }else if(oldSkillsTextView.isFirstResponder){
            NSLog("saved oldSkills!")
            skillData.oldSkills = oldSkillsTextView.text!
            dataManager.updateSkill(skill: skillData)
            
        }else if(newLearningsTextView.isFirstResponder){
            NSLog("saved newLearnings!")
            skillData.newLearnings = newLearningsTextView.text!
            dataManager.updateSkill(skill: skillData)
        }
    }
    
    @IBAction func timeSpentLearningSliderMoved(_ sender: UISlider) {
        let sliderPos = timeSpentLearningSlider.value
        let sliderVal = round(sliderPos * timeSpentLearningMax) / timeSpentLearningMax
        timeSpentLearningRealVal = Int(round(sliderPos * timeSpentLearningMax)) * 5
        sender.setValue(sliderVal, animated: true)
        if(timeSpentLearningLabel.text != String(timeSpentLearningRealVal) + " min"){
            timeSpentLearningLabel.text = String(timeSpentLearningRealVal) + " min"
            generator.impactOccurred()
        }
    }
    @IBAction func percentLearnedSliderMoved(_ sender: UISlider) {
        let sliderPos = percentLearnedSlider.value
        let sliderVal = round(sliderPos * percentLearnedMax) / percentLearnedMax
        percentLearnedRealVal = Int(round(sliderPos * percentLearnedMax)) * 5
        sender.setValue(sliderVal, animated: true)
        if(percentLearnedLabel.text != String(percentLearnedRealVal) + "%"){
            percentLearnedLabel.text = String(percentLearnedRealVal) + "%"
            generator.impactOccurred()
        }
    }
    
    var onDoneBlock : ((Bool) -> Void)?
    
    @IBAction func backAddConceptBtn(_ sender: UIButton) {
        learningsDelegate?.reloadLearningsTable()
        dismiss(animated: true, completion: nil)
        //self.performSegue(withIdentifier: "unwindSegueToFirstViewController", sender: self)
    }
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        /*let concept = mainConceptTextField.text as! String
        let newLearnings = newConceptsTextView.text as! String
        let oldSkills = skillsUsedTextView.text as! String
        let percentNew = Int(percentLearnedRealVal)
        let timeSpentLearning = Int(timeSpentLearningRealVal)*/

        /*let curSkill = SkillObj(concept : concept,
                                newLearnings : newLearnings,
                                oldSkills : oldSkills,
                                percentNew : percentNew,
                                timeLearned : timeLearned!,
                                timeSpentLearning : timeSpentLearning)*/

        dataManager.updateSkill(skill: skillData)
        // We want to make sure that the skill was saved properly before scheduling a review

        reviewManager.createReview(skill : skillData)

        learningsDelegate?.reloadLearningsTable()
        dismiss(animated: true, completion: nil)
    }
    
}
