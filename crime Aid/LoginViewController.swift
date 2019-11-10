//
//  ViewController.swift
//  crime Aid
//
//  Created by Cassy on 11/9/19.
//  Copyright © 2019 Cassy. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate{
    
        weak var emailText : UITextField?
        weak var passwordText : UITextField?
        weak var signInText: UILabel?
        weak var loginButton: UIButton?
        weak var registerButton: UIButton?
        weak var backGroundImage: UIImageView?
        
        var handle: AuthStateDidChangeListenerHandle?

        override func loadView() {
            super.loadView()
            let bgImage = UIImageView(frame: .zero)
            bgImage.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(bgImage)
            NSLayoutConstraint.activate([bgImage.topAnchor.constraint(equalTo: self.view.topAnchor),
                                         bgImage.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
                                         bgImage.leftAnchor.constraint(equalTo: self.view.leftAnchor),
                                         bgImage.rightAnchor.constraint(equalTo: self.view.rightAnchor)])

            bgImage.image = UIImage(named: "angryimg")
            self.backGroundImage = bgImage
            
            let signInText = UILabel(frame: .zero)
            signInText.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(signInText)
            constrain(this: signInText, toFirst: view, toSecond: view, width: 200.0/207.0, height: 50.0/219.0, left: 14, top: 20)
            self.signInText = signInText
            
            let email = UITextField(frame: .zero)
            email.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(email)
            constrain(this: email, toFirst: view, toSecond: signInText, width: 50.0/69.0, height: 25.0/438.0, left: 8, top: 25)
            self.emailText = email
            
            let password = UITextField(frame: .zero)
            password.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(password)
            constrainOthers(this: password, toFirst: email, toSecond: email, toThird: email, top: 15)
            self.passwordText = password
            passwordText?.isSecureTextEntry = true

            let login = UIButton(frame: .zero)
            login.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(login)
            constrainOthers(this: login, toFirst: view, toSecond: signInText, toThird: password, width: 50.0/207.0, height: 65.0/867.0, left: 40, top: 25)
            self.loginButton = login

            let register = UIButton(frame: .zero)
            register.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(register)
            constrainOthers(this: register, toFirst: view, toSecond: view, toThird: login, width: 50.0/207.0, height: 55.0/876.0, left: 80, top: 150)
            self.registerButton = register
        }
        
        override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
            passwordText?.underline()
            emailText?.underline()
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            setUpView()
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            handle = Auth.auth().addStateDidChangeListener{(auth, user) in
                if user != nil{
                    self.emailText?.text = nil
                    self.passwordText?.text = nil
                }
            }
        }
        
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            Auth.auth().removeStateDidChangeListener(handle!)
        }
        
        private func setUpView(){
            self.view.backgroundColor = .clear
            signInText?.adjustsFontSizeToFitWidth = true
            signInText?.font = UIFont(name: "HelveticaNeue-Light", size: 70)
            signInText?.text = "SignIn"
            signInText?.textColor = .white
            emailText?.attributedPlaceholder = NSAttributedString(string: "email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
            emailText?.borderStyle = .none
            emailText?.adjustsFontSizeToFitWidth = true
            emailText?.font = UIFont(name: "HelveticaNeue-Light", size: 20)
            emailText?.delegate = self
            passwordText?.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
            passwordText?.borderStyle = .none
            passwordText?.adjustsFontSizeToFitWidth = true
            passwordText?.font = UIFont(name: "HelveticaNeue-Light", size: 20)
            passwordText?.delegate = self
            loginButton?.layer.cornerRadius = 8
            loginButton?.layer.masksToBounds = true
            loginButton?.setTitle("Login", for: .normal)
            loginButton?.setTitleColor(.white, for: .normal)
            loginButton?.backgroundColor = .lavender
            loginButton?.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 35)
            loginButton?.addTarget(self, action: #selector(loginPressed(_:)), for: .touchUpInside)
            registerButton?.layer.cornerRadius = 8
            registerButton?.layer.masksToBounds = true
            registerButton?.setTitle("Register", for: .normal)
            registerButton?.setTitleColor(.white, for: .normal)
            registerButton?.backgroundColor = .lavender
            registerButton?.titleLabel?.adjustsFontSizeToFitWidth = true
            registerButton?.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 25)
            registerButton?.addTarget(self, action: #selector(registerPressed(_:)), for: .touchUpInside)
        }
        
        @IBAction func loginPressed(_ sender: UIButton){
            let login = HomeViewController()
            login.modalPresentationStyle = .fullScreen

            guard let email = emailText?.text , let password = passwordText?.text, email.count > 0, password.count > 0 else{
                return
        }
            
            Auth.auth().signIn(withEmail: email, password: password){ (user, error) in
                if let signInError = error, user == nil{
                    let failAlert = UIAlertController(title: "SignIn Failed", message: signInError.localizedDescription, preferredStyle: .alert)
                    failAlert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(failAlert, animated: true, completion: nil)
                }
                else{
                    self.show(login, sender: self)
                }
            }
        }
        
        @IBAction func registerPressed(_ sender: UIButton){
            let register = RegisterViewController()
            register.modalPresentationStyle = .fullScreen
            showDetailViewController(register, sender: self)
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            if textField == emailText{
                passwordText?.becomeFirstResponder()
            }
            else{
                textField.resignFirstResponder()
            }
            return true
        }
        
        private func constrain(this: UIView, toFirst: UIView, toSecond: UIView, width: CGFloat, height: CGFloat, left: CGFloat, top: CGFloat){
            NSLayoutConstraint.activate([this.widthAnchor.constraint(equalTo: toFirst.widthAnchor, multiplier: width),
                                         this.heightAnchor.constraint(equalTo: toFirst.heightAnchor, multiplier: height),
                                         this.leftAnchor.constraint(equalToSystemSpacingAfter: toFirst.leftAnchor, multiplier: left),
                                         this.topAnchor.constraint(equalToSystemSpacingBelow: toSecond.topAnchor, multiplier: top)
            ])
        }
        
        private func constrainOthers(this: UIView, toFirst: UIView, toSecond: UIView, toThird: UIView, width: CGFloat = 1.0, height: CGFloat = 1.0, left: CGFloat = 0.0, top: CGFloat = 0.0 ){
            NSLayoutConstraint.activate([this.widthAnchor.constraint(equalTo: toFirst.widthAnchor, multiplier: width),
                                         this.heightAnchor.constraint(equalTo: toFirst.heightAnchor, multiplier: height),
                                         this.leftAnchor.constraint(equalTo: toSecond.leftAnchor, constant: left),
                                         this.topAnchor.constraint(equalTo: toThird.bottomAnchor, constant: top)])
        }
    }
