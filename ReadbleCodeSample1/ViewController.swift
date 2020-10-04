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
    
    // Realmへ保存用のメモリスト
    var memoListForRealm:Results<MemoModel>!
    // Realm
    let realm               = try! Realm()
    // メモリスト
    var memoList            = [NSAttributedString]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        memoList                    = [NSAttributedString]()
        // Realm-Read
        memoListForRealm            = realm.objects(MemoModel.self)
        
        // memoList[i]: memoListForRealm.data -> NSAttributedString
        // memoList[i] add to attributedTextArray
        if memoListForRealm.count > 0 {
            for i in 0...memoListForRealm.count-1 {
                let attributeText = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(memoListForRealm![i].data) as! NSAttributedString
                memoList.append(attributeText)
            }
        }
        
        memoTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        memoTableView.delegate   = self
        memoTableView.dataSource = self
        memoTableView.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "customcell")
    }
    
    
    /* TableView */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memoListForRealm.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customcell", for: indexPath) as! CustomCell
        cell.label.text = memoList[indexPath.row].string
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "display", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let selectedMemo = memoListForRealm[indexPath.row]
        
        //Realm-Delete
        try! realm.write() {
            realm.delete(selectedMemo)
        }
        
        tableView.reloadData()
    }
    /***/
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "display" {
            // DisplayMemoに選択したメモを渡す
            let vc = segue.destination as! DisplayMemo
            guard let indexPathRow = memoTableView.indexPathForSelectedRow?.row else {
                return
            }
            vc.selectedMemoObject          = memoListForRealm[indexPathRow]
            vc.selectedMemoString          = memoList[indexPathRow]
            vc.selectedIndexPathRow        = indexPathRow
        }
    }

}

