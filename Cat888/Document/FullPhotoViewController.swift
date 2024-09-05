//
//  FullPhotoViewController.swift
//  Cat888
//
//  Created by Владимир Кацап on 04.09.2024.
//

import UIKit

class FullPhotoViewController: UIViewController {
    
    var doc: PhotoAndDescription?

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
        closeBut.setBackgroundImage(.closeBut2, for: .normal)
        view.addSubview(closeBut)
        closeBut.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.width.equalTo(39)
            make.right.equalToSuperview()
            make.top.equalTo(hideView.snp.bottom).inset(-5)
        }
        closeBut.addTarget(self, action: #selector(close), for: .touchUpInside)
        
        let nameLabel = {
            let label = UILabel()
            label.text = doc?.text
            label.textColor = .black
            label.font = .systemFont(ofSize: 15)
            return label
        }()
        view.addSubview(nameLabel)
        nameLabel.snp.makeConstraints({ make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(closeBut)
        })
        
        let imageView = UIImageView(image: UIImage(data: doc?.image ?? Data()))
        view.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        imageView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(nameLabel.snp.bottom).inset(-15)
            make.height.equalTo(523)
        }
        
        let closeButton = UIButton(type: .system)
        closeButton.layer.cornerRadius = 25
        closeButton.setTitle("Close", for: .normal)
        closeButton.backgroundColor = UIColor(red: 254/255, green: 1/255, blue: 255/255, alpha: 1)
        closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        closeButton.setTitleColor(.black, for: .normal)
        view.addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.height.equalTo(50)
        }
        
    }
    
    @objc func close() {
        self.dismiss(animated: true)
    }
}
