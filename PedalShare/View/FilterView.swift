//
//  FilterView.swift
//  PedalShare
//
//  Created by Andrew Miller on 05/05/2018.
//  Copyright © 2018 Andrew Miller. All rights reserved.
//

import UIKit

class FilterView: UIView {
    override func awakeFromNib() {
        self.layer.cornerRadius = 15.0
        self.layer.shadowOpacity = 0.75
        self.layer.shadowRadius = 2.0
        self.layer.shadowColor = UIColor.gray.cgColor
        super.awakeFromNib()
    }
}
