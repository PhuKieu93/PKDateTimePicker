//
//  PKDateTimePicker.swift
//  Demo
//
//  Created by Kieu Minh Phu on 1/11/18.
//  Copyright © 2018 Kieu Minh Phu. All rights reserved.
//

import UIKit

enum PKDateTimePickerComponent {
    
    case day(isShowOneValue: Bool)
    case month(isShowOneValue: Bool)
    case year(isShowOneValue: Bool)
    case hour(isShowOneValue: Bool)
    case minute(isShowOneValue: Bool)
    case second(isShowOneValue: Bool)
    case period(isShowOneValue: Bool)
    case custom(format: String, localeIdentifier: String, minimumDate: Date, maximumDate: Date)
}

class PKDateTimePicker: UIView {
    
    private let picker = UIPickerView()
    
    private var views = [String: UIView]()
    
    private var maxRows = 100000
    private var widthComponent: CGFloat = 45
    
    var pickerComponents: [PKDateTimePickerComponent]? {
        
        didSet {
            self.setTitles()
        }
    }
    
    var date: Date?
    
    fileprivate var titles = [[String]]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.initializeUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initializeUI() {
        
        self.picker.delegate = self
        self.picker.dataSource = self
        
        self.picker.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.picker)
        
        self.views = ["superview": self,
                      "picker": self.picker]
        
        var constraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[picker]|", options: .alignAllCenterX, metrics: nil, views: self.views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[picker]|", options: .alignAllCenterY, metrics: nil, views: self.views)
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func formatType(form: String, localeIdentifier: String) -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: localeIdentifier)
        dateFormatter.dateFormat = form
        return dateFormatter
    }
    
    private func havePeriodComponent() -> Bool {
        
        guard let pickerComponents = self.pickerComponents else {
            return false
        }
        
        return pickerComponents.contains(where: { (item) -> Bool in
            switch item {
            case .period:
                return true
                
            default:
                return false
            }
        })
    }
    
    private func setTitles() {
        
        if let pickerComponents = self.pickerComponents {
            for component in pickerComponents {
                
                switch component {
                case .day:
                    
                    var strings = [String]()
                    for i in 1...31 {
                        strings.append(String(i))
                    }
                    
                    self.titles.append(strings)
                    break
                    
                case .month:
                    
                    var strings = [String]()
                    for i in 1...12 {
                        strings.append(String(i))
                    }
                    
                    self.titles.append(strings)
                    
                    break
                    
                case .year:
                    
                    var strings = [String]()
                    for i in 1...10000 {
                        strings.append(String(i))
                    }
                    
                    self.titles.append(strings)
                    break
                    
                case .hour:
                    
                    var strings = [String]()
                    
                    if self.havePeriodComponent() {
                        for i in 1...12 {
                            strings.append(String(i))
                        }
                    } else {
                        for i in 0...23 {
                            strings.append(String(i))
                        }
                    }
                    
                    self.titles.append(strings)
                    break
                    
                case .minute:
                    
                    var strings = [String]()
                    for i in 0...59 {
                        var item = ""
                        if i < 10 {
                            item = "0" + String(i)
                        } else {
                            item = String(i)
                        }
                        strings.append(item)
                    }
                    
                    self.titles.append(strings)
                    break
                    
                case .second:
                    
                    var strings = [String]()
                    for i in 0...59 {
                        strings.append(String(i))
                    }
                    
                    self.titles.append(strings)
                    break
                    
                case .period:
                    
                    let strings = ["AM", "PM"]
                    
                    self.titles.append(strings)
                    
                    break
                    
                case .custom(let format, let localeIdentifier, let minimumDate, let maximumDate):
                    
                    var min = minimumDate
                    var strings = [String]()
                    while min <= maximumDate {
                        strings.append(self.formatType(form: format, localeIdentifier: localeIdentifier).string(from: min))
                        min = Calendar.current.date(byAdding: .day, value: 1, to: min)!
                    }
                    
                    self.titles.append(strings)
                    break
                }
            }
        }
    }
}

extension PKDateTimePicker: UIPickerViewDataSource {
    
    internal func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return self.pickerComponents?.count ?? 0
    }
    
    internal func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if let pickerComponents = self.pickerComponents {
            switch pickerComponents[component] {
            case .custom, .period:
                return self.titles[component].count
            default:
                return maxRows
            }
        }
        
        return maxRows
    }
    
    internal func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let myRow = row % self.titles[component].count
        return self.titles[component][myRow]
    }
}

extension PKDateTimePicker: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        
        if let pickerComponents = self.pickerComponents {
            
            switch pickerComponents[component] {
            case .custom:
                return self.picker.frame.width - self.widthComponent * CGFloat(pickerComponents.count - 1) - 15
                
            default:
                return self.widthComponent
            }
        }
        return self.widthComponent
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let myRow = row % self.titles[component].count
        
    }
}

