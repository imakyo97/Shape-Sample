//
//  ViewController.swift
//  ZukeiArc2
//
//  Created by 今村京平 on 2021/06/10.
//

import UIKit

class ViewController: UIViewController {

    func drawLine() -> UIImage {
        let size = view.bounds.size
        UIGraphicsBeginImageContextWithOptions(size, false, 1)
        
        let center = CGPoint(x: view.center.x, y: view.center.y)
        let arcPath = UIBezierPath(arcCenter: center,
                                   radius: 80,
                                   startAngle: CGFloat(-Double.pi/2),
                                   endAngle: CGFloat(Double.pi/4*3),
                                   clockwise: true)
        arcPath.addLine(to: center)
        arcPath.close()
        
        UIColor.cyan.setFill()
        arcPath.fill()
        
        arcPath.lineWidth = 5
        arcPath.lineCapStyle = .butt
        UIColor.cyan.setStroke()
        arcPath.stroke()
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    override func viewDidLoad() {
        super.viewDidLoad()
let arcImage = drawLine()
        let arcView = UIImageView(image: arcImage)
        view.addSubview(arcView)
    }


}

