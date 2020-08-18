//
//  AddMemo.swift
//  ReadbleCodeSample1
//
//  Created by Nekokichi on 2020/08/14.
//  Copyright © 2020 Nekokichi. All rights reserved.
//

import UIKit
import RealmSwift

class MemoModel: Object {
    @objc dynamic var data: Data!
    @objc dynamic var identifier: String!
}

class AddMemo: UIViewController {
    
    @IBOutlet private weak var memoTextView: UITextView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
    }
    
    @IBAction func addMemo(_ sender: Any) {
        let realm = try! Realm()
        let memoObject: MemoModel = MemoModel()
        let archivedAttributedText = try! NSKeyedArchiver.archivedData(withRootObject: memoTextView.attributedText!, requiringSecureCoding: false)
        memoObject.data = archivedAttributedText
        memoObject.identifier = String().randomString()
        try! realm.write{
            realm.add(memoObject)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func attachImageGesture(_ sender: UILongPressGestureRecognizer) {
        let alert = UIAlertController(title: "画像を添付", message: nil, preferredStyle: .actionSheet)
        let action = UIAlertAction(title: "OK", style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
            self.present(self.imagePicker, animated: true, completion: nil)
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
        if let pickerImage = info[.originalImage] as? UIImage {
            let mutAttrMemoText = NSMutableAttributedString(attributedString: memoTextView.attributedText)
            let resizedImage = pickerImage.resizeImage(withPercentage: 0.1)!
            let width = pickerImage.size.width
            let padding: CGFloat = self.view.frame.width / 2
            let scaleRate = width / (memoTextView.frame.size.width - padding)
            let imageAttachment = NSTextAttachment()
            imageAttachment.image = UIImage(cgImage: resizedImage.cgImage!, scale: scaleRate, orientation: resizedImage.imageOrientation)
            let imageAttributedString = NSAttributedString(attachment: imageAttachment)
            mutAttrMemoText.append(imageAttributedString)
            memoTextView.attributedText = mutAttrMemoText
        }
        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    

}
