//
//  ViewController.swift
//  Demo
//
//  Created by Kieu Minh Phu on 1/11/18.
//  Copyright © 2018 Kieu Minh Phu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let dateTimePicker = PKDateTimePicker()
    
    var views = [String: UIView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initializeUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func initializeUI() {
        
        self.view.addSubview(self.dateTimePicker)

        self.dateTimePicker.pickerComponents = [.custom(format: "EEEE dd/MM/yyyy", localeIdentifier: "vi_VN", minimumDate: Date(), maximumDate: Date().addingTimeInterval(30 * 24 * 60 * 60)), .minute(isShowOneValue: false)]
        self.dateTimePicker.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.dateTimePicker)
        
        self.views = ["superview": self.view,
                      "picker": self.dateTimePicker]
        
        var constraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[picker(320)]", options: .alignAllCenterX, metrics: nil, views: self.views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[picker]|", options: [], metrics: nil, views: self.views)
        
        NSLayoutConstraint.activate(constraints)
    }
}

