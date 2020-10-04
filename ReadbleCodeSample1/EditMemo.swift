//
//  EditMemo.swift
//  ReadbleCodeSample1
//
//  Created by Nekokichi on 2020/08/14.
//  Copyright © 2020 Nekokichi. All rights reserved.
//

import UIKit
import RealmSwift

final class EditMemo: UIViewController {
    
    @IBOutlet private weak var memoTextView: UITextView!
    
    // Realm
    private let realm       = try! Realm()
    private let imagePicker = UIImagePickerController()
    // ViewControllerで選択されたメモのデータ群
    var selectedMemoObject  :MemoModel!
    var selectedMemoString  :NSAttributedString!
    var selectedIndexPathRow:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker.delegate   = self
        imagePicker.sourceType = .photoLibrary
        
        memoTextView.attributedText = selectedMemoString
    }
    
    // 長押しタップ -> アラート表示 -> ImagePicker起動
    @IBAction private func attachImageGesture(_ sender: UILongPressGestureRecognizer) {
        let alert = UIAlertController(title: "画像を添付", message: nil, preferredStyle: .actionSheet)

        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        alert.addAction(okAction)

        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        alert.addAction(cancelAction)

        present(alert, animated: true, completion: nil)
    }
    
    @IBAction private func updateMemo(_ sender: Any) {
        // memoTextView.attributedText -> Data()
        let editedMemoTextData = try! NSKeyedArchiver.archivedData(withRootObject: memoTextView.attributedText!, requiringSecureCoding: false)
        // Realm内のデータを参照
        let realmRef  = realm.objects(MemoModel.self).filter("identifier == %@", selectedMemoObject.identifier!)
        
        // Realm-Update
        try! realm.write {
            realmRef.setValue(editedMemoTextData, forKey: "data")
        }
        
        // Back to ViewContrller
        self.navigationController?.popToRootViewController(animated: true)
    }
        
}

extension EditMemo: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickerImage = info[.originalImage] as? UIImage {

            let width                 = pickerImage.size.width
            let padding               = self.view.frame.width / 2
            let scaleRate             = width / (memoTextView.frame.size.width - padding)
            // 10%に圧縮した画像
            let resizedImage          = pickerImage.resizeImage(withPercentage: 0.1)!
            let imageAttachment       = NSTextAttachment()
            // resizedImage -> NSAttributedString()
            imageAttachment.image = UIImage(cgImage: resizedImage.cgImage!, scale: scaleRate, orientation: resizedImage.imageOrientation)

            let imageAttributedString = NSAttributedString(attachment: imageAttachment)

            // memoTextView.attributedText -> NSMutableAttributedString()
            let mutAttrMemoString     = NSMutableAttributedString(attributedString: memoTextView.attributedText)
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

extension UIImage {
    func resizeImage(withPercentage percentage: CGFloat) -> UIImage? {
        // 圧縮後のサイズ情報
        let canvas = CGSize(width: size.width * percentage, height: size.height * percentage)
        // return resized Image
        return UIGraphicsImageRenderer(size: canvas, format: imageRendererFormat).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
}
