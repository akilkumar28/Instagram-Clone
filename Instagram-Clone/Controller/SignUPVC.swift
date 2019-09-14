//
//  SignUPVC.swift
//  Instagram-Clone
//
//  Created by Akil Kumar Thota on 4/10/19.
//  Copyright © 2019 Akil Kumar Thota. All rights reserved.
//

import UIKit
import Firebase

class SignUPVC: UIViewController {

    // Outlets

    let plusPhotoButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "plus_photo").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(plusPhotoButtonTapped(sender:)), for: .touchUpInside)
        button.layer.cornerRadius = 140 / 2
        return button
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

    let usernameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Username"
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

    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 5.0
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(signUpButtonTapped(sender:)), for: .touchUpInside)
        button.isEnabled = false
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

    let haveAnAccountAlreadyButton: UIButton = {
        let button = UIButton(type: .system)

        let attributedTitle = NSMutableAttributedString(string: "Have an account already?  ", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)])

        attributedTitle.append(NSAttributedString(string: "Sign In!", attributes: [NSAttributedString.Key.foregroundColor: UIColor.rgb(red: 0, green: 120, blue: 175), NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)]))

        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(haveAnAccountAlreadyButtonTapped), for: .touchUpInside)

        return button
    }()

    // properties

    var didChooseProfilePictureImageFromImagePickerController = false

    // life cycle methods

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

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

        view.addSubview(haveAnAccountAlreadyButton)
        haveAnAccountAlreadyButton.anchor(top: nil, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 10, paddingRight: 20, width: 0, height: 20)
    }

    // Functions

    @objc private func haveAnAccountAlreadyButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    private func resetAllUIFields() {
        emailTextField.text = ""
        passwordTextField.text = ""
        usernameTextField.text = ""
        resetPlusPhotoButtonImageView()
    }

    private func resetPlusPhotoButtonImageView() {
        plusPhotoButton.setImage(#imageLiteral(resourceName: "plus_photo").withRenderingMode(.alwaysOriginal), for: .normal)
        plusPhotoButton.layer.borderColor = UIColor.clear.cgColor
        plusPhotoButton.layer.borderWidth = 0
    }

    private func signUpUser() {
        print("Trying to create a new user")

        guard let email = emailTextField.text, email != "" else {
            print("email textfield is empty")
            return
        }

        guard let password = passwordTextField.text, password != "" else {
            print("password textfield is empty")
            return
        }


        guard let username = usernameTextField.text, username != "" else {
            print("username is empty")
            return
        }

        guard didChooseProfilePictureImageFromImagePickerController, let profileImage = plusPhotoButton.currentImage else {
            print("User not not select a profile image")
            return
        }

        AuthenticationManager.sharedInstance.createUser(withEmail: email, withPassword: password) { (success, result, error) in

            guard success else {
                print(error ?? "")
                return
            }

            print("User successfully created")

            guard let result = result else {
                return
            }

            print("Trying to store user profile image")

            let fileName = UUID().uuidString

            let storageReference = Storage.storage().reference().child(AK_PROFILE_IMAGES).child(fileName)

            StorageManager.sharedInstance.storeImageToFirebase(withImage: profileImage, storageReference: storageReference, completion: { (success, error, downloadURL) in
                if !success {
                    print(error ?? "")
                }

                let values = [
                    AK_USERNAME: username,
                    AK_PROFILE_IMAGE_DOWNLOAD_URL: downloadURL ?? ""
                ]

                print("Trying to store additional values for user to the database")
                DatabaseManager.sharedInstance.updateUserValuesInDatabase(withUserId: result.user.uid, withValue: values, completion: { [unowned self] (success, error) in
                    guard success else {
                        print(error ?? "")
                        return
                    }

                    print("Successfully stored additional values for user to the database")


                    // segue to next screen
                    let rootTabBarVC = RootTabBarVC()
                    self.present(rootTabBarVC, animated: true, completion: nil)
                    self.resetAllUIFields()
                })

            })
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    @objc func signUpButtonTapped(sender: UIButton) {
        signUpUser()
    }

    @objc func plusPhotoButtonTapped(sender:UIButton) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }

    @objc func handleTextfieldChange() {
        let isFormValid = emailTextField.text?.count ?? 0 > 0 && passwordTextField.text?.count ?? 0 > 0 && usernameTextField.text?.count ?? 0 > 0

        if isFormValid {
            signUpButton.isEnabled = true
            signUpButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        } else {
            signUpButton.isEnabled = false
            signUpButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        }
    }

}

extension SignUPVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            didChooseProfilePictureImageFromImagePickerController = true
            plusPhotoButton.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
            plusPhotoButton.layer.cornerRadius = 140 / 2
            plusPhotoButton.layer.masksToBounds = true
            plusPhotoButton.layer.borderColor = UIColor.black.cgColor
            plusPhotoButton.layer.borderWidth = 3.0
            dismiss(animated: true, completion: nil)
        }
    }
}

