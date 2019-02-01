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
        mainConceptTextField.layer.cornerRadius = 20
        skillsUsedTextView.layer.cornerRadius = 20
        newConceptsTextView.layer.cornerRadius = 20
        
        newConceptsTextView.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        newConceptsTextView.layer.borderWidth = 1.0
        newConceptsTextView.layer.cornerRadius = 5
        
        newConceptsTextView.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        newConceptsTextView.layer.borderWidth = 1.0
        newConceptsTextView.layer.cornerRadius = 5
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
