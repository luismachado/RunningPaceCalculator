//
//  TimeView.swift
//  Running Pace Calculator
//
//  Created by Luís Machado on 16/05/17.
//  Copyright © 2017 LuisMachado. All rights reserved.
//

import UIKit

class TimeView: UIView, MissingFieldsProtocol {
    
    var racePaceController: RunningPaceController?
    
    let headerName: UILabel = {
        let label = UILabel()
        label.text = "Time"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    let hoursField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "hr"
        tf.keyboardType = .numberPad
        tf.backgroundColor = .white
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 16)
        return tf
    }()
    
    let minutesField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "min"
        tf.keyboardType = .numberPad
        tf.backgroundColor = .white
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 16)
        return tf
    }()
    
    let secondsField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "sec"
        tf.keyboardType = .numberPad
        tf.backgroundColor = .white
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 16)
        return tf
    }()
    
    let startColor = UIColor.rgb(red: 152, green: 172, blue: 222)
    let endColor = UIColor.rgb(red: 192, green: 162, blue: 220)
    
    lazy var calculateButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Calculate", for: .normal)
        button.addTarget(self, action: #selector(calculateTime), for: .touchUpInside)
        button.tintColor = .white
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 4
        button.clipsToBounds = true
        return button
    }()
    
    lazy var resetButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "erase-1"), for: .normal)
        button.tintColor = UIColor.rgb(red: 152, green: 172, blue: 222)
        button.addTarget(self, action: #selector(resetFields), for: .touchUpInside)
        return button
    }()
    
    func resetFields() {
        hoursField.text = ""
        minutesField.text = ""
        secondsField.text = ""
    }
    
    func calculateTime() {
        racePaceController?.calculate(type: .time)
    }
    
    init() {
        let frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        super.init(frame: frame) // Init with a default frame
        
        setup()
    }
    
    fileprivate func setup() {
        
        hoursField.delegate = self
        minutesField.delegate = self
        secondsField.delegate = self
        
        let stackView = UIStackView(arrangedSubviews: [hoursField, minutesField, secondsField])
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        
        addSubview(headerName)
        headerName.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 4, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 24)
        
        addSubview(stackView)
        stackView.anchor(top: headerName.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 6, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 200, height: 30)
        stackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        addSubview(resetButton)
        resetButton.anchor(top: topAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 6, paddingLeft: 0, paddingBottom: 0, paddingRight: 6, width: 32, height: 24)
        
        addSubview(calculateButton)
        calculateButton.anchor(top: nil, left: nil, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: -15, paddingRight: 15, width: 120, height: 30)
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if calculateButton.frame.contains(point) {
            return calculateButton;
        }
        return super.hitTest(point, with: event)
    }
    
    func setupButtons() {
        calculateButton.applyGradient(colours: [gradientStartColor, gradientEndColor], startPoint: CGPoint(x: 0.0, y: 0.5), endPoint: CGPoint(x: 1.0, y: 0.5))
    }
    
    func setTime(hours: String, minutes: String, seconds: String) {
        
        hoursField.text = hours
        minutesField.text = minutes
        secondsField.text = seconds
    }
    
    func highlightMissing() {
        hoursField.layer.cornerRadius = 5.0;
        hoursField.layer.borderColor = UIColor.red.cgColor
        hoursField.backgroundColor = UIColor(red: 255/255, green: 0, blue: 0, alpha: 0.1)
        hoursField.layer.borderWidth = 1.0;
        
        minutesField.layer.cornerRadius = 5.0;
        minutesField.layer.borderColor = UIColor.red.cgColor
        minutesField.backgroundColor = UIColor(red: 255/255, green: 0, blue: 0, alpha: 0.1)
        minutesField.layer.borderWidth = 1.0;
        
        secondsField.layer.cornerRadius = 5.0;
        secondsField.layer.borderColor = UIColor.red.cgColor
        secondsField.backgroundColor = UIColor(red: 255/255, green: 0, blue: 0, alpha: 0.1)
        secondsField.layer.borderWidth = 1.0;
    }
    
    func clearMissing() {
        hoursField.layer.borderColor = UIColor.clear.cgColor
        minutesField.layer.borderColor = UIColor.clear.cgColor
        secondsField.layer.borderColor = UIColor.clear.cgColor
        hoursField.backgroundColor = .white
        minutesField.backgroundColor = .white
        secondsField.backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TimeView: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        racePaceController?.textFieldBeingEdited = textField
    }
}

