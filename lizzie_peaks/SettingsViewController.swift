//
//  SettingsViewController.swift
//  lizzie_peaks
//
//  Created by Curtis Chong on 2019-02-02.
//  Copyright © 2019 Curtis Chong. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController , UIPickerViewDelegate, UIPickerViewDataSource{

    @IBOutlet weak var defaultReviewPicker: UIPickerView!
    
    var learningsDelegate : learningsProtocol?
    var defaultReviewData: [String] = [String]()
    let dataManager = DataManager()
    let settingsManager = SettingsManager()
    var defaultReviewCurve : Int!
    private let generator = UIImpactFeedbackGenerator(style: .light)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        defaultReviewPicker.delegate = self
        defaultReviewPicker.dataSource = self
        defaultReviewData = ["Simple", "Moderate", "ML", "Brief"]
        defaultReviewCurve = 0
        
        if(settingsManager.defaultReview == "Simple"){
            defaultReviewPicker.selectRow(0, inComponent: 0, animated: true)
        }else if(settingsManager.defaultReview == "Moderate"){
            defaultReviewPicker.selectRow(1, inComponent: 0, animated: true)
        }else if(settingsManager.defaultReview == "ML"){
            defaultReviewPicker.selectRow(2, inComponent: 0, animated: true)
        }else if(settingsManager.defaultReview == "Brief"){
            defaultReviewPicker.selectRow(3, inComponent: 0, animated: true)
        }
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
        generator.impactOccurred()
        learningsDelegate?.reloadLearningsTable()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func purgeDatabaseBtn(_ sender: UIButton) {
        generator.impactOccurred()
        dataManager.dropAllRows()
    }
}
