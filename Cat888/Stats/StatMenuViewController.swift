//
//  StatMenuViewController.swift
//  Cat888
//
//  Created by Владимир Кацап on 05.09.2024.
//

import UIKit

class StatMenuViewController: UIViewController {
    
    lazy var arr: [Stat] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationBar()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 255/255, green: 239/255, blue: 255/255, alpha: 1)
        fillStatArr()
        createInterface()
    }
    
    func createInterface() {
        
        let collection: UICollectionView = {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "1")
            collection.backgroundColor = .clear
            collection.delegate = self
            collection.dataSource = self
            collection.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
            collection.showsVerticalScrollIndicator = false
            layout.minimumLineSpacing = 40
            return collection
        }()
        view.addSubview(collection)
        collection.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
        
        
    }
   
}

extension StatMenuViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  arr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "1", for: indexPath)
        cell.subviews.forEach { $0.removeFromSuperview() }
        cell.backgroundColor = UIColor(red: 255/255, green: 239/255, blue: 255/255, alpha: 1)
        
        let imageView = UIImageView(image: arr[indexPath.row].image)
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        cell.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(180)
        }
        
        let label = UILabel()
        label.text = arr[indexPath.row].header
        label.numberOfLines = 2
        label.textAlignment = .left
        label.textColor = .black
        label.font = .systemFont(ofSize: 28, weight: .regular)
        cell.addSubview(label)
        label.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).inset(-5)
            make.bottom.equalToSuperview()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 30, height: 268)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailCatViewController(item: arr[indexPath.row])
        self.present(vc, animated: true)
    }
    
    
}
