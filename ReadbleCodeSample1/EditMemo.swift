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
    
    //Realmのインスタンス、Realmのデータを受け取る変数
    var memoList:Results<MemoModel>!
    let realm                       = try! Realm()
    //imagePickerのインスタンス
    let imagePicker                 = UIImagePickerController()
    //DisplayMemoから値を受け取る変数群
    var selectedMemoObject          = MemoModel()
    var selectedMemo_attributedText = NSAttributedString()
    var selectedIndexPathRow        = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //imagePickerの設定
        imagePicker.delegate   = self
        imagePicker.sourceType = .photoLibrary
        
        //Realmからデータを取得、
        memoList = realm.objects(MemoModel.self)
        
        //memoTextViewにDisplayMemoから渡されたデータを代入
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
        //編集したデータ
        let data2 = try! NSKeyedArchiver.archivedData(withRootObject: memoTextView.attributedText!, requiringSecureCoding: false)
        //Realm内にある編集した元データの指定先
        let memo  = realm.objects(MemoModel.self).filter("identifier == %@", selectedMemoObject.identifier!)
        
        //Realmに書き込み
        try! realm.write {
            memo.setValue(data2, forKey: "data")
        }
        
        //ViewControllerに戻る
        self.navigationController?.popToRootViewController(animated: true)
    }
        
}

extension EditMemo: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickerImage = info[.originalImage] as? UIImage {
            //画像の圧縮やサイズ調整に必要な値
            let width                 = pickerImage.size.width
            let padding               = self.view.frame.width / 2
            let scaleRate             = width / (memoTextView.frame.size.width - padding)
            //圧縮した画像
            let resizedImage          = pickerImage.resizeImage(withPercentage: 0.1)!
            //インスタンスの宣言
            let imageAttachment       = NSTextAttachment()
            var imageAttributedString = NSAttributedString()
            //memoTextViewのテキストをAttributedStringに変換
            let mutAttrMemoText       = NSMutableAttributedString(attributedString: memoTextView.attributedText)
            
            //画像をNSAttributedStringに変換
            imageAttachment.image = UIImage(cgImage: resizedImage.cgImage!, scale: scaleRate, orientation: resizedImage.imageOrientation)
            imageAttributedString = NSAttributedString(attachment: imageAttachment)
            mutAttrMemoText.append(imageAttributedString)
            
            //画像を追加したAttributedStringをmemoTextViewに追加
            memoTextView.attributedText = mutAttrMemoText
        }
        //imagePickerを閉じる
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
