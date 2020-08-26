//
//  DisplayMemo.swift
//  ReadbleCodeSample1
//
//  Created by Nekokichi on 2020/08/14.
//  Copyright © 2020 Nekokichi. All rights reserved.
//

import UIKit
import RealmSwift

class DisplayMemo: UIViewController {
    
    @IBOutlet weak var memoTextView: UITextView!
    //ViewControllerから値を受け取る変数群
    var selectedMemoObject          = MemoModel()
    var selectedMemo_attributedText = NSAttributedString()
    var selectedIndexPathRow        = Int()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //前画面で選択されたメモのテキストを表示
        memoTextView.attributedText = selectedMemo_attributedText
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "edit" {
            //EditMemoのインスタンス
            let vc = segue.destination as! EditMemo
            //EditMemoのプロパティに代入
            vc.selectedMemoObject          = selectedMemoObject
            vc.selectedMemo_attributedText = memoTextView.attributedText
            vc.selectedIndexPathRow        = selectedIndexPathRow
        }
    }
    

}
