//
//  SettingsViewController.swift
//  lizzie_peaks
//
//  Created by Curtis Chong on 2019-02-02.
//  Copyright © 2019 Curtis Chong. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    let dataManager = DataManager()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func backSettingsBtn(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func purgeDatabaseBtn(_ sender: UIButton) {
        dataManager.dropAllRows()
    }
}
