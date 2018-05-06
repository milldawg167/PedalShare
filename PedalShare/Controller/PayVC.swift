//
//  PayVC.swift
//  PedalShare
//
//  Created by Andrew Miller on 06/05/2018.
//  Copyright © 2018 Andrew Miller. All rights reserved.
//

import UIKit

class PayVC: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView?
    
    var image: UIImage? {
        didSet {
            configureView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
    func configureView() {
        imageView?.image = image
    }
}
