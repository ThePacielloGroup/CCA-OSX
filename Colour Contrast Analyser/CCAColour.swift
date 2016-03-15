//
//  CCAColor.swift
//  Colour Contrast Analyser
//
//  Created by Cédric Trévisan on 15/03/2016.
//  Copyright © 2016 Cédric Trévisan. All rights reserved.
//

import Cocoa

class CCAColour {
    var value: NSColor
    var hexvalue: String
    var notification: String
    
    private init(value: NSColor, notification: String) {
        self.value = value
        self.hexvalue = value.getHexString()
        self.notification = notification
    }
    
    func update(value: NSColor) {
        self.value = value
        self.hexvalue = value.getHexString()
        let userInfo = ["color" : self.value]
        NSNotificationCenter.defaultCenter().postNotificationName(self.notification, object: nil, userInfo: userInfo)
    }
}

class CCAColourForeground: CCAColour {
    static let sharedInstance = CCAColourForeground(value: NSColor(red: 0, green: 0, blue: 0, alpha: 1.0), notification: "ForegroundColorChangedNotification")
}

class CCAColourBackground: CCAColour {
    static let sharedInstance = CCAColourBackground(value: NSColor(red: 1, green: 1, blue: 1, alpha: 1.0), notification: "BackgroundColorChangedNotification")
}