//
//  Utility.swift
//  Drive To Survive
//
//  Created by DeviL on 2015-10-13.
//  Copyright © 2015 Orange Think Box. All rights reserved.
//

import UIKit
import SpriteKit

//extension SKNode {
//    
//    class func unarchiveFromFile(file: String) -> SKNode? {
//        
//        if let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks") {
//            
//            var sceneData = NSData(contentsOfFile: path, options:.DataReadingMappedIfSafe, error: nil)!
//            var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
//            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
//            let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as SKScene
//            archiver.finishDecoding()
//            return scene
//        }
//        else {
//            return nil
//        }
//    }
//}

extension String {
    
//    func contains(find: String) -> Bool {
//        
//        if rangeOfString(find) != nil {
//            return true
//        }
//        return false
//    }
//    
//    func replace(target: String, withString: String) -> String {
//        
//        return self.stringByReplacingOccurrencesOfString(target, withString: withString, options: NSString.CompareOptions.LiteralSearch, range: nil)
//    }
}

extension CGPoint {
    
    func distance(point: CGPoint) -> CGFloat {
        
        let dx = self.x - point.x
        let dy = self.y - point.y
        return sqrt(dx * dx + dy * dy);
    }
}

// MARK: Rotate node to face another node
extension SKNode {
    func rotateToFaceNode(targetNode: SKNode, sourceNode: SKNode) {
        print("Source position: \(sourceNode.position)")
        print("Target position: \(targetNode.position)")
        let angle = atan2(targetNode.position.y - sourceNode.position.y, targetNode.position.x - sourceNode.position.x) - CGFloat.pi / 2
        print("Angle: \(angle)")
        self.run(SKAction.rotate(toAngle: angle, duration: 0))
    }
}

// MARK: Delay closure
//func delay(delay: Double, closure:()->()) {
//
//    dispatch_after(dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(delay * Double(NSEC_PER_SEC)) ), dispatch_get_main_queue(), closure)
//}

// MARK: Distance between nodes
func distanceBetween(nodeA: SKNode, nodeB: SKNode) -> CGFloat {
    
    return CGFloat(hypotf(Float(nodeB.position.x - nodeA.position.x), Float(nodeB.position.y - nodeA.position.y)));
}

class Utility: NSObject {
        
//    class func hexStringToUIColor(hex:String) -> UIColor {
//
//        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet() as NSCharacterSet).uppercaseString
//
//        if (cString.hasPrefix("#")) {
//            cString = cString.stringByReplacingOccurrencesOfString("#", withString: "")
//        }
//
//        if cString.count != 6 {
//            return UIColor.gray
//        }
//
//        var rgbValue:UInt32 = 0
//        Scanner(string: cString).scanHexInt32(&rgbValue)
//
//        return UIColor(
//            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
//            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
//            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
//            alpha: CGFloat(1.0)
//        )
//    }

//    class func alert(title: String, message: String, view: UIViewController) {
//        
//        if let getModernAlert: AnyClass = NSClassFromString("UIAlertController") {
//            
//            // iOS 8
//            let myAlert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
//            myAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
//            view.presentViewController(myAlert, animated: true, completion: nil)
//        }
//        else {
//            
//            // iOS 7
//            let alert: UIAlertView = UIAlertView()
//            alert.delegate = self
//            alert.title = title
//            alert.message = message
//            alert.addButtonWithTitle("OK")
//            alert.show()
//        }
//    }
}
