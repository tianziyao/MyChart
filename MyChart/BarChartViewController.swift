//
//  BarChartViewController.swift
//  MyChart
//
//  Created by 田子瑶 on 16/12/23.
//  Copyright © 2016年 田子瑶. All rights reserved.
//

import UIKit
import SnapKit
import Charts

class BarChartViewController: UIViewController {

    var barChartView: BarChartView!
    var data: BarChartData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        let titleLabel = UILabel()
        titleLabel.text = "Bar Chart"
        titleLabel.font = UIFont.systemFont(ofSize: 17)
        titleLabel.textColor = UIColor.darkGray
        titleLabel.textAlignment = .center
        self.view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(20)
            make.height.equalTo(44)
            make.centerX.equalTo(self.view.snp.centerX)
        }
        
        let displayButton = UIButton()
        displayButton.setTitle("返回", for: .normal)
        displayButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        displayButton.setTitleColor(UIColor.darkGray, for: .normal)
        displayButton.addTarget(self, action: #selector(self.dismissBarChartVC), for: .touchUpInside)
        self.view.addSubview(displayButton)
        displayButton.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 200, height: 50))
            make.centerX.equalTo(self.view.snp.centerX)
            make.bottom.equalTo(self.view.snp.bottom)
        }
        
        barChartView = BarChartView()
        barChartView.delegate = self
        self.view.addSubview(barChartView)
        barChartView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.top.equalTo(titleLabel.snp.bottom)
            make.bottom.equalTo(displayButton.snp.top)
        }
        
        //基本样式
        self.barChartView.backgroundColor = UIColor.white
        self.barChartView.noDataText = "暂无数据"//没有数据时的文字提示
        self.barChartView.drawValueAboveBarEnabled = true//数值显示在柱形的上面还是下面
        //self.barChartView.drawHighlightArrowEnabled = false//点击柱形图是否显示箭头
        self.barChartView.drawBarShadowEnabled = false//是否绘制柱形的阴影背景
        //self.barChartView.setViewPortOffsets(left: 0, top: 0, right: 0, bottom: 0)//内边距
        //self.barChartView.setDragOffsetX(20)//拖放时超出的距离
        //self.barChartView.minOffset = 20
        
        //交互设置
        self.barChartView.scaleYEnabled = false//Y轴缩放
        self.barChartView.doubleTapToZoomEnabled = false//双击缩放
        self.barChartView.dragEnabled = true//启用拖拽图表
        self.barChartView.zoom(scaleX: 30, scaleY: 0, x: 0, y: 0)//缩放等级
        self.barChartView.dragDecelerationEnabled = true//拖拽后是否有惯性效果
        self.barChartView.dragDecelerationFrictionCoef = 0.9//拖拽后惯性效果的摩擦系数(0~1)，数值越小，惯性越不明显
        
        //X轴样式
        let xAxis = self.barChartView.xAxis
        xAxis.axisLineWidth = 0//设置X轴线宽
        xAxis.labelPosition = .bottom//X轴的显示位置，默认是显示在上面的
        xAxis.drawGridLinesEnabled = false//不绘制网格线
        xAxis.spaceMax = 0//X轴最小值百分比
        xAxis.spaceMin = 0//Y轴最大值百分比
        //xAxis.spaceBetweenLabels = 4//设置label间隔，若设置为1，则如果能全部显示，则每个柱形下面都会显示label
        xAxis.labelTextColor = UIColor.brown//label文字颜色
        
        //右边Y轴样式
        self.barChartView.rightAxis.enabled = false//不绘制右边轴
        
        //左边Y轴样式
        let leftAxis = self.barChartView.leftAxis//获取左边Y轴
        //leftAxis.labelCount = 5//Y轴label数量，数值不一定，如果forceLabelsEnabled等于YES, 则强制绘制制定数量的label, 但是可能不平均
        //leftAxis.setLabelCount(5, force: false)
        leftAxis.zeroLineWidth = 0//Y轴起始线
        //leftAxis.forceLabelsEnabled = true//不强制绘制制定数量的label
        //leftAxis.showOnlyMinMaxEnabled = false//是否只显示最大值和最小值
        leftAxis.axisMinimum = 0//设置Y轴的最小值
        //leftAxis.startAtZeroEnabled = true//从0开始绘制
        leftAxis.axisMaximum = 500//设置Y轴的最大值
        //leftAxis.zeroLineDashLengths = [2, 6, 9]
        //leftAxis.axisLineDashLengths = [2, 6, 9]//Y轴虚线样式
        leftAxis.inverted = false//是否将Y轴进行上下翻转
        leftAxis.axisLineColor = UIColor.black//Y轴颜色
        leftAxis.axisLineWidth = 0//Y轴宽度
        let formatter = NumberFormatter()//自定义格式
        formatter.positiveSuffix = " $"//数字后缀单位
        leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: formatter)
        leftAxis.labelPosition = .outsideChart//label位置
        leftAxis.labelTextColor = UIColor.brown//文字颜色
        leftAxis.labelFont = UIFont.systemFont(ofSize: 10)//文字字体
        //网格线样式
        leftAxis.gridLineDashLengths = [3, 3]//设置虚线样式的网格线
        leftAxis.gridLineWidth = 0//Y轴网格线宽度
        leftAxis.gridColor = UIColor.gray//网格线颜色
        leftAxis.gridAntialiasEnabled = true//开启抗锯齿
        
        //leftAxis.entries = [50, 100, 150, 200, 300, 500]
        
        
        let limitLine = ChartLimitLine(limit: 50, label: "限制线")
        limitLine.lineWidth = 1
        limitLine.lineColor = UIColor.green
        //limitLine.xOffset = -20
        limitLine.lineDashLengths = [5, 5]//虚线样式
        limitLine.labelPosition = .leftBottom//位置
        leftAxis.addLimitLine(limitLine)//添加到Y轴上
        leftAxis.drawLimitLinesBehindDataEnabled = false//设置限制线绘制在柱形图的后面
        
        //图例说明样式
        self.barChartView.legend.enabled = false//不显示图例说明
        self.barChartView.legend.direction = .leftToRight//位置
        
        //右下角的description文字样式
        self.barChartView.chartDescription?.text = ""//不显示，就设为空字符串即可
        
        self.data = self.setData()
        
        //为柱形图提供数据
        self.barChartView.data = self.data
        
        //设置动画效果，可以设置X轴和Y轴的动画效果
        self.barChartView.animate(xAxisDuration: 1)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissBarChartVC() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setData() -> BarChartData {
        
        let xValsCount = 1440//X轴上要显示多少条数据
        let maxYValue: UInt32 = 500//Y轴的最大值
        
        //X轴上面需要显示的数据
        var xValues: [String] = []
        
        //对应Y轴上面需要显示的数据
        var yValues: [BarChartDataEntry] = []
        
        for i in 0 ... xValsCount {
            let value = arc4random_uniform(maxYValue + 1)
            let entry = BarChartDataEntry(x: Double(i), y: Double(value))
            yValues.append(entry)
            xValues.append("\(i + 1)月")
        }
        
        self.barChartView.xAxis.valueFormatter = XValsFormatter(xVals: xValues)
        self.barChartView.xAxis.axisMinimum = Double(0)
        self.barChartView.xAxis.axisMaximum = Double(xValues.count - 1)
        
        //创建BarChartDataSet对象，其中包含有Y轴数据信息，以及可以设置柱形样式
        let chSet = BarChartDataSet(values: yValues, label: "中国")
        //chSet.barSpace = 0.2//柱形之间的间隙占整个柱形(柱形+间隙)的比例
        chSet.drawValuesEnabled = false//是否在柱形图上面显示数值
        chSet.highlightEnabled = false//点击选中柱形图是否有高亮效果，（双击空白处取消选中）
        //chSet.barBorderWidth = 1//柱形图描边宽度
        chSet.barBorderColor = UIColor.clear
        //chSet.formLineWidth = 0
        chSet.setColors(ChartColorTemplates.material(), alpha: 1)//设置柱形图颜色
        //将BarChartDataSet对象放入数组中
        let data = BarChartData(dataSet: chSet)
        //BarChartData *data = [[BarChartData alloc] initWithXVals:xVals dataSets:dataSets];
        data.setValueFont(NSUIFont(name: "HelveticaNeue-Light", size: 10))//文字字体
        data.setValueTextColor(NSUIColor.blue)//文字颜色
        let formatter = NumberFormatter()
        //自定义数据显示格式
        formatter.numberStyle = .decimal
        formatter.positiveFormat = "#0.0"
        data.setValueFormatter(DefaultValueFormatter(formatter: formatter))
        
        return data
        
    }
    
}

extension BarChartViewController: ChartViewDelegate {
    
    //点击选中柱形时回调
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        
    }
    
    //没有选中柱形图时回调，当选中一个柱形图后，在空白处双击，就可以取消选择，此时会回调此方法
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        
    }
    
    //放大图表时回调
    func chartScaled(_ chartView: ChartViewBase, scaleX: CGFloat, scaleY: CGFloat) {
        
    }
    
    //拖拽图表时回调
    func chartTranslated(_ chartView: ChartViewBase, dX: CGFloat, dY: CGFloat) {
        
    }
    
}
