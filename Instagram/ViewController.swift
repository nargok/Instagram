//
//  ViewController.swift
//  Instagram
//
//  Created by 後閑諒一 on 2017/06/11.
//  Copyright © 2017年 ryoichi.gokan. All rights reserved.
//

import UIKit
import ESTabBarController
import Firebase
import FirebaseAuth

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setupTab()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //起動時にログインしていなければログイン画面を表示する
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated) //親クラスのメソッドを呼び出す
        
        //currentUserがnilならログインしていない
        if FIRAuth.auth()?.currentUser == nil {
            // viewDidAppear内でpresentを呼び出しても表示されないためメソッドが終了してから呼ばれるように予約する            
            DispatchQueue.main.async {
                //Storyboard上のLoginViewControllerを取得する
                let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login")
                //モーダル表示
                self.present(loginViewController!, animated: true, completion: nil)
            }
        }
    }
    
    func setupTab() {
        
        // 画像のファイル名を指定してESTabBarControllerを作成する
        let tabBarController: ESTabBarController! = ESTabBarController(tabIconNames: [ "home", "camera", "setting" ])
        
        // 背景色、選択時の色を設定する
        tabBarController.selectedColor = UIColor(red: 1.0, green: 0.44, blue: 0.11, alpha: 1)
        tabBarController.buttonsBackgroundColor = UIColor(red: 0.96, green: 0.91, blue: 0.87, alpha: 1)
        
        // 作成したESTabBarControllerを親のViewController(=self)に追加する
        addChildViewController(tabBarController)  //didMoveとset
        //追加するときの処理　ここから
        view.addSubview(tabBarController.view) //子のViewContollerのviewを追加する
        tabBarController.view.frame = view.bounds //viewのframeを親のViewConrollerのviewと同じ値にする
        //追加するときの処理　ここまで
        tabBarController.didMove(toParentViewController: self) //addChildViewControllerとset
        
        // タブをタップした時に表示するViewControllerを設定する
        let homeViewController = storyboard?.instantiateViewController(withIdentifier: "Home")
        let settingViewController = storyboard?.instantiateViewController(withIdentifier: "Setting")
        
        tabBarController.setView(homeViewController, at: 0)
        tabBarController.setView(settingViewController, at: 2)
        
        //真ん中のタブはボタンとして扱う
        tabBarController.highlightButton(at: 1)
        tabBarController.setAction({
            //ボタンが押されたらImageViewControllerをモーダルで表示する
            let imageViewController = self.storyboard?.instantiateViewController(withIdentifier: "ImageSelect")
            self.present(imageViewController!, animated: true, completion: nil)
        }, at: 1)
    }
}

