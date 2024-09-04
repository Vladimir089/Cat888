//
//  PhotoEditCreateViewController.swift
//  Cat888
//
//  Created by Владимир Кацап on 04.09.2024.
//

import UIKit

class PhotoEditCreateViewController: UIViewController, UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    weak var delegate: DetailDocumentViewControllerDelegate?
    var doc: Document?
    var index = 0 
    
    //edit or new
    var isNew = true
    var indexPhoto = 0 
    var photo: PhotoAndDescription?
    
    //ui
    var imageView: UIImageView?
    var nameTextField: UITextField?
    var nameLabel: UILabel?
    
    var saveButton: UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        createInterface()
        checkIsNew()
    }
    
    func checkIsNew() {
        if isNew == false {
            imageView?.image = UIImage(data: photo?.image ?? Data())
            nameLabel?.text = photo?.text
            nameTextField?.placeholder = photo?.text
        }
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
        closeBut.setBackgroundImage(.closeBut2, for: .normal)
        view.addSubview(closeBut)
        closeBut.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.width.equalTo(39)
            make.right.equalToSuperview()
            make.top.equalTo(hideView.snp.bottom).inset(-5)
        }
        closeBut.addTarget(self, action: #selector(close), for: .touchUpInside)
        
        nameLabel = {
            let label = UILabel()
            label.text = photo?.text ?? " "
            label.textColor = .black
            label.font = .systemFont(ofSize: 15)
            return label
        }()
        view.addSubview(nameLabel!)
        nameLabel?.snp.makeConstraints({ make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(closeBut)
        })
        
        imageView = {
            let imageView = UIImageView(image: .niImageView)
            imageView.layer.cornerRadius = 10
            imageView.clipsToBounds = true
            return imageView
        }()
        view.addSubview(imageView!)
        imageView?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(closeBut.snp.bottom).inset(-15)
            make.height.equalTo(183)
        })
        
        nameTextField = {
            let textField = UITextField()
            textField.backgroundColor = .white
            textField.layer.cornerRadius = 12
            textField.layer.borderColor = UIColor(red: 255/255, green: 102/255, blue: 172/255, alpha: 1).cgColor
            textField.layer.borderWidth = 1
            textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
            textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
            textField.leftViewMode = .always
            textField.rightViewMode = .always
            textField.placeholder = "Description"
            textField.delegate = self
            return textField
        }()
        view.addSubview(nameTextField!)
        nameTextField?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(54)
            make.top.equalTo(imageView!.snp.bottom).inset(-15)
        })
        
        let addPhotoButton = UIButton(type: .system)
        addPhotoButton.layer.cornerRadius = 25
        addPhotoButton.clipsToBounds = true
        addPhotoButton.backgroundColor = UIColor(red: 254/255, green: 1/255, blue: 255/255, alpha: 1)
        addPhotoButton.setTitle("Add foto", for: .normal)
        addPhotoButton.setTitleColor(.black, for: .normal)
        view.addSubview(addPhotoButton)
        addPhotoButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(50)
            make.top.equalTo(nameTextField!.snp.bottom).inset(-15)
        }
        addPhotoButton.addTarget(self, action: #selector(setImage), for: .touchUpInside)
        
        saveButton = {
            let button = UIButton(type: .system)
            button.setTitle("Save", for: .normal)
            button.layer.cornerRadius = 25
            button.isEnabled = false
            button.setTitleColor(.black, for: .normal)
            button.backgroundColor = UIColor(red: 6/255, green: 12/255, blue: 38/255, alpha: 0.5)
            return button
        }()
        view.addSubview(saveButton!)
        saveButton!.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.height.equalTo(50)
            make.top.equalTo(addPhotoButton.snp.bottom).inset(-15)
            make.right.equalTo(view.snp.centerX).offset(-7.5)
        }
        saveButton?.addTarget(self, action: #selector(saveImage), for: .touchUpInside)
        
        let delButton = UIButton(type: .system)
        delButton.setTitle("Delete", for: .normal)
        delButton.isEnabled = isNew ? false : true
        delButton.setTitleColor(.black, for: .normal)
        delButton.backgroundColor = .clear
        delButton.layer.borderWidth = 1
        delButton.layer.borderColor = UIColor(red: 254/255, green: 1/255, blue: 255/255, alpha: 1).cgColor
        delButton.layer.cornerRadius = 25
        view.addSubview(delButton)
        delButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.right.equalToSuperview().inset(15)
            make.top.equalTo(addPhotoButton.snp.bottom).inset(-15)
            make.left.equalTo(view.snp.centerX).offset(7.5)
        }
        delButton.addTarget(self, action: #selector(del), for: .touchUpInside)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(hideKB))
        view.addGestureRecognizer(gesture)
    }
    
    @objc func saveImage() {
        let text:String = nameTextField?.text ?? ""
        let image: Data = imageView?.image?.jpegData(compressionQuality: 1) ?? Data()
        
        let item = PhotoAndDescription(text: text, image: image)
        
        if isNew == true {
            doc?.images.append(item)
            arrDoc[index] = doc!
        } else {
            doc?.images[indexPhoto] = item
            arrDoc[index] = doc!
        }
        do {
            let data = try JSONEncoder().encode(arrDoc) //тут мкассив конвертируем в дату
            try saveAthleteArrToFile(data: data)
           
            delegate?.reloadItems(newDoc: doc!)
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
    
    @objc func del() {
        doc?.images.remove(at:indexPhoto)
        arrDoc[index] = doc!
        do {
            let data = try JSONEncoder().encode(arrDoc) //тут мкассив конвертируем в дату
            try saveAthleteArrToFile(data: data)
           
            delegate?.del(dock: doc!)
            self.dismiss(animated: true)
        } catch {
            print("Failed to encode or save athleteArr: \(error)")
        }
    }
    
    func checkButton() {
        if imageView?.image != .niImageView, nameTextField?.text?.count ?? 0 > 0 {
            saveButton?.isEnabled = true
            saveButton?.backgroundColor = UIColor(red: 254/255, green: 1/255, blue: 255/255, alpha: 1)
        } else {
            saveButton?.isEnabled = false
            saveButton?.backgroundColor = UIColor(red: 6/255, green: 12/255, blue: 38/255, alpha: 0.5)
        }
    }
    
    @objc func hideKB() {
        view.endEditing(true)
    }
    
    @objc func setImage() {
        view.endEditing(true)
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
    
    
    @objc func close() {
        delegate = nil
        self.dismiss(animated: true)
    }

}


extension PhotoEditCreateViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideKB()
        checkButton()
        return true
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
}
