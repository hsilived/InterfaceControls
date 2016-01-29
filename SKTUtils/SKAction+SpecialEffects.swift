/*
 * Copyright (c) 2013-2014 Razeware LLC
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import SpriteKit

public extension SKAction {
  /**
   * Creates a screen shake animation.
   *
   * @param node The node to shake. You cannot apply this effect to an SKScene.
   * @param amount The vector by which the node is displaced.
   * @param oscillations The number of oscillations; 10 is a good value.
   * @param duration How long the effect lasts. Shorter is better.
   */
  public class func screenShakeWithNode(node: SKNode, amount: CGPoint, oscillations: Int, duration: NSTimeInterval) -> SKAction {
    let oldPosition = node.position
    let newPosition = oldPosition + amount
    
    let effect = SKTMoveEffect(node: node, duration: duration, startPosition: newPosition, endPosition: oldPosition)
    effect.timingFunction = SKTCreateShakeFunction(oscillations)

    return SKAction.actionWithEffect(effect)
  }

  /**
   * Creates a screen rotation animation.
   *
   * @param node You usually want to apply this effect to a pivot node that is
   *        centered in the scene. You cannot apply the effect to an SKScene.
   * @param angle The angle in radians.
   * @param oscillations The number of oscillations; 10 is a good value.
   * @param duration How long the effect lasts. Shorter is better.
   */
  public class func screenRotateWithNode(node: SKNode, angle: CGFloat, oscillations: Int, duration: NSTimeInterval) -> SKAction {
    let oldAngle = node.zRotation
    let newAngle = oldAngle + angle
    
    let effect = SKTRotateEffect(node: node, duration: duration, startAngle: newAngle, endAngle: oldAngle)
    effect.timingFunction = SKTCreateShakeFunction(oscillations)

    return SKAction.actionWithEffect(effect)
  }

  /**
   * Creates a screen zoom animation.
   *
   * @param node You usually want to apply this effect to a pivot node that is
   *        centered in the scene. You cannot apply the effect to an SKScene.
   * @param amount How much to scale the node in the X and Y directions.
   * @param oscillations The number of oscillations; 10 is a good value.
   * @param duration How long the effect lasts. Shorter is better.
   */
  public class func screenZoomWithNode(node: SKNode, amount: CGPoint, oscillations: Int, duration: NSTimeInterval) -> SKAction {
    let oldScale = CGPoint(x: node.xScale, y: node.yScale)
    let newScale = oldScale * amount
    
    let effect = SKTScaleEffect(node: node, duration: duration, startScale: newScale, endScale: oldScale)
    effect.timingFunction = SKTCreateShakeFunction(oscillations)

    return SKAction.actionWithEffect(effect)
  }

  /**
   * Causes the scene background to flash for duration seconds.
   */
  public class func colorGlitchWithScene(scene: SKScene, originalColor: SKColor, duration: NSTimeInterval) -> SKAction {
    
    return SKAction.customActionWithDuration(duration) {(node, elapsedTime) in
        
      if elapsedTime < CGFloat(duration) {
        
        scene.backgroundColor = SKColorWithRGB(Int.random(0...255), g: Int.random(0...255), b: Int.random(0...255))
      }
      else {
        
        scene.backgroundColor = originalColor
      }
    }
  }
    
    //MARK: - Spring Actions
    
    class func moveByX(deltaX: CGFloat, y deltaY: CGFloat, duration: NSTimeInterval, delay: NSTimeInterval, usingSpringWithDamping dampingRatio: CGFloat, initialSpringVelocity velocity: CGFloat) -> SKAction {
        
        let moveByX = animateKeyPath("x", byValue: deltaX, duration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity)
        let moveByY = animateKeyPath("y", byValue: deltaY, duration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity)
        
        return SKAction.group([moveByX, moveByY])
    }
    
    class func moveBy(delta: CGVector, duration: NSTimeInterval, delay: NSTimeInterval, usingSpringWithDamping dampingRatio: CGFloat, initialSpringVelocity velocity: CGFloat) -> SKAction {
        
        let moveByX = animateKeyPath("x", byValue: delta.dx, duration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity)
        let moveByY = animateKeyPath("y", byValue: delta.dy, duration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity)
        
        return SKAction.group([moveByX, moveByY])
    }
    
    class func moveTo(location: CGPoint, duration: NSTimeInterval, delay: NSTimeInterval, usingSpringWithDamping dampingRatio: CGFloat, initialSpringVelocity velocity: CGFloat) -> SKAction {
        
        let moveToX = animateKeyPath("x", toValue: location.x, duration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity)
        let moveToY = animateKeyPath("y", toValue: location.y, duration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity)
        
        return SKAction.group([moveToX, moveToY])
    }
    
    class func moveToX(x: CGFloat, duration: NSTimeInterval, delay: NSTimeInterval, usingSpringWithDamping dampingRatio: CGFloat, initialSpringVelocity velocity: CGFloat) -> SKAction {
        
        return animateKeyPath("x", toValue: x, duration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity)
    }
    
    class func moveToY(y: CGFloat, duration: NSTimeInterval, delay: NSTimeInterval, usingSpringWithDamping dampingRatio: CGFloat, initialSpringVelocity velocity: CGFloat) -> SKAction {
        
        return animateKeyPath("y", toValue: y, duration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity)
    }

    //MARK: - Rotate Actions
    
    class func rotateByAngle(radians: CGFloat, duration: NSTimeInterval, delay: NSTimeInterval, usingSpringWithDamping dampingRatio: CGFloat, initialSpringVelocity velocity: CGFloat) -> SKAction {
        
        return animateKeyPath("zRotation", byValue: radians, duration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity)
    }
    
    class func rotateToAngle(radians: CGFloat, duration: NSTimeInterval, delay: NSTimeInterval, usingSpringWithDamping dampingRatio: CGFloat, initialSpringVelocity velocity: CGFloat) -> SKAction {
        
        return animateKeyPath("zRotation", toValue: radians, duration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity)
    }
    
    //MARK: - Speed Actions
    
    class func speedBy(speed: CGFloat, duration: NSTimeInterval, delay: NSTimeInterval, usingSpringWithDamping dampingRatio: CGFloat, initialSpringVelocity velocity: CGFloat) -> SKAction {
        
        return animateKeyPath("speed", byValue: speed, duration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity)
    }
    
    class func speedTo(speed: CGFloat, duration: NSTimeInterval, delay: NSTimeInterval, usingSpringWithDamping dampingRatio: CGFloat, initialSpringVelocity velocity: CGFloat) -> SKAction {
        
        return animateKeyPath("speed", toValue: speed, duration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity)
    }
    
    //MARK: - Scale Actions
    
    class func scaleBy(scale: CGFloat, duration: NSTimeInterval, delay: NSTimeInterval, usingSpringWithDamping dampingRatio: CGFloat, initialSpringVelocity velocity: CGFloat) -> SKAction {
        
        return scaleXBy(scale, y: scale, duration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity)
    }
    
    class func scaleTo(scale: CGFloat, duration: NSTimeInterval, delay: NSTimeInterval, usingSpringWithDamping dampingRatio: CGFloat, initialSpringVelocity velocity: CGFloat) -> SKAction {
        
        return scaleXTo(scale, y: scale, duration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity)
    }
    
    class func scaleXBy(xScale: CGFloat, y yScale: CGFloat, duration: NSTimeInterval, delay: NSTimeInterval, usingSpringWithDamping dampingRatio: CGFloat, initialSpringVelocity velocity: CGFloat) -> SKAction {
        
        let scaleXBy = animateKeyPath("xScale", byValue: xScale, duration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity)
        let scaleYBy = animateKeyPath("yScale", byValue: yScale, duration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity)
        
        return SKAction.group([scaleXBy, scaleYBy])
    }
    
    class func scaleXTo(scale: CGFloat, duration: NSTimeInterval, delay: NSTimeInterval, usingSpringWithDamping dampingRatio: CGFloat, initialSpringVelocity velocity: CGFloat) -> SKAction {
        
        return animateKeyPath("xScale", toValue: scale, duration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity)
    }
    
    class func scaleYTo(scale: CGFloat, duration: NSTimeInterval, delay: NSTimeInterval, usingSpringWithDamping dampingRatio: CGFloat, initialSpringVelocity velocity: CGFloat) -> SKAction {
        
        return animateKeyPath("yScale", toValue: scale, duration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity)
    }
    
    class func scaleXTo(xScale: CGFloat, y yScale: CGFloat, duration: NSTimeInterval, delay: NSTimeInterval, usingSpringWithDamping dampingRatio: CGFloat, initialSpringVelocity velocity: CGFloat) -> SKAction {
        
        let scaleXTo = self.scaleXTo(xScale, duration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity)
        let scaleYTo = self.scaleYTo(yScale, duration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity)
        
        return SKAction.group([scaleXTo, scaleYTo])
    }
    
    //MARK: - Fade Actions
    
    class func fadeInWithDuration(duration: NSTimeInterval, delay: NSTimeInterval, usingSpringWithDamping dampingRatio: CGFloat, initialSpringVelocity velocity: CGFloat) -> SKAction {
        
        return animateKeyPath("alpha", toValue: 1, duration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity)
    }
    
    class func fadeOutWithDuration(duration: NSTimeInterval, delay: NSTimeInterval, usingSpringWithDamping dampingRatio: CGFloat, initialSpringVelocity velocity: CGFloat) -> SKAction {
        
        return animateKeyPath("alpha", toValue: 0, duration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity)
    }
    
    class func fadeAlphaBy(factor: CGFloat, duration: NSTimeInterval, delay: NSTimeInterval, usingSpringWithDamping dampingRatio: CGFloat, initialSpringVelocity velocity: CGFloat) -> SKAction {
        
        return animateKeyPath("alpha", byValue: factor, duration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity)
    }
    
    class func fadeAlphaTo(factor: CGFloat, duration: NSTimeInterval, delay: NSTimeInterval, usingSpringWithDamping dampingRatio: CGFloat, initialSpringVelocity velocity: CGFloat) -> SKAction {
        
        return animateKeyPath("alpha", toValue: factor, duration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity)
    }
    
    //MARK: - Resize Actions
    
    class func resizeByWidth(width: CGFloat, height: CGFloat, duration: NSTimeInterval, delay: NSTimeInterval, usingSpringWithDamping dampingRatio: CGFloat, initialSpringVelocity velocity: CGFloat) -> SKAction {
        
        let resizeByWidth = animateKeyPath("width", byValue: width, duration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity)
        let resizeByHeight = animateKeyPath("height", byValue: height, duration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity)
        
        return SKAction.group([resizeByWidth, resizeByHeight])
    }
    
    class func resizeToWidth(width: CGFloat, duration: NSTimeInterval, delay: NSTimeInterval, usingSpringWithDamping dampingRatio: CGFloat, initialSpringVelocity velocity: CGFloat) -> SKAction {
        
        return animateKeyPath("width", toValue: width, duration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity)
    }
    
    class func resizeToHeight(height: CGFloat, duration: NSTimeInterval, delay: NSTimeInterval, usingSpringWithDamping dampingRatio: CGFloat, initialSpringVelocity velocity: CGFloat) -> SKAction {
        
        return animateKeyPath("height", toValue: height, duration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity)
    }
    
    class func resizeToWidth(width: CGFloat, height: CGFloat, duration: NSTimeInterval, delay: NSTimeInterval, usingSpringWithDamping dampingRatio: CGFloat, initialSpringVelocity velocity: CGFloat) -> SKAction {
        
        let resizeToWidth = self.resizeToWidth(width, duration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity)
        let resizeToHeight = self.resizeToHeight(height, duration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity)
        
        return SKAction.group([resizeToWidth, resizeToHeight])
    }
    
    //MARK: - Colorize Actions
    
    class func colorizeWithColorBlendFactor(colorBlendFactor: CGFloat, duration: NSTimeInterval, delay: NSTimeInterval, usingSpringWithDamping dampingRatio: CGFloat, initialSpringVelocity velocity: CGFloat) -> SKAction {
        
        return animateKeyPath("colorBlendFactor", toValue: colorBlendFactor, duration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity)
    }
    
    //MARK: - Damping Logic
    
    class func animateKeyPath(keyPath: String, byValue initialDistance: CGFloat, duration: NSTimeInterval, delay: NSTimeInterval, usingSpringWithDamping dampingRatio: CGFloat, initialSpringVelocity velocity: CGFloat) -> SKAction {
        
        return animateKeyPath(keyPath, byValue: initialDistance, toValue: nil, duration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity)
    }
    
    class func animateKeyPath(keyPath: String, toValue finalValue: CGFloat, duration: NSTimeInterval, delay: NSTimeInterval, usingSpringWithDamping dampingRatio: CGFloat, initialSpringVelocity velocity: CGFloat) -> SKAction {
        
        return animateKeyPath(keyPath, byValue: nil, toValue: finalValue, duration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity)
    }
    
    private class func animateKeyPath(keyPath: String, var byValue initialDistance: CGFloat!, var toValue finalValue: CGFloat!, duration: NSTimeInterval, delay: NSTimeInterval, usingSpringWithDamping dampingRatio: CGFloat, initialSpringVelocity velocity: CGFloat) -> SKAction {
        
        var initialValue: CGFloat!
        var naturalFrequency, dampedFrequency, t1, t2: CGFloat!
        var A, B: CGFloat!
        
        let animation = SKAction.customActionWithDuration(duration) {
            node, elapsedTime in
            
            if initialValue == nil {
                
                initialValue = node.valueForKeyPath(keyPath) as! CGFloat
                initialDistance = initialDistance ?? finalValue - initialValue
                finalValue = finalValue ?? initialValue + initialDistance
                
                var magicNumber: CGFloat! // picked manually to visually match the behavior of UIKit
                if dampingRatio < 1 { magicNumber = 8 / dampingRatio }
                else if dampingRatio == 1 { magicNumber = 10 }
                else { magicNumber = 12 * dampingRatio }
                
                naturalFrequency = magicNumber / CGFloat(duration)
                dampedFrequency = naturalFrequency * sqrt(1 - pow(dampingRatio, 2))
                t1 = 1 / (naturalFrequency * (dampingRatio - sqrt(pow(dampingRatio, 2) - 1)))
                t2 = 1 / (naturalFrequency * (dampingRatio + sqrt(pow(dampingRatio, 2) - 1)))
            }
            
            var currentValue: CGFloat!
            
            if elapsedTime < CGFloat(duration) {
                
                if dampingRatio < 1 {
                    
                    A = A ?? initialDistance
                    B = B ?? (dampingRatio * naturalFrequency - velocity) * initialDistance / dampedFrequency
                    
                    currentValue = finalValue - exp(-dampingRatio * naturalFrequency * elapsedTime) * (A * cos(dampedFrequency * elapsedTime) + B * sin(dampedFrequency * elapsedTime))
                }
                else if dampingRatio == 1 {
                    
                    A = A ?? initialDistance
                    B = B ?? (naturalFrequency - velocity) * initialDistance
                    
                    currentValue = finalValue - exp(-dampingRatio * naturalFrequency * elapsedTime) * (A + B * elapsedTime)
                }
                else {
                    
                    A = A ?? (t1 * t2 / (t1 - t2)) * initialDistance * (1/t2 - velocity)
                    B = B ?? (t1 * t2 / (t2 - t1)) * initialDistance * (1/t1 - velocity)
                    
                    currentValue = finalValue - A * exp(-elapsedTime/t1) - B * exp(-elapsedTime/t2)
                }
            }
            else {
                
                currentValue = finalValue
            }
            
            node.setValue(currentValue, forKeyPath: keyPath)
        }
        
        if delay > 0 {
            
            return SKAction.sequence([SKAction.waitForDuration(delay), animation])
        }
        else {
            
            return animation
        }
    }
}
