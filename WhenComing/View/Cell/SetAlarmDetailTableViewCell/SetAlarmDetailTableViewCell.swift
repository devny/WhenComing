//
//  SetAlarmDetailTableViewCell.swift
//  WhenComing
//
//  Created by 장혜준 on 2018. 5. 9..
//  Copyright © 2018년 장혜준. All rights reserved.
//

import UIKit

class SetAlarmDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var indicatorImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var busAlarmSwitch: UISwitch!
    @IBOutlet weak var bottomView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.busAlarmSwitch.isOn = false
        self.busAlarmSwitch.tintColor = UIColor(red: 187, green: 187, blue: 187, alpha: 1)
        self.busAlarmSwitch.layer.cornerRadius = self.busAlarmSwitch.frame.height / 2
        self.busAlarmSwitch.backgroundColor = UIColor(red: 187, green: 187, blue: 187, alpha: 1)
    }
    
    @IBAction func valueChangedAlarmSwitch(_ sender: UISwitch) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "valueChangedAlarmSwitch"), object: nil, userInfo: ["indexPath" : sender.tag])
    }
    
}
