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
    
    var selectedMemoObject: MemoModel = MemoModel()
    var selectedMemo_attributedText = NSAttributedString()
    var selectedIndexPathRow: Int!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        memoTextView.attributedText = selectedMemo_attributedText
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "edit" {
            let vc = segue.destination as! EditMemo
            vc.selectedMemoObject = selectedMemoObject
            vc.selectedMemo_attributedText = memoTextView.attributedText
            vc.selectedIndexPathRow = selectedIndexPathRow
        }
    }
    

}
