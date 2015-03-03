//
//  ViewController.swift
//  Stormy
//
//  Created by Nick on 10/31/14.
//  Copyright (c) 2014 Nick. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var precipitationLabel: UILabel!
    @IBOutlet weak var SummaryLabel: UILabel!
    
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var refreshActivityIndicator: UIActivityIndicatorView!

    private let apiKey = "b5fc64ec0fd771c2e1a100a9e8bb1f18"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        getCurrentWeatherData()
        
        refreshActivityIndicator.hidden = true
        
    }
    
    func getCurrentWeatherData() -> Void{
        
        let baseURL = NSURL(string: "https://api.forecast.io/forecast/\(apiKey)/")
        let forecastURL = NSURL(string: "40.713959,-74.002036", relativeToURL: baseURL?)
        //let weatherData = NSData.dataWithContentsOfURL(forecastURL!, options: nil, error: nil)
        //let weatherData = NSData(contentsOfURL: forecastURL!, options: nil, error:nil)
        //println(weatherData)
        let sharedSession = NSURLSession.sharedSession()
        let downloadTask: NSURLSessionDownloadTask = sharedSession.downloadTaskWithURL(forecastURL!, completionHandler: { (location: NSURL!, response :NSURLResponse!, error: NSError!) -> Void in
            
            //var urlContents = NSString(contentsOfURL: location, encoding: NSUTF8StringEncoding, error: nil)
            //println(urlContents)
            
            if (error == nil){
                let dataObject = NSData(contentsOfURL: location)
                let weatherDictionary = NSJSONSerialization.JSONObjectWithData(dataObject!, options: nil, error: nil) as NSDictionary
                
                let currentWeather = Current(weatherDictionary: weatherDictionary)
                //println(currentWeather.currentTime!)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.temperatureLabel.text = "\(currentWeather.temperature)"
                    self.iconView.image = currentWeather.icon!
                    self.currentTimeLabel.text = "At \(currentWeather.currentTime!) it is"
                    self.humidityLabel.text = "\(currentWeather.humidity)"
                    self.precipitationLabel.text = "\(currentWeather.precipProbability)"
                    self.SummaryLabel.text = "\(currentWeather.summamry)"
                    
                    //stop refresh
                    self.refreshActivityIndicator.stopAnimating()
                    self.refreshActivityIndicator.hidden = true
                    self.refreshButton.hidden = false
                })
                
            } else {
                let networkIssueController = UIAlertController(title: "Error", message: "Unabel to load data", preferredStyle: .Alert)
                let okButton = UIAlertAction(title: "OK", style: .Default, handler: nil)
                let cancelButton = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
                networkIssueController.addAction(cancelButton)
                self.presentViewController(networkIssueController, animated: true, completion: nil)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.refreshActivityIndicator.stopAnimating()
                    self.refreshActivityIndicator.hidden = true
                    self.refreshButton.hidden = false
                })
            }
            
        })
        downloadTask.resume()
    }
    
    @IBAction func refresh() {
        refreshButton.hidden = true
        refreshActivityIndicator.hidden = false
        refreshActivityIndicator.startAnimating()
        getCurrentWeatherData()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

