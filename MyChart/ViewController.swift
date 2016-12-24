//
//  ViewController.swift
//  MyChart
//
//  Created by 田子瑶 on 16/12/21.
//  Copyright © 2016年 田子瑶. All rights reserved.
//

import UIKit
import SnapKit
import Charts

class ViewController: UIViewController {
    
    var barChartButton: UIButton!
    var barChartVC: BarChartViewController!
    
    var lineChartButton: UIButton!
    var lineChartVC: LineChartViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        barChartButton = UIButton()
        barChartButton.setTitle("barChart", for: .normal)
        barChartButton.backgroundColor = UIColor.gray
        barChartButton.setTitleColor(UIColor.darkGray, for: .normal)
        barChartButton.titleLabel?.font = UIFont.systemFont(ofSize: 22)
        barChartButton.addTarget(self, action: #selector(self.presentBarChartVC(sender:)), for: .touchUpInside)
        self.view.addSubview(barChartButton)
        barChartButton.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.top.equalTo(100)
            make.height.equalTo(100)
        }
        
        
        lineChartButton = UIButton()
        lineChartButton.setTitle("lineChart", for: .normal)
        lineChartButton.backgroundColor = UIColor.gray
        lineChartButton.setTitleColor(UIColor.darkGray, for: .normal)
        lineChartButton.titleLabel?.font = UIFont.systemFont(ofSize: 22)
        lineChartButton.addTarget(self, action: #selector(self.presentLineChartVC(sender:)), for: .touchUpInside)
        self.view.addSubview(lineChartButton)
        lineChartButton.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.top.equalTo(barChartButton.snp.bottom).inset(-20)
            make.height.equalTo(100)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func presentBarChartVC(sender: UIButton) {
        barChartVC = BarChartViewController()
        self.present(barChartVC, animated: true, completion: nil)
    }
    
    func presentLineChartVC(sender: UIButton) {
        lineChartVC = LineChartViewController()
        self.present(lineChartVC, animated: true, completion: nil)
    }
}

class XValsFormatter: NSObject, IAxisValueFormatter {
    
    let xVals: [String]
    init(xVals: [String]) {
        self.xVals = xVals
    }
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return xVals[Int(value)]
    }
    
}

