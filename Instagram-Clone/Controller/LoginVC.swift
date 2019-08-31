//
//  LoginVC.swift
//  Instagram-Clone
//
//  Created by Akil Kumar Thota on 7/24/19.
//  Copyright © 2019 Akil Kumar Thota. All rights reserved.
//

import UIKit
import Firebase

class LoginVC: UIViewController {

    let instagramBannerView: UIView = {
        let view = UIView()

        let imageView = UIImageView(image: #imageLiteral(resourceName: "Instagram_logo_white"))
        imageView.contentMode = .scaleAspectFill

        view.addSubview(imageView)
        imageView.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 200, height: 50)
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        view.backgroundColor = UIColor.rgb(red: 0, green: 120, blue: 175)
        return view
    }()

    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.addTarget(self, action: #selector(handleTextfieldChange), for: .editingChanged)
        return textField
    }()

    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.isSecureTextEntry = true
        textField.addTarget(self, action: #selector(handleTextfieldChange), for: .editingChanged)
        return textField
    }()

    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 5.0
        button.setTitle("Login", for: .normal)
        button.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.isEnabled = false
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        return button
    }()

    let signUpButton: UIButton = {
        let button = UIButton(type: .system)

        let attributedTitle = NSMutableAttributedString(string: "Don't have an account?  ", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)])

        attributedTitle.append(NSAttributedString(string: "Sign up!", attributes: [NSAttributedString.Key.foregroundColor: UIColor.rgb(red: 0, green: 120, blue: 175), NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)]))

        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)

        return button
    }() 

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        navigationController?.isNavigationBarHidden = true

        view.addSubview(instagramBannerView)
        instagramBannerView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 200)

        setupLoginStack()

        view.addSubview(signUpButton)
        signUpButton.anchor(top: nil, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 10, paddingRight: 20, width: 0, height: 20)

        DispatchQueue.main.async {
            self.openHomePageIfUserLoggedIn()
        }
    }

    private func resetUIFields() {
        emailTextField.text = ""
        passwordTextField.text = ""
    }

    @objc private func loginButtonTapped() {
        guard let email = emailTextField.text, email != "" else {
            print("email is incorrect")
            return
        }

        guard let password = passwordTextField.text, password != "" else {
            print("password is incorrect")
            return
        }

        AuthenticationManager.sharedInstance.signInUser(withEmail: email, withPassword: password) { [weak self] success in
            guard success else {
                print("Sign in attempt failed")
                return
            }

            guard Auth.auth().currentUser != nil else {
                print("Current user is nil after sign in attempt")
                return
            }

            // segue to next screen
            let rootTabBarVC = RootTabBarVC()
            self?.present(rootTabBarVC, animated: true, completion: nil)

            self?.resetUIFields()
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    @objc private func handleTextfieldChange() {
        let isFormValid = emailTextField.text?.count ?? 0 > 0 && passwordTextField.text?.count ?? 0 > 0

        if isFormValid {
            loginButton.isEnabled = true
            loginButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        } else {
            loginButton.isEnabled = false
            loginButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        }
    }

    private func setupLoginStack() {

        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10

        view.addSubview(stackView)

        stackView.anchor(top: instagramBannerView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 40, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 150)
    }

    private func openHomePageIfUserLoggedIn() {
        guard Auth.auth().currentUser != nil else {
            return
        }

        // segue to next screen
        let rootTabBarVC = RootTabBarVC()
        self.present(rootTabBarVC, animated: true, completion: nil)
    }

    @objc private func signUpButtonTapped() {
        navigationController?.pushViewController(SignUPVC(), animated: true)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
