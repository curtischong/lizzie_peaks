//
//  AddConceptViewController.swift
//  lizzie_peaks
//
//  Created by Curtis Chong on 2019-01-31.
//  Copyright © 2019 Curtis Chong. All rights reserved.
//

import UIKit

//TODO: show to date of the last review at the top and make it a button that brings you directly to the reviewViewController

protocol conceptProtocol {
    func reloadReviewTable()
}

class ConceptViewController: UIViewController , UITableViewDelegate, UITableViewDataSource, conceptProtocol{

    @IBOutlet weak var timeSpentLearningLabel: UILabel!
    @IBOutlet weak var percentNewLabel: UILabel!
    @IBOutlet weak var timeSpentLearningSlider: UISlider!
    @IBOutlet weak var percentNewSlider: UISlider!
    
    @IBOutlet weak var mainConceptTextField: UITextField!
    @IBOutlet weak var oldSkillsTextView: UITextView!
    @IBOutlet weak var newLearningsTextView: UITextView!
    @IBOutlet weak var timeLearnedLabel: UILabel!
    
    @IBOutlet weak var reviewsTableView: UITableView!
    
    @IBOutlet weak var scroller: UIScrollView!
    private let generator = UIImpactFeedbackGenerator(style: .light)
    private var timeSpentLearningRealVal = 0
    private var percentNewRealVal = 0
    
    var timeLearned : Date?
    let timeSpentLearningMax = Float(60.0)
    let percentNewMax = Float(20.0)
    let dataManager = DataManager()
    let reviewManager = ReviewScheduleManager()
    var learningsDelegate : learningsProtocol?
    let displayDateFormatter = DateFormatter()
    var toolbar : UIToolbar!
    let cellReuseIdentifier = "reviewCell"
    
    var skillData : SkillObj!
    var allReviews : [ReviewObj] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        scroller.contentSize = CGSize(width: scroller.contentSize.width, height: 2500)
        displayDateFormatter.dateFormat = "MMM d, h:mm a"
        
        timeSpentLearningSlider.setValue(0.0, animated: true)
        percentNewSlider.setValue(0.0, animated: true)
        //timeLearned = Int(round(1000*Date().timeIntervalSince1970)/1000)
        
        mainConceptTextField.layer.borderColor = UIColor(red:1.00, green:0.51, blue:0.28, alpha:1.0).cgColor
        mainConceptTextField.layer.cornerRadius = 5
        
        oldSkillsTextView.layer.borderColor = UIColor(red:1.00, green:0.51, blue:0.28, alpha:1.0).cgColor
        oldSkillsTextView.layer.borderWidth = 1.0
        oldSkillsTextView.layer.cornerRadius = 5
        //oldSkillsTextView.frame.size.height = 100
        oldSkillsTextView.isScrollEnabled = false
        
        newLearningsTextView.layer.borderColor = UIColor(red:1.00, green:0.51, blue:0.28, alpha:1.0).cgColor
        newLearningsTextView.layer.borderWidth = 1.0
        newLearningsTextView.layer.cornerRadius = 5
        //newLearningsTextView.frame.size.height = 100
        oldSkillsTextView.isScrollEnabled = false
        // Do any additional setup after loading the view.
        
        // keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        //init toolbar
        toolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: self.view.frame.size.width, height: 30))
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
        percentNewSlider.addTarget(self, action: #selector(self.savePercentNew), for: .touchUpInside)
        // Load skill Data
        
        mainConceptTextField.text = skillData.concept
        oldSkillsTextView.text = skillData.oldSkills
        newLearningsTextView.text = skillData.newLearnings
        
        timeSpentLearningRealVal = skillData.timeSpentLearning
        let timeSpentLearningSliderVal = Float(timeSpentLearningRealVal) / (5 * timeSpentLearningMax)
        timeSpentLearningSlider.setValue(timeSpentLearningSliderVal, animated: true)
        timeSpentLearningLabel.text = String(timeSpentLearningRealVal) + " min"
        
        percentNewRealVal = skillData.percentNew
        let percentNewSliderVal = Float(percentNewRealVal) / (5 * percentNewMax)
        percentNewSlider.setValue(percentNewSliderVal, animated: true)
        percentNewLabel.text = String(percentNewRealVal) + "%"
        
        // Note: the timeLearned is set before the seque occurs
        timeLearnedLabel.text = displayDateFormatter.string(from: skillData.timeLearned)
        
        for item in skillData.scheduledReviewDurations{
            print("\(item)")
        }
        
        reviewsTableView.delegate = self
        reviewsTableView.dataSource = self
        reviewsTableView.tableFooterView = UIView()
        reviewsTableView.separatorColor = UIColor.white
    }

    @objc func saveTimeSpent(sender: UISlider) {
        NSLog("saved timeSpent!")
        skillData.timeSpentLearning = timeSpentLearningRealVal
        dataManager.updateSkill(skill: skillData)
    }
    
    @objc func savePercentNew(sender: UISlider) {
        
        NSLog("saved percentNew!")
        skillData.percentNew = percentNewRealVal
        dataManager.updateSkill(skill: skillData)
    }
    
    @objc func doneButtonAction() {
        //skillsUsedTextView.resignFirstResponder()
        generator.impactOccurred()
        self.view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if(oldSkillsTextView.isFirstResponder || newLearningsTextView.isFirstResponder){
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                if self.view.frame.origin.y == 0 {
                    self.view.frame.origin.y -= (keyboardSize.height) // 30 is the height of the toolbar
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
    @IBAction func percentNewSliderMoved(_ sender: UISlider) {
        let sliderPos = percentNewSlider.value
        let sliderVal = round(sliderPos * percentNewMax) / percentNewMax
        percentNewRealVal = Int(round(sliderPos * percentNewMax)) * 5
        sender.setValue(sliderVal, animated: true)
        if(percentNewLabel.text != String(percentNewRealVal) + "%"){
            percentNewLabel.text = String(percentNewRealVal) + "%"
            generator.impactOccurred()
        }
    }
    
    var onDoneBlock : ((Bool) -> Void)?
    
    @IBAction func backAddConceptBtn(_ sender: UIButton) {
        generator.impactOccurred()
        if(skillData.scheduledReviews.count == 0){
            NSLog("has no reviews!")
            reviewManager.scheduleReview(skill : skillData)
        }else{
            NSLog("has \(skillData.scheduledReviews.count) reviews!")
        }
        // Note: you want to reload the table last so all Skills are updated
        learningsDelegate?.reloadLearningsTable()
        dismiss(animated: true, completion: nil)
        //self.performSegue(withIdentifier: "unwindSegueToFirstViewController", sender: self)
    }
    @IBAction func reviewNowBtn(_ sender: UIButton) {
        generator.impactOccurred()
        performSegue(withIdentifier: "timerSegue", sender: skillData)
    }
    @IBAction func deleteSkillBtn(_ sender: Any) {
        generator.impactOccurred()
        dataManager.deleteReviews(timeLearned: skillData.timeLearned)
        dataManager.deleteSkill(timeLearned: skillData.timeLearned)
        learningsDelegate?.reloadLearningsTable()
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let pop = segue.destination as? TimerViewController {
            pop.conceptViewControllerRef = self
            pop.skillData = sender as? SkillObj
            pop.conceptDelegate = self
        }
        if let pop = segue.destination as? ReviewViewController {
            pop.reviewData = sender as? ReviewObj
            pop.conceptViewControllerRef = self
            pop.conceptDelegate = self
        }
    }
    
    func reloadReviewTable(){
        NSLog("review Table reloaded!")
        self.reviewsTableView.reloadData()
    }
    
    
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        allReviews = dataManager.getAllReviews(timeLearned : skillData.timeLearned)
        allReviews = allReviews.reversed() // TODO: refactor this reverse in the coredata command
        return allReviews.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:ReviewTableViewCell = self.reviewsTableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! ReviewTableViewCell
        if allReviews.count > indexPath.row{
            let cellData = allReviews[indexPath.row]
            
            let newDate = cellData.dateReviewed
            
            cell.dateReviewedLabel.text = self.displayDateFormatter.string(from: newDate)
            cell.reviewDurationLabel.text = String(cellData.reviewDuration) + " min"
        }
        NSLog("created cell")
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.generator.impactOccurred()
        performSegue(withIdentifier: "reviewSegue", sender: allReviews[indexPath.row])
        print("You tapped cell number \(indexPath.row).")
    }
}
