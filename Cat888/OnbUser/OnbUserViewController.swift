//
//  OnbUserViewController.swift
//  Cat888
//
//  Created by Владимир Кацап on 02.09.2024.
//

import UIKit

class OnbUserViewController: UIViewController {
    
    var imageView: UIImageView?
    var topLabel: UILabel?
    var botLabel: UILabel?
    var arrBotDotsView: [UIView] = []
    
    var tap = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 255/255, green: 239/255, blue: 255/255, alpha: 1)
        fillArrViews()
        createInterface()
    }
    

    func createInterface() {
        imageView = UIImageView(image: .load1)
        view.addSubview(imageView!)
        imageView?.snp.makeConstraints({ make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(545)
        })
        
        topLabel = {
            let label = UILabel()
            label.numberOfLines = 2
            label.textColor = .black
            label.font = .systemFont(ofSize: 28, weight: .bold)
            label.textAlignment = .center
            label.text = "Keep an eye on your pet"
            return label
        }()
        view.addSubview(topLabel!)
        topLabel?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(imageView!.snp.bottom).inset(-15)
        })
        
        botLabel = {
            let label = UILabel()
            label.textColor = .black.withAlphaComponent(0.7)
            label.font = .systemFont(ofSize: 15, weight: .regular)
            label.numberOfLines = 2
            label.textAlignment = .center
            label.text = "Monitor task completion"
            return label
        }()
        view.addSubview(botLabel!)
        botLabel?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(topLabel!.snp.bottom).inset(-15)
        })
        
        let nextButton: UIButton = {
            let button = UIButton(type: .system)
            button.layer.cornerRadius = 25
            button.backgroundColor = UIColor(red: 254/255, green: 1/255, blue: 255/255, alpha: 1)
            button.setTitle("Next", for: .normal)
            button.setTitleColor(.black, for: .normal)
            return button
        }()
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(50)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(30)
        }
        nextButton.addTarget(self, action: #selector(nextPage), for: .touchUpInside)
        
        arrBotDotsView[0].backgroundColor = UIColor(red: 254/255, green: 1/255, blue: 255/255, alpha: 1)
        view.addSubview(arrBotDotsView[0])
        arrBotDotsView[0].snp.makeConstraints { make in
            make.height.width.equalTo(8)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.centerX.equalToSuperview().offset(-7.5)
        }
        
        
        view.addSubview(arrBotDotsView[1])
        arrBotDotsView[1].snp.makeConstraints { make in
            make.height.width.equalTo(8)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.centerX.equalToSuperview().offset(7.5)
        }
        
    }
    
    @objc func nextPage() {
        tap += 1
        
        switch tap {
        case 1:
            imageView?.image = .load2
            topLabel?.text = "Fill out information about\nyour animals"
            botLabel?.text = "Add new backgrounds, track your friend's\nperformance"
            arrBotDotsView[1].backgroundColor = UIColor(red: 254/255, green: 1/255, blue: 255/255, alpha: 1)
            arrBotDotsView[0].backgroundColor = UIColor(red: 229/255, green: 25/255, blue: 64/255, alpha: 0.5)
        case 2:
            self.navigationController?.setViewControllers([TabBarViewController()], animated: true)
        default:
            return
        }
    }
    
    func fillArrViews() {
        for _ in 0..<2 {
            let view = UIView()
            view.backgroundColor = UIColor(red: 229/255, green: 25/255, blue: 64/255, alpha: 0.5)
            view.layer.cornerRadius = 4
            arrBotDotsView.append(view)
        }
    }

}
