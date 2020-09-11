//
//  ViewController.swift
//  codeOnly
//
//  Created by 池田友宏 on 2020/08/25.
//  Copyright © 2020 Tomohiro Ikeda. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    fileprivate let label = UILabel()
    fileprivate let tableView = UITableView()
    fileprivate let textField = UITextField()
    fileprivate let submitButton = UIButton()
    
    fileprivate var textArray = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBasic()
        setupBackgroundImageView()
        setupLabel()
        setupTextField()
        setupButton()
        setupTableView()
        fetchTitleData()
    }
    
    fileprivate func setupBasic() {
        view.backgroundColor = .white
    }
    fileprivate func setupBackgroundImageView() {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "backImage"))
        view.addSubview(imageView)
        imageView.fillSuperview()
    }
    fileprivate func setupLabel() {
        view.addSubview(label)
        label.anchor(top: view.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 50, left: 0, bottom: 0, right: 0))
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.text = "とりあえずかんたんなやつ"
        label.textColor = .green
        label.textAlignment = .center
        label.frame = CGRect(x: 0, y: 50, width: view.frame.size.width, height: 20)
    }
    fileprivate func setupTextField() {
        view.addSubview(textField)
        textField.anchor(top: label.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 12, left: 0, bottom: 0, right: 0), size: .init(width: 150, height: 30))
        textField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        textField.backgroundColor = .white
        textField.delegate = self
    }
    fileprivate func setupButton() {
        view.addSubview(submitButton)
        submitButton.anchor(top: textField.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 32, left: 0, bottom: 0, right: 0), size: .init(width: 150, height: 50))
        submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        submitButton.setTitle("ボタンですよ", for: UIControl.State.normal)
        submitButton.addTarget(self, action: #selector(addText), for: .touchUpInside)
    }
    fileprivate func setupTableView() {
        view.addSubview(tableView)
        tableView.anchor(top: submitButton.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        tableView.backgroundColor = UIColor.init(red: 0.8, green: 0, blue: 0, alpha: 0.1)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.className) // ←これはなんだ？？
    }
    
    // ボタンをクリックしたときのアクション
    @objc private func addText() {
        let inputText = textField.text ?? ""
        label.text = inputText + "を記録したよ。"
        // Firebaseにデータを保存する
        let titleDB = Database.database().reference().child("titles")
        let titleInfo = ["title":inputText]
        titleDB.childByAutoId().setValue(titleInfo) { (error, result) in
            
            if error != nil {
                print(error)
            } else {
                print("送信完了！")
            }
        }
        textField.text = ""
    }
    
    // データを取得する
    func fetchTitleData() {
        // Firebaseからデータを取得
        let fetchDataRef = Database.database().reference().child("titles")
        
        // 新しく更新があったときに取得する
        fetchDataRef.observe(.childAdded, with: { (snapShot) in
            let snapShotData = snapShot.value as AnyObject
            let title = snapShotData.value(forKey: "title")
            
            self.textArray.append(title as! String)
            self.tableView.reloadData()

        }, withCancel: nil)
    }
}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in sampleTableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return textArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.className) else { fatalError("improper UITableViewCell")} // ←これはなんだ？？
        cell.textLabel?.text = textArray[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextViewController = NextViewController()
//        nextViewController.modalPresentationStyle = .fullScreen
        present(nextViewController, animated: true, completion: nil)
    }
}
extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


