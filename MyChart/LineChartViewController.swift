//
//  LineChartViewController.swift
//  MyChart
//
//  Created by 田子瑶 on 16/12/23.
//  Copyright © 2016年 田子瑶. All rights reserved.
//

import UIKit
import SnapKit
import Charts

class LineChartViewController: UIViewController {

    var lineChartView: LineChartView!
    var data: LineChartData!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        
        let titleLabel = UILabel()
        titleLabel.text = "Line Chart"
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
        displayButton.addTarget(self, action: #selector(self.dismissLineChartVC), for: .touchUpInside)
        self.view.addSubview(displayButton)
        displayButton.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 200, height: 50))
            make.centerX.equalTo(self.view.snp.centerX)
            make.bottom.equalTo(self.view.snp.bottom)
        }
        
        lineChartView = LineChartView()
        lineChartView.delegate = self
        self.view.addSubview(lineChartView)
        lineChartView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.top.equalTo(titleLabel.snp.bottom)
            make.bottom.equalTo(displayButton.snp.top)
        }
        
        //基本样式
        self.lineChartView.backgroundColor = UIColor.white
        self.lineChartView.noDataText = "暂无数据"//没有数据时的文字提示
        
        //交互设置
        self.lineChartView.scaleYEnabled = false//Y轴缩放
        self.lineChartView.doubleTapToZoomEnabled = false//双击缩放
        self.lineChartView.dragEnabled = true//启用拖拽图表
        //self.lineChartView.zoom(scaleX: 30, scaleY: 0, x: 0, y: 0)//缩放等级
        self.lineChartView.dragDecelerationEnabled = true//拖拽后是否有惯性效果
        self.lineChartView.dragDecelerationFrictionCoef = 0.9//拖拽后惯性效果的摩擦系数(0~1)，数值越小，惯性越不明显
        
        //X轴样式
        let xAxis = self.lineChartView.xAxis
        xAxis.axisLineWidth = 1//设置X轴线宽
        xAxis.labelPosition = .bottom//X轴的显示位置，默认是显示在上面的
        xAxis.drawGridLinesEnabled = false//不绘制网格线
        //xAxis.spaceMax = 0//X轴最小值百分比
        //xAxis.spaceMin = 0//Y轴最大值百分比
        //xAxis.spaceBetweenLabels = 4//设置label间隔，若设置为1，则如果能全部显示，则每个柱形下面都会显示label
        xAxis.labelTextColor = UIColor.brown//label文字颜色
        
        //右边Y轴样式
        self.lineChartView.rightAxis.enabled = false//不绘制右边轴
        
        //左边Y轴样式
        let leftAxis = self.lineChartView.leftAxis//获取左边Y轴
        leftAxis.labelCount = 5//Y轴label数量，数值不一定，如果forceLabelsEnabled等于YES, 则强制绘制制定数量的label, 但是可能不平均
        //leftAxis.setLabelCount(5, force: false)
        leftAxis.zeroLineWidth = 0//Y轴起始线
        leftAxis.forceLabelsEnabled = true//不强制绘制制定数量的label
        //leftAxis.showOnlyMinMaxEnabled = false//是否只显示最大值和最小值
        leftAxis.axisMinimum = 0//设置Y轴的最小值
        //leftAxis.startAtZeroEnabled = true//从0开始绘制
        leftAxis.axisMaximum = 105//设置Y轴的最大值
        //leftAxis.zeroLineDashLengths = [2, 6, 9]
        //leftAxis.axisLineDashLengths = [2, 6, 9]//Y轴虚线样式
        leftAxis.inverted = false//是否将Y轴进行上下翻转
        leftAxis.axisLineColor = UIColor.black//Y轴颜色
        //leftAxis.axisLineWidth = 0//Y轴宽度
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
        
        //添加限制线
        let limitLine = ChartLimitLine(limit: 80, label: "限制线")
        limitLine.lineWidth = 1
        limitLine.lineColor = UIColor.green
        //limitLine.xOffset = -20
        limitLine.lineDashLengths = [5, 5]//虚线样式
        limitLine.labelPosition = .leftBottom//位置
        leftAxis.addLimitLine(limitLine)//添加到Y轴上
        leftAxis.drawLimitLinesBehindDataEnabled = false//设置限制线绘制在柱形图的后面
        
        //描述及图例样式
        self.lineChartView.chartDescription?.text = "折线图"//不显示，就设为空字符串即可
        self.lineChartView.chartDescription?.textColor = UIColor.darkGray
        self.lineChartView.legend.form = .line
        self.lineChartView.legend.formSize = 30
        self.lineChartView.legend.textColor = UIColor.darkGray
        self.lineChartView.legend.direction = .leftToRight//位置
        
        self.data = self.setData()
        
        //为柱形图提供数据
        self.lineChartView.data = self.data
        
        //设置动画效果，可以设置X轴和Y轴的动画效果
        self.lineChartView.animate(xAxisDuration: 1)
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissLineChartVC() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setData() -> LineChartData {
        
        let xValsCount = 12//X轴上要显示多少条数据
        let maxYValue: UInt32 = 100//Y轴的最大值
        
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
        
        self.lineChartView.xAxis.valueFormatter = XValsFormatter(xVals: xValues)
        self.lineChartView.xAxis.axisMinimum = Double(0)
        self.lineChartView.xAxis.axisMaximum = Double(xValues.count - 1)
        
        //创建BarChartDataSet对象，其中包含有Y轴数据信息，以及可以设置柱形样式
        let chSet = LineChartDataSet(values: yValues, label: "中国")
        
        //设置折线的样式
        chSet.lineWidth = 1//折线宽度
        chSet.drawValuesEnabled = true//是否在拐点处显示数据
        chSet.valueColors = [UIColor.brown]//折线拐点处显示数据的颜色
        chSet.setColor(UIColor.brown)//折线颜色
        chSet.mode = .linear//设定折线图的样式
        //折线拐点样式
        chSet.drawCirclesEnabled = true//是否绘制拐点
        chSet.circleRadius = 4//拐点半径
        chSet.circleColors = [UIColor.red, UIColor.blue]//拐点颜色
        //拐点中间的空心样式
        chSet.drawCircleHoleEnabled = true//是否绘制中间的空心
        chSet.circleHoleRadius = 2//空心的半径
        chSet.circleHoleColor = UIColor.black//空心的颜色
        //折线的颜色填充样式
        //第一种填充样式:单色填充
        //chSet.drawFilledEnabled = true//是否填充颜色
        //chSet.fillColor = UIColor.red//填充颜色
        //chSet.fillAlpha = 0.3//填充颜色的透明度
        //第二种填充样式:渐变填充
        //chSet.drawFilledEnabled = true//是否填充颜色
        //let gradientColors = [UIColor.purple.cgColor, UIColor.red.cgColor]
        //let gradientRef = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)
        //chSet.fillAlpha = 0.3//透明度
        //chSet.fill = Fill.init(linearGradient: gradientRef!, angle: 90)//赋值填充颜色对象
        
        //点击选中拐点的交互样式
        chSet.highlightEnabled = true//选中拐点,是否开启高亮效果(显示十字线)
        chSet.highlightColor = UIColor.darkGray//点击选中拐点的十字线的颜色
        chSet.highlightLineWidth = 1 / UIScreen.main.scale//十字线宽度
        chSet.highlightLineDashLengths = [5, 5]//十字线的虚线样式
        
        //添加第二个LineChartDataSet对象
        let usSet = LineChartDataSet(values: yValues.sorted(by: {$0.x < $1.x}), label: "美国")
        usSet.setColor(UIColor.blue)
        //usSet.drawFilledEnabled = true//是否填充颜色
        //usSet.fillColor = UIColor.blue//填充颜色
        //usSet.fillAlpha = 0.1//填充颜色的透明度
        
        //创建LineChartData对象, 此对象就是lineChartView需要最终数据对象
        let data = LineChartData(dataSets: [chSet, usSet])
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

extension LineChartViewController: ChartViewDelegate {
    
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
