//
//  ViewController.swift
//  Zukei1
//
//  Created by 今村京平 on 2021/06/10.
//

import UIKit

class ViewController: UIViewController {
    
    func boxImage(width w: CGFloat, height h: CGFloat) -> UIImage {
        let size = CGSize(width: w, height: h)
        UIGraphicsBeginImageContextWithOptions(size, false, 1)
        
        let context = UIGraphicsGetCurrentContext()
        
        let drawRect = CGRect(x: 0, y: 0, width: w, height: h)
        let drawPath = UIBezierPath(rect: drawRect)
        
        context?.setFillColor(red: 0, green: 1, blue: 1, alpha: 1)
        drawPath.fill()
        context?.setStrokeColor(red: 0, green: 0, blue: 1, alpha: 1)
        drawPath.stroke()
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let boxImage = boxImage(width: 200, height: 200)
        let boxView = UIImageView(image: boxImage)
        boxView.center = view.center
        view.addSubview(boxView)
    }


}

