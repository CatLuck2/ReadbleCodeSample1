//
//  DisplayMemo.swift
//  ReadbleCodeSample1
//
//  Created by Nekokichi on 2020/08/14.
//  Copyright © 2020 Nekokichi. All rights reserved.
//

import UIKit
import RealmSwift

final class DisplayMemo: UIViewController {
    
    @IBOutlet private weak var memoTextView: UITextView!
    // ViewControllerから値を受け取る
    var selectedMemoObject          : MemoModel!
    var selectedMemoString          : NSAttributedString!
    var selectedIndexPathRow        : Int!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        memoTextView.attributedText = selectedMemoString
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "edit" {
            // EditMemoに保持中のメモを渡す
            let vc                         = segue.destination as! EditMemo
            vc.selectedMemoObject          = selectedMemoObject
            vc.selectedMemoString          = selectedMemoString
            vc.selectedIndexPathRow        = selectedIndexPathRow
        }
    }
    

}
