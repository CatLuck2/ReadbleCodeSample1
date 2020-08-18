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
    
    let imagePicker = UIImagePickerController()
    var memoList:Results<MemoModel>!
    var selectedMemoObject: MemoModel = MemoModel()
    var selectedMemo_attributedText = NSAttributedString()
    var selectedIndexPathRow: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        let realm = try! Realm()
        memoList = realm.objects(MemoModel.self)
        memoTextView.attributedText = selectedMemo_attributedText
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
    
    @IBAction func updateMemo(_ sender: Any) {
        let realm = try! Realm()
        let data2 = try! NSKeyedArchiver.archivedData(withRootObject: memoTextView.attributedText!, requiringSecureCoding: false)
        let memo = realm.objects(MemoModel.self).filter("identifier == %@", selectedMemoObject.identifier!)
        try! realm.write {
            memo.setValue(data2, forKey: "data")
        }
        self.navigationController?.popToRootViewController(animated: true)
    }
        
}

extension EditMemo: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

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

extension UIImage {
    //データサイズを変更する
    func resizeImage(withPercentage percentage: CGFloat) -> UIImage? {
        let canvas = CGSize(width: size.width * percentage, height: size.height * percentage)
        return UIGraphicsImageRenderer(size: canvas, format: imageRendererFormat).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
}
