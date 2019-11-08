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

public func SKColorWithRGB(r: Int, g: Int, b: Int) -> SKColor {
    return SKColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: 1.0)
}

public func SKColorWithRGBA(r: Int, g: Int, b: Int, a: Int) -> SKColor {
    return SKColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: CGFloat(a)/255.0)
}

public func SKColorWithHSB(h: Int, s: Int, b: Int) -> SKColor {
    return SKColor(hue: CGFloat(h)/360.0, saturation: CGFloat(s)/100.0, brightness: CGFloat(b)/100.0, alpha: 1.0)
}

public func SKColorWithHSB(h: Int, s: Int, b: Int, a: Int) -> SKColor {
    return SKColor(hue: CGFloat(h)/360.0, saturation: CGFloat(s)/100.0, brightness: CGFloat(b)/100.0, alpha: CGFloat(a)/255.0)
}

//public func SKColorFromHexString(hexString: String, alpha: CGFloat) -> SKColor {
//
//    //If non valid string:
//    if (hexString == "") { return .white }
//
//    unsigned rgbValue = 0;
//
//    NSScanner *scanner = [NSScanner scannerWithString: hexString];
//    [scanner setScanLocation:1]; // bypass '#' character
//    [scanner scanHexInt:&rgbValue];
//
//    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:alpha];
//}

extension SKColor {
    
    //convenience initializers
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat){
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
    }
    
    convenience init(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat){
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1)
    }
    
    //array of all flatUI colors
    
    class func flatUIColors() -> [UIColor] {
        return [UIColor.turquoise(), UIColor.emerald(), UIColor.peterRiver(), UIColor.amethyst(), UIColor.wetAsphalt(), UIColor.greenSea(), UIColor.nephritis(), UIColor.belizeHole(), UIColor.wisteria(), UIColor.midnightBlue(), UIColor.sunFlower(), UIColor.carrot(), UIColor.alizarin(), UIColor.clouds(), UIColor.concrete(), UIColor.orange(), UIColor.pumpkin(), UIColor.pomegranate(), UIColor.silver(), UIColor.asbestos()]
    }
    
    func getSubStringRange(fullString: String, fromIndex: Int, subStringSize: Int) -> Range<String.Index> {
        
        let startIndex = fullString.index(fullString.startIndex, offsetBy: fromIndex)
        let endIndex = fullString.index(startIndex, offsetBy: subStringSize)
        
        let subStringRange = startIndex..<endIndex
        
        return subStringRange
    }
    
    public convenience init?(hexString: String) {
        
        let r, g, b: CGFloat
        
        var hexColor = hexString
        
        if hexColor.hasPrefix("#") {
            
            //let start = hexString.startIndex.advancedBy(1)
            //hexColor = hexString.substringFromIndex(start)
            
            let startIndex = hexString.index(hexString.startIndex, offsetBy: 1)
            let endIndex = hexString.index(startIndex, offsetBy: hexString.count - 1)
            
            let subStringRange = startIndex..<endIndex
            
            hexColor = String(hexString[subStringRange])
        }
        
        if hexColor.count == 6 {
            
            let scanner = Scanner(string: hexColor)
            var hexNumber: UInt64 = 0
            
            if scanner.scanHexInt64(&hexNumber) {
                
                //                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                //                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                //                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                //                    a = CGFloat(hexNumber & 0x000000ff) / 255
                //                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                b = CGFloat(hexNumber & 0x0000ff) / 255
                
                self.init(red: r, green: g, blue: b, alpha: 1.0)
                
                return
            }
        }
        
        return nil
    }
    
    //convenience methods to return flatUI colors
    
    class func turquoise() -> UIColor {
        return UIColor(26, 188, 156)
    }
    
    class func emerald() -> UIColor {
        return UIColor(46, 204, 113)
    }
    
    class func peterRiver() -> UIColor {
        return UIColor(52, 152, 219)
    }
    
    class func amethyst() -> UIColor {
        return UIColor(155, 89, 182)
    }
    
    class func wetAsphalt() -> UIColor {
        return UIColor(52, 73, 94)
    }
    
    class func greenSea() -> UIColor {
        return UIColor(22, 160, 133)
    }
    
    class func nephritis() -> UIColor {
        return UIColor(39, 174, 96)
    }
    
    class func belizeHole() -> UIColor {
        return UIColor(41, 128, 185)
    }
    
    class func powderBlue() -> UIColor {
        return UIColor(184, 201, 241)
    }
    
    class func wisteria() -> UIColor {
        return UIColor(142, 68, 173)
    }
    
    class func midnightBlue() -> UIColor {
        return UIColor(44, 62, 80)
    }
    
    class func sunFlower() -> UIColor {
        return UIColor(241, 196, 15)
    }
    
    class func carrot() -> UIColor {
        return UIColor(230, 126, 34)
    }
    
    class func alizarin() -> UIColor {
        return UIColor(231, 76, 60)
    }
    
    class func clouds() -> UIColor {
        return UIColor(236, 240, 241)
    }
    
    class func concrete() -> UIColor {
        return UIColor(149, 165, 166)
    }
    
    class func orange() -> UIColor {
        return UIColor(243, 156, 18)
    }
    
    class func pumpkin() -> UIColor {
        return UIColor(211, 84, 0)
    }
    
    class func pomegranate() -> UIColor {
        return UIColor(192, 57, 43)
    }
    
    class func silver() -> UIColor {
        return UIColor(189, 195, 199)
    }
    
    class func asbestos() -> UIColor {
        return UIColor(127, 140, 141)
    }
    
    var hexString: String {
        
        let components = self.cgColor.components
        
        var red = Float((components?[0])!)
        var green = Float((components?[1])!)
        var blue = Float((components?[2])!)
        
        red = red < 0 ? 0 : red
        green = green < 0 ? 0 : green
        blue = blue < 0 ? 0 : blue
        //        print("red \(red)")
        //        print("green \(green)")
        //        print("blue \(blue)")
        //        print("red rounded \(lroundf(red * 255))")
        //        print("green rounded \(lroundf(green * 100))")
        //        print("blue rounded \(lroundf(blue * 100))")
        let hexedColor = String(format: "%02X%02X%02X", lroundf(red * 255), lroundf(green * 255), lroundf(blue * 255))
        //        print("hexedColor \(hexedColor)")
        return hexedColor
    }
}
