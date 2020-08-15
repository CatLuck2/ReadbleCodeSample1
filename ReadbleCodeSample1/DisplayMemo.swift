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
    
    var list:Results<MemoObject>!
    var memo: MemoObject = MemoObject()
    var text = NSAttributedString()
    var indexPath: Int!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        memoTextView.attributedText = text
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "edit" {
            let vc = segue.destination as! EditMemo
            vc.memoObject = memo
            vc.text = memoTextView.attributedText
            vc.indexPath = indexPath
        }
    }
    

}
