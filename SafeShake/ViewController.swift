//
//  ViewController.swift
//  SafeShake
//
//  Created by Olivia Corrodi on 3/7/20.
//  Copyright © 2020 Olivia Corrodi. All rights reserved.
//

import UIKit
import CoreMotion
import AVFoundation

class ViewController: UIViewController {
    
    let motion = CMMotionManager()
    
    var timer: Timer?
    
    var actionType: action = .kiss
    
    @IBOutlet var image: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        if (UIDevice.current.orientation == .portrait) {
            image.image = UIImage(named: "Lips_Emoji_grande.png")
        }
        else {
            image.image = UIImage(named: "raised-hand.png")
        }
        // Do any additional setup after loading the view.
        image.image = generateQRCode(from: "Hacking with Swift is the best iOS coding tutorial I've ever read!")
    }
    
    func shake() {
        image.image = UIImage(named: "handshake.png")
        UIDevice.vibrate()
    }
    
    func kiss() {
        image.image = UIImage(named: "Lips_Emoji_grande.png")
        var soundEffect : AVAudioPlayer
        let path = Bundle.main.path(forResource: "kiss.mp3", ofType:nil)!
        let url = URL(fileURLWithPath: path)

        do {
            soundEffect = try AVAudioPlayer(contentsOf: url)
            soundEffect.play()
        } catch {
            // couldn't load file :(
        }
    }
    
    override func becomeFirstResponder() -> Bool {
        return true
    }

    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?){
        if motion == .motionShake {
            shake()
            //show some alert here
        }
    }
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        //var text=""
        switch UIDevice.current.orientation{
        case .portrait:
            self.actionType = .kiss
        case .portraitUpsideDown:
            self.actionType = .kiss
        case .landscapeLeft:
            self.actionType = .shake
        case .landscapeRight:
            self.actionType = .shake
        default:
            self.actionType = .shake
        }
        changeImage(newAction: self.actionType)
        //NSLog("You have moved: \(text)")
    }
    
    func changeImage (newAction : action) {
        if (newAction == .kiss) {
            image.image = UIImage(named: "Lips_Emoji_grande.png")
        }
        else {
            image.image = UIImage(named: "raised-hand.png")
        }
    }
    
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)

        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)

            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }

        return nil
    }

    
    /*func startGyros() {
       if motion.isGyroAvailable {
          self.motion.gyroUpdateInterval = 1.0 / 60.0
          self.motion.startGyroUpdates()

          // Configure a timer to fetch the accelerometer data.
          self.timer = Timer(fire: Date(), interval: (1.0/60.0),
                 repeats: true, block: { (timer) in
             // Get the gyro data.
             if let data = self.motion.gyroData {
                let x = data.rotationRate.x
                let y = data.rotationRate.y
                let z = data.rotationRate.z
                print("x \(x)")
                print("y \(y)")
                print("z \(z)")
                

                // Use the gyroscope data in your app.
             }
          })
          RunLoop.current.add(timer!, forMode: RunLoop.Mode.default)
          // Add the timer to the current run loop.
          //RunLoop.current.add(self.timer!, forMode: .RunLoop.Mode.default)
       }
    }

    func stopGyros() {
       if self.timer != nil {
        self.timer!.invalidate()
          self.timer = nil

          self.motion.stopGyroUpdates()
       }
    }*/


}
extension UIDevice {
    static func vibrate() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
}

enum action {
    case shake
    case kiss
}

