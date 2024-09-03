//
//  DetailPetViewController.swift
//  Cat888
//
//  Created by Владимир Кацап on 03.09.2024.
//

import UIKit

protocol DetailPetViewControllerDelegate: AnyObject {
    func reload(item: Pet)
    func del()
}

class DetailPetViewController: UIViewController {
    
    weak var delegate: HomeViewControllerDelegate?
    var pet: Pet?
    var index = 0
    
    var sortedTaskrs: [Task] = []
    
    //ui
    var imageViewPhoto, imageViewHealth: UIImageView?
    var yearsLabel, genderLabel, breedLabel, weightLabel: UILabel?
    var deskTextView: UITextView?
    
    //other
    var collectionOne, collectionTask: UICollectionView?
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showNavigationBar()
        title = pet?.name
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 255/255, green: 239/255, blue: 255/255, alpha: 1)
        
        let backButtonAppearance = UIBarButtonItem.appearance()
        backButtonAppearance.tintColor = UIColor(red: 255/255, green: 102/255, blue: 172/255, alpha: 1)
        if let backButton = navigationController?.navigationBar.topItem?.backBarButtonItem {
            backButton.tintColor = UIColor(red: 255/255, green: 102/255, blue: 172/255, alpha: 1)
        }
        
        createInterface()
        reload(item: pet!)
    }
    
    func createInterface() {
        
        collectionOne = {
            let layout = UICollectionViewFlowLayout()
            let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collection.showsVerticalScrollIndicator = false
            collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "1")
            collection.backgroundColor = .clear
            collection.contentInset = UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0)
            layout.scrollDirection = .vertical
            collection.delegate = self
            collection.dataSource = self
            return collection
        }()
        view.addSubview(collectionOne!)
        collectionOne?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        })
        
        collectionTask = {
            let layout = UICollectionViewFlowLayout()
            let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collection.showsVerticalScrollIndicator = false
            collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "2")
            collection.backgroundColor = .clear
            layout.scrollDirection = .vertical
            collection.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
            collection.delegate = self
            collection.dataSource = self
            return collection
        }()
        
    }
    
    func createView(label: UILabel) -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor(red: 255/255, green: 239/255, blue: 255/255, alpha: 1)
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(red: 254/255, green: 1/255, blue: 255/255, alpha: 1).cgColor
        
        view.addSubview(label)
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textColor = UIColor(red: 254/255, green: 1/255, blue: 255/255, alpha: 1)
        label.numberOfLines = 0
        label.snp.makeConstraints { make in
            make.bottom.left.right.top.equalToSuperview().inset(5)
        }
        
        return view
    }
    
    @objc func createNewTask() {
        let vc = AddEditNewTaskViewController()
        vc.delegate = self
        vc.indexPet = index
        vc.pet = pet
        self.present(vc, animated: true)
    }
    
    @objc func editTask(sender: UIButton) {
        let vc = AddEditNewTaskViewController()
        vc.delegate = self
        vc.indexPet = index
        vc.pet = pet
        vc.isNew = false
        
        var ind = 0
        for i in pet!.tasks {
            if i.isComplete == sortedTaskrs[sender.tag].isComplete, i.text == sortedTaskrs[sender.tag].text {
                vc.indexTask = ind
            } else {
                ind += 1
            }
        }
        
        self.present(vc, animated: true)
    }
    
    func sortArr() {
        var compArr: [Task] = []
        var noCompArr: [Task] = []
        sortedTaskrs.removeAll()
        
        for i in pet!.tasks {
            if i.isComplete == true {
                compArr.append(i)
            } else {
                noCompArr.append(i)
            }
        }
        
        sortedTaskrs = noCompArr + compArr
        collectionOne?.reloadData()
        collectionTask?.reloadData()
    }
    
    
    @objc func checkIn(sender: UIButton) {
        if sortedTaskrs[sender.tag].isComplete == true {
            sender.setBackgroundImage(.taskNo, for: .normal)
            sortedTaskrs[sender.tag].isComplete = false
        } else {
            sender.setBackgroundImage(.taskyes, for: .normal)
            sortedTaskrs[sender.tag].isComplete = true
        }
        
        var ind = 0
        
        for i in pet!.tasks {
            if sortedTaskrs[sender.tag].text == i.text {
                pet?.tasks[ind] = sortedTaskrs[sender.tag]
            } else {
                ind += 1
            }
        }
        
        pets[index] = pet!
        
        do {
            let data = try JSONEncoder().encode(pets) //тут мкассив конвертируем в дату
            try saveAthleteArrToFile(data: data)
            delegate?.reloadCollection()
            sortArr()
            self.dismiss(animated: true)
        } catch {
            print("Failed to encode or save athleteArr: \(error)")
        }
  
    }
    
    func saveAthleteArrToFile(data: Data) throws {
        let fileManager = FileManager.default
        if let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let filePath = documentDirectory.appendingPathComponent("pet.plist")
            try data.write(to: filePath)
        } else {
            throw NSError(domain: "SaveError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Unable to get document directory"])
        }
    }
    
    @objc func openEditPet() {
        let vc = NewAndEditViewController()
        vc.detailDelegate = self
        vc.isNew = false
        vc.pet = pet
        vc.idnex = index
        self.present(vc, animated: true)
    }
    
   
}


extension DetailPetViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionOne {
            return 1
        } else {
            return sortedTaskrs.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionOne {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "1", for: indexPath)
            cell.subviews.forEach { $0.removeFromSuperview() }
            
            imageViewPhoto = {
                let imageView = UIImageView(image: UIImage(data: pet?.image ?? Data()))
                imageView.clipsToBounds = true
                imageView.layer.cornerRadius = 10
                return imageView
            }()
            cell.addSubview(imageViewPhoto!)
            imageViewPhoto?.snp.makeConstraints({ make in
                make.left.right.equalToSuperview().inset(15)
                make.top.equalToSuperview()
                make.height.equalTo(262)
            })
            
            imageViewHealth = {
                let imageView = UIImageView()
                switch pet?.health {
                case 0:
                    imageView.image = UIImage.but1.withRenderingMode(.alwaysTemplate)
                case 1:
                    imageView.image = UIImage.but2.withRenderingMode(.alwaysTemplate)
                case 2:
                    imageView.image = UIImage.but3.withRenderingMode(.alwaysTemplate)
                case .none:
                    break
                case .some(_):
                    break
                }
                imageView.tintColor = UIColor(red: 254/255, green: 1/255, blue: 255/255, alpha: 1)
                return imageView
            }()
            imageViewPhoto?.addSubview(imageViewHealth!)
            imageViewHealth?.snp.makeConstraints({ make in
                make.height.width.equalTo(24)
                make.top.left.equalToSuperview().inset(15)
            })
            
            let glassView: UIView = {
                let view = UIView()
                view.layer.cornerRadius = 20
                view.backgroundColor = .white.withAlphaComponent(0.3)
                
                let editButton = UIButton(type: .system)
                editButton.setBackgroundImage(.editBut, for: .normal)
                view.addSubview(editButton)
                editButton.snp.makeConstraints { make in
                    make.height.width.equalTo(27)
                    make.right.top.equalToSuperview().inset(15)
                }
                editButton.addTarget(self, action: #selector(openEditPet), for: .touchUpInside)
                
                yearsLabel = UILabel()
                yearsLabel?.text = "\(pet?.age ?? "")\nYears"
                genderLabel = UILabel()
                genderLabel?.text = pet?.gender
                
                let oneView = createView(label: yearsLabel!)
                let twoView = createView(label: genderLabel!)
                
                let oneStackView = UIStackView(arrangedSubviews: [oneView, twoView])
                oneStackView.axis = .horizontal
                oneStackView.spacing = 10
                oneStackView.distribution = .fillEqually
                view.addSubview(oneStackView)
                oneStackView.snp.makeConstraints { make in
                    make.left.right.equalToSuperview().inset(10)
                    make.top.equalTo(editButton.snp.bottom).inset(-10)
                    make.height.equalTo(96)
                }
                
                breedLabel = UILabel()
                breedLabel?.text = pet?.breed
                weightLabel = UILabel()
                weightLabel?.text = "\(pet?.weight ?? "")\nKilograms"
                
                let threeView = createView(label: breedLabel!)
                let fourView = createView(label: weightLabel!)
                
                let twoStackView = UIStackView(arrangedSubviews: [threeView, fourView])
                twoStackView.axis = .horizontal
                twoStackView.spacing = 10
                twoStackView.distribution = .fillEqually
                view.addSubview(twoStackView)
                twoStackView.snp.makeConstraints { make in
                    make.left.right.equalToSuperview().inset(10)
                    make.top.equalTo(oneStackView.snp.bottom).inset(-10)
                    make.height.equalTo(96)
                }
                
                return view
            }()
            cell.addSubview(glassView)
            glassView.snp.makeConstraints { make in
                make.left.right.equalToSuperview().inset(15)
                make.top.equalTo(imageViewPhoto!.snp.centerY)
                make.height.equalTo(262)
            }
            
            
            let pecLabel = UILabel()
            pecLabel.text = "Peculiarities"
            pecLabel.textColor = .black
            pecLabel.font = .systemFont(ofSize: 28, weight: .bold)
            cell.addSubview(pecLabel)
            pecLabel.snp.makeConstraints { make in
                make.left.equalToSuperview().inset(15)
                make.top.equalTo(glassView.snp.bottom).inset(-10)
            }
            
            
            deskTextView = UITextView()
            deskTextView?.text = pet?.desk
            deskTextView?.showsVerticalScrollIndicator = false
            deskTextView?.isEditable = false
            deskTextView?.backgroundColor = .clear
            deskTextView?.font = .systemFont(ofSize: 15, weight: .regular)
            deskTextView?.layer.cornerRadius = 16
            deskTextView?.layer.borderColor = UIColor(red: 254/255, green: 1/255, blue: 255/255, alpha: 1).cgColor
            deskTextView?.layer.borderWidth = 1
            deskTextView?.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            cell.addSubview(deskTextView!)
            deskTextView?.snp.makeConstraints({ make in
                make.left.right.equalToSuperview().inset(15)
                make.top.equalTo(pecLabel.snp.bottom).inset(-15)
                make.height.equalTo(68)
            })
            
            let taskLabel = UILabel()
            taskLabel.textColor = .black
            taskLabel.font = .systemFont(ofSize: 28, weight: .semibold)
            taskLabel.text = "Tasks"
            cell.addSubview(taskLabel)
            taskLabel.snp.makeConstraints { make in
                make.left.equalToSuperview().inset(15)
                make.top.equalTo(deskTextView!.snp.bottom).inset(-15)
            }
            
            let addNewTaskButton = UIButton(type: .system)
            addNewTaskButton.setBackgroundImage(.plus, for: .normal)
            cell.addSubview(addNewTaskButton)
            addNewTaskButton.snp.makeConstraints { make in
                make.height.width.equalTo(23)
                make.right.equalToSuperview().inset(15)
                make.centerY.equalTo(taskLabel)
            }
            addNewTaskButton.addTarget(self, action: #selector(createNewTask), for: .touchUpInside)
            
            let gotovoLabel = UILabel()
            gotovoLabel.textColor = UIColor(red: 255/255, green: 102/255, blue: 172/255, alpha: 1)
            gotovoLabel.font = .systemFont(ofSize: 15, weight: .semibold)
            
            var gotov: Float = 0
            let all: Float = Float(pet!.tasks.count)
            
            for i in pet!.tasks {
                if i.isComplete == true {
                    gotov += 1
                }
            }
            gotovoLabel.text = "\(Int(gotov))"
            cell.addSubview(gotovoLabel)
            gotovoLabel.snp.makeConstraints { make in
                make.left.equalToSuperview().inset(15)
                make.top.equalTo(addNewTaskButton.snp.bottom).inset(-15)
            }
            
            let allLabel = UILabel()
            allLabel.textColor = .black.withAlphaComponent(0.48)
            allLabel.font = .systemFont(ofSize: 15, weight: .semibold)
            allLabel.text = "\(Int(all))"
            cell.addSubview(allLabel)
            allLabel.snp.makeConstraints { make in
                make.right.equalToSuperview().inset(15)
                make.top.equalTo(addNewTaskButton.snp.bottom).inset(-15)
            }
            
            let progressView = UIProgressView()
            progressView.layer.cornerRadius = 4
            progressView.clipsToBounds = true
            progressView.progressTintColor = UIColor(red: 255/255, green: 102/255, blue: 172/255, alpha: 1)
            progressView.tintColor = UIColor(red: 54/255, green: 54/255, blue: 54/255, alpha: 0.05)
            cell.addSubview(progressView)
            progressView.snp.makeConstraints { make in
                make.height.equalTo(8)
                make.left.right.equalToSuperview().inset(15)
                make.top.equalTo(gotovoLabel.snp.bottom).inset(-10)
            }
            
            if all != 0 , gotov != 0 {
                let sttingProgress: Float = gotov / all
                progressView.setProgress(sttingProgress, animated: true)
            }
            
            let botLeftLabel = UILabel()
            botLeftLabel.text = "Procedures performed"
            botLeftLabel.textColor = .black.withAlphaComponent(0.3)
            botLeftLabel.font = .systemFont(ofSize: 13, weight: .regular)
            cell.addSubview(botLeftLabel)
            botLeftLabel.snp.makeConstraints { make in
                make.left.equalToSuperview().inset(15)
                make.top.equalTo(progressView.snp.bottom).inset(-5)
            }
            
            
            let rightLeftLabel = UILabel()
            rightLeftLabel.text = "Total procedures"
            rightLeftLabel.textColor = .black.withAlphaComponent(0.3)
            rightLeftLabel.font = .systemFont(ofSize: 13, weight: .regular)
            cell.addSubview(rightLeftLabel)
            rightLeftLabel.snp.makeConstraints { make in
                make.right.equalToSuperview().inset(15)
                make.top.equalTo(progressView.snp.bottom).inset(-5)
            }
            
            cell.addSubview(collectionTask!)
            collectionTask?.snp.makeConstraints({ make in
                make.left.right.equalToSuperview()
                make.bottom.equalToSuperview()
                make.top.equalTo(rightLeftLabel.snp.bottom).inset(-15)
            })
            
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "2", for: indexPath)
            cell.subviews.forEach { $0.removeFromSuperview() }
            cell.backgroundColor = UIColor(red: 255/255, green: 239/255, blue: 255/255, alpha: 1)
            cell.layer.cornerRadius = 16
            cell.layer.shadowColor = UIColor.black.cgColor
            cell.layer.shadowOpacity = 0.25
            cell.layer.shadowOffset = CGSize(width: 0, height: 2)
            cell.layer.shadowRadius = 4
            cell.layer.masksToBounds = false
            
            let checkButton = UIButton(type: .system)
            if sortedTaskrs[indexPath.row].isComplete == false {
                checkButton.setBackgroundImage(.taskNo, for: .normal)
            } else {
                checkButton.setBackgroundImage(.taskyes, for: .normal)
            }
            checkButton.addTarget(self, action: #selector(checkIn), for: .touchUpInside)
            checkButton.tag = indexPath.row
            cell.addSubview(checkButton)
            checkButton.snp.makeConstraints { make in
                make.height.width.equalTo(20)
                make.centerY.equalToSuperview()
                make.left.equalToSuperview().inset(15)
            }
            
            let label = UILabel()
            label.text = sortedTaskrs[indexPath.row].text
            label.textColor = .black
            label.font = .systemFont(ofSize: 15, weight: .regular)
            cell.addSubview(label)
            label.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.left.equalTo(checkButton.snp.right).inset(-15)
            }
            
            let editButton = UIButton(type: .system)
            editButton.setBackgroundImage(.editBut, for: .normal)
            editButton.tag = indexPath.row
            cell.addSubview(editButton)
            editButton.snp.makeConstraints { make in
                make.height.width.equalTo(24)
                make.right.equalToSuperview().inset(15)
                make.top.equalToSuperview().inset(15)
            }
            editButton.addTarget(self, action: #selector(editTask(sender:)), for: .touchUpInside)
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionOne {
            return CGSize(width: collectionView.frame.width, height: 1165)
        } else {
            return CGSize(width: collectionView.frame.width - 30, height: 71)
        }
    }
    
    
}


extension DetailPetViewController: DetailPetViewControllerDelegate {
    func reload(item: Pet) {
        self.pet = item
        title = item.name
        sortArr()
        delegate?.reloadCollection()
    }
    
    func del() {
        delegate?.reloadCollection()
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
}
