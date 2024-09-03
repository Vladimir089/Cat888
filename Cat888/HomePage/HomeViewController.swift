//
//  HomeViewController.swift
//  Cat888
//
//  Created by Владимир Кацап on 02.09.2024.
//

import UIKit

var pets: [Pet] = []

protocol HomeViewControllerDelegate: AnyObject {
    func reloadLabels(leftText: Int, rightText: Int, progress: Float, botText:Int)
    func reloadCollection()
}

class HomeViewController: UIViewController {
    
    //topView
    var leftLabel, rightLabel: UILabel?
    var progressView: UIProgressView?
    var botLabel: UILabel?
    
    //coll
    var collection: UICollectionView?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 255/255, green: 239/255, blue: 255/255, alpha: 1)
        pets = loadAthleteArrFromFile() ?? []
        createInterface()
        checkStat()
        checkPets()
        
    }
    

    func createInterface() {
        
        let topView: UIView = {
            let view = UIView()
            view.backgroundColor = UIColor(red: 255/255, green: 239/255, blue: 255/255, alpha: 1)
            
            view.layer.cornerRadius = 16
            view.layer.shadowColor = UIColor.black.cgColor
            view.layer.shadowOpacity = 0.25
            view.layer.shadowOffset = CGSize(width: 0, height: 2)
            view.layer.shadowRadius = 4
            view.layer.masksToBounds = false
            
            let editButton = UIButton(type: .system)
            editButton.setBackgroundImage(.editBut, for: .normal)
            view.addSubview(editButton)
            editButton.snp.makeConstraints { make in
                make.height.width.equalTo(27)
                make.top.right.equalToSuperview().inset(15)
            }
            editButton.addTarget(self, action: #selector(openEditStat), for: .touchUpInside)
            
            leftLabel = UILabel()
            leftLabel?.textColor = UIColor(red: 254/255, green: 1/255, blue: 255/255, alpha: 1)
            leftLabel?.font = .systemFont(ofSize: 17, weight: .bold)
            leftLabel?.text = "0"
            view.addSubview(leftLabel!)
            leftLabel?.snp.makeConstraints({ make in
                make.left.equalToSuperview().inset(15)
                make.top.equalTo(editButton.snp.bottom).inset(-15)
            })
            
            rightLabel = UILabel()
            rightLabel?.textColor = .black.withAlphaComponent(0.48)
            rightLabel?.font = .systemFont(ofSize: 17, weight: .bold)
            rightLabel?.text = "0"
            view.addSubview(rightLabel!)
            rightLabel?.snp.makeConstraints({ make in
                make.right.equalToSuperview().inset(15)
                make.top.equalTo(editButton.snp.bottom).inset(-15)
            })
            
            progressView = UIProgressView()
            progressView?.layer.cornerRadius = 6
            progressView?.clipsToBounds = true
            progressView?.trackTintColor = UIColor(red: 54/255, green: 54/255, blue: 54/255, alpha: 0.05)
            progressView?.progressTintColor = UIColor(red: 254/255, green: 1/255, blue: 255/255, alpha: 1)
            view.addSubview(progressView!)
            progressView?.snp.makeConstraints({ make in
                make.left.right.equalToSuperview().inset(15)
                make.height.equalTo(12)
                make.top.equalTo(rightLabel!.snp.bottom).inset(-5)
            })
            
            let leftTextLabel = UILabel()
            leftTextLabel.textColor = .black.withAlphaComponent(0.3)
            leftTextLabel.font = .systemFont(ofSize: 13, weight: .regular)
            leftTextLabel.text = "Procedures performed"
            view.addSubview(leftTextLabel)
            leftTextLabel.snp.makeConstraints { make in
                make.left.equalToSuperview().inset(15)
                make.top.equalTo(progressView!.snp.bottom).inset(-5)
            }
            
            let rightTextLabel = UILabel()
            rightTextLabel.textColor = .black.withAlphaComponent(0.3)
            rightTextLabel.font = .systemFont(ofSize: 13, weight: .regular)
            rightTextLabel.text = "Total procedures"
            view.addSubview(rightTextLabel)
            rightTextLabel.snp.makeConstraints { make in
                make.right.equalToSuperview().inset(15)
                make.top.equalTo(progressView!.snp.bottom).inset(-5)
            }
            
            let corneredView = UIView()
            corneredView.layer.cornerRadius = 16
            corneredView.layer.borderColor = UIColor(red: 254/255, green: 1/255, blue: 255/255, alpha: 1).cgColor
            corneredView.layer.borderWidth = 1
            view.addSubview(corneredView)
            corneredView.snp.makeConstraints { make in
                make.left.right.equalToSuperview().inset(15)
                make.top.equalTo(rightTextLabel.snp.bottom).inset(-20)
                make.height.equalTo(96)
            }
            
            let activeLabel = UILabel()
            activeLabel.font = .systemFont(ofSize: 20, weight: .bold)
            activeLabel.textColor = .black
            activeLabel.text = "Active tasks"
            corneredView.addSubview(activeLabel)
            activeLabel.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.bottom.equalTo(corneredView.snp.centerY).offset(-7.5)
            }
            
            botLabel = UILabel()
            botLabel?.text = "0"
            botLabel?.textColor = UIColor(red: 254/255, green: 1/255, blue: 255/255, alpha: 1)
            botLabel?.font = .systemFont(ofSize: 28, weight: .bold)
            corneredView.addSubview(botLabel!)
            botLabel?.snp.makeConstraints({ make in
                make.centerX.equalToSuperview()
                make.top.equalTo(corneredView.snp.centerY)
            })
            
            
            
            return view
        }()
        view.addSubview(topView)
        topView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.height.equalTo(249)
        }
        
        let petsLabel = UILabel()
        petsLabel.textColor = .black
        petsLabel.text = "Pets"
        petsLabel.font = .systemFont(ofSize: 28, weight: .bold)
        view.addSubview(petsLabel)
        petsLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(topView.snp.bottom).inset(-15)
        }
        
        let addNewPetButton = UIButton(type: .system)
        addNewPetButton.setImage(.plus, for: .normal)
        addNewPetButton.tintColor = .black
        view.addSubview(addNewPetButton)
        addNewPetButton.snp.makeConstraints { make in
            make.height.width.equalTo(25)
            make.right.equalToSuperview().inset(15)
            make.centerY.equalTo(petsLabel)
        }
        addNewPetButton.addTarget(self, action: #selector(createNewPet), for: .touchUpInside)
        
        collection = {
            let layout = UICollectionViewFlowLayout()
            let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
            layout.scrollDirection = .vertical
            collection.backgroundColor = .clear
            collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "1")
            collection.showsVerticalScrollIndicator = false
            collection.delegate = self
            collection.dataSource = self
            collection.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 50, right: 0)
            return collection
        }()
        view.addSubview(collection!)
        collection?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo(petsLabel.snp.bottom).inset(-15)
        })
        
    }
    
    @objc func createNewPet() {
        let vc = NewAndEditViewController()
        vc.delegate = self
        vc.isNew = true
        self.present(vc, animated: true)
    }
    
    func checkPets() {
        if pets.count > 0 {
            collection?.alpha = 1
        } else {
            collection?.alpha = 0
        }
    }
    
    func loadAthleteArrFromFile() -> [Pet]? {
        let fileManager = FileManager.default
        guard let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Unable to get document directory")
            return nil
        }
        let filePath = documentDirectory.appendingPathComponent("pet.plist")
        do {
            let data = try Data(contentsOf: filePath)
            let athleteArr = try JSONDecoder().decode([Pet].self, from: data)
            return athleteArr
        } catch {
            print("Failed to load or decode athleteArr: \(error)")
            return nil
        }
    }
    
    
    func checkStat() {
        if let a = UserDefaults.standard.array(forKey: "Stat") as? [Int] {
            leftLabel?.text = "\(a[0])"
            rightLabel?.text = "\(a[1])"
            botLabel?.text = "\(a[2])"
            
            print(a)
            
            let oneFloat:Float = Float(a[0])
            let twoFloat:Float = Float(a[1])
            let value = oneFloat / twoFloat
            progressView?.setProgress(value, animated: true)
        }
    }
    
    @objc func openEditStat() {
        let vc = EditStatViewController()
        vc.delegate = self
        vc.topText = leftLabel?.text
        vc.midText = rightLabel?.text
        vc.botText = botLabel?.text
        self.present(vc, animated: true)
    }
    
    

}


extension HomeViewController: HomeViewControllerDelegate {
    func reloadCollection() {
        checkPets()
        collection?.reloadData()
    }
    
    func reloadLabels(leftText: Int, rightText: Int, progress: Float, botText: Int) {
        leftLabel?.text = "\(leftText)"
        rightLabel?.text = "\(rightText)"
        progressView?.setProgress(progress, animated: true)
        botLabel?.text = "\(botText)"
        
    }
}



extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pets.count
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
        
        
        let imageView = UIImageView(image: UIImage(data: pets[indexPath.row].image))
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 26
        cell.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.height.width.equalTo(52)
            make.top.left.equalToSuperview().inset(15)
        }
        
        let nameLabel = UILabel()
        nameLabel.text = pets[indexPath.row].name
        nameLabel.textColor = .black
        nameLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        cell.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.bottom.equalTo(imageView.snp.centerY).offset(-2)
            make.left.equalTo(imageView.snp.right).inset(-10)
        }
        
        let healthImageView = UIImageView()
        switch pets[indexPath.row].health {
        case 0:
            healthImageView.image = .but1.withRenderingMode(.alwaysTemplate)
        case 1:
            healthImageView.image = .but2.withRenderingMode(.alwaysTemplate)
        case 2:
            healthImageView.image = .but3.withRenderingMode(.alwaysTemplate)
        default:
            break
        }
        healthImageView.tintColor = UIColor(red: 254/255, green: 1/255, blue: 255/255, alpha: 1)
        cell.addSubview(healthImageView)
        healthImageView.snp.makeConstraints { make in
            make.height.width.equalTo(24)
            make.top.equalTo(imageView.snp.centerY)
            make.left.equalTo(imageView.snp.right).inset(-10)
        }
        
        let imageViewOpen = UIImageView(image: .openPet)
        cell.addSubview(imageViewOpen)
        imageViewOpen.snp.makeConstraints { make in
            make.height.width.equalTo(35)
            make.right.top.equalToSuperview().inset(15)
        }
        
        var oneFloat: Float = 0
        let twoFloat: Float = Float(pets[indexPath.row].tasks.count )
        for i in pets[indexPath.row].tasks {
            if i.isComplete == true {
                oneFloat += 1
            }
        }
        
        let leftLabel = UILabel()
        leftLabel.text = "\(Int(oneFloat))"
        leftLabel.textColor = UIColor(red: 255/255, green: 128/255, blue: 255/255, alpha: 1)
        leftLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        cell.addSubview(leftLabel)
        leftLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(imageView.snp.bottom).inset(-15)
        }
        
        let rightLabel = UILabel()
        rightLabel.text = "\(Int(twoFloat))"
        rightLabel.textColor = .black.withAlphaComponent(0.48)
        rightLabel.font = .systemFont(ofSize: 17, weight: .regular)
        cell.addSubview(rightLabel)
        rightLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(15)
            make.top.equalTo(imageView.snp.bottom).inset(-15)
        }
        
        
        let progressView = UIProgressView()
        progressView.trackTintColor = UIColor(red: 54/255, green: 54/255, blue: 54/255, alpha: 0.05)
        progressView.progressTintColor = UIColor(red: 255/255, green: 102/255, blue: 172/255, alpha: 1)
        progressView.layer.cornerRadius = 4
        progressView.clipsToBounds = true
        cell.addSubview(progressView)
        progressView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(8)
            make.top.equalTo(leftLabel.snp.bottom).inset(-15)
        }

        let razn = oneFloat / twoFloat
        if oneFloat != 0 {
            progressView.setProgress(razn, animated: true)
        }
        
        let leftBotLabel = UILabel()
        leftBotLabel.text = "Procedures performed"
        leftBotLabel.font = .systemFont(ofSize: 13, weight: .regular)
        leftBotLabel.textColor = .black.withAlphaComponent(0.3)
        cell.addSubview(leftBotLabel)
        leftBotLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(progressView.snp.bottom).inset(-5)
        }
        
        let rightBotLabel = UILabel()
        rightBotLabel.text = "Total procedures"
        rightBotLabel.font = .systemFont(ofSize: 13, weight: .regular)
        rightBotLabel.textColor = .black.withAlphaComponent(0.3)
        cell.addSubview(rightBotLabel)
        rightBotLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(15)
            make.top.equalTo(progressView.snp.bottom).inset(-5)
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 30, height: 166)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailPetViewController()
        vc.delegate = self
        vc.index = indexPath.row
        vc.pet = pets[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
