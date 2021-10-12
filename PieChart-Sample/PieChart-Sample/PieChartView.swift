//
//  PieChartView.swift
//  PieChart-Sample
//
//  Created by 今村京平 on 2021/10/11.
//

import UIKit

class PieChartView: UIView, CAAnimationDelegate {

    struct Pie {
        let layer: CAShapeLayer
        let duration: CGFloat
    }

    private var count = 0 // 実行中のアニメーションレイヤー
    private var pies: [Pie] = []
    private var size: CGFloat! // frameの短い辺

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        size = min(frame.width, frame.height)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        size = min(frame.width, frame.height)
    }

    func setupPieChartView(setData data: [GraphData]) {
        // 初期化の処理
        count = 0
        layer.sublayers?.forEach { $0.removeFromSuperlayer() }

        // レイヤーを作成
        let totalBalance = data.reduce(0) { $0 + $1.balance }
        var startAngle = CGFloat(-Double.pi / 4 * 1)
        data.sorted { $0.balance > $1.balance}
        .forEach {
            let angleRate = Double($0.balance) / Double(totalBalance)
            let angle = CGFloat(Double.pi * 2 * angleRate) + startAngle
            let arcPath = createArcPath(startAngle: startAngle, endAngle: angle)
            let layer = createCAShapeLayer(path: arcPath, storokeColor: $0.color.cgColor)
            pies.append(Pie(layer: layer, duration: angle))
            startAngle = angle
        }

        // 最初のアニメーション実行
        addCABasicAnimation(layer: pies[count].layer)
        layer.addSublayer(pies[count].layer)
    }

    // 円弧のパスを作成
    private func createArcPath(startAngle: CGFloat, endAngle: CGFloat) -> CGPath {
        let radius: CGFloat = size / 3
        let arcCenter = CGPoint(x: size / 2, y: size / 2)
        let arcPath = UIBezierPath(
            arcCenter: arcCenter,
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: true
        )
        return arcPath.cgPath
    }

    // レイヤーを作成
    private func createCAShapeLayer(path: CGPath, storokeColor: CGColor) -> CAShapeLayer {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path
        shapeLayer.strokeColor = storokeColor
        shapeLayer.lineWidth = size / 3
        shapeLayer.fillColor = UIColor.clear.cgColor
        return shapeLayer
    }

    // アニメーションを作成
    private func addCABasicAnimation(layer: CAShapeLayer) {
        let animation = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.strokeEnd))
        animation.duration = 0.1
        animation.fromValue = 0
        animation.toValue = 1
        animation.delegate = self
        layer.add(animation, forKey: #keyPath(CAShapeLayer.strokeEnd))
    }

    // MARK: - CAAnimationDelegate
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        count += 1
        print("💣")
        if count < pies.count {
            addCABasicAnimation(layer: pies[count].layer)
            layer.addSublayer(pies[count].layer)
        } 
    }
}
