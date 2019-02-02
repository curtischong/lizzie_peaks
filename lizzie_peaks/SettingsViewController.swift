//
//  SettingsViewController.swift
//  lizzie_peaks
//
//  Created by Curtis Chong on 2019-02-02.
//  Copyright © 2019 Curtis Chong. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController , UIPickerViewDelegate, UIPickerViewDataSource{

    @IBOutlet weak var briefReviewSwitch: UISwitch!
    @IBOutlet weak var defaultReviewPicker: UIPickerView!
    
    
    var defaultReviewData: [String] = [String]()
    let dataManager = DataManager()
    let settingsManager = SettingsManager()
    var defaultReviewCurve : Int!
    var briefReviews = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        defaultReviewPicker.delegate = self
        defaultReviewPicker.dataSource = self
        defaultReviewData = ["Simple", "Moderate", "ML"]
        defaultReviewCurve = 0
        briefReviews = settingsManager.briefReviews
        briefReviewSwitch.setOn(briefReviews, animated: true)
    }
    
    

    @IBAction func briefReviewSwitchMoved(_ sender: UISwitch) {
        briefReviews = !briefReviews
        print("Brief reviews: \(briefReviews)")
        settingsManager.briefReviews = briefReviews
        settingsManager.saveSettings()
    }
    

    
    // Number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int)-> Int {
    return defaultReviewData.count
    }
    
    private func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String{
        return defaultReviewData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent  component: Int) {
        let reviewTypeSelected = defaultReviewData[row] as String
        print("selected: \(reviewTypeSelected)")
        
        settingsManager.defaultReview = reviewTypeSelected
        settingsManager.saveSettings()
    }
    

    @IBAction func backSettingsBtn(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func purgeDatabaseBtn(_ sender: UIButton) {
        dataManager.dropAllRows()
    }
}
