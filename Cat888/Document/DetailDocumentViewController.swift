//
//  DetailDocumentViewController.swift
//  Cat888
//
//  Created by Владимир Кацап on 04.09.2024.
//

import UIKit

protocol DetailDocumentViewControllerDelegate: AnyObject {
    func reloadProfile(newDoc: Document)
    func reloadItems(newDoc: Document)
    func del(dock: Document)
}

class DetailDocumentViewController: UIViewController {
    
    weak var delegate: DocumentViewControllerDelegate?
    var index = 0
    var doc: Document?
    
    //profile
    var imageViewProfile: UIImageView?
    var nameLabel: UILabel?
    var deskTextView: UITextView?
    
    //coll
    var collection: UICollectionView?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showNavigationBar()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 255/255, green: 239/255, blue: 255/255, alpha: 1)
        
        let backButtonAppearance = UIBarButtonItem.appearance()
        backButtonAppearance.tintColor = UIColor(red: 255/255, green: 102/255, blue: 172/255, alpha: 1)
        if let backButton = navigationController?.navigationBar.topItem?.backBarButtonItem {
            backButton.tintColor = UIColor(red: 255/255, green: 102/255, blue: 172/255, alpha: 1)
        }
        title = doc?.name
        createInterface()
    }
    

    func createInterface() {
        
        let profileView: UIView = {
            let view = UIView()
            view.layer.cornerRadius = 20
            view.backgroundColor = UIColor(red: 255/255, green: 239/255, blue: 255/255, alpha: 1)
            view.layer.cornerRadius = 16
            view.layer.shadowColor = UIColor.black.cgColor
            view.layer.shadowOpacity = 0.25
            view.layer.shadowOffset = CGSize(width: 0, height: 2)
            view.layer.shadowRadius = 4
            view.layer.masksToBounds = false
            
            imageViewProfile = UIImageView(image: UIImage(data: doc?.image ?? Data()))
            imageViewProfile?.layer.cornerRadius = 37
            imageViewProfile?.clipsToBounds = true
            view.addSubview(imageViewProfile!)
            imageViewProfile?.snp.makeConstraints({ make in
                make.height.width.equalTo(74)
                make.top.left.equalToSuperview().inset(15)
            })
            
            nameLabel = UILabel()
            nameLabel?.text = doc?.name
            nameLabel?.textColor = .black
            nameLabel?.numberOfLines = 2
            nameLabel?.font = .systemFont(ofSize: 28, weight: .semibold)
            nameLabel?.textAlignment = .left
            view.addSubview(nameLabel!)
            nameLabel?.snp.makeConstraints({ make in
                make.left.equalTo(imageViewProfile!.snp.left)
                make.right.equalTo(imageViewProfile!.snp.right)
                make.top.equalTo(imageViewProfile!.snp.bottom).inset(-5)
            })
            
            let pecLabel = UILabel()
            pecLabel.text = "Peculiarities"
            pecLabel.textColor = .black
            pecLabel.font = .systemFont(ofSize: 16, weight: .semibold)
            view.addSubview(pecLabel)
            pecLabel.snp.makeConstraints { make in
                make.left.equalTo(imageViewProfile!.snp.right).inset(-10)
                make.top.equalTo(imageViewProfile!.snp.top)
            }
            
            deskTextView = {
                let textView = UITextView()
                textView.text = doc?.desk
                textView.textColor = .black
                textView.font = .systemFont(ofSize: 15, weight: .regular)
                textView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
                textView.layer.cornerRadius = 16
                textView.isUserInteractionEnabled = false
                textView.layer.borderWidth = 1
                textView.backgroundColor = .clear
                textView.layer.borderColor = UIColor(red: 254/255, green: 1/255, blue: 255/255, alpha: 1).cgColor
                return textView
            }()
            view.addSubview(deskTextView!)
            deskTextView?.snp.makeConstraints({ make in
                make.left.equalTo(imageViewProfile!.snp.right).inset(-10)
                make.top.equalTo(pecLabel.snp.bottom).inset(-10)
                make.bottom.equalToSuperview().inset(15)
                make.width.equalTo(217)
            })
            
            let editButton = UIButton(type: .system)
            editButton.setBackgroundImage(.editBut, for: .normal)
            view.addSubview(editButton)
            editButton.snp.makeConstraints { make in
                make.height.width.equalTo(22)
                make.top.right.equalToSuperview().inset(15)
            }
            editButton.addTarget(self, action: #selector(editDoc), for: .touchUpInside)
            
            return view
        }()
        view.addSubview(profileView)
        profileView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.height.equalTo(179)
        }
        
        let docLabel = UILabel()
        docLabel.text = "Document"
        docLabel.textColor = .black
        docLabel.font = .systemFont(ofSize: 28, weight: .bold)
        view.addSubview(docLabel)
        docLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(profileView.snp.bottom).inset(-15)
        }
        
        collection = {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collection.backgroundColor = .clear
            collection.showsVerticalScrollIndicator = false
            collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "1")
            collection.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
            collection.delegate = self
            collection.dataSource = self
            return collection
        }()
        view.addSubview(collection!)
        collection?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo(docLabel.snp.bottom)
        })
        
        let createButton = UIButton(type: .system)
        createButton.setBackgroundImage(.plus, for: .normal)
        view.addSubview(createButton)
        createButton.snp.makeConstraints { make in
            make.height.width.equalTo(20)
            make.right.equalToSuperview().inset(15)
            make.centerY.equalTo(docLabel.snp.centerY)
        }
        createButton.addTarget(self, action: #selector(createAndEditPhoto), for: .touchUpInside)
        
        
    }
    
    @objc func editDoc() {
        let vc = NewDocumentViewController()
        vc.isNew = false
        vc.doc = doc
        vc.index = index
        vc.twoDeleagte = self
        self.present(vc, animated: true)
    }
    
    @objc func createAndEditPhoto() {
        let vc = PhotoEditCreateViewController()
        vc.delegate = self
        vc.doc = doc
        vc.index = index
        vc.isNew = true
        self.present(vc, animated: true)
    }
    
    @objc func editPhoto(sender: UIButton) {
        let vc = PhotoEditCreateViewController()
        vc.delegate = self
        vc.doc = doc
        vc.index = index
        vc.isNew = false
        vc.indexPhoto = sender.tag
        vc.photo = doc?.images[sender.tag]
        self.present(vc, animated: true)
    }

    @objc func openFullPhoto(sender: UITapGestureRecognizer) {
        let vc = FullPhotoViewController()
        vc.doc = doc?.images[sender.view!.tag]
        self.present(vc, animated: true)
    }
}


extension DetailDocumentViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return doc?.images.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "1", for: indexPath)
        cell.subviews.forEach { $0.removeFromSuperview() }
        cell.backgroundColor = UIColor(red: 255/255, green: 239/255, blue: 255/255, alpha: 1)
        cell.layer.cornerRadius = 16
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 0.25
        cell.layer.shadowOffset = CGSize(width: 0, height: 2)
        cell.layer.shadowRadius = 4
        cell.layer.masksToBounds = false
        
        let label = UILabel()
        label.text = doc?.images[indexPath.row].text
        label.textColor = .black
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textAlignment = .left
        cell.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(15)
            make.height.equalTo(25)
        }
        
        let imageView = UIImageView(image: UIImage(data: doc?.images[indexPath.row].image ?? Data()))
        imageView.clipsToBounds = true
        imageView.tag = indexPath.row
        imageView.layer.cornerRadius = 10
        imageView.isUserInteractionEnabled = true
        cell.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(label.snp.bottom).inset(-15)
            make.left.right.equalToSuperview().inset(15)
            make.bottom.equalToSuperview().inset(15)
        }
        let gesture = UITapGestureRecognizer(target: self, action: #selector(openFullPhoto(sender:)))
        imageView.addGestureRecognizer(gesture)
        
        let editButton = UIButton(type: .system)
        editButton.setBackgroundImage(.editBut, for: .normal)
        editButton.tag = indexPath.row
        cell.addSubview(editButton)
        editButton.snp.makeConstraints { make in
            make.height.width.equalTo(20)
            make.right.top.equalToSuperview().inset(15)
        }
        
        editButton.addTarget(self, action: #selector(editPhoto), for: .touchUpInside)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 30, height: 215)
    }
    
    
}


extension DetailDocumentViewController: DetailDocumentViewControllerDelegate {
    func reloadItems(newDoc: Document) {
        delegate?.reloadCollection()
        self.doc = newDoc
        collection?.reloadData()
    }
    
    
    func reloadProfile(newDoc: Document) {
        delegate?.reloadCollection()
        self.doc = newDoc
        imageViewProfile?.image = UIImage(data: newDoc.image)
        nameLabel?.text = newDoc.name
        deskTextView?.text = newDoc.desk
        title = newDoc.name
        collection?.reloadData()
    }
    
    func del(dock: Document) {
        self.doc = dock
        delegate?.reloadCollection()
        collection?.reloadData()
    }
    
    
    
}
