//
//  Brightness.swift
//  Brightness
//
//  Created by Christian Otkjær on 18/02/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import Foundation
import Animation
import Interpolation

// MARK: - Brightness

public extension UIScreen
{
    func setBrightness(brightness: CGFloat,
        duration:Double = 1,
        timingFunction: TimingFunction = .QuadraticEaseInOut,
        completion: (Bool -> ())? = nil)
    {
        let brightnessBefore = self.brightness
        
        Animator.animate(duration,
            delay: 0,
            timingFunction: timingFunction,
            closure: { self.brightness = (brightnessBefore, brightness) ◊ CGFloat($0) },
            completion: completion)
    }
}

// MARK: - Brightness
/*
extension UIViewController
{
    var brightnessManager : BrightnessManager { return BrightnessManager.sharedBrightnessManager }
}

public class BrightnessManager
{
    public static func adjustBrightness(animated animated: Bool = true)
    {
        sharedBrightnessManager.adjustBrightness(animated: animated)
    }
    
    public static var brightness : CGFloat { return sharedBrightnessManager.brightness }
        
    private static let sharedBrightnessManager = BrightnessManager()
    
    private var brightness : CGFloat { return UIScreen.mainScreen().brightness }
    
    private func adjustBrightness(animated animated: Bool = true)
    {
        let preferences = UIApplication.sharedApplication().visibleViewControllers.cast(BrightnessAffecter).map{ $0.brightnessPreferences() }
        
        if !preferences.isEmpty
        {
            let minBrightness = preferences.flatMap { $0.min }.maxElement() ?? 0
            let maxBrightness = preferences.flatMap { $0.max }.minElement() ?? 1
            
            let preferredBrightnesses = preferences.map { $0.preferred }.filter { $0 >= minBrightness && $0 <= maxBrightness }
            
            var newBrightness = brightness
            
            if let preferredBrightness = preferredBrightnesses.frequencies().first?.0
            {
                newBrightness = preferredBrightness
            }
            else
            {
                newBrightness = min(maxBrightness, max(minBrightness, brightness))
            }
            
            if brightness != newBrightness
            {
                if animated
                {
                    setBrightness(newBrightness, duration: 0.5)
                }
                else
                {
                    UIScreen.mainScreen().brightness = newBrightness
                }
            }
        }
    }
}


public protocol BrightnessAffecter
{
    func brightnessPreferences() -> (min: CGFloat?, preferred: CGFloat, max: CGFloat?)
    
    //    var preferredBrightness : CGFloat? { get }
    //    var requiredMinimumBrightness : CGFloat? { get }
    //    var requiredMaximumBrightness : CGFloat? { get }
}

////MARK: - Brightness
//
//let StepsPerSecond : CGFloat = 20
//let StepSize = 1 / StepsPerSecond
//
//class BrightnessController
//{
////    var timer : NSTimer?
//
//    var tasks = Array<Task>()
//
//    func setBrightness(brightness: CGFloat, duration: Double)
//    {
//        tasks.forEach { $0.unschedule() }
//        tasks.removeAll(keepCapacity: true)
//
//        let b1 = UIScreen.mainScreen().brightness
//        let b2 = max(0, min(1, brightness))
//        let T = CGFloat(max(0.1, duration))
//
//        //easing function
//        let f = { (t:CGFloat) -> CGFloat in return (b1 * (T - t) + b2 * t) / T }
//
//        let steps = T.stride(to: 0, by: -StepSize).map { return ($0, f($0)) }.reverse()
//
//        steps.forEach { (t, b) in
//            if t > StepSize / 2
//            {
//                let task = Task({ UIScreen.mainScreen().brightness = b })
//                task.schedule(Double(t))
//
//                tasks.append(task)
//            }
//        }
//    }
//}


//private let brightnessController = BrightnessController()

private let brightnessAnimator = FloatAnimator(
    setter: { b in UIScreen.mainScreen().brightness = CGFloat(b) },
    getter: { return Float(UIScreen.mainScreen().brightness) })

extension UIScreen
{
    //    public func setBrightness(brightness: CGFloat, duration: Double = 0.25, delay: Double = 0)
    //    {
    ////        let options = UIViewKeyframeAnimationOptions.CalculationModePaced
    //
    ////        let KeyFramesPerSecond : Double = 60
    ////        let frameCount = max(1, Int(abs(duration * KeyFramesPerSecond)))
    //        let b1 = UIScreen.mainScreen().brightness
    //        let b2 = brightness
    //        let T = CGFloat(max(0.1, duration))
    //
    //        //easing function
    //        let f = { (t:CGFloat) -> CGFloat in return (b1 * (T - t) + b2 * t) / T }
    //
    //        let steps = T.stride(to: 0, by: -StepSize).map { return f($0) }.reverse()
    //
    //        UIView.animateKeyframesWithDuration(
    //            duration,
    //            delay: delay,
    //            options: [.CalculationModePaced, .BeginFromCurrentState],
    //            animations: {
    //
    //                for brightness in steps
    //                {
    //                    UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 0, animations: { UIScreen.mainScreen().brightness = brightness })
    //                }
    //            },
    //            completion: nil)
    //    }
    
    //    // note that we've set relativeStartTime and relativeDuration to zero.
    //    // Because we're using `CalculationModePaced` these values are ignored
    //    // and iOS figures out values that are needed to create a smooth constant transition
    //    UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 0, animations: {
    //    self.fish.transform = CGAffineTransformMakeRotation(1/3 * fullRotation)
    //    })
    //
    //    UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 0, animations: {
    //    self.fish.transform = CGAffineTransformMakeRotation(2/3 * fullRotation)
    //    })
    //
    //    UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 0, animations: {
    //    self.fish.transform = CGAffineTransformMakeRotation(3/3 * fullRotation)
    //    })
    //
    //    }, completion: nil)
    
    //
    //
    public func setBrightness(brightness: CGFloat, duration: Double)
    {
        brightnessAnimator.animateFloat(Float(brightness), duration:duration)
        
        //        brightnessController.setBrightness(brightness, duration: duration)
        
        //        let b1 = self.brightness
        //        let b2 = max(0, min(1, brightness))
        //        let T = CGFloat(max(0.1, duration))
        //
        //        //easing function
        //        let f = { (t:CGFloat) -> CGFloat in return (b1 * (T - t) + b2 * t) / T }
        //
        //        let steps = T.stride(to: 0, by: -StepSize).map { return ($0, f($0)) }.reverse()
        //
        //        steps.forEach { (t, b) in
        //            debugPrint("delay: \(t), brightness: \(b)")
        //            delay(Double(t), closure: { self.brightness = b })
        //        }
        
        
        //        for var t : CGFloat = T ; t > 0; t -= 0.05
        //        {
        //            let b = f(t)
        //
        //            delay(Double(t)) {
        //                self.brightness = b
        //            }
        //        }
    }
}

public func setBrightness(brightness: CGFloat, duration: Double)
{
    brightnessAnimator.animateFloat(Float(brightness), duration:duration)
}
*/