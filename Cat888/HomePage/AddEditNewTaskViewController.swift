//
//  AddEditNewTaskViewController.swift
//  Cat888
//
//  Created by Владимир Кацап on 03.09.2024.
//

import UIKit

class AddEditNewTaskViewController: UIViewController {
    
    weak var delegate: DetailPetViewControllerDelegate?
    var pet: Pet?
    var indexPet = 0
    var indexTask = 0
    
    var isNew = true
    
    var taskTextField: UITextField?
    var saveButton: UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        createInterface()
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
        
        let taskLabel = UILabel()
        taskLabel.text = "Task"
        taskLabel.textColor = .black
        taskLabel.font = .systemFont(ofSize: 20, weight: .bold)
        view.addSubview(taskLabel)
        taskLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(closeBut.snp.bottom).inset(-15)
        }
        
        let deskLabel = UILabel()
        deskLabel.textColor = .black
        deskLabel.text = "Description"
        deskLabel.font = .systemFont(ofSize: 17, weight: .bold)
        view.addSubview(deskLabel)
        deskLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(taskLabel.snp.bottom).inset(-15)
        }
        
        taskTextField = {
            let textField = UITextField()
            textField.backgroundColor = .white
            textField.layer.cornerRadius = 12
            textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
            textField.leftViewMode  = .always
            textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
            textField.rightViewMode  = .always
            textField.layer.borderWidth = 1
            textField.placeholder = isNew ? "" : pet?.tasks[indexTask].text
            textField.layer.borderColor = UIColor(red: 255/255, green: 102/255, blue: 172/255, alpha: 1).cgColor
            textField.textColor = .black
            textField.delegate = self
            return textField
        }()
        view.addSubview(taskTextField!)
        taskTextField?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(54)
            make.top.equalTo(deskLabel.snp.bottom).inset(-15)
        })
        
        saveButton = UIButton(type: .system)
        saveButton?.setTitle("Save", for: .normal)
        saveButton?.isEnabled = false
        saveButton?.setTitleColor(.black, for: .normal)
        saveButton?.backgroundColor = UIColor(red: 6/255, green: 12/255, blue: 38/255, alpha: 0.5)
        saveButton?.layer.cornerRadius = 25
        view.addSubview(saveButton!)
        saveButton?.snp.makeConstraints({ make in
            make.height.equalTo(50)
            make.left.equalToSuperview().inset(15)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.right.equalTo(view.snp.centerX).offset(-7.5)
        })
        saveButton?.addTarget(self, action: #selector(save), for: .touchUpInside)
        
        let deleteButton = UIButton(type: .system)
        deleteButton.setTitle("Delete", for: .normal)
        deleteButton.setTitleColor(.black, for: .normal)
        deleteButton.layer.cornerRadius = 25
        deleteButton.backgroundColor = .white
        deleteButton.layer.borderColor = UIColor(red: 254/255, green: 1/255, blue: 255/255, alpha: 1).cgColor
        deleteButton.layer.borderWidth = 1
        view.addSubview(deleteButton)
        deleteButton.isEnabled = isNew ? false:true
        deleteButton.snp.makeConstraints({ make in
            make.height.equalTo(50)
            make.right.equalToSuperview().inset(15)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.left.equalTo(view.snp.centerX).offset(7.5)
        })
        deleteButton.addTarget(self, action: #selector(del), for: .touchUpInside)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(hideKB))
        view.addGestureRecognizer(gesture)
    }
    
    @objc func hideKB() {
        checkBut()
        view.endEditing(true)
    }
    
    @objc func save() {
        let text: String = taskTextField?.text ?? ""
        let task = Task(text: text, isComplete: false)
        
        if isNew != true {
            pet?.tasks[indexTask] = task
            pets[indexPet] = pet!
        } else {
            pet?.tasks.append(task)
            pets[indexPet] = pet!
        }
        
        do {
            let data = try JSONEncoder().encode(pets) //тут мкассив конвертируем в дату
            try saveAthleteArrToFile(data: data)
           
            delegate?.reload(item: pet!)
            self.dismiss(animated: true)
        } catch {
            print("Failed to encode or save athleteArr: \(error)")
        }
        
    }
    
    @objc func del() {
        pet?.tasks.remove(at: indexTask)
        pets[indexPet] = pet!
        
        do {
            let data = try JSONEncoder().encode(pets) //тут мкассив конвертируем в дату
            try saveAthleteArrToFile(data: data)
           
            delegate?.reload(item: pet!)
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
    
    
    func checkBut() {
        if taskTextField?.text?.count ?? 0 > 0 {
            saveButton?.isEnabled = true
            saveButton?.backgroundColor = UIColor(red: 254/255, green: 1/255, blue: 255/255, alpha: 1)
        } else {
            saveButton?.isEnabled = false
            saveButton?.backgroundColor = UIColor(red: 6/255, green: 12/255, blue: 38/255, alpha: 0.5)
        }
    }
    

    @objc func close() {
        self.dismiss(animated: true)
    }
}


extension AddEditNewTaskViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        checkBut()
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        checkBut()
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        checkBut()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        checkBut()
        return true
    }
    
}
