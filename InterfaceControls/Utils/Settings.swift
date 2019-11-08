//
//  Settings.swift
//  Nuke & Juke
//
//  Created by DeviL on 2017-03-01.
//  Copyright © 2017 Orange Think Box. All rights reserved.
//

import Foundation
import SpriteKit

let kViewSize = UIScreen.main.bounds.size

let kScreenCenter = CGPoint(x: kViewSize.width / 2, y: kViewSize.height / 2)

let kGameFont = "Molot"
let kMiscFont: String = "Helvetica"

#if os(iOS)
    var isIpad = (UIDevice.current.userInterfaceIdiom == .pad)
    let isIphone = (UIDevice.current.userInterfaceIdiom == .phone)
    var isIphoneX = isIphoneXOrLonger
    let isWatch = false
#else
    let isIpad = false
    let isIphone = false
    let isIphoneX = false
    let isWatch = true
#endif

let kTestMode = true

//TODO: this should not be hardcoded
var kGameWidth: CGFloat = 0
var kGameHeight: CGFloat = 1080

//TextInputBox and OptionSelectBox Constants
let kKeyDelete: String = "delete"
let kKeyEnter: String = "done"
let kKeySpace: String = "space"
let kKeyBlank: String = "blank"
let kKeyClose: String = "close"
let kOffsetPadding: String = "pad"
let kOffsetSize: Int = 20
let kSpaceBetweenKeys: CGFloat = 20
let kAmountToMoveCaratForSpace: CGFloat = 18
let kTextBoxFontSize: CGFloat = 98.0
let kTextBoxFont: String = "Helvetica"
let kDefaultTextColor = SKColor(white: 0.4, alpha: 1.0)
let kTextColor = SKColor(white: 0.2, alpha: 1.0)
let kTextLabelColor = SKColor(white: 0.9, alpha: 1.0)

var hasSafeArea: Bool {
    guard #available(iOS 11.0, *), let topPadding = UIApplication.shared.keyWindow?.safeAreaInsets.top, topPadding > 24 else { return false }
    
    return true
}

var isIphoneXOrLonger: Bool {
    // 812.0 / 375.0 on iPhone X, XS.
    // 896.0 / 414.0 on iPhone XS Max, XR.
    return UIScreen.main.bounds.height / UIScreen.main.bounds.width >= 896.0 / 414.0
}
