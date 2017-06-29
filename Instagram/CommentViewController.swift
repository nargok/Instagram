//
//  CommentViewController.swift
//  Instagram
//
//  Created by 後閑諒一 on 2017/06/20.
//  Copyright © 2017年 ryoichi.gokan. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class CommentViewController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate {
//    @IBOutlet weak var commentTxtField: UITextField!
    let commentTxtField = UITextField(frame: CGRect(x: 0,y: 0,width: 200,height: 30))
    let sc = UIScrollView();
    var txtActiveField = UITextField()
    
    // コメントテキストフィールド
    @IBOutlet weak var commentTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
//        sc.frame = self.view.frame;
//        sc.backgroundColor = UIColor.clear;
//        sc.delegate = self;
        
//        sc.contentSize = CGSize(width: 250, height: 500)
//        self.view.addSubview(sc);

        // 文字列の設定
//        commentTxtField.text = ""
//        commentTxtField.placeholder = "コメント入力"
        commentTextField.placeholder = "コメントを入力してください"
        
        // Delegateを設定する
//        commentTxtField.delegate = self
        
//        commentTxtField.borderStyle = UITextBorderStyle.roundedRect

        // UITextFieldの表示する位置を設定する.
//        commentTxtField.layer.position = CGPoint(x:self.view.bounds.width/2,y:500);
        
//        self.view.addSubview(commentTxtField)
        
        // Viewに追加する
//        sc.addSubview(commentTxtField)
    }

    
    // テキストフィールド終了時に呼び出されるメソッド
    // Returnキーを押すとキーボードが閉じられるようにする
    @IBAction func endInputTextField(_ sender: UITextField) {
    }
    
    // UITextFieldが編集された直後に呼ばれる
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        txtActiveField = textField
        return true
    }
    
    // UITextFieldの下辺とキーボードの上辺が重なっているかどうか調べるための処理
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(CommentViewController.handlekeyboardWillShowNotification(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        notificationCenter.addObserver(self, selector: #selector(CommentViewController.handlekeyboardWillHideNotification(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func handlekeyboardWillShowNotification(_ notification: Notification) {
        
        let userInfo = notification.userInfo!
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let myBoundSize: CGSize = UIScreen.main.bounds.size
        
        let txtLimit = txtActiveField.frame.origin.y + txtActiveField.frame.height + 8.0
        let kbdLimit = myBoundSize.height - keyboardScreenEndFrame.size.height
        
        print("テキストフィールドの下辺:(\(txtLimit))")
        print("キーボードの上辺:(\(kbdLimit))")
        
        if txtLimit >= kbdLimit {
            sc.contentOffset.y = txtLimit - kbdLimit
        }
    }
    
    func handlekeyboardWillHideNotification(_ notification: Notification) {
        
        sc.contentOffset.y = 0
        
    }
    
    // 戻るボタン処理　後で消す
    @IBAction func backBtn(_ sender: Any) {
        //閉じる
        self.dismiss(animated: true, completion: nil)
    }
    
    // 送信ボタン押下時の処理
    @IBAction func commentSubmitBtn(_ sender: Any) {
        // タップされたセルのデータを受け取る
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let postData = appDelegate.postData
        
        print("DEBUG PRINT: 更新するデータのkey: \(postData?.id)")
        
        // FireBaseにコメント登録
        let postRef = FIRDatabase.database().reference().child(Const.PostPath).child((postData?.id!)!)
        let uid: String = (FIRAuth.auth()?.currentUser?.uid)!
        let commentText: String = commentTextField.text!
        
        // comment配列に追加
        postData?.comment = [uid : commentText]
        let comments = ["comments": postData?.comment]
        postRef.updateChildValues(comments)
        
        // 元の画面へ戻る
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
