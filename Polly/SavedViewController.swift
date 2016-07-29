//
//  SavedViewController.swift
//  Polly
//
//  Created by Nikki Fernandez on 28/07/2016.
//  Copyright © 2016 SourcePad. All rights reserved.
//

import UIKit

class SavedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var savedPollys: NSArray = []
    
    // MARK: - Lazy variables
    private lazy var tableView: UITableView = {
        let tableView: UITableView = UITableView(frame: CGRectMake(0.0, 0.0, self.view.bounds.width, self.view.bounds.height - 60.0))
        tableView.delegate = self
        tableView.dataSource = self
        
        let footerView = UIView(frame: CGRectZero)
        tableView.tableFooterView = footerView
       
        let headerView = UIView(frame:  CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*0.05))
        headerView.backgroundColor = UIColor.clearColor()
        tableView.tableHeaderView = headerView
        return tableView
    }()
    
    private lazy var dfMMddyyyy: NSDateFormatter = {
        let df: NSDateFormatter = NSDateFormatter()
        df.dateFormat = "MM/dd/yyyy"
        
        return df
    }()
    
    private lazy var dfMMMd: NSDateFormatter = {
        let df: NSDateFormatter = NSDateFormatter()
        df.dateFormat = "MMM d"
        
        return df
    }()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        
        savedPollys = samplePollyData
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Private Methods
    func configureView() {
        self.title = "Saved"
        self.view.backgroundColor = UIColor.whiteColor()
        self.automaticallyAdjustsScrollViewInsets = false
        self.edgesForExtendedLayout = .None
        
        self.view.addSubview(tableView)
    }

    // MARK: - Table View
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedPollys.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell.init(style: .Value1, reuseIdentifier: "savedCell")
        cell.textLabel?.font = CustomFont(FONT_TITLE, fontSize: 13.0)
        cell.textLabel?.textColor = UIColor.blackColor()
        cell.detailTextLabel?.font = CustomFont(FONT_DEFAULT, fontSize: 11.0)
        cell.detailTextLabel?.textColor = UIColor.lightGrayColor()

        let savedPolly = savedPollys.objectAtIndex(indexPath.row)
        cell.textLabel?.text = savedPolly["title"] as? String
        let date = dfMMddyyyy.dateFromString((savedPolly["date"] as? String)!)
        cell.detailTextLabel?.text = dfMMMd.stringFromDate(date!)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    // MARK: - Sample Data
    private lazy var samplePollyData: NSArray = {
        var sampleArray: NSArray = []
        
        let hoodoc = ["title": "Hoodoc Meeting",
                      "date": "07/22/2016",
                      "url": "http://wwww.google.com"]
        let scrum = ["title": "Scrum June 10",
                     "date": "06/10/2016",
                     "url": "http://www.facebook.com"]
        
        sampleArray = [hoodoc, scrum]
        return sampleArray
    }()
    
}

