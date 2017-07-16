//
//  ViewController.swift
//  SmartCameraLBTA
//
//  Created by Victor Lee on 16/7/17.
//  Copyright © 2017 VictorLee. All rights reserved.
//

import UIKit
import AVKit
import Vision

class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let captureSession = AVCaptureSession()
        captureSession.sessionPreset = .photo // give it a more cropped look.  Not compulsory.
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        
        // AVCaptureDeviceInput may throw error if device has no camera so use try? if don't want to use Do Try Catch let
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else { return }
        captureSession.addInput(input)
        captureSession.startRunning()
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        view.layer.addSublayer(previewLayer)
        // Add Frame
        previewLayer.frame = view.frame
        
        // Instantiate dataOutput and conform to AVCaptureVideoOutputSampleBufferDelegate
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        captureSession.addOutput(dataOutput)
        
    }
    
    // Implement didOutput method that runs everytime the camera captures a frame and renders it inside the previewLayer
    // First import the SqueezeNet model before accessing the VNCoreMLModel and parsing into the request
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        //        print("Camera was able to capture a frame", Date())
        
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        guard let model = try? VNCoreMLModel(for: SqueezeNet().model) else { return }
        let request = VNCoreMLRequest(model: model) { (finishedRequest, error) in
            if let error = error {
                print("Failed to request", error)
                return
            }
            print(finishedRequest.results as Any)
            
            guard let results = finishedRequest.results as? [VNClassificationObservation] else { return }
            guard let firstObservation = results.first else { return }
            
            print(firstObservation.identifier, firstObservation.confidence)
        }
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
        
        
    }
    
}

