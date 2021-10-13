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
        let label: UILabel? // 項目の割合が小さい場合はラベルを表示しないためオプショナル
    }

    private var count = 0 // 実行中のアニメーションレイヤー
    private var pies: [Pie] = []
    private var size: CGFloat! // frameの短い辺
    private var radius: CGFloat! // arcPathの半径
    private var basicLineWidth: CGFloat! // グラフの幅
    private var largerLineWidth: CGFloat! // 拡大時のグラフの幅
    private var selectedLayer: CAShapeLayer?
    private var centerSpace: CGFloat! // グラフ中心のスペース
    private let duration: Double = 0.25 // グラフが表示されるまでの時間

    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        size = min(frame.width, frame.height)
        radius = size / 16 * 5
        basicLineWidth = size / 4
        largerLineWidth = size / 8 * 3
        centerSpace = size / 8 * 3
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        size = min(frame.width, frame.height)
        radius = size / 16 * 5
        basicLineWidth = size / 4
        largerLineWidth = size / 8 * 3
        centerSpace = size / 8 * 3
    }

    // MARK: - touchesBegan
    // グラフタップ時にグラフを拡大・縮小
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // タップされたポイントの色を取得
        let touch = touches.first
        let point = touch!.location(in: self)
        let color = colorOfPoint(point: point)

        // 色がグラフのレイヤーと一致すれば拡大・縮小を行う
        guard let layer = pies.filter({ $0.layer.strokeColor == color }).first?.layer else { return }
        if layer == selectedLayer {
            // すでに選択されている時
            layer.lineWidth = basicLineWidth
            selectedLayer = nil
        } else {
            // 選択されていない時
            selectedLayer?.lineWidth = basicLineWidth
            layer.lineWidth = largerLineWidth
            selectedLayer = layer
        }
    }

    // TODO: 深掘りが必要
    // pointの色を取得する
    func colorOfPoint(point: CGPoint) -> CGColor {
        let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)

        var pixelData: [UInt8] = [0, 0, 0, 0]

        let context = CGContext(data: &pixelData, width: 1, height: 1,bitsPerComponent: 8,
                                bytesPerRow: 4,space: colorSpace,bitmapInfo: bitmapInfo.rawValue)

        context!.translateBy(x: -point.x, y: -point.y)

        self.layer.render(in: context!)

        let red: CGFloat = CGFloat(pixelData[0]) / CGFloat(255.0)
        let green: CGFloat = CGFloat(pixelData[1]) / CGFloat(255.0)
        let blue: CGFloat = CGFloat(pixelData[2]) / CGFloat(255.0)
        let alpha: CGFloat = CGFloat(pixelData[3]) / CGFloat(255.0)

        let color: UIColor = UIColor(red: red, green: green, blue: blue, alpha: alpha)

        return color.cgColor
    }

    // MARK: - function
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

            // angleRateが小さい場合はラベルを作らない
            var label: UILabel?
            if angleRate > Double(22 / size) {
                label = createCategoryLabel(category: $0.category, balance: $0.balance,
                                            startAngle: startAngle, endAngle: angle)
            }

            pies.append(
                Pie(layer: layer, duration: Double(angleRate * duration), label: label)
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

        // グラフが表示されてから、グラフ中央のviewを反映
        // TODO: NumberFormatterで実装
        let totalString = String.localizedStringWithFormat("%d", totalBalance) + "円"
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) { [weak self] in
            guard let self = self else { return }
            self.addCenterView(text: totalString)
        }
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
        shapeLayer.lineWidth = basicLineWidth
        shapeLayer.fillColor = UIColor.clear.cgColor
        return shapeLayer
    }

    // レイヤーにアニメーションを反映
    private func addCABasicAnimation(layer: CAShapeLayer, duration: CFTimeInterval) {
        let animation = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.strokeEnd))
        animation.duration = duration
        animation.fromValue = 0
        animation.toValue = 1
        animation.delegate = self
        layer.add(animation, forKey: #keyPath(CAShapeLayer.strokeEnd))
    }

    // グラフ中央のViewを反映
    private func addCenterView(text: String) {
        // センターの丸いviewを作成
        let centerView = UIView(frame: CGRect(x: 0, y: 0, width: centerSpace, height: centerSpace))
        centerView.backgroundColor = .white
        centerView.layer.cornerRadius = centerSpace / 2
        centerView.clipsToBounds = true
        centerView.center = CGPoint(x: size / 2, y: size / 2)
        // センターに載せるラベルを作成
        let label = UILabel(
            frame: CGRect(x: 0, y: 0, width: centerSpace - 10, height: 42)
        )
        label.textAlignment = NSTextAlignment.center
        label.numberOfLines = 2
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.text = text
        label.center = CGPoint(x: centerSpace / 2, y: centerSpace / 2)
        centerView.addSubview(label)
        addSubview(centerView)
    }

    // グラフの上に載せるラベルを作成
    private func createCategoryLabel(category: String, balance: Int, startAngle: Double, endAngle: Double) -> UILabel {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: basicLineWidth - 10, height: 51))
        label.textAlignment = NSTextAlignment.center
        label.numberOfLines = 3
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
        return CGPoint(x: Double(size / 2) + x, y: Double(size / 2) + y)
    }

    // MARK: - CAAnimationDelegate
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        count += 1
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
