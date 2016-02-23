//
//  ViewController.swift
//  BrightnessDemo
//
//  Created by Christian Otkjær on 22/02/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import UIKit
import Brightness
import Interpolation
import Animation
import Random

class ViewController: UIViewController {

    @IBOutlet weak var brightnessSlider: UISlider!
    
    @IBOutlet weak var animateButton: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    
        brightnessSlider.value = Float(UIScreen.mainScreen().brightness)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func handleBrightnessSlider(sender: UISlider)
    {
        animateButton.enabled = Float(UIScreen.mainScreen().brightness) != sender.value

        UIScreen.mainScreen().brightness = CGFloat(sender.value)
    }

    @IBAction func animateToSlider()
    {
        animateButton.enabled = false
        
        let oldBrightness = UIScreen.mainScreen().brightness
        let newBrightness = CGFloat.random(between: 0, and: 1)
        
        let timing = TimingFunction.SineEaseInOut
        let duration = Double(1)
        
        let valueBefore = brightnessSlider.value
        
        Animator.animate(duration,
            delay: 0,
            timingFunction: timing,
            closure: { (t) -> () in

                self.brightnessSlider.value = (valueBefore, Float(newBrightness)) ◊ Float(t)
                
                UIScreen.mainScreen().brightness = (oldBrightness, newBrightness) ◊ CGFloat(t)
                
            }) { completed in
                self.animateButton.enabled = true
        }
    }
}

