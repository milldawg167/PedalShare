//
//  DirectionsTableView.swift
//  PedalShare
//
//  Created by Andrew Miller on 06/05/2018.
//  Copyright © 2018 Andrew Miller. All rights reserved.
//

import UIKit
import MapKit

class DirectionsTableView: UITableView {
    
    
    
    var directionsArray: [(startingAddress: String, endingAddress: String, route: MKRoute)]!
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension DirectionsTableView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.font = UIFont(name: "Monserrat-Regular", size: 14)
        label.numberOfLines = 5
        setLabelBackgroundColor(label: label, section: section)
        
        return label
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let label = UILabel()
        label.font = UIFont(name: "Monserrat-Regular", size: 14)
        label.numberOfLines = 8
        setLabelBackgroundColor(label: label, section: section)
        
        return label
    }
    
    func setLabelBackgroundColor(label: UILabel, section: Int) {
        switch section {
        case 0:
            label.backgroundColor = UIColor.blue.withAlphaComponent(0.75)
        case 1:
            label.backgroundColor = UIColor.green.withAlphaComponent(0.75)
        default:
            label.backgroundColor = UIColor.red.withAlphaComponent(0.75)
        }
    }
}

extension DirectionsTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DirectionCell") as UITableViewCell?
        cell?.textLabel?.numberOfLines = 4
        cell?.textLabel?.font = UIFont(name: "Monserrat-Regular", size: 12)
        cell?.isUserInteractionEnabled = false
        return cell!
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return directionsArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return directionsArray[section].route.steps.count
    }
}

extension Float {
    func format(f: String) -> String {
        return NSString(format: "%\(f)f" as NSString, self) as String
    }
}

extension CLLocationDistance {
    func miles() -> String {
        let miles = Float(self)/1609.344
        return miles.format(f: ".2")
    }
}

extension TimeInterval {
    func formatted() -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [NSCalendar.Unit.hour, NSCalendar.Unit.minute, NSCalendar.Unit.second]
        
        return formatter.string(from: self)!
    }
}
