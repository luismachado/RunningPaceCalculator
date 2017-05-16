//
//  OptionsController.swift
//  Running Pace Calculator
//
//  Created by Luís Machado on 16/05/17.
//  Copyright © 2017 LuisMachado. All rights reserved.
//

import UIKit

class OptionsController: UITableViewController {
    
    let cellId = "cellId"
    var textFieldBeingEdited: UITextField?
    var userDefaults: UDWrapper?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Options"
        tableView.register(OptionsCell.self, forCellReuseIdentifier: cellId)
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
        gestureRecognizer.cancelsTouchesInView = false
        self.view.addGestureRecognizer(gestureRecognizer)
        
    }
    
    func handleTap(gestureRecognizer: UIGestureRecognizer) {
        
        if textFieldBeingEdited != nil && (textFieldBeingEdited?.isFirstResponder)!{
            textFieldBeingEdited?.resignFirstResponder()
            
            if let cell = tableView.cellForRow(at: IndexPath(item: 0, section: 0)) as? OptionsCell {
                let unit = cell.pickerUnits[cell.eventsPickerView.selectedRow(inComponent: 1)]
                saveUnits(newUnit: unit)
            }
        }
    }
    
    func saveUnits(newUnit: Units) {
        userDefaults?.setDistanceUnits(unit: newUnit)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! OptionsCell
        
        if indexPath.row == 0 {
            cell.title.text = "Distance Units"
            
            cell.value.setTitle("Kilometers", for: .normal)
            cell.userDefaults = userDefaults
            
            if let unitsSelected = userDefaults?.getDistanceUnits() {
                cell.value.setTitle(unitsSelected.rawValue, for: .normal)
            }
            
        }
        
        cell.optionsController = self
        cell.selectionStyle = .none
        
        return cell
        
    }
}

class OptionsCell: UITableViewCell {
    
    var optionsController: OptionsController?
    var pickerUnits:[Units] = [Units.kilometers, Units.miles]
    var toolBar = UIToolbar()
    var userDefaults: UDWrapper?
    
    let title: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var value: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Kilometers", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(chooseUnitsPressed), for: .touchUpInside)
        button.contentHorizontalAlignment = .right
        return button
    }()
    
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
    
    func chooseUnitsPressed() {
        self.hiddenDistance.becomeFirstResponder()
        optionsController?.textFieldBeingEdited = hiddenDistance
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(value)
        value.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        value.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16).isActive = true
        value.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        value.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        addSubview(title)
        title.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        title.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
        title.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        title.rightAnchor.constraint(equalTo: value.leftAnchor, constant: -8).isActive = true
        
        toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "OK", style: .plain, target: self, action: #selector(donePressed))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        hiddenDistance.delegate = self
        hiddenDistance.inputView = eventsPickerView
        hiddenDistance.inputAccessoryView = toolBar
        addSubview(hiddenDistance)
        
    }
    
    func donePressed() {
        if hiddenDistance.isFirstResponder {
            hiddenDistance.resignFirstResponder()
        }
        
        let unit = pickerUnits[eventsPickerView.selectedRow(inComponent: 1)]
        optionsController?.saveUnits(newUnit: unit)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension OptionsCell: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let unitsSelected = userDefaults?.getDistanceUnits() {
            if let index = pickerUnits.index(of: unitsSelected) {
                eventsPickerView.selectRow(index, inComponent: 1, animated: false)
            }
        }
    }
    
}

extension OptionsCell: UIPickerViewDelegate, UIPickerViewDataSource {
    
    // MARK: UIPickerView controls
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if component == 1 {
            return pickerUnits.count
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
        
        label.text = pickerUnits[row].rawValue
        
        return label
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        value.setTitle(pickerUnits[row].rawValue, for: .normal)
    }
}
