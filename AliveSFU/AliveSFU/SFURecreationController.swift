//
//  SFURecreationController.swift
//  AliveSFU
//
//  Created by Gur Kohli on 2016-10-26.
//  Developers: Vivek Sharma
//  Copyright © 2016 SimonDevs. All rights reserved.
//

import UIKit
import JBChart

class SFURecreationController: UIViewController, JBBarChartViewDelegate, JBBarChartViewDataSource {
    
    
/* Variables */
    
    var currDay : DaysInAWeek = DaysInAWeek.Sunday
    var chartLegend = ["Sun", "Mon", "Tues", "Wed", "Thurs", "Fri", "Sat"] //x-axis information
/***********************Enter actual gym traffic data here***********************************/
//////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////
    var chartData = [5, 8, 6, 2, 9, 6, 4]//sample data to display bar graph, replace with actual exercise completion numbers
//////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////
/********************************************************************************************/
    let SFURed = UIColor(red: 166, green: 25, blue: 46)
    let SFUGrey = UIColor(red: 84, green: 88, blue: 90)

    
    
    @IBOutlet weak var barChart: JBBarChartView!
    @IBOutlet weak var todayHours: UILabel!
    @IBOutlet weak var overlayHours: UIView!
    @IBOutlet weak var todayHourView: UIView!
    @IBOutlet weak var overlayHeight: NSLayoutConstraint!
    
    var isOverlayOpen = false
    var isAnimating = false
    
    let HEIGHT_OF_OVERLAY:CGFloat = 180
    
    override func viewDidLoad() {
        super.viewDidLoad()
	
	let tapGesture = UITapGestureRecognizer(target: self, action: #selector (todayHoursAction(_:)))
        todayHourView.addGestureRecognizer(tapGesture)
        todayHourView.isUserInteractionEnabled = true
        
        overlayHeight.constant = 0
        isOverlayOpen = false
	
        setupBarChart()
        barChartView(barChart, didSelectBarAt: UInt(currDay.index - 1))
        
        let borderColor = UIColor.init(red: 238, green: 238, blue: 238).cgColor
        barChart.layer.borderColor = borderColor

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        barChart.reloadData()
        _ = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(MyProgressController.showChart), userInfo: nil, repeats: false)

    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupBarChart()
    {
        barChart.backgroundColor = UIColor.white
        barChart.delegate = self
        barChart.dataSource = self
        barChart.minimumValue = 0
        barChart.maximumValue = CGFloat(chartData.max()!) //Max value of a bar in the graph is the max value from the data array.
        //The height of each bar is relative to this value
        
        //NOTE: footer and header created below reduce size/space of the actual bar graph.
        
        //Creating a footer with appropriate Day labels. Spacing is hard coded unfortunately
        let footer = UILabel(frame: CGRect(x: 0, y: 0, width: barChart.frame.width, height: 16))
        footer.textColor = UIColor.black
        footer.text = "\(chartLegend[0])     \(chartLegend[1])    \(chartLegend[2])    \(chartLegend[3])   \(chartLegend[4])   \(chartLegend[5])       \(chartLegend[6])"
        footer.textAlignment = NSTextAlignment.left
        
        //Creating a header.
        let header = UILabel(frame: CGRect(x: 0, y: 0, width: barChart.frame.width, height: 16))
        header.textColor = UIColor.black
        header.text = "Gym Traffic"
        header.textAlignment = NSTextAlignment.center
        
        barChart.footerView = footer
        barChart.headerView = header
        barChart.reloadData()
        barChart.setState(.collapsed, animated: false)
    }
    
    func hideChart() {
        barChart.setState(.collapsed, animated: true)
    }
    
    func showChart() {
        barChart.setState(.expanded, animated: true)
    }
    
    
    func numberOfBars(in barChartView: JBBarChartView!) -> UInt {
        return UInt(chartData.count)
    }
    
    func barChartView(_ barChartView: JBBarChartView!, heightForBarViewAt index: UInt) -> CGFloat {
        return CGFloat(chartData[Int(index)])
    }
    
    func barChartView(_ barChartView: JBBarChartView!, colorForBarViewAt index: UInt) -> UIColor! {
        return SFURed
        
    }
    
    func barChartView(_ barChartView: JBBarChartView!, didSelectBarAt index: UInt) {
        let data = chartData[Int(index)]
        let key = chartLegend[Int(index)]
        
        //informationLabel.text = "People at the gym on \(key): \(data)"
        //Maybe change the bar graphs to a percentage, so that if all workouts are completed on that day, the bar is a maximum height.
    }
    func updateChartData() {
        //chartData = //enter logic to obtain chart data here
        barChart.reloadData()
    }

    func todayHoursAction(_ recognizer: UITapGestureRecognizer) {
        if (!isOverlayOpen) {
            //Open overlay
            var frame = overlayHours.frame
            frame.size.height = HEIGHT_OF_OVERLAY
            if (!isAnimating) {
                isAnimating = true
                UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {self.overlayHours.frame = frame}, completion: {(completed: Bool) -> Void in
                    self.isAnimating = false
                    self.isOverlayOpen = true
                })
            }
        } else {
            var frame = overlayHours.frame
            frame.size.height = 0
            if (!isAnimating) {
                isAnimating = true
                
                UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {self.overlayHours.frame = frame}, completion: {(completed: Bool) -> Void in
                    self.isAnimating = false
                    self.isOverlayOpen = false
                })
            }
        }
    }
}

