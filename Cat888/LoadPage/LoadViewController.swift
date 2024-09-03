//
//  LoadViewController.swift
//  Cat888
//
//  Created by Владимир Кацап on 02.09.2024.
//

import UIKit
import SnapKit

class LoadViewController: UIViewController {
    
    var timer: Timer?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationBar()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 255/255, green: 239/255, blue: 255/255, alpha: 1)
        createInterface()
        timer = Timer.scheduledTimer(withTimeInterval: 0, repeats: false, block: { [self] _ in //поменять тайминтервал на 7
            timer?.invalidate()
            timer = nil
            if isBet == false {
                if UserDefaults.standard.value(forKey: "tab") != nil {
                    self.navigationController?.setViewControllers([TabBarViewController()], animated: true)
                } else {
                    self.navigationController?.setViewControllers([OnbUserViewController()], animated: true)
                }
            } else {
                
            }
        })
    }
    
    func createInterface() {
        let imageView = UIImageView(image: .logLoad)
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.height.width.equalTo(244)
            make.center.equalToSuperview()
            make.center.equalToSuperview()
        }
        
        let activityView = UIActivityIndicatorView(style: .large)
        activityView.color = UIColor(red: 254/255, green: 1/255, blue: 255/255, alpha: 1)
        activityView.startAnimating()
        view.addSubview(activityView)
        activityView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).inset(-90)
        }
    }
    
    


}


extension UIViewController {
    func hideNavigationBar() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func showNavigationBar() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
}
