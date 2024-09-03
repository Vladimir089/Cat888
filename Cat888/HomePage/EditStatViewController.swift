//
//  EditStatViewController.swift
//  Cat888
//
//  Created by Владимир Кацап on 02.09.2024.
//

import UIKit

class EditStatViewController: UIViewController {
    
    weak var delegate: HomeViewControllerDelegate?
    var topText, midText, botText: String?
    
    //ui
    var perfTextField, totalTextField, tasksTextField: UITextField?
    
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
        closeBut.addTarget(self, action: #selector(closeVC), for: .touchUpInside)
        
        let enterDataLabel = UILabel()
        enterDataLabel.text = "Enter data"
        enterDataLabel.textColor = .black
        enterDataLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        view.addSubview(enterDataLabel)
        enterDataLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(closeBut.snp.bottom).inset(-15)
        }
        
        let performLabel = createLabel(text: "Procedures performed")
        view.addSubview(performLabel)
        performLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(enterDataLabel.snp.bottom).inset(-15)
        }
        
        perfTextField = createTextField()
        perfTextField?.placeholder = topText
        view.addSubview(perfTextField!)
        perfTextField?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(54)
            make.top.equalTo(performLabel.snp.bottom).inset(-10)
        })
        
        let totalLabel = createLabel(text: "Total procedures")
        view.addSubview(totalLabel)
        totalLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(perfTextField!.snp.bottom).inset(-15)
        }
        
        totalTextField = createTextField()
        totalTextField?.placeholder = midText
        view.addSubview(totalTextField!)
        totalTextField?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(54)
            make.top.equalTo(totalLabel.snp.bottom).inset(-10)
        })
        
        let activeLabel = createLabel(text: "Active tasks")
        view.addSubview(activeLabel)
        activeLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(totalTextField!.snp.bottom).inset(-15)
        }
        
        tasksTextField = createTextField()
        tasksTextField?.placeholder = botText
        view.addSubview(tasksTextField!)
        tasksTextField?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(54)
            make.top.equalTo(activeLabel.snp.bottom).inset(-10)
        })
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(hideKB))
        view.addGestureRecognizer(gesture)
        
        saveButton = {
            let button = UIButton(type: .system)
            button.backgroundColor = UIColor(red: 6/255, green: 12/255, blue: 38/255, alpha: 0.5)
            button.setTitle("Save", for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.layer.cornerRadius = 25
            button.isEnabled = false
            return button
        }()
        view.addSubview(saveButton!)
        saveButton?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(50)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        })
        saveButton?.addTarget(self, action: #selector(save), for: .touchUpInside)
    }
    
    @objc func save() {
        let perfText = perfTextField?.text ?? ""
        let perf = Int(perfText) ?? 0
        
        let totalText = totalTextField?.text ?? ""
        let total = Int(totalText) ?? 0
        
        let sasksText = tasksTextField?.text ?? ""
        let tasks: Int = Int(sasksText) ?? 0
        
        UserDefaults.standard.setValue([perf,total,tasks], forKey: "Stat")
        
        let onePar: Float = Float(perf)
        let twoPar: Float = Float(total)
        
        let prog: Float = onePar / twoPar
        
        delegate?.reloadLabels(leftText: perf, rightText: total, progress: prog, botText: tasks)
        self.dismiss(animated: true)
    }
    
    func checkButton() {
        if perfTextField?.text?.count ?? 0 > 0, totalTextField?.text?.count ?? 0 > 0 , tasksTextField?.text?.count ?? 0 > 0 {
            saveButton?.isEnabled = true
            saveButton?.backgroundColor = UIColor(red: 254/255, green: 1/255, blue: 255/255, alpha: 1)
        } else {
            saveButton?.isEnabled = false
            saveButton?.backgroundColor = UIColor(red: 6/255, green: 12/255, blue: 38/255, alpha: 0.5)
        }
    }
    
    @objc func hideKB() {
        checkButton()
        view.endEditing(true)
    }
    
    func createLabel(text: String) -> UILabel {
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
    
    
    @objc func closeVC() {
        delegate = nil
        view.endEditing(true)
        self.dismiss(animated: true)
    }
    
    
}


extension EditStatViewController: UITextFieldDelegate {
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
