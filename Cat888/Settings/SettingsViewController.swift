//
//  SettingsViewController.swift
//  Cat888
//
//  Created by Владимир Кацап on 05.09.2024.
//

import UIKit
import StoreKit
import WebKit

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 255/255, green: 239/255, blue: 255/255, alpha: 1)
        createView()
    }
    
    func createView() {
        let settingsLabel = UILabel()
        settingsLabel.text = "Settings"
        settingsLabel.textColor = .black
        settingsLabel.font = .systemFont(ofSize: 34, weight: .bold)
        view.addSubview(settingsLabel)
        settingsLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
        let rateButton = createButton(image: .rate, text: "Rate our app")
        view.addSubview(rateButton)
        rateButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(settingsLabel.snp.bottom).inset(-30)
            make.height.equalTo(50)
        }
        rateButton.addTarget(self, action: #selector(rateApps), for: .touchUpInside)
        
        let polButton = createButton(image: .pol, text: "Usage Policy")
        view.addSubview(polButton)
        polButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(rateButton.snp.bottom).inset(-10)
            make.height.equalTo(50)
        }
        polButton.addTarget(self, action: #selector(policy), for: .touchUpInside)
        
        let shareButton = createButton(image: .share, text: "Share our app")
        view.addSubview(shareButton)
        shareButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(polButton.snp.bottom).inset(-10)
            make.height.equalTo(50)
        }
        shareButton.addTarget(self, action: #selector(shareApps), for: .touchUpInside)
        
    }
    
    func createButton(image: UIImage, text: String) -> UIButton {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 255/255, green: 128/255, blue: 255/255, alpha: 1)
        button.layer.cornerRadius = 10
        
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        button.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.height.equalTo(22)
            make.width.equalTo(18)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(15)
        }
        
        let label = UILabel()
        label.text = text
        label.textColor = .white
        label.font = .systemFont(ofSize: 17, weight: .regular)
        button.addSubview(label)
        label.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(imageView.snp.right).inset(-15)
        }
        
        let arrowImageView = UIImageView(image: .arrowRight)
        arrowImageView.contentMode = .scaleAspectFit
        button.addSubview(arrowImageView)
        arrowImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(15)
            make.height.equalTo(20)
            make.width.equalTo(13)
        }
     
        return button
    }
    
    @objc func policy() {
        let webVC = WebViewController()
        webVC.urlString = "pol"
        present(webVC, animated: true, completion: nil)
    }
    
    @objc func rateApps() {
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        } else {
            if let url = URL(string: "id") {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        }
    }
    
    @objc func shareApps() {
        let appURL = URL(string: "id")!
        let activityViewController = UIActivityViewController(activityItems: [appURL], applicationActivities: nil)
        
        // Настройка для показа в виде popover на iPad
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }

        self.present(activityViewController, animated: true, completion: nil)
    }
    
    
 
}


class WebViewController: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    var urlString: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
        
        // Загружаем URL
        if let urlString = urlString, let url = URL(string: urlString) {
            webView.load(URLRequest(url: url))
        }
    }
}
