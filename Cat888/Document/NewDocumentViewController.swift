//
//  NewDocumentViewController.swift
//  Cat888
//
//  Created by Владимир Кацап on 03.09.2024.
//

import UIKit

class NewDocumentViewController: UIViewController, UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    weak var delegate: DocumentViewControllerDelegate?
    weak var twoDeleagte: DetailDocumentViewControllerDelegate?
    
    var isNew = true
    var index = 0
    var doc: Document?
    
    //new
    var imageView: UIImageView?
    var nameTextField: UITextField?
    var deskTextView: UITextView?
    
    var saveButton: UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        createInterface()
        isNewCheck()
    }
    

    func createInterface() {
        let hideView = UIView()
        hideView.backgroundColor = UIColor(red: 60/255, green: 60/255, blue: 67/255, alpha: 0.3)
        hideView.layer.cornerRadius = 2.5
        view.addSubview(hideView)
        hideView.snp.makeConstraints { make in
            make.height.equalTo(5)
            make.width.equalTo(36)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(5)
        }
        
        let closeBut = UIButton(type: .system)
        closeBut.setBackgroundImage(.closeBut, for: .normal)
        view.addSubview(closeBut)
        closeBut.snp.makeConstraints { make in
            make.height.width.equalTo(30)
            make.right.equalToSuperview().inset(15)
            make.top.equalTo(hideView.snp.bottom).inset(-5)
        }
        closeBut.addTarget(self, action: #selector(close), for: .touchUpInside)
        
        let enterDatalabel = createLabel(text: "Enter data")
        enterDatalabel.font = .systemFont(ofSize: 20, weight: .semibold)
        view.addSubview(enterDatalabel)
        enterDatalabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(closeBut.snp.bottom).inset(-15)
        }
        
        imageView = {
            let imageView = UIImageView(image: .niImageView)
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 20
            imageView.isUserInteractionEnabled = true
            return imageView
        }()
        view.addSubview(imageView!)
        imageView?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(enterDatalabel.snp.bottom).inset(-15)
            make.height.equalTo(158)
        })
        let gestureStImage = UITapGestureRecognizer(target: self, action: #selector(setImage))
        imageView?.addGestureRecognizer(gestureStImage)
        
        let nameLabel = createLabel(text: "Name")
        view.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(imageView!.snp.bottom).inset(-15)
        }
        
        nameTextField = createTextField()
        view.addSubview(nameTextField!)
        nameTextField?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(54)
            make.top.equalTo(nameLabel.snp.bottom).inset(-10)
        })
        
        let labelDesk = createLabel(text: "Description")
        view.addSubview(labelDesk)
        labelDesk.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(nameTextField!.snp.bottom).inset(-15)
        }
        
        deskTextView = {
            let textView = UITextView()
            textView.backgroundColor = .white
            textView.textColor = .black
            textView.font = .systemFont(ofSize: 17, weight: .regular)
            textView.layer.cornerRadius = 12
            textView.layer.borderWidth = 1
            textView.delegate = self
            textView.textContainer.maximumNumberOfLines = 2
            textView.layer.borderColor = UIColor(red: 255/255, green: 102/255, blue: 172/255, alpha: 1).cgColor
            textView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            return textView
        }()
        view.addSubview(deskTextView!)
        deskTextView?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(labelDesk.snp.bottom).inset(-10)
            make.height.equalTo(76)
        })
        
        saveButton = {
            let button = UIButton(type: .system)
            button.setTitle("Save", for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.isEnabled = false
            button.layer.cornerRadius = 25
            button.backgroundColor = UIColor(red: 6/255, green: 12/255, blue: 38/255, alpha: 0.5)
            return button
        }()
        view.addSubview(saveButton!)
        saveButton?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(50)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        })
        saveButton?.addTarget(self, action: #selector(savePet), for: .touchUpInside)
        
        let hideKBGesture = UITapGestureRecognizer(target: self, action: #selector(hideKb))
        view.addGestureRecognizer(hideKBGesture)
       
    }
    
    func checkButton() {
        if imageView?.image != .niImageView, nameTextField?.text?.count ?? 0 > 0, deskTextView?.text.count ?? 0 > 0 {
            UIView.animate(withDuration: 0.3) { [self] in
                saveButton?.isEnabled = true
                saveButton?.backgroundColor = UIColor(red: 254/255, green: 1/255, blue: 255/255, alpha: 1)
            }
        } else {
            saveButton?.isEnabled = false
            saveButton?.backgroundColor = UIColor(red: 6/255, green: 12/255, blue: 38/255, alpha: 0.5)
        }
    }
    
    func isNewCheck() {
        if isNew == false {
            imageView?.image = UIImage(data: doc?.image ?? Data())
            nameTextField?.placeholder = doc?.name
            deskTextView?.text = doc?.desk
        }
    }
    
    @objc func hideKb() {
        checkButton()
        view.endEditing(true)
    }
    
    @objc func setImage() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = false
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let pickedImage = info[.originalImage] as? UIImage {
            imageView?.image = pickedImage
            checkButton()
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func createTextField() -> UITextField {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 12
        textField.layer.borderColor = UIColor(red: 255/255, green: 102/255, blue: 172/255, alpha: 1).cgColor
        textField.layer.borderWidth = 1
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        textField.leftViewMode = .always
        textField.rightViewMode = .always
        textField.delegate = self
        return textField
    }
    
    func createLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = .black
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        return label
    }
    
    @objc func close() {
        self.dismiss(animated: true)
    }
    
    @objc func savePet() {
        let image = imageView?.image?.jpegData(compressionQuality: 1)
        let name: String = nameTextField?.text ?? ""
        let desk: String = deskTextView?.text ?? ""
        
        
        let doc = Document(image: image ?? Data(), name: name, desk: desk, images: isNew ? [] : doc!.images)
        if isNew == true {
            arrDoc.append(doc)
        } else {
            arrDoc[index] = doc
        }
        
        do {
            let data = try JSONEncoder().encode(arrDoc) //тут мкассив конвертируем в дату
            try saveAthleteArrToFile(data: data)
            delegate?.reloadCollection()
            twoDeleagte?.reloadProfile(newDoc: doc)
            delegate = nil
            twoDeleagte = nil
            self.dismiss(animated: true)
        } catch {
            print("Failed to encode or save athleteArr: \(error)")
        }
        
    }
    
    func saveAthleteArrToFile(data: Data) throws {
        let fileManager = FileManager.default
        if let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let filePath = documentDirectory.appendingPathComponent("doc.plist")
            try data.write(to: filePath)
        } else {
            throw NSError(domain: "SaveError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Unable to get document directory"])
        }
    }

}


extension NewDocumentViewController: UITextFieldDelegate, UITextViewDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        checkButton()
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        UIView.animate(withDuration: 0.3) {
            self.view.transform = CGAffineTransform(translationX: 0, y: -250)
            
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        UIView.animate(withDuration: 0.3) {
            self.view.transform = .identity
        }
        self.checkButton()
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        checkButton()
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        checkButton()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        checkButton()
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        checkButton()
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        checkButton()
    }
}
