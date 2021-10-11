//
//  ViewController.swift
//  Zukei1
//
//  Created by 今村京平 on 2021/06/10.
//

import UIKit

class ViewController: UIViewController {

    // 四角形の図形イメージを作る
    func makeBoxImage(width w: CGFloat, height h: CGFloat) -> UIImage {
        // イメージ処理の開始
        let size = CGSize(width: w, height: h)
        UIGraphicsBeginImageContextWithOptions(size, false, 1)
        // コンテキスト
        let context = UIGraphicsGetCurrentContext()
        // サイズを決める
        let drawRect = CGRect(x: 0, y: 0, width: w, height: h)
        // パスを作る（四角形）
        let drawPath = UIBezierPath(rect: drawRect)

        // 塗り色
        context?.setFillColor(CGColor(red: 0, green: 1, blue: 1, alpha: 1))
        // パスを塗る
        drawPath.fill()
        // 線の色
        context?.setStrokeColor(red: 0, green: 0, blue: 1, alpha: 1)
        // パスを描く
        drawPath.stroke()

        // イメージコンテキストからUIImageを作る
        let image = UIGraphicsGetImageFromCurrentImageContext()
        // イメージ処理の終了
        UIGraphicsEndImageContext()

        return image!
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // 四角形のイメージを作る
        let boxImage = makeBoxImage(width: 240, height: 180)
        // イメージビューに設定する
        let boxView = UIImageView(image: boxImage)
        // 画面に表示する
        boxView.center = view.center
        view.addSubview(boxView)
    }
}

