//
//  AuthViewController.swift
//  Git client
//
//  Created by Ruslan Bagautdinov on 18.11.2021.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import FirebaseDatabase

final class AuthViewController: UIViewController {

    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var loginField: UITextField!
    @IBOutlet private weak var emailField: UITextField!
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var passField: UITextField!
    @IBOutlet private weak var loginButton: UIButton!

    //MARK: - Alert errors text
    enum AlertMessage: String {
        case inUse = "email уже используется!"
        case weak = "Ваш пароль считается слишком слабым!"
        case invalid = "Не верный email!"
        case wrong = "Не верный пароль!"
        case notFound = "Учетная запись не найдена!"
        case other = "Other error!"
        case field = "Пожалуйста заполните все поля!"
    }

    //MARK: - Switch title LogIn & SignUp
    private var signup: Bool = true {
        willSet {
            if newValue {
                textLabel.text = "РЕГИСТРАЦИЯ"
                loginField.isHidden = false
                questionLabel.text = "У Вас уже есть аккаунт?"
                loginButton.setTitle("Авторизоваться", for: .normal)
            } else {
                textLabel.text = "АВТОРИЗАЦИЯ"
                loginField.isHidden = true
                questionLabel.text = "У Вас нет аккаунта?"
                loginButton.setTitle("Зарегистрировать", for: .normal)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loginField.delegate = self
        emailField.delegate = self
        passField.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        resetTextField()
    }
    
    //MARK: - reset text TextFieds
    func resetTextField() {
        loginField.text = ""
        emailField.text = ""
        passField.text = ""
    }
        
    //MARK: - Switch button LogIn & SignUp
    @IBAction private func signButton(_ sender: UIButton) {
        signup = !signup
    }
    
    //MARK: - Alerts error
    func showAlert(message: AlertMessage) {
        let alert = UIAlertController(title: "Ошибка!", message: message.rawValue, preferredStyle: .alert)
        
        let attributedStringForTitle = NSAttributedString(string: "Ошибка!", attributes: [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17),
            NSAttributedString.Key.foregroundColor: UIColor.red
        ])
        alert.setValue(attributedStringForTitle, forKey: "attributedTitle")
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default) { action in
        self.resetTextField()
        })
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Move to TabBar
    private func moveToTabBar() {
        let tabVC = self.storyboard?.instantiateViewController(withIdentifier: "toTabBar") as! TabBarViewController
        tabVC.modalPresentationStyle = .fullScreen
        self.present(tabVC, animated: true)
    }
    
    //MARK: - Authorization & Create accaunt & save in BD
    @IBAction private func enterBut(_ sender: UIButton) {
        
        let login = loginField.text!
        let email = emailField.text!
        let password = passField.text!

        //MARK: - Create authorization
        if (signup) {
            if (!login.isEmpty && !email.isEmpty && !password.isEmpty) {
                Auth.auth().createUser(withEmail: email, password: password) { result, error in
                    if error == nil {
                        if let result = result {
                            
                            //MARK: - Save data in DB
                            let db = Firestore.firestore()
                            db.collection("users").addDocument(data: ["login" : login, "email" : email, "uid" : result.user.uid]) { error in
                                if error != nil {
                                    if let errorCode = AuthErrorCode(rawValue: error!._code) {
                                        switch errorCode {
                                            
                                        case .emailAlreadyInUse:
                                            self.showAlert(message: .inUse)
                                            
                                        case .weakPassword:
                                            self.showAlert(message: .weak)
                                            
                                        default:
                                            self.showAlert(message: .other)
                                        }
                                    }
                                }
                            }

                            self.moveToTabBar()
                        }
                    }
                }
            } else  {
                self.showAlert(message: .field)
            }
        } else {
            
            //MARK: - Authorization
            if (!email.isEmpty && !password.isEmpty) {
                Auth.auth().signIn(withEmail: email, password: password) { result, error in
                    if error != nil {
                        if let errorCode = AuthErrorCode(rawValue: error!._code) {
                            switch errorCode {
                            case .invalidEmail:
                                self.showAlert(message: .invalid)
                            case .wrongPassword:
                                self.showAlert(message: .wrong)
                            case .userNotFound:
                                self.showAlert(message: .notFound)
                            default:
                                self.showAlert(message: .other)
                            }
                        }
                    }
                    if error == nil {
                        self.moveToTabBar()
                    }
                }
            } else {
                self.showAlert(message: .field)
            }
        }
    }
}


//MARK: - Text Field Delegate
extension AuthViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        loginField.resignFirstResponder()
        emailField.resignFirstResponder()
        passField.resignFirstResponder()
        return true
    }
}
