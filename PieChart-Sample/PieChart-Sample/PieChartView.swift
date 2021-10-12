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
        let duration: CFTimeInterval
        let label: UILabel?
    }

    private var count = 0 // 実行中のアニメーションレイヤー
    private var pies: [Pie] = []
    private var size: CGFloat! // frameの短い辺
    private var radius: CGFloat!

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        size = min(frame.width, frame.height)
        radius = size / 3
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        size = min(frame.width, frame.height)
        radius = size / 3
    }

    func setupPieChartView(setData data: [GraphData]) {
        // 初期化の処理
        count = 0
        layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        pies.removeAll()

        // Pie配列を作成
        let totalBalance = data.reduce(0) { $0 + $1.balance }
        var startAngle = -Double.pi / 2
        data.sorted { $0.balance > $1.balance}
        .forEach {
            let angleRate = Double($0.balance) / Double(totalBalance)
            let angle = Double.pi * 2 * angleRate + startAngle
            let arcPath = createArcPath(startAngle: startAngle, endAngle: angle)
            let layer = createCAShapeLayer(path: arcPath, storokeColor: $0.color.cgColor)

            // angleRateが小さい場合はラベルは作らない
            var label: UILabel?
            if angleRate > Double(22 / size) {
                label = createCategoryLabel(category: $0.category, balance: $0.balance,
                                            startAngle: startAngle, endAngle: angle)
            }

            pies.append(
                Pie(layer: layer, duration: Double(angleRate / 4), label: label)
            )
            startAngle = angle
        }

        // 最初のアニメーション実行
        addCABasicAnimation(layer: pies[count].layer, duration: pies[count].duration)
        layer.addSublayer(pies[count].layer)

        // 最初のラベルを反映
        if let label = pies[count].label {
            addSubview(label)
        }

        // グラフ中央のラベルを作成
        // TODO: NumberFormatterで実装
        let totalString = String.localizedStringWithFormat("%d", totalBalance) + "円"
        addTotalLabel(text: totalString)
    }

    // 円弧のパスを作成
    private func createArcPath(startAngle: CGFloat, endAngle: CGFloat) -> CGPath {
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
    private func addCABasicAnimation(layer: CAShapeLayer, duration: CFTimeInterval) {
        let animation = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.strokeEnd))
        animation.duration = duration
        animation.fromValue = 0
        animation.toValue = 1
        animation.delegate = self
        layer.add(animation, forKey: #keyPath(CAShapeLayer.strokeEnd))
    }

    // グラフ中央のTotalラベルを作成
    private func addTotalLabel(text: String) {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: (size / 3) - 10, height: 50))
        label.textAlignment = NSTextAlignment.center
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.text = text
        label.center = CGPoint(x: size / 2, y: size / 2)
        addSubview(label)
    }

    // グラフの上に載せるラベルを作成
    private func createCategoryLabel(category: String, balance: Int, startAngle: Double, endAngle: Double) -> UILabel {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: (size / 3) - 10, height: 50))
        label.textAlignment = NSTextAlignment.center
        label.numberOfLines = 2
        label.font = UIFont.boldSystemFont(ofSize: 14)
        // TODO: NumberFormatterで実装
        label.text = "\(category)\n\(String.localizedStringWithFormat("%d", balance))円"
        label.textColor = .white
        label.center = calcCenter(startAngle: startAngle, endAngle: endAngle)
        return label
    }

    // グラフの上に載せるラベルのセンターを計算
    private func calcCenter(startAngle: Double, endAngle: Double) -> CGPoint {
        let angle = (endAngle - startAngle) / 2 + startAngle
        let x = cos(angle) * radius
        let y = sin(angle) * radius
        switch angle {
        case -Double.pi / 2...Double.pi / 2 * 3:
            return CGPoint(x: Double(size / 2) + x, y: Double(size / 2) + y)
        default:
            fatalError("想定していない値")
        }
    }

    // MARK: - CAAnimationDelegate
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        count += 1
        print("💣")
        if count < pies.count {
            // アニメーションを実行
            addCABasicAnimation(layer: pies[count].layer, duration: pies[count].duration)
            layer.addSublayer(pies[count].layer)
            // ラベルを反映
            if let label = pies[count].label {
                addSubview(label)
            }
        }
    }
}
