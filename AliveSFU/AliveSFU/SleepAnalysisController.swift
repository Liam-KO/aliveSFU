
//
//  SleepAnalysisController.swift
//  AliveSFU
//
//  Created by Gur Kohli on 2016-10-26.
//  Developers: Vivek Sharma
//  Copyright © 2016 SimonDevs. All rights reserved.
//

import UIKit
import JBChart
import HealthKit

class SleepAnalysisController: UIViewController, JBBarChartViewDelegate, JBBarChartViewDataSource {
    
    
    //@IBOutlet weak var infoLabel: UILabel! //this label would be used to display hours of the bar that is touched

    @IBOutlet weak var barChart: JBBarChartView!
    @IBOutlet weak var hoursInBed: UILabel!
    @IBOutlet weak var hoursSlept: UILabel!
    @IBOutlet weak var percentageSpentSleeping: UILabel!
    @IBOutlet weak var timesWokenUp: UILabel!
    @IBOutlet weak var timeTakenToSleep: UILabel!
    @IBOutlet weak var graphView: JBBarChartView!
    @IBOutlet weak var labelView: UIView!
    @IBOutlet weak var asleepUnavailableWarning: UILabel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var errorView: UIView!
    
    
    /* Variables */
    
    var isDataLoaded = false
    var currDay : DaysInAWeek = DaysInAWeek.Sunday
    var panTileOrigin = CGPoint(x: 0, y: 0)
    var chartLegend = ["Sun", "Mon", "Tues", "Wed", "Thurs", "Fri", "Sat"] //x-axis information
    var chartData = DataHandler.getSleepAnalysisData()

    let SFURed = UIColor(red: 166, green: 25, blue: 46)
    let SFUGrey = UIColor(red: 84, green: 88, blue: 90)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let borderColor = UIColor.init(red: 238, green: 238, blue: 238).cgColor
        graphView.layer.borderColor = borderColor
        labelView.layer.borderColor = borderColor
        errorView.layer.borderColor = borderColor
        setupBarChart()
        barChartView(barChart, didSelectBarAt: UInt(currDay.index - 1))
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        barChart.reloadData()
        _ = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(MyProgressController.showChart), userInfo: nil, repeats: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        self.errorView.isHidden = true
        
        if (!isDataLoaded) {
            //Load data
            retrieveSleepAnalysis()
        }
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
        footer.text = " \(chartLegend[0])     \(chartLegend[1])      \(chartLegend[2])     \(chartLegend[3])     \(chartLegend[4])     \(chartLegend[5])       \(chartLegend[6])"
        footer.textAlignment = NSTextAlignment.left
        
        //Creating a header.
        let header = UILabel(frame: CGRect(x: 0, y: 0, width: barChart.frame.width, height: 16))
        header.textColor = UIColor.black
        header.text = "Sleep History"
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
        
        //Uncomment below if implementing a label to display hours slept when a bar is touched
        //infoLabel.text = "Workouts completed on \(key): \(data)"
        //Maybe change the bar graphs to a percentage, so that if all workouts are completed on that day, the bar is a maximum height.
    }
    func updateChartData() {
        chartData = DataHandler.getSleepAnalysisData()
        
        /*******Makes sure the bars for future days in the week are not displayed****/
        let calendar = NSCalendar.current
        var comps = calendar.dateComponents([.weekday], from: Date())
        print(comps.weekday!)
        if(comps.weekday! != 7){
            for index in (comps.weekday!+1)...7{
                chartData[index-1] = 0
            }
        }
        
        barChart.reloadData()
    }
    
    
    func retrieveSleepAnalysis() {
        let date = Date()
        let formattedDate = DateFormatter()
        formattedDate.timeStyle = .none
        formattedDate.dateStyle = .long
        let dateString = formattedDate.string(from: date)
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.component(.weekday, from: date)
        let dayOfWeek = components
        
        let healthStore = HKHealthStore()
        
        // first, we define the object type we want
        if let sleepType = HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepAnalysis) {
            
            // Use a sortDescriptor to get the recent data first
            let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
            
            // we create our query with a block completion to execute
            let query = HKSampleQuery(sampleType: sleepType, predicate: nil, limit: 50, sortDescriptors: [sortDescriptor], resultsHandler: {(query, tmpResult, error) -> Void in
                
                if error != nil {
                    
                    // something happened
                    return
                    
                }
                
                DispatchQueue.main.async {
                    if let result = tmpResult {
                        
                        if result.count > 0 {
                            // do something with my data
                            var maxEndDateBed = date
                            var minStartDateBed = date
                            if let firstSample = result.first as? HKCategorySample {
                                maxEndDateBed = firstSample.endDate
                                minStartDateBed = firstSample.startDate
                            }
                            var minStartDateAsleep = minStartDateBed
                            var maxEndDateAsleep = maxEndDateBed
                            var isAsleepDataAvailable = false
                            
                            let THRESHOLD_FOR_VALID_TIME = Double(5/60) //5 minutes = 5/60 hours
                            var noOfValidSamples = 0
                            var lastValidStartDate = minStartDateBed
                            
                            for item in result {
                                if let sample = item as? HKCategorySample {
                                    let endDate = formattedDate.string(from: sample.endDate)
                                    if (endDate == dateString) {
                                        
                                        minStartDateBed = minStartDateBed.compare(sample.startDate) == ComparisonResult.orderedDescending ? sample.startDate : minStartDateBed
                                        
                                        if (lastValidStartDate.timeIntervalSince(sample.endDate) >= THRESHOLD_FOR_VALID_TIME) {
                                            lastValidStartDate = sample.startDate
                                            noOfValidSamples += 1
                                        }
                                        
                                        if (sample.value == HKCategoryValueSleepAnalysis.asleep.rawValue) {
                                            isAsleepDataAvailable = true
                                            // If it's the first asleep sample
                                            minStartDateAsleep = minStartDateAsleep == minStartDateBed ? sample.startDate : minStartDateAsleep
                                            maxEndDateAsleep = maxEndDateAsleep == maxEndDateBed ? sample.endDate : maxEndDateBed
                                            
                                            // For every other asleep sample
                                            minStartDateAsleep = minStartDateAsleep.compare(sample.startDate) == ComparisonResult.orderedDescending ? sample.startDate : minStartDateAsleep
                                            maxEndDateAsleep = maxEndDateAsleep.compare(sample.endDate) == ComparisonResult.orderedAscending ? maxEndDateAsleep : maxEndDateAsleep
                                            
                                        }
                                    }
                                }
                            }
                            
                            let totalHoursInBed = maxEndDateBed.timeIntervalSince(minStartDateBed) / 3600
                            let totalHoursAsleep = maxEndDateAsleep.timeIntervalSince(minStartDateAsleep) / 3600
                            let percentageOfTimeSlept = (totalHoursAsleep / totalHoursInBed) * 100
                            let noOfTimesWokenUp = noOfValidSamples
                            let timeTakenToFallAsleep = minStartDateAsleep.timeIntervalSince(minStartDateBed) / 60
                            
                            if (!isAsleepDataAvailable) {
                                // Asleep data not available. Let user know
                                self.asleepUnavailableWarning.isHidden = false
                            }
                            
                            self.hoursInBed.text = String(format: "%.1f", totalHoursInBed)
                            self.hoursSlept.text = String(format: "%.1f", totalHoursAsleep)
                            self.percentageSpentSleeping.text = String(format: "%.1f",percentageOfTimeSlept) + "%"
                            self.timeTakenToSleep.text = String(format: "%.1f", timeTakenToFallAsleep) + " min"
                            self.timesWokenUp.text = String(noOfTimesWokenUp)
                            
                            // Saving total hours slept for graph
                            DataHandler.setSleepAnalysisDataForDay(day: dayOfWeek, value: totalHoursAsleep)
                            self.updateChartData()
                            
                            self.view.layoutSubviews()
                            self.activityIndicator.stopAnimating()
                            self.mainView.alpha = 1
                            self.isDataLoaded = true
                        } else {
                            self.activityIndicator.stopAnimating()
                            self.errorView.isHidden = false
                        }
                    }
                }
            })
            
            // finally, we execute our query
            self.activityIndicator.startAnimating()
            self.mainView.alpha = 0.2
            healthStore.execute(query)
        }
    }
    
}

