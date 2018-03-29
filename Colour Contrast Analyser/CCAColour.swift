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
    private var hexStringVal: String?
    private var rgbStringVal: String?
    private var notification: String
    
    var hexString: String {
        get {
            if (self.hexStringVal == nil) {
                self.hexStringVal = self.value.hexString
            }
            return self.hexStringVal!
        }
    }

    var rgbString: String {
        get {
            if (self.rgbStringVal == nil) {
                self.rgbStringVal = self.value.rgbString
            }
            return self.rgbStringVal!
        }
    }
    
    fileprivate init(value: NSColor, notification: String) {
        self.value = value
        self.notification = notification
    }
    
    func update(_ value: NSColor) {
        self.value = value
        self.hexStringVal = nil
        self.rgbStringVal = nil
        let userInfo = ["color" : self.value]
        NotificationCenter.default.post(name: Notification.Name(rawValue: self.notification), object: nil, userInfo: userInfo)
    }
    
    func isHexStringEqual(string: String) -> Bool {
        let color = NSColor(hexString: string)
        return (color?.hexString == self.hexString)
    }
    
    func isRGBStringEqual(string: String) -> Bool {
        let color = NSColor(rgbString: string)
        return (color?.rgbString == self.rgbString)
    }
}

class CCAColourForeground: CCAColour {
    static let sharedInstance = CCAColourForeground(value: NSColor(red: 0, green: 0, blue: 0, alpha: 1.0), notification: "ForegroundColorChangedNotification")
}

class CCAColourBackground: CCAColour {
    static let sharedInstance = CCAColourBackground(value: NSColor(red: 1, green: 1, blue: 1, alpha: 1.0), notification: "BackgroundColorChangedNotification")
}
