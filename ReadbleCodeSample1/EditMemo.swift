//
//  EditMemo.swift
//  ReadbleCodeSample1
//
//  Created by Nekokichi on 2020/08/14.
//  Copyright © 2020 Nekokichi. All rights reserved.
//

import UIKit
import RealmSwift

class EditMemo: UIViewController {
    
    @IBOutlet weak var memoTextView: UITextView!
    
    let picker = UIImagePickerController()
    var list:Results<MemoObject>!
    var memoObject: MemoObject = MemoObject()
    var text = NSAttributedString()
    var indexPath: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        let realm = try! Realm()
        list = realm.objects(MemoObject.self)
        memoTextView.attributedText = text
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
    
    @IBAction func complete(_ sender: Any) {
        let realm = try! Realm()
        let data2 = try! NSKeyedArchiver.archivedData(withRootObject: memoTextView.attributedText!, requiringSecureCoding: false)
        let memo = realm.objects(MemoObject.self).filter("identifier == %@", memoObject.identifier)
        try! realm.write {
            memo.setValue(data2, forKey: "data")
        }
        self.navigationController?.popToRootViewController(animated: true)
    }
        
}

extension EditMemo: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            let fullString = NSMutableAttributedString(attributedString: memoTextView.attributedText)
            let pickerImage = image.resized(withPercentage: 0.1)!
            let imageWidth = pickerImage.size.width
            let padding: CGFloat = self.view.frame.width / 2
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

extension UIImage {
    //データサイズを変更する
    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvas = CGSize(width: size.width * percentage, height: size.height * percentage)
        return UIGraphicsImageRenderer(size: canvas, format: imageRendererFormat).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
}
