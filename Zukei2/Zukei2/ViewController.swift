//
//  ViewController.swift
//  Zukei2
//
//  Created by 今村京平 on 2021/06/10.
//

import UIKit

class ViewController: UIViewController {

    func makeRoundRectImage(width w: CGFloat, height h: CGFloat, corner r: CGFloat) -> UIImage {
        let size = CGSize(width: w, height: h)
        UIGraphicsBeginImageContextWithOptions(size, false, 1)
        
        let context = UIGraphicsGetCurrentContext()
        
        let drawRect = CGRect(x: 0, y: 0, width: w, height: h)
        let drawPath = UIBezierPath(roundedRect: drawRect, cornerRadius: r)
        
        context?.setFillColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        drawPath.fill()
        context?.setStrokeColor(red: 1, green: 1, blue: 1, alpha: 1)
        drawPath.stroke()
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        let roundImage = makeRoundRectImage(width: 200, height: 200, corner: 20)
        let roundView = UIImageView(image: roundImage)
        roundView.center = view.center
        view.addSubview(roundView)
    }


}

