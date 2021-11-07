//
//  ViewControllerLogin.swift
//  Git client
//
//  Created by Ruslan Bagautdinov on 03.11.2021.
//

import UIKit

let users = ["user" : "123"]

class ViewControllerLogin: UIViewController {

    
    @IBOutlet private weak var usernameText: UITextField!
    @IBOutlet private weak var passText: UITextField!
    @IBOutlet private weak var checkLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLabel.text = ""
    }

    //MAKE: - Segue to TabBar, Login&Pass
    @IBAction func userCheck() {
        let tabVC = storyboard?.instantiateViewController(withIdentifier: "goTabBar") as! ViewControllerTabBar
        tabVC.modalPresentationStyle = .fullScreen
        present(tabVC, animated: true)
//        if usernameText.text == "user" && passText.text == users["user"] {
//            let tabVC = storyboard?.instantiateViewController(withIdentifier: "goTabBar") as! ViewControllerTabBar
//            tabVC.modalPresentationStyle = .fullScreen
//            present(tabVC, animated: true)
//        } else {
//            checkLabel.text = "Не верный логин или пароль!\nПроверьте правильность ввода данных..."
//            usernameText.text = ""
//            passText.text = ""
//        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
