//
//  ViewController.swift
//  Zukei3
//
//  Created by 今村京平 on 2021/06/10.
//

import UIKit

class ViewController: UIViewController {

    func makeOval(width w: CGFloat, height h: CGFloat) -> UIImage {
        let size = CGSize(width: w, height: h)
        UIGraphicsBeginImageContextWithOptions(size, false, 1)
        
        let context = UIGraphicsGetCurrentContext()
        
        let drowRect = CGRect(x: 0, y: 0, width: w, height: h)
        let drawPath = UIBezierPath(ovalIn: drowRect)
        
        context?.setFillColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        drawPath.fill()
        context?.setStrokeColor(red: 0.8, green: 1, blue: 1, alpha: 1)
        drawPath.stroke()
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ovalImage = makeOval(width: 200, height: 200)
        let ovalView = UIImageView(image: ovalImage)
        ovalView.center = view.center
        view.addSubview(ovalView)
    }


}

