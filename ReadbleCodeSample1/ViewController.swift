//
//  ViewController.swift
//  ReadbleCodeSample1
//
//  Created by Nekokichi on 2020/08/14.
//  Copyright © 2020 Nekokichi. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var list:Results<MemoObject>!
    var text = [NSAttributedString]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let realm = try! Realm()
        text = [NSAttributedString]()
        list = realm.objects(MemoObject.self)
        if list.count > 0 {
            for i in 0...list.count-1 {
                let attributeText = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(list![i].data) as! NSAttributedString
                text.append(attributeText)
            }
        }
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "customcell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customcell", for: indexPath) as! CustomCell
        cell.label.text = text[indexPath.row].string
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "display", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let realm = try! Realm()
        let object = list[indexPath.row]
        try! realm.write() {
            realm.delete(object)
        }
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "display" {
            let vc = segue.destination as! DisplayMemo
            vc.memo = list[tableView.indexPathForSelectedRow!.row]
            vc.text = text[tableView.indexPathForSelectedRow!.row]
            vc.indexPath = tableView.indexPathForSelectedRow?.row
        }
    }

}

