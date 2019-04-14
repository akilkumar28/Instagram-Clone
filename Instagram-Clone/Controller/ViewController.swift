//
//  ViewController.swift
//  Instagram-Clone
//
//  Created by Akil Kumar Thota on 4/10/19.
//  Copyright © 2019 Akil Kumar Thota. All rights reserved.
//

import UIKit

class ViewController: UIViewController {


    // Outlets

    let plusPhotoButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "plus_photo").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(plusPhotoButtonTapped(sender:)), for: .touchUpInside)
        return button
    }()


    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.font = UIFont.systemFont(ofSize: 14)
        return textField
    }()

    let usernameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Username"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.font = UIFont.systemFont(ofSize: 14)
        return textField
    }()

    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.isSecureTextEntry = true
        return textField
    }()

    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 5.0
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(signUpButtonTapped(sender:)), for: .touchUpInside)
        return button
    }()

    let verticalStackView :UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .fill
        sv.distribution = .fillEqually
        sv.spacing = 10.0
        return sv
    }()

    // life cycle methods

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(plusPhotoButton)
        view.addSubview(verticalStackView)

        plusPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        plusPhotoButton.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 40, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 140, height: 140)

        verticalStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        verticalStackView.anchor(top: plusPhotoButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 200)

        verticalStackView.addArrangedSubview(emailTextField)
        verticalStackView.addArrangedSubview(usernameTextField)
        verticalStackView.addArrangedSubview(passwordTextField)
        verticalStackView.addArrangedSubview(signUpButton)
    }


    // Functions


    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }


    @objc func signUpButtonTapped(sender: UIButton) {
        print("button tapped")
    }

    @objc func plusPhotoButtonTapped(sender:UIButton) {
        print("plus photo button tapped")
    }





}

