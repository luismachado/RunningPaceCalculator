//
//  ViewController.swift
//  Running Pace Calculator
//
//  Created by Luís Machado on 16/05/17.
//  Copyright © 2017 LuisMachado. All rights reserved.
//

import UIKit
import GoogleMobileAds

enum CalculationType {
    case time
    case distance
    case pace
}

let kmToMilesConstant: Double = 0.621371

let containerColor: UIColor = UIColor(white: 0.98, alpha: 1)
let backgroundColor: UIColor = UIColor.rgb(red: 240, green: 240, blue: 240)
let gradientStartColor = UIColor.rgb(red: 152, green: 172, blue: 222).cgColor
let gradientEndColor = UIColor.rgb(red: 192, green: 162, blue: 220).cgColor

class RunningPaceController: UIViewController {
    
    var textFieldBeingEdited: UITextField?
    let userDefaults = UDWrapper()
    
    let bannerView: GADBannerView = {
        let view = GADBannerView()
        view.backgroundColor = .white
        view.adUnitID = ""
        return view
    }()
    
    lazy var timeContainer: TimeView = {
        let container = TimeView()
        container.racePaceController = self
        container.backgroundColor = containerColor
        container.layer.cornerRadius = 6
        container.clipsToBounds = false
        container.layer.shadowColor = UIColor.black.cgColor
        container.layer.shadowOpacity = 0.3
        container.layer.shadowOffset = CGSize(width: 0, height: 2)
        container.layer.shadowRadius = 4
        return container
    }()
    
    lazy var distanceContainer: DistanceView = {
        let container = DistanceView()
        container.racePaceController = self
        container.userDefaults = self.userDefaults
        container.layer.cornerRadius = 6
        container.backgroundColor = containerColor
        container.clipsToBounds = false
        container.layer.shadowColor = UIColor.black.cgColor
        container.layer.shadowOpacity = 0.3
        container.layer.shadowOffset = CGSize(width: 0, height: 2)
        container.layer.shadowRadius = 4
        return container
    }()
    
    lazy var paceContainer: PaceView = {
        let container = PaceView()
        container.racePaceController = self
        container.layer.cornerRadius = 6
        container.backgroundColor = containerColor
        container.clipsToBounds = false
        container.layer.shadowColor = UIColor.black.cgColor
        container.layer.shadowOpacity = 0.3
        container.layer.shadowOffset = CGSize(width: 0, height: 2)
        container.layer.shadowRadius = 4
        return container
    }()
    
    let logoImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "run")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Running Pace Calculator"
        let button = UIBarButtonItem(image: #imageLiteral(resourceName: "cog"), style: .plain, target: self, action: #selector(showOptions))
        navigationItem.setRightBarButton(button, animated: true)
        
        setup()
        
//        bannerView.rootViewController = self
//        let request = GADRequest()
//        bannerView.load(request)
        
    }
    
    fileprivate func setup() {
        
        setNavBarColor()
        navigationController?.navigationBar.tintColor = .white
        navigationController!.navigationBar.titleTextAttributes =
            [NSForegroundColorAttributeName: UIColor.white]
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
        gestureRecognizer.cancelsTouchesInView = false
        self.view.addGestureRecognizer(gestureRecognizer)
        
        view.addSubview(timeContainer)
        timeContainer.anchor(top: topLayoutGuide.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 90)
        
        view.addSubview(distanceContainer)
        distanceContainer.anchor(top: timeContainer.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 30, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 90)
        
        view.addSubview(paceContainer)
        paceContainer.anchor(top: distanceContainer.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 30, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 90)

        
        view.addSubview(bannerView)
        bannerView.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
        view.addSubview(logoImage)
        logoImage.anchor(top: paceContainer.bottomAnchor, left: view.leftAnchor, bottom: bannerView.topAnchor, right: view.rightAnchor, paddingTop: 40, paddingLeft: 20, paddingBottom: 20, paddingRight: 20, width: 0, height: 0)
        
        view.backgroundColor = backgroundColor
    }
    
    func setNavBarColor() {
        
        let navBar = self.navigationController?.navigationBar
        
        //Make navigation bar transparent
        navBar?.setBackgroundImage(UIImage(), for: .default)
        navBar?.shadowImage = UIImage()
        navBar?.isTranslucent = true
        
        //Create View behind navigation bar and add gradient
        let behindView = UIView(frame: CGRect(x: 0, y:0, width: UIApplication.shared.statusBarFrame.width, height: UIApplication.shared.statusBarFrame.height + (navBar?.frame.height)!))
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = behindView.frame
        gradientLayer.colors = [gradientStartColor, gradientEndColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        
        // Render the gradient to UIImage
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        behindView.layer.insertSublayer(gradientLayer, at: 0)
        behindView.layer.shadowColor = UIColor.black.cgColor
        behindView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        behindView.layer.shadowRadius = 4.0
        behindView.layer.shadowOpacity = 0.3
        behindView.layer.masksToBounds = false
        
        self.navigationController?.view.insertSubview(behindView, belowSubview: navBar!)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        timeContainer.setupButtons()
        distanceContainer.setupButtons()
        paceContainer.setupButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
    
    fileprivate func highlightViewRed(view: MissingFieldsProtocol) {
        
        
        UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            
            view.highlightMissing()
            
        }, completion: nil)
        
    }
    
    fileprivate func dehighlightViews() {
        
        UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            
            self.timeContainer.clearMissing()
            self.distanceContainer.clearMissing()
            self.paceContainer.clearMissing()
            
        }, completion: nil)
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
