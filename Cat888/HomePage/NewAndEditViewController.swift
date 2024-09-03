//
//  NewAndEditViewController.swift
//  Cat888
//
//  Created by Владимир Кацап on 02.09.2024.
//

import UIKit

class NewAndEditViewController: UIViewController, UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    weak var delegate: HomeViewControllerDelegate?
    weak var detailDelegate: DetailPetViewControllerDelegate?
    var isNew = true
    var pet: Pet?
    var idnex: Int?
    
    //ui
    var imageView: UIImageView?
    var nameTextField: UITextField?
    var health: Int?
    var ageTextField, genderTextField, weightTextField, breedTextField: UITextField?
    var deskTextView: UITextView?
    
    var saveButton, delButton: UIButton?
    
    //other
    var arrButtons: [UIButton] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        fillButt()
        createInterface()
    }
    
    
    func checkIsNew() {
        if isNew == false {
            imageView?.image = UIImage(data: pet?.image ?? Data())
            nameTextField?.placeholder = pet?.name
            health = pet?.health
            arrButtons[health ?? 0].tintColor = UIColor(red: 254/255, green: 1/255, blue: 255/255, alpha: 1)
            ageTextField?.placeholder = pet?.age
            genderTextField?.placeholder = pet?.gender
            weightTextField?.placeholder = pet?.weight
            breedTextField?.placeholder = pet?.breed
            deskTextView?.text = pet?.desk
        }
    }

    func createInterface() {
        let hideView = UIView()
        hideView.layer.cornerRadius = 2.5
        hideView.backgroundColor = UIColor(red: 60/255, green: 60/255, blue: 67/255, alpha: 0.3)
        view.addSubview(hideView)
        hideView.snp.makeConstraints { make in
            make.height.equalTo(5)
            make.width.equalTo(36)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(5)
        }
        
        let profLabel = UILabel()
        profLabel.text = "Profile"
        profLabel.textColor = .black
        view.addSubview(profLabel)
        profLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(hideView.snp.bottom).inset(-15)
        }
        
        let closeButton = UIButton(type: .system)
        closeButton.setBackgroundImage(.closeBut2, for: .normal)
        view.addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.width.equalTo(39)
            make.height.equalTo(44)
            make.right.equalToSuperview()
            make.centerY.equalTo(profLabel)
        }
        closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        
        let collection: UICollectionView = {
            let layout = UICollectionViewFlowLayout()
            let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
            layout.scrollDirection = .vertical
            collection.backgroundColor = .white
            collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "1")
            collection.showsVerticalScrollIndicator = false
            collection.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
            collection.delegate = self
            collection.dataSource = self
            return collection
        }()
        view.addSubview(collection)
        collection.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(closeButton.snp.bottom).inset(-15)
            make.bottom.equalToSuperview()
        }
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(hideKB))
        view.addGestureRecognizer(gesture)
        
    }
    
    func fillButt() {
        let arr = [UIImage.but1, UIImage.but2, UIImage.but3]
        var tag = 0
        for i in arr {
            let button = UIButton()
            
            button.setBackgroundImage(i.withRenderingMode(.alwaysTemplate), for: .normal)
            button.tintColor = .black.withAlphaComponent(0.5)
            button.tag = tag
            button.addTarget(self, action: #selector(healthTapped), for: .touchUpInside)
            arrButtons.append(button)
            tag += 1
        }
    }
    
    @objc func close() {
        delegate = nil
        self.dismiss(animated: true)
    }
    
    func createlabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = .black
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        return label
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
        textField.keyboardType = .numberPad
        return textField
    }
    
    @objc func healthTapped(sender: UIButton) {
        health = sender.tag
        for i in arrButtons {
            i.tintColor = .black.withAlphaComponent(0.5)
        }
        sender.tintColor = UIColor(red: 254/255, green: 1/255, blue: 255/255, alpha: 1)
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
    
    
    @objc func hideKB() {
        view.endEditing(true)
    }
    
    func checkButton() {
        if imageView?.image != .niImageView , nameTextField?.text?.count ?? 0 > 0, health != nil, ageTextField?.text?.count ?? 0 > 0, genderTextField?.text?.count ?? 0 > 0, weightTextField?.text?.count ?? 0 > 0, breedTextField?.text?.count ?? 0 > 0, deskTextView?.text.count ?? 0 > 0 {
            saveButton?.isEnabled = true
            saveButton?.backgroundColor = UIColor(red: 254/255, green: 1/255, blue: 255/255, alpha: 1)
        } else {
            saveButton?.isEnabled = false
            saveButton?.backgroundColor = UIColor(red: 6/255, green: 12/255, blue: 38/255, alpha: 0.5)
        }
    }
    
    @objc func save() {
        let image: Data = imageView?.image?.jpegData(compressionQuality: 1) ?? Data()
        let heal: Int = health ?? 0
        let name: String = nameTextField?.text ?? ""
        let age: String = ageTextField?.text ?? ""
        let gender: String = genderTextField?.text ?? ""
        let weight: String = weightTextField?.text ?? ""
        let bread: String = breedTextField?.text ?? ""
        let desk: String = deskTextView?.text ?? ""
        
        
        let pet = Pet(image: image, name: name, health: heal, age: age, gender: gender, weight: weight, breed: bread, desk: desk, tasks: isNew ? [] : pet!.tasks)
        
        if isNew == true {
            pets.append(pet)
        } else {
            pets[idnex!] = pet
        }
        
        do {
            let data = try JSONEncoder().encode(pets) //тут мкассив конвертируем в дату
            try saveAthleteArrToFile(data: data)
            detailDelegate?.reload(item: pet)
            delegate?.reloadCollection()
            self.dismiss(animated: true)
        } catch {
            print("Failed to encode or save athleteArr: \(error)")
        }
        
    }
    
    @objc func del() {
        pets.remove(at: idnex!)
        
        do {
            let data = try JSONEncoder().encode(pets) //тут мкассив конвертируем в дату
            try saveAthleteArrToFile(data: data)
           
            detailDelegate?.del()
            self.dismiss(animated: true)
        } catch {
            print("Failed to encode or save athleteArr: \(error)")
        }
    }
    
    
    
    func saveAthleteArrToFile(data: Data) throws {
        let fileManager = FileManager.default
        if let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let filePath = documentDirectory.appendingPathComponent("pet.plist")
            try data.write(to: filePath)
        } else {
            throw NSError(domain: "SaveError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Unable to get document directory"])
        }
    }
}


extension NewAndEditViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "1", for: indexPath)
        cell.backgroundColor = .white
        cell.subviews.forEach { $0.removeFromSuperview() }
        
        imageView = {
            let imageView = UIImageView(image: .niImageView)
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 10
            imageView.isUserInteractionEnabled = true
            return imageView
        }()
        cell.addSubview(imageView!)
        imageView?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(183)
        })
        let gesture = UITapGestureRecognizer(target: self, action: #selector(setImage))
        imageView?.addGestureRecognizer(gesture)
        
        let nameLabel = createlabel(text: "Name")
        cell.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(imageView!.snp.bottom).inset(-15)
        }
        
        nameTextField = createTextField()
        cell.addSubview(nameTextField!)
        nameTextField?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview()
            make.height.equalTo(54)
            make.top.equalTo(nameLabel.snp.bottom).inset(-10)
        })
        
        let healLabel = createlabel(text: "Health")
        cell.addSubview(healLabel)
        healLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(nameTextField!.snp.bottom).inset(-15)
        }
        
        let stackView = UIStackView(arrangedSubviews: arrButtons)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        cell.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.height.equalTo(50)
            make.top.equalTo(healLabel.snp.bottom).inset(-10)
            make.width.equalTo(180)
        }
        
        let ageLabel = createlabel(text: "Age")
        cell.addSubview(ageLabel)
        ageLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(stackView.snp.bottom).inset(-15)
        }
        
        ageTextField = createTextField()
        cell.addSubview(ageTextField!)
        ageTextField?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview()
            make.height.equalTo(54)
            make.top.equalTo(ageLabel.snp.bottom).inset(-10)
        })
        
        let genderLabel = createlabel(text: "Gender")
        cell.addSubview(genderLabel)
        genderLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(ageTextField!.snp.bottom).inset(-15)
        }
        genderTextField = createTextField()
        cell.addSubview(genderTextField!)
        genderTextField?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview()
            make.height.equalTo(54)
            make.top.equalTo(genderLabel.snp.bottom).inset(-10)
        })
        
        let weightLabel = createlabel(text: "Weight")
        cell.addSubview(weightLabel)
        weightLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(genderTextField!.snp.bottom).inset(-15)
        }
        
        weightTextField = createTextField()
        cell.addSubview(weightTextField!)
        weightTextField?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview()
            make.height.equalTo(54)
            make.top.equalTo(weightLabel.snp.bottom).inset(-10)
        })
        
        let breedLabel = createlabel(text: "Breed")
        cell.addSubview(breedLabel)
        breedLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(weightTextField!.snp.bottom).inset(-15)
        }
        breedTextField = createTextField()
        cell.addSubview(breedTextField!)
        breedTextField?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview()
            make.height.equalTo(54)
            make.top.equalTo(breedLabel.snp.bottom).inset(-10)
        })
        
        let deskLabel = createlabel(text: "Description")
        cell.addSubview(deskLabel)
        deskLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(breedTextField!.snp.bottom).inset(-15)
        }
        deskTextView = {
            let textview = UITextView()
            textview.textColor = .black
            textview.textContainer.maximumNumberOfLines = 2
            textview.font = .systemFont(ofSize: 17, weight: .regular)
            textview.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            textview.layer.cornerRadius = 12
            textview.delegate = self
            textview.layer.borderColor = UIColor(red: 255/255, green: 102/255, blue: 172/255, alpha: 1).cgColor
            textview.layer.borderWidth = 1
            return textview
        }()
        cell.addSubview(deskTextView!)
        deskTextView?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview()
            make.top.equalTo(deskLabel.snp.bottom).inset(-10)
            make.height.equalTo(76)
        })
        
        saveButton = UIButton(type: .system)
        saveButton?.setTitle("Save", for: .normal)
        saveButton?.isEnabled = false
        saveButton?.setTitleColor(.black, for: .normal)
        saveButton?.backgroundColor = UIColor(red: 6/255, green: 12/255, blue: 38/255, alpha: 0.5)
        saveButton?.layer.cornerRadius = 25
        cell.addSubview(saveButton!)
        saveButton?.snp.makeConstraints({ make in
            make.height.equalTo(50)
            make.left.equalToSuperview()
            make.top.equalTo(deskTextView!.snp.bottom).inset(-15)
            make.right.equalTo(cell.snp.centerX).offset(-7.5)
        })
        saveButton?.addTarget(self, action: #selector(save), for: .touchUpInside)
        
        let deleteButton = UIButton(type: .system)
        deleteButton.setTitle("Delete", for: .normal)
        deleteButton.setTitleColor(.black, for: .normal)
        deleteButton.layer.cornerRadius = 25
        deleteButton.backgroundColor = .white
        deleteButton.layer.borderColor = UIColor(red: 254/255, green: 1/255, blue: 255/255, alpha: 1).cgColor
        deleteButton.layer.borderWidth = 1
        cell.addSubview(deleteButton)
        deleteButton.isEnabled = isNew ? false:true
        deleteButton.snp.makeConstraints({ make in
            make.height.equalTo(50)
            make.right.equalToSuperview()
            make.top.equalTo(deskTextView!.snp.bottom).inset(-15)
            make.left.equalTo(cell.snp.centerX).offset(7.5)
        })
        deleteButton.addTarget(self, action: #selector(del), for: .touchUpInside)
        checkIsNew()
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 1000)
    }
    
}


extension NewAndEditViewController: UITextFieldDelegate, UITextViewDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        checkButton()
        return true
    }
    
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == breedTextField || textField == weightTextField {
            checkButton()
            UIView.animate(withDuration: 0.3) {
                self.view.transform = CGAffineTransform(translationX: 0, y: -250)
                
            }
        }
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkButton()
        UIView.animate(withDuration: 0.3) {
              self.view.transform = .identity
          }
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        checkButton()
        UIView.animate(withDuration: 0.3) {
            self.view.transform = CGAffineTransform(translationX: 0, y: -300)
            
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        checkButton()
        UIView.animate(withDuration: 0.3) {
              self.view.transform = .identity
          }
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
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        checkButton()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        checkButton()
        return true
    }
    
}
