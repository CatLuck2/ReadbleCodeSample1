//
//  AddMemo.swift
//  ReadbleCodeSample1
//
//  Created by Nekokichi on 2020/08/14.
//  Copyright © 2020 Nekokichi. All rights reserved.
//

import UIKit
import RealmSwift

class MemoObject: Object {
    @objc dynamic var data: Data!
    @objc dynamic var identifier: String!
}

class AddMemo: UIViewController {
    
    @IBOutlet private weak var memoTextView: UITextView!
    
    let picker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        picker.sourceType = .photoLibrary
    }
    
    @IBAction func leftButton(_ sender: Any) {
        let realm = try! Realm()
        let memo: MemoObject = MemoObject()
        let data = try! NSKeyedArchiver.archivedData(withRootObject: memoTextView.attributedText!, requiringSecureCoding: false)
        memo.data = data
        memo.identifier = String().randomString()
        try! realm.write{
            realm.add(memo)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func gesture(_ sender: UILongPressGestureRecognizer) {
        let alert = UIAlertController(title: "画像を添付", message: nil, preferredStyle: .actionSheet)
        let action = UIAlertAction(title: "OK", style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
            self.present(self.picker, animated: true, completion: nil)
        }
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        alert.addAction(action)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
}

extension String {
    func randomString() -> String {
        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var len = Int()
        var randomCharacters = String()
        for _ in 1...9 {            len = Int(arc4random_uniform(UInt32(characters.count)))
            randomCharacters += String(characters[characters.index(characters.startIndex,offsetBy: len)])
        }
        return randomCharacters
    }
}

extension AddMemo: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            let pickerImage = image.resized(withPercentage: 0.5)!
            let fullString = NSMutableAttributedString(string: memoTextView.text)
            let imageWidth = pickerImage.size.width
            let padding: CGFloat = self.view.frame.width / 8
            let scaleFactor = imageWidth / (memoTextView.frame.size.width - padding)
            let imageAttachment = NSTextAttachment()
            imageAttachment.image = UIImage(cgImage: pickerImage.cgImage!, scale: scaleFactor, orientation: pickerImage.imageOrientation)
            let imageString = NSAttributedString(attachment: imageAttachment)
            fullString.append(imageString)
            memoTextView.attributedText = fullString
        }
        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

}
