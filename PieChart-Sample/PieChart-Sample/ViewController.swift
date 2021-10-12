//
//  ViewController.swift
//  PieChart-Sample
//
//  Created by 今村京平 on 2021/10/11.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private weak var pieChartView: PieChartView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    private let graphDataArray: [GraphData] = [
        GraphData(category: "飲食費", color: .red, balance: 100),
        GraphData(category: "医療費", color: .blue, balance: 400),
        GraphData(category: "交通費", color: .green, balance: 3000)
    ]

    @IBAction func didTapButton(_ sender: Any) {
        pieChartView.setupPieChartView(setData: graphDataArray)
    }
}

