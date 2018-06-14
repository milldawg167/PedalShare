//
//  ProfileVC.swift
//  PedalShare
//
//  Created by Andrew Miller on 05/05/2018.
//  Copyright © 2018 Andrew Miller. All rights reserved.
//

import UIKit
import Firebase

class ProfileVC: UIViewController, UIPopoverControllerDelegate {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var emailLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.emailLbl.text = Auth.auth().currentUser?.email
    }
    
    @IBAction func signOutBtnPressed(_ sender: Any) {
        let logoutPopup = UIAlertController(title: nil, message: "Are you sure you want to sign out?", preferredStyle: .actionSheet)
        logoutPopup.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: {
            (alertAction: UIAlertAction!) in
            logoutPopup.dismiss(animated: true, completion: nil)
        }))
        let logoutAction = UIAlertAction(title: "Sign out", style: .destructive) { (buttonTapped) in
            do {
                try Auth.auth().signOut()
                let authVC = self.storyboard?.instantiateViewController(withIdentifier: "AuthVC") as? AuthVC
                self.present(authVC!, animated: true, completion: nil)
            } catch {
                print(error)
            }
        }
        logoutPopup.addAction(logoutAction)
        present(logoutPopup, animated: true, completion: nil)
    }
}
