//
//  ViewController.swift
//  Running Pace Calculator
//
//  Created by Luís Machado on 16/05/17.
//  Copyright © 2017 LuisMachado. All rights reserved.
//

import UIKit

enum CalculationType {
    case time
    case distance
    case pace
}

let kmToMilesConstant: Double = 0.621371

let baseColor: UIColor = UIColor(white: 0.5, alpha: 0.1)

class RunningPaceController: UIViewController {
    
    var textFieldBeingEdited: UITextField?
    let userDefaults = UDWrapper()
    
    lazy var timeContainer: TimeView = {
        let container = TimeView()
        container.racePaceController = self
        container.backgroundColor = baseColor
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
        
    }()
    
    lazy var distanceContainer: DistanceView = {
        let container = DistanceView()
        container.racePaceController = self
        container.backgroundColor = baseColor
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    
    lazy var paceContainer: PaceView = {
        let container = PaceView()
        container.racePaceController = self
        container.backgroundColor = baseColor
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    
    let upperSeparator: UIView = {
        let separator = UIView()
        separator.backgroundColor = .black
        return separator
    }()
    
    let lowerSeparator: UIView = {
        let separator = UIView()
        separator.backgroundColor = .black
        return separator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Running Pace Calculator"
        let button = UIBarButtonItem(image: #imageLiteral(resourceName: "cog").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(showOptions))
        navigationItem.setRightBarButton(button, animated: true)
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
        gestureRecognizer.cancelsTouchesInView = false
        self.view.addGestureRecognizer(gestureRecognizer)
        
        view.addSubview(timeContainer)
        timeContainer.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        timeContainer.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        timeContainer.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        timeContainer.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        view.addSubview(distanceContainer)
        distanceContainer.topAnchor.constraint(equalTo: timeContainer.bottomAnchor).isActive = true
        distanceContainer.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        distanceContainer.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        distanceContainer.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        view.addSubview(paceContainer)
        paceContainer.topAnchor.constraint(equalTo: distanceContainer.bottomAnchor).isActive = true
        paceContainer.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        paceContainer.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        paceContainer.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        
        
        view.addSubview(upperSeparator)
        upperSeparator.anchor(top: timeContainer.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        
        view.addSubview(lowerSeparator)
        lowerSeparator.anchor(top: distanceContainer.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        
        view.backgroundColor = .white
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let unit = userDefaults.getDistanceUnits()
        
        if unit == .kilometers {
            distanceContainer.distanceField.placeholder = "kms"
            paceContainer.label.text = "/ km"
        } else if unit == .miles {
            distanceContainer.distanceField.placeholder = "mi"
            paceContainer.label.text = "/ mi"
        }
        
    }
    
    @objc fileprivate func showOptions() {
        let optionsController = OptionsController(style: .grouped)
        optionsController.userDefaults = self.userDefaults
        navigationController?.pushViewController(optionsController, animated: true)
    }
    
    func handleTap(gestureRecognizer: UIGestureRecognizer) {
        
        if textFieldBeingEdited != nil && (textFieldBeingEdited?.isFirstResponder)!{
            textFieldBeingEdited?.resignFirstResponder()
        }
    }
    
    fileprivate func highlightViewRed(view: UIView) {
        
        
        UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            
            view.backgroundColor = .red
            
        }, completion: nil)
        
    }
    
    fileprivate func dehighlightViews() {
        
        UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            
            self.timeContainer.backgroundColor = baseColor
            self.distanceContainer.backgroundColor = baseColor
            self.paceContainer.backgroundColor = baseColor
            
        }, completion: nil)
        
        timeContainer.backgroundColor = baseColor
        distanceContainer.backgroundColor = baseColor
        paceContainer.backgroundColor = baseColor
    }
    
    func calculate(type: CalculationType) {
        
        textFieldBeingEdited?.resignFirstResponder()
        dehighlightViews()
        
        guard let timeHourValue = timeContainer.hoursField.text else { return }
        guard let timeMinutesValue = timeContainer.minutesField.text else { return }
        guard let timeSecondsValue = timeContainer.secondsField.text else { return }
        guard let distanceValue = distanceContainer.distanceField.text else { return }
        guard let paceMinuteValue = paceContainer.minutesField.text else { return }
        guard let paceSecondsValue = paceContainer.secondsField.text else { return }
        
        
        if type == .time {
            
            getSecondsFrom(hours: "", minutes: paceMinuteValue, seconds: paceSecondsValue, completion: { (pace, error) in
                
                if error != nil {
                    AlertHelper.displayAlert(title: "Missing Fields", message: "Pace has to be filled", displayTo: self)
                    self.highlightViewRed(view: self.paceContainer)
                    return
                }
                
                guard let pace = pace else { return }
                
                if distanceValue == "" {
                    AlertHelper.displayAlert(title: "Missing Fields", message: "Distance has to be filled", displayTo: self)
                    self.highlightViewRed(view: self.distanceContainer)
                } else {
                    let distanceWithDot = distanceValue.replacingOccurrences(of: ",", with: ".")
                    guard let distance = Double(distanceWithDot) else {
                        AlertHelper.displayAlert(title: "Missing Fields", message: "Distance has to be filled", displayTo: self)
                        self.highlightViewRed(view: self.distanceContainer)
                        return }
                    
                    let timeInSeconds = distance * pace
                    let hours = Int(timeInSeconds / 3600)
                    let minutes = Int(timeInSeconds.truncatingRemainder(dividingBy: 3600)/60)
                    let seconds = Int(timeInSeconds.truncatingRemainder(dividingBy: 3600).truncatingRemainder(dividingBy: 60))
                    
                    self.timeContainer.setTime(hours: String(hours), minutes: String(minutes), seconds: String(seconds))
                }
                
            })
            
        } else if type == .distance {
            
            getSecondsFrom(hours: timeHourValue, minutes: timeMinutesValue, seconds: timeSecondsValue, completion: { (time, error) in
                
                if error != nil {
                    AlertHelper.displayAlert(title: "Missing Fields", message: "Time has to be filled", displayTo: self)
                    self.highlightViewRed(view: self.timeContainer)
                    return
                }
                
                guard let time = time else { return }
                
                self.getSecondsFrom(hours: "", minutes: paceMinuteValue, seconds: paceSecondsValue, completion: { (pace, error) in
                    
                    if error != nil {
                        AlertHelper.displayAlert(title: "Missing Fields", message: "Pace has to be filled", displayTo: self)
                        self.highlightViewRed(view: self.paceContainer)
                        return
                    }
                    
                    guard let pace = pace else { return }
                    
                    let roundDistance = Double(round(1000 * time / pace)/1000)
                    
                    self.distanceContainer.setDistance(distance: String(roundDistance))
                    
                })
                
            })
            
        } else if type == .pace {
            
            getSecondsFrom(hours: timeHourValue, minutes: timeMinutesValue, seconds: timeSecondsValue, completion: { (time, error) in
                
                if error != nil {
                    AlertHelper.displayAlert(title: "Missing Fields", message: "Time has to be filled", displayTo: self)
                    self.highlightViewRed(view: self.timeContainer)
                    return
                }
                
                guard let time = time else { return }
                
                if distanceValue == "" {
                    AlertHelper.displayAlert(title: "Missing Fields", message: "Distance has to be filled", displayTo: self)
                    self.highlightViewRed(view: self.distanceContainer)
                } else {
                    let distanceWithDot = distanceValue.replacingOccurrences(of: ",", with: ".")
                    guard let distance = Double(distanceWithDot) else {
                        AlertHelper.displayAlert(title: "Missing Fields", message: "Distance has to be filled", displayTo: self)
                        self.highlightViewRed(view: self.distanceContainer)
                        return }
                    
                    let timeInSeconds = time / distance
                    let minutes = Int(timeInSeconds/60)
                    let seconds = Int(timeInSeconds.truncatingRemainder(dividingBy: 60))
                    
                    self.paceContainer.setTime(minutes: String(minutes), seconds: String(seconds))
                }
            })
        }
    }
    
    
    func getSecondsFrom(hours: String, minutes: String, seconds: String, completion: @escaping (Double?, _ error:Error?) -> ()) {
        
        if hours == "" && minutes == "" && seconds == "" {
            completion(nil, NSError(domain: "At least on of the fields must be filled", code: -1, userInfo: nil))
            return
        }
        
        var hoursValue: Double = 0
        var minutesValue: Double = 0
        var secondsValue: Double = 0
        
        if hours != "" {
            if let hoursDouble = Double(hours) {
                hoursValue = hoursDouble
            }
        }
        
        if minutes != "" {
            if let minutesDouble = Double(minutes) {
                minutesValue = minutesDouble
            }
        }
        
        if seconds != "" {
            if let secondsDouble = Double(seconds) {
                secondsValue = secondsDouble
            }
        }
        
        let total = (hoursValue*60*60) + (minutesValue*60) + secondsValue
        
        completion(total, nil)
    }
    
}
