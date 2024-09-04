//
//  DocumentViewController.swift
//  Cat888
//
//  Created by Владимир Кацап on 03.09.2024.
//

import UIKit

var arrDoc: [Document] = []

protocol DocumentViewControllerDelegate: AnyObject {
    func reloadCollection()
}

class DocumentViewController: UIViewController {
    
    var collection: UICollectionView?
    var noArrView: UIView?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationBar()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 255/255, green: 239/255, blue: 255/255, alpha: 1)
        arrDoc = loadAthleteArrFromFile() ?? []
        createInterface()
        checkArr()
    }
    

    func createInterface() {
        
        let mainLabel = UILabel()
        mainLabel.text = "Document"
        mainLabel.font = .systemFont(ofSize: 28, weight: .bold)
        mainLabel.textColor = .black
        view.addSubview(mainLabel)
        mainLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
        let addButton = UIButton(type: .system)
        addButton.setBackgroundImage(.plus, for: .normal)
        view.addSubview(addButton)
        addButton.snp.makeConstraints { make in
            make.height.width.equalTo(22)
            make.right.equalToSuperview().inset(15)
            make.centerY.equalTo(mainLabel)
        }
        addButton.addTarget(self, action: #selector(createNewPet), for: .touchUpInside)
        
        noArrView = {
            let view = UIView()
            view.backgroundColor = .clear
            let labelToop = UILabel()
            labelToop.text = "The list is empty"
            labelToop.textColor = .black
            labelToop.font = .systemFont(ofSize: 20, weight: .semibold)
            view.addSubview(labelToop)
            labelToop.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.centerX.equalToSuperview()
            }
            
            let botLabel = UILabel()
            botLabel.text = "Add your document"
            botLabel.font = .systemFont(ofSize: 16, weight: .regular)
            botLabel.textColor = .black.withAlphaComponent(0.3)
            view.addSubview(botLabel)
            botLabel.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalTo(labelToop.snp.bottom).inset(-5)
            }
            
            let newDockButton = UIButton(type: .system)
            newDockButton.setBackgroundImage(.addBut, for: .normal)
            view.addSubview(newDockButton)
            newDockButton.snp.makeConstraints { make in
                make.top.equalTo(botLabel.snp.bottom).inset(-15)
                make.left.right.equalToSuperview()
                make.height.equalTo(52)
            }
            newDockButton.addTarget(self, action: #selector(createNewPet), for: .touchUpInside)
            
            return view
        }()
        
        view.addSubview(noArrView!)
        noArrView?.snp.makeConstraints({ make in
            make.center.equalToSuperview()
            make.width.equalTo(158)
            make.height.equalTo(200)
        })
        
        collection = {
            let layout = UICollectionViewFlowLayout()
            let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collection.showsVerticalScrollIndicator = false
            layout.scrollDirection = .vertical
            layout.sectionInset = UIEdgeInsets(top: 5, left: 0, bottom: 10, right: 0)
            collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "1")
            collection.delegate = self
            collection.dataSource = self
            collection.backgroundColor = .clear
            return collection
        }()
        
        view.addSubview(collection!)
        collection?.snp.makeConstraints({ make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(mainLabel.snp.bottom).inset(-5)
        })
        
    }
    
    @objc func createNewPet() {
        let vc = NewDocumentViewController()
        vc.isNew = true
        vc.delegate = self
        self.present(vc, animated: true)
    }
    
    
    func checkArr() {
        if arrDoc.count > 0 {
            noArrView?.alpha = 0
            collection?.alpha = 1
        } else {
            noArrView?.alpha = 1
            collection?.alpha = 0
        }
    }
    
    
    func loadAthleteArrFromFile() -> [Document]? {
        let fileManager = FileManager.default
        guard let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Unable to get document directory")
            return nil
        }
        let filePath = documentDirectory.appendingPathComponent("doc.plist")
        do {
            let data = try Data(contentsOf: filePath)
            let athleteArr = try JSONDecoder().decode([Document].self, from: data)
            return athleteArr
        } catch {
            print("Failed to load or decode athleteArr: \(error)")
            return nil
        }
    }
    
    
    
    
    
}

extension DocumentViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrDoc.count
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
        
        let avaImageView = UIImageView(image: UIImage(data: arrDoc[indexPath.row].image))
        avaImageView.clipsToBounds = true
        avaImageView.layer.cornerRadius = 26
        cell.addSubview(avaImageView)
        avaImageView.snp.makeConstraints { make in
            make.left.top.equalToSuperview().inset(15)
            make.height.width.equalTo(52)
        }
        
        let nameLabel = UILabel()
        nameLabel.text = arrDoc[indexPath.row].name
        nameLabel.textColor = .black
        nameLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        cell.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(avaImageView.snp.top)
            make.left.equalTo(avaImageView.snp.right).inset(-10)
        }
        
        let openImageView = UIImageView(image: .openPet)
        cell.addSubview(openImageView)
        openImageView.snp.makeConstraints { make in
            make.height.width.equalTo(35)
            make.top.right.equalToSuperview().inset(15)
        }
        
        var imagesArr: [UIImageView] = []
        for i in arrDoc[indexPath.row].images {
            let imageViewE = UIImageView(image: UIImage(data: i.image))
            imageViewE.layer.cornerRadius = 10
            imageViewE.clipsToBounds = true
            
            imagesArr.append(imageViewE)
        }
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        cell.addSubview(stackView)
        if imagesArr.count == 1 {
            stackView.addArrangedSubview(imagesArr[0])
            stackView.snp.makeConstraints { make in
                make.height.equalTo(79)
                make.width.equalTo(105)
                make.bottom.left.equalToSuperview().inset(15)
            }
        } else if imagesArr.count == 2 {
            stackView.addArrangedSubview(imagesArr[0])
            stackView.addArrangedSubview(imagesArr[1])
            stackView.snp.makeConstraints { make in
                make.height.equalTo(79)
                make.width.equalTo(215)
                make.bottom.left.equalToSuperview().inset(15)
            }
        } else if imagesArr.count > 2 {
            for i in 0..<3 {
                print(i)
                stackView.addArrangedSubview(imagesArr[i])
            }
            stackView.snp.makeConstraints { make in
                make.height.equalTo(79)
                make.left.right.equalToSuperview().inset(15)
                make.bottom.left.equalToSuperview().inset(15)
            }
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 30, height: 166)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailDocumentViewController()
        vc.delegate = self
        vc.index = indexPath.row
        vc.doc = arrDoc[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}


extension DocumentViewController: DocumentViewControllerDelegate {
    func reloadCollection() {
        checkArr()
        collection?.reloadData()
        print(arrDoc)
    }
}
