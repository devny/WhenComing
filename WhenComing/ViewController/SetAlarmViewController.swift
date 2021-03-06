//
//  SetAlarmViewController.swift
//  WhenComing
//
//  Created by 장혜준 on 2018. 4. 26..
//  Copyright © 2018년 장혜준. All rights reserved.
//

import UIKit

class SetAlarmViewController: UIViewController, SendBackDetailData {

    @IBOutlet weak var regionView: UIView!
    @IBOutlet weak var stopView: UIView!
    @IBOutlet weak var stopBtn: UIButton!
    @IBOutlet weak var busView: UIView!
    @IBOutlet weak var busBtn: UIButton!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var dayStackView: UIStackView!
    
    var borderColor: CGColor = UIColor(red: 221, green: 221, blue: 221, alpha: 1).cgColor
    var textColor: UIColor = UIColor(red: 12, green: 31, blue: 120, alpha: 1)
    var placeholderColor: UIColor = UIColor(red: 187, green: 187, blue: 187, alpha: 1)
    
    var isUpdate: Bool = false
    var delegate: SendBackAlarmData?
    
    var isBusStop: Bool = true
    var alarmId: Int?
    var arsId: String!
    var stName: String!
    var next_station: String!
    var busRouteIdList = [String]()
    var busRouteTypeList = [String]()
    var busRouteNameList = [String]()
    var alarmTime: String!
    var alarmDay = [String]()
    
    var attributedString: NSMutableAttributedString = NSMutableAttributedString(string: "")
    var dayString: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.prepareNavigation()
        self.prepareView()
        self.prepareAlarmTime()
        self.prepareAlarmDay()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.prepareBusStop()
        self.prepareBus()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goSetAlarmDetail" {
            if let vc = segue.destination as? SetAlarmDetailViewController {
                vc.delegate = self
                vc.isBusStop = self.isBusStop
                
                if let id = self.arsId, let name = self.stName {
                    vc.arsId = id
                    vc.stName = name
                    vc.busRouteNameList = self.busRouteNameList
                }
            }
        }
    }
    
    @IBAction func touchedStopBtn(_ sender: UIButton) {
        self.isBusStop = true
        performSegue(withIdentifier: "goSetAlarmDetail", sender: nil)
    }
    
    @IBAction func touchedBusBtn(_ sender: UIButton) {
        self.isBusStop = false
        performSegue(withIdentifier: "goSetAlarmDetail", sender: nil)
    }
    
    @IBAction func selectedDayBtn(_ sender: UIButton) {
        sender.isSelected = sender.isSelected ? false : true
        sender.backgroundColor = sender.isSelected ? UIColor(red: 54, green: 80, blue: 206, alpha: 1) : UIColor.white
    }
    
    @IBAction func touchedCompleteBtn(_ sender: UIButton) {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "HH:mm"
        let selectTimeString = formatter.string(from: self.timePicker.date)
        
        let btnStackView = self.dayStackView.arrangedSubviews.map { $0 as! UIButton }
        self.dayString = ""
        for i in 0 ..< btnStackView.count {
            if btnStackView[i].isSelected == true {
                self.dayString += "\(i + 1),"
            }
        }
        
        guard let id = self.arsId, let name = self.stName, let nextStation = self.next_station else {
            print("touchedCompleteBtn in SetAlarmViewController [self.arsId is 'nil']")
            return
        }
        
        if self.dayString != "" {
            self.dayString.removeLast()
            let joinBusId = self.busRouteIdList.joined(separator: ",")
            let joinBusType = self.busRouteTypeList.joined(separator: ",")
            let joinBusName = self.busRouteNameList.joined(separator: ",")
            
            delegate?.sendBackAlarmData(alarmId: self.alarmId, arsId: id, ars_name: name, next_station: nextStation, busId: joinBusId, busType: joinBusType, busName: joinBusName, alarmTime: selectTimeString, alarmDay: self.dayString)
            self.navigationController?.popViewController(animated: true)
        }
        
        else {
            print("touchedCompleteBtn in SetAlarmViewController [self.dayString is Empty]")
        }
    }
    
    @objc func touchedBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func prepareNavigation() {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav_back"), style: .plain, target: self, action: #selector(touchedBackButton))
    }
    
    func prepareView() {
        self.regionView.layer.borderWidth = 1
        self.regionView.layer.borderColor = self.borderColor
        
        self.stopView.layer.borderWidth = 1
        self.stopView.layer.borderColor = self.borderColor
        
        self.busView.layer.borderWidth = 1
        self.busView.layer.borderColor = self.borderColor
        
        self.timePicker.setValue(UIColor(red: 12, green: 31, blue: 120, alpha: 1), forKey: "textColor")
        self.timePicker.subviews[0].subviews[1].backgroundColor = UIColor(red: 54, green: 80, blue: 206, alpha: 1)
        self.timePicker.subviews[0].subviews[2].backgroundColor = UIColor(red: 54, green: 80, blue: 206, alpha: 1)
        self.timePicker.layer.borderWidth = 1
        self.timePicker.layer.borderColor = self.borderColor
        
        self.dayStackView.layer.borderWidth = 1
        self.dayStackView.layer.borderColor = self.borderColor
    }
    
    func prepareBusStop() {
        if let busStopName = self.stName {
            self.stopBtn.setTitle(busStopName, for: .normal)
            self.stopBtn.setTitleColor(self.textColor, for: .normal)
        }
            
        else {
            self.stopBtn.setTitle("정류장을 선택하세요", for: .normal)
            self.stopBtn.setTitleColor(self.placeholderColor, for: .normal)
        }
        
        self.busBtn.isEnabled = self.stopBtn.currentTitle != "정류장을 선택하세요" ? true : false
    }
    
    func prepareBus() {
        if !self.busRouteNameList.isEmpty && !self.busRouteTypeList.isEmpty {
            self.attributedString = NSMutableAttributedString(string: "")
            
            for (key, val) in self.busRouteNameList.enumerated() {
                let attribute = [NSMutableAttributedString.Key.foregroundColor : UIColor.getBusTextColor(busRouteType: self.busRouteTypeList[key])]
                self.attributedString.append(NSMutableAttributedString(string: val, attributes: attribute))
                self.attributedString.append(NSMutableAttributedString(string: " "))
            }
            
            self.busBtn.setAttributedTitle(self.attributedString, for: .normal)
        }
            
        else if !self.busRouteNameList.isEmpty && self.busRouteTypeList.isEmpty {
            let joinText = self.busRouteNameList.joined(separator: " ")
            
            self.busBtn.setTitle(joinText, for: .normal)
            self.busBtn.setTitleColor(self.textColor, for: .normal)
        }
        
        else {
            self.busBtn.setTitle("버스를 선택하세요", for: .normal)
            self.busBtn.setTitleColor(self.placeholderColor, for: .normal)
        }
    }
    
    func prepareAlarmTime() {
        if let timeString = self.alarmTime {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm:ss"
            
            self.timePicker.date = dateFormatter.date(from: timeString)!
        }
    }
    
    func prepareAlarmDay() {
        if !self.alarmDay.isEmpty {
            let btnStackView = self.dayStackView.arrangedSubviews.map { $0 as! UIButton }
            
            for i in 0 ..< self.alarmDay.count {
                self.selectedDayBtn(btnStackView[Int(self.alarmDay[i])! - 1])
            }
        }
    }
    
    // SendBackDetailData Protocol Function
    func sendBackBusStopData(id: String, name: String, next_station: String) {
        self.arsId = id
        self.stName = name
        self.next_station = next_station
    }
    
    func sendBackBusData(idList: [String], nameList: [String], typeList: [String]) {
        self.busRouteIdList = idList
        self.busRouteNameList = nameList
        self.busRouteTypeList = typeList
    }

}
