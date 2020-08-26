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
    
    //メモリスト
    var memoList:Results<MemoModel>!
    //Realm
    let realm               = try! Realm()
    //保存用の配列
    var attributedTextArray = [NSAttributedString]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //初期化
        attributedTextArray = [NSAttributedString]()
        //データ取得
        memoList            = realm.objects(MemoModel.self)
        
        //Realmから取得したデータをAttributedStringに変換していって
        //attributedTextArrayに追加していく
        if memoList.count > 0 {
            for i in 0...memoList.count-1 {
                let attributeText = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(memoList![i].data) as! NSAttributedString
                attributedTextArray.append(attributeText)
            }
        }
        
        //tableView更新
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
        //選択したメモのデータ
        let selectedMemo = memoList[indexPath.row]
        //TableViewで選択したメモのデータをRealmから削除する
        try! realm.write() {
            realm.delete(selectedMemo)
        }
        
        //tableView更新
        tableView.reloadData()
    }
    /***/
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "display" {
            //DisplayMemoのインスタンスを宣言
            let vc = segue.destination as! DisplayMemo
            //DisplayMemoのプロパティに値を代入
            vc.selectedMemoObject          = memoList[memoTableView.indexPathForSelectedRow!.row]
            vc.selectedMemo_attributedText = attributedTextArray[memoTableView.indexPathForSelectedRow!.row]
            vc.selectedIndexPathRow        = memoTableView.indexPathForSelectedRow!.row
        }
    }

}

