//
//  PollyViewController.swift
//  Polly
//
//  Created by Nikki Fernandez on 28/07/2016.
//  Copyright © 2016 SourcePad. All rights reserved.
//

import UIKit
import AVFoundation

class PollyViewController: UIViewController, AVAudioRecorderDelegate {

    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    
    private lazy var startButton: UIButton = {
        let button: UIButton = UIButton(frame: CGRectMake(0.0, 0.0, 180.0, 30.0))
        button.center = CGPointMake(self.view.center.x, self.view.center.y-80.0)
        button.backgroundColor = COLOR_POLLY_GREEN
        button.setTitleColor(COLOR_POLLY_TEXT, forState: .Normal)
        button.setTitle("Start Recording", forState: .Normal)
        button.setTitle("Stop", forState: .Selected)
        button.setTitle("Recording not Allowed", forState: .Disabled)
        button.titleLabel?.font = UIFont.boldSystemFontOfSize(15.0)
        button.layer.cornerRadius = 10.0
        button.addTarget(self, action: #selector(PollyViewController.startButtonAction(_:)), forControlEvents:.TouchUpInside)
        return button
    }()
    
    private lazy var instructionLabel: UILabel = {
        let label: UILabel = UILabel(frame: CGRectMake(self.startButton.frame.origin.x-30, self.startButton.frame.origin.y - 100.0, 300.0, 80.0))
        label.textColor = COLOR_POLLY_TEXT
        label.textAlignment = .Left
        label.numberOfLines = 0
        label.text = "Hello there, ready to record and summarize your meeting for today?"
        label.font = UIFont.boldSystemFontOfSize(18.0)
        return label
    }()
    
    private lazy var recordingImageView: UIImageView = {
        let imageView : UIImageView = UIImageView(frame: self.instructionLabel.frame)
        imageView.image = UIImage(named: "recording")
        //imageView.contentMode = .ScaleAspectFit
        imageView.hidden = true
        return imageView
    }()
    
    private lazy var logoImageView: UIImageView = {
        let dimension : CGFloat = 70.0
        let imageView : UIImageView = UIImageView(frame: CGRectMake(self.instructionLabel.frame.origin.x-dimension, self.instructionLabel.frame.origin.y, dimension, dimension))
        imageView.image = UIImage(named: "logo")
        imageView.contentMode = .ScaleAspectFit
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "Polly"
        self.view.backgroundColor = UIColor.whiteColor()
        self.automaticallyAdjustsScrollViewInsets = false
        self.edgesForExtendedLayout = .None
        
        self.view.addSubview(self.startButton)
        self.view.addSubview(self.instructionLabel)
        self.view.addSubview(self.recordingImageView)
        self.view.addSubview(self.logoImageView)
        
        // Get permission to record
        recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] (allowed: Bool) -> Void in
                dispatch_async(dispatch_get_main_queue()) {
                    if !allowed {
                        // failed to record!
                        print("Failed to record")
                        self.startButton.enabled = false
                    }
                }
            }
        }
        catch {
            // failed to record!
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func startButtonAction(sender: AnyObject) {
        let selected = !self.startButton.selected
        
        self.startButton.selected = selected
        self.startButton.backgroundColor = selected ? COLOR_POLLY_PINK : COLOR_POLLY_GREEN
        self.recordingImageView.hidden = !selected
        
        if(selected) {
            self.startRecording()
        }
        else {
            self.endRecording()
        }
    }
    
    //MARK: Recording
    // Reference: https://www.hackingwithswift.com/example-code/media/how-to-record-audio-using-avaudiorecorder
    func startRecording()
    {
        print("Start recording")
        
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0]
        
        let audioFilename = documentsDirectory.stringByAppendingString("/recording.wav")
        let audioURL = NSURL(fileURLWithPath: audioFilename)
        
        print("Path: \(audioURL)")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatLinearPCM),
            AVSampleRateKey: 12000.0,
            AVNumberOfChannelsKey: 1 as NSNumber,
            AVEncoderAudioQualityKey: AVAudioQuality.High.rawValue
        ]
        do {
            audioRecorder = try AVAudioRecorder(URL: audioURL, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
        }
        catch {
        }
    }
    
    func endRecording()
    {
        print("End recording")
        
        audioRecorder.stop()
        audioRecorder = nil
        
        // Done recording!
        let alert = UIAlertController(title: "Save now?", message: "", preferredStyle: .Alert)
        let yesAction = UIAlertAction(title: "Yes", style: .Default, handler: { (alert) -> Void in
            let vc : PollyTitleViewController = PollyTitleViewController()
            vc.audioUrl = self.audioRecorder.url
            self.navigationController?.pushViewController(vc, animated: true)
        })
        let noAction = UIAlertAction(title: "No", style: .Cancel, handler: { (alert) -> Void in
        })
        alert.addAction(yesAction)
        alert.addAction(noAction)
        self.presentViewController(alert, animated: false, completion: nil)
    }
    
    //MARK: AVAudioRecorderDelegate
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool)
    {
        if !flag {
            print("Recording finished!")
        }
    }
}

