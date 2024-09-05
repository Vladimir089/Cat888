//
//  DetailCatViewController.swift
//  Cat888
//
//  Created by Владимир Кацап on 05.09.2024.
//

import UIKit

class DetailCatViewController: UIViewController {
    
    let item: Stat
    
    var cellTextView: UITextView?
    
    init(item: Stat) {
        self.item = item
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
            make.centerX.equalToSuperview()
            make.height.equalTo(5)
            make.width.equalTo(36)
            make.top.equalToSuperview().inset(5)
        }
        
        cellTextView = {
            let view = UITextView()
            view.text = item.text
            view.font = .systemFont(ofSize: 17, weight: .regular)
            view.textColor = .black
            view.isScrollEnabled = false
            view.backgroundColor = .white
            return view
        }()
        
        let collection: UICollectionView = {
            let layout = UICollectionViewFlowLayout()
            let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "1")
            collection.backgroundColor = .clear
            collection.showsVerticalScrollIndicator = false
            collection.delegate = self
            collection.dataSource = self
            return collection
        }()
        view.addSubview(collection)
        collection.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.bottom.equalToSuperview()
            make.top.equalTo(hideView.snp.bottom).inset(-15)
        }
        
        
        
    }

}


extension DetailCatViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "1", for: indexPath)
        cell.subviews.forEach { $0.removeFromSuperview() }
        cell.backgroundColor = .white
        
        if indexPath.row == 0 {
            let headerLabel = UILabel()
            headerLabel.numberOfLines = 0
            headerLabel.textColor = .black
            headerLabel.text = item.header
            headerLabel.textAlignment = .left
            headerLabel.font = .systemFont(ofSize: 34, weight: .regular)
            cell.addSubview(headerLabel)
            headerLabel.snp.makeConstraints { make in
                make.left.right.top.equalToSuperview()
            }
            
            let imageView = UIImageView(image: item.image)
            imageView.clipsToBounds = true
            imageView.contentMode = .scaleAspectFill
            imageView.layer.cornerRadius = 20
            cell.addSubview(imageView)
            imageView.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.height.equalTo(250)
                make.top.equalTo(headerLabel.snp.bottom).inset(-15)
            }
        } else {
            cell.addSubview(cellTextView!)
            cellTextView?.snp.makeConstraints({ make in
                make.left.right.top.bottom.equalToSuperview()
            })
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0 {
            return CGSize(width: collectionView.frame.width, height: 388)
        } else {
            print(cellTextView!.frame.height)
            let size = cellTextView!.sizeThatFits(CGSize(width: collectionView.frame.width, height: CGFloat.greatestFiniteMagnitude))
            return size
        }
    }
    
    
}
