//
//  DistanceView.swift
//  Running Pace Calculator
//
//  Created by Luís Machado on 16/05/17.
//  Copyright © 2017 LuisMachado. All rights reserved.
//

import UIKit

struct Event {
    var name: String
    var distance: Double
}

class DistanceView: UIView, MissingFieldsProtocol {
    
    var racePaceController: RunningPaceController?
    var userDefaults:UDWrapper?
    
    var events:[Event] = [Event(name: "5K", distance: 5.000),Event(name: "10K", distance: 10.000),Event(name: "Half-Marathon", distance: 21.098),Event(name: "Marathon", distance: 42.196)]
    
    lazy var eventsPickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        return picker
    }()
    
    let hiddenDistance: UITextField = {
        let tf = UITextField()
        tf.isHidden = true
        return tf
    }()
    
    let orLabel: UILabel = {
        let label = UILabel()
        label.text = "or"
        label.textAlignment = .center
        return label
    }()
    
    let eventButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Choose event", for: .normal)
        button.addTarget(self, action: #selector(chooseEventPressed), for: .touchUpInside)
        return button
    }()
    
    func chooseEventPressed() {
        self.hiddenDistance.becomeFirstResponder()
        racePaceController?.textFieldBeingEdited = hiddenDistance
    }
    
    var toolBar = UIToolbar()
    
    let distanceField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "kms"
        tf.keyboardType = .decimalPad
        tf.backgroundColor = .white
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 16)
        return tf
    }()
    
    lazy var resetButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "erase"), for: .normal)
        button.addTarget(self, action: #selector(resetFields), for: .touchUpInside)
        return button
    }()
    
    func resetFields() {
        distanceField.text = ""
    }
    
    lazy var calculateButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Calculate Distance", for: .normal)
        button.addTarget(self, action: #selector(calculateDistance), for: .touchUpInside)
        return button
    }()
    
    func calculateDistance() {
        racePaceController?.calculate(type: .distance)
    }
    
    init() {
        let frame = CGRect(x: 0, y:0, width: 100, height: 100)
        super.init(frame: frame) // Init with a default frame
        
        setup()
    }
    
    fileprivate func setup() {
        
        distanceField.delegate = self
        
        toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "OK", style: .plain, target: self, action: #selector(donePressed))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        hiddenDistance.inputView = eventsPickerView
        hiddenDistance.inputAccessoryView = toolBar
        addSubview(hiddenDistance)
        
        addSubview(orLabel)
        orLabel.anchor(top: topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 30, height: 30)
        orLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        addSubview(eventButton)
        eventButton.anchor(top: topAnchor, left: orLabel.rightAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 100, height: 30)
        
        addSubview(distanceField)
        distanceField.anchor(top: topAnchor, left: nil, bottom: nil, right: orLabel.leftAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 5, width: 70, height: 30)
        
        addSubview(calculateButton)
        calculateButton.anchor(top: orLabel.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 200, height: 30)
        calculateButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        addSubview(resetButton)
        resetButton.anchor(top: nil, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 16, width: 30, height: 30)
        resetButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        
    }
    
    func highlightMissing() {
        distanceField.layer.cornerRadius = 5.0;
        distanceField.layer.borderColor = UIColor.red.cgColor
        distanceField.backgroundColor = UIColor(red: 255/255, green: 0, blue: 0, alpha: 0.1)
        distanceField.layer.borderWidth = 1.0;
    }
    
    func clearMissing() {
        distanceField.layer.borderColor = UIColor.clear.cgColor
        distanceField.backgroundColor = .white
    }
    
    func donePressed() {
        if hiddenDistance.isFirstResponder {
            hiddenDistance.resignFirstResponder()
        }
    }
    
    func setDistance(distance: String) {
        
        distanceField.text = distance
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



extension DistanceView: UIPickerViewDelegate, UIPickerViewDataSource {
    
    // MARK: UIPickerView controls
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if component == 1 {
            return events.count
        } else {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        if component == 1 {
            return self.frame.width / 2
        } else {
            return self.frame.width / 4
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label:UILabel = UILabel()
        label.backgroundColor = .clear;
        label.font = UIFont.boldSystemFont(ofSize: 22)
        
        label.text = events[row].name
        
        return label
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        var selected = events[row].distance
        distanceField.text = "\(selected)"
        
        let unitSelected = userDefaults?.getDistanceUnits()
        
        if unitSelected == .miles {
            selected = selected * kmToMilesConstant
            let rounded = Double(round(1000 * selected)/1000)
            distanceField.text = "\(rounded)"
        }
        
        
    }
}

extension DistanceView: UITextFieldDelegate {
    
    
    // TEXT FIELD HIDE KEYBOARD
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        racePaceController?.textFieldBeingEdited = textField
    }
}




