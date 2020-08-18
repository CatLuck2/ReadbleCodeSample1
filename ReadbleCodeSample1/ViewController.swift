//
//  ViewController.swift
//  ReadbleCodeSample1
//
//  Created by Nekokichi on 2020/08/14.2
//  Copyright © 2020 Nekokichi. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var memoTableView: UITableView!
    
    var memoList:Results<MemoModel>!
    var attributedTextArray = [NSAttributedString]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let realm = try! Realm()
        attributedTextArray = [NSAttributedString]()
        memoList = realm.objects(MemoModel.self)
        if memoList.count > 0 {
            for i in 0...memoList.count-1 {
                let attributeText = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(memoList![i].data) as! NSAttributedString
                attributedTextArray.append(attributeText)
            }
        }
        memoTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memoTableView.delegate = self
        memoTableView.dataSource = self
        memoTableView.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "customcell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memoList.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customcell", for: indexPath) as! CustomCell
        cell.label.text = attributedTextArray[indexPath.row].string
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "display", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let realm = try! Realm()
        let selectedMemo = memoList[indexPath.row]
        try! realm.write() {
            realm.delete(selectedMemo)
        }
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "display" {
            let vc = segue.destination as! DisplayMemo
            vc.selectedMemoObject = memoList[memoTableView.indexPathForSelectedRow!.row]
            vc.selectedMemo_attributedText = attributedTextArray[memoTableView.indexPathForSelectedRow!.row]
            vc.selectedIndexPathRow = memoTableView.indexPathForSelectedRow?.row
        }
    }

}

