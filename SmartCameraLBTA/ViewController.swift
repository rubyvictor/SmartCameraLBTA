//
//  ViewController.swift
//  SmartCameraLBTA
//
//  Created by Victor Lee on 16/7/17.
//  Copyright © 2017 VictorLee. All rights reserved.
//

import UIKit
import AVKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let captureSession = AVCaptureSession()
        
        
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        
        // AVCaptureDeviceInput may throw error if device has no camera so use try? if don't want to use Do Try Catch let
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else { return }
        
        captureSession.addInput(input)
        
        captureSession.startRunning()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

