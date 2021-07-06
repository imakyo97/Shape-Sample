//
//  ViewController.swift
//  ZukeiArc1
//
//  Created by 今村京平 on 2021/06/10.
//

import UIKit

class ViewController: UIViewController {

    func drawLine() -> UIImage {
        let size = view.bounds.size
        UIGraphicsBeginImageContextWithOptions(size, false, 1)
        let arcPath = UIBezierPath(arcCenter: CGPoint(x: view.center.x, y: view.center.y),
                                   radius: 80,
                                   startAngle: 0,
                                   endAngle: CGFloat(Double.pi * 5 / 3),
                                   clockwise: true)
        arcPath.lineWidth = 40
        arcPath.lineCapStyle = .round
        arcPath.stroke()
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        let drawImage = drawLine()
        let drawView = UIImageView(image: drawImage)
        view.addSubview(drawView)
    }


}

