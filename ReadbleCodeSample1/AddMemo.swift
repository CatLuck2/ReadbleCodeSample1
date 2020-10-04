//
//  AddMemo.swift
//  ReadbleCodeSample1
//
//  Created by Nekokichi on 2020/08/14.
//  Copyright © 2020 Nekokichi. All rights reserved.
//

import UIKit
import RealmSwift

// Model for Realm
class MemoModel: Object {
    @objc dynamic var data: Data!
    @objc dynamic var identifier: String!
}

class AddMemo: UIViewController {
    
    @IBOutlet private weak var memoTextView: UITextView!
    
    // Realm
    let realm       = try! Realm()
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate   = self
        imagePicker.sourceType = .photoLibrary
    }
    
    @IBAction func addMemo(_ sender: Any) {
        guard let inputAttrText = memoTextView.attributedText else {
            return
        }
        let memoObject             = MemoModel()
        // memoTextView.attributedText -> Data()
        memoObject.data            = try! NSKeyedArchiver.archivedData(withRootObject: inputAttrText, requiringSecureCoding: false)
        memoObject.identifier      = String().randomString()
        
        // Realm-Add
        try! realm.write{
            realm.add(memoObject)
        }
        
        // Back to ViewController
        self.navigationController?.popViewController(animated: true)
    }
    
    // 長押しタップ -> アラート表示 -> ImagePicker起動
    @IBAction func attachImageGesture(_ sender: UILongPressGestureRecognizer) {
        let alert = UIAlertController(title: "画像を添付", message: nil, preferredStyle: .actionSheet)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
}

extension String {
    func randomString() -> String {
        // 文字群
        let characters       = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        // 文字列の長さ
        var len              = Int()
        // 乱数文字
        var randomCharacters = String()
        
        // 乱数を生成
        for _ in 1...9 {
            len = Int(arc4random_uniform(UInt32(characters.count)))
            randomCharacters += String(characters[characters.index(characters.startIndex,offsetBy: len)])
        }
        
        return randomCharacters
    }
}

extension AddMemo: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickerImage = info[.originalImage] as? UIImage {
            // NSAttributedString用のパラメーター
            let width                 = pickerImage.size.width
            let padding               = self.view.frame.width / 2
            let scaleRate             = width / (memoTextView.frame.size.width - padding)
            // 10%に圧縮した画像
            let resizedImage          = pickerImage.resizeImage(withPercentage: 0.1)!
            let imageAttachment       = NSTextAttachment()
            var imageAttributedString = NSAttributedString()
            // memoTextView.attributedText -> NSMutableAttributedString()
            let mutAttrMemoString     = NSMutableAttributedString(attributedString: memoTextView.attributedText)
            
            // resizedImage -> NSAttributedString()
            imageAttachment.image = UIImage(cgImage: resizedImage.cgImage!, scale: scaleRate, orientation: resizedImage.imageOrientation)
            imageAttributedString = NSAttributedString(attachment: imageAttachment)
            mutAttrMemoString.append(imageAttributedString)
            
            // 画像を追加後のテキスト -> memoTextView.attributedText
            memoTextView.attributedText = mutAttrMemoString
        }
        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

}
