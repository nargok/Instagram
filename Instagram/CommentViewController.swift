//
//  CommentViewController.swift
//  Instagram
//
//  Created by 後閑諒一 on 2017/07/01.
//  Copyright © 2017年 ryoichi.gokan. All rights reserved.
//

// 仕様概要
// CommentViewControllerに遷移したときにキーボードを表示する
// CommentViewControllerの背景は透過している(透明)
// キーボードの上部(アクセサリ)にテキストとボタンを設置する
// コメントを入力し送信ボタンをタップすると入力したコメントをFireBaseに登録する
// コメントの登録が終わると、タイムラインの画面に戻る

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class CommentViewController: UIViewController, UITextFieldDelegate {

    // コメント入力フィールド
    @IBOutlet weak var commentTextField: UITextField!
    var myTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        commentTextField.placeholder = "コメントを入力してください"
        
        // ボタンビュー作成
        let myKeyboard = UIView(frame: CGRectMake(0, 0, 320, 40))
        myKeyboard.backgroundColor = UIColor.darkGray

        // textField作成
        myTextField = UITextField(frame: CGRectMake(5, 5, 280, 30))
        myTextField.backgroundColor = UIColor.white
        myTextField.placeholder = "コメントを入力してください"
        // textFieldをViewに追加
        myKeyboard.addSubview(myTextField)
        
        // 投稿ボタン作成
        let myButton = UIButton(frame: CGRectMake(310, 5, 80, 30))
        myButton.backgroundColor = UIColor.lightGray
        myButton.setTitle("投稿", for: UIControlState.normal)
        myButton.addTarget(self, action: #selector(CommentViewController.onMyButton), for: UIControlEvents.touchUpInside)
        
        // ボタンをViewに追加
        myKeyboard.addSubview(myButton)

        // ビューをフィールドに設定
        commentTextField.inputAccessoryView = myKeyboard
        commentTextField.delegate = self
        
        // 画面遷移時にキーボードを表示させる
        self.commentTextField.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 投稿ボタンタップ時に実行するメソッド
    func onMyButton() {

        let time = NSDate.timeIntervalSinceReferenceDate
        
        if myTextField.text != nil {

            // タップされたセルのデータを受け取る
            let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
            let postData = appDelegate.postData
            print("DEBUG PRINT: 更新するデータのkey: \(postData?.id)")
            
            
            // FireBaseからデータ取得

            let postRef = FIRDatabase.database().reference().child(Const.PostPath).child((postData?.id!)!).child("comments")
            let uid: String = (FIRAuth.auth()?.currentUser?.uid)!
            let name: String = (FIRAuth.auth()?.currentUser?.displayName)!
            let commentText: String = myTextField.text!
            
            let comments = ["time": String(time), "comment": commentText, "uid": uid, "name": name ]
            
            // コメントにnullを登録するのを回避する
            if postData?.comments is NSNull {
                print("DEBUG PRINT: comment is Null")
            } else {
                postData?.comments.append(comments)
            }
                        
            print("Test PRINT2: \(postData?.comments)")
            
            // FireBaseのデータ更新 commentにデータを追加
            postRef.setValue(postData?.comments)
        }
        
        // 元の画面へ戻る
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    // リターンキーでのdelegate method
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        commentTextField.text = myTextField.text
        self.view.endEditing(true)
        return false
    }
    
    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
}
