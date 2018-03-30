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
    private var hslStringVal: String?
    private var nameStringVal: String?
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

    var hslString: String {
        get {
            if (self.hslStringVal == nil) {
                self.hslStringVal = self.value.hslString
            }
            return self.hslStringVal!
        }
    }
    
    var nameString: String {
        get {
            if (self.nameStringVal == nil) {
                self.nameStringVal = self.value.nameString
            }
            return self.nameStringVal!
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
        self.hslStringVal = nil
        self.nameStringVal = nil
        let userInfo = ["color" : self.value]
        NotificationCenter.default.post(name: Notification.Name(rawValue: self.notification), object: nil, userInfo: userInfo)
    }
    
    func isHexStringEqual(string: String) -> Bool {
        let (redA, grnA, bluA) = NSColor.parseHex(string: string)
        let redB = Int(round(self.value.redComponent * 255))
        let grnB = Int(round(self.value.greenComponent * 255))
        let bluB = Int(round(self.value.blueComponent * 255))
        return (redA == redB && grnA == grnB && bluA == bluB)
    }
    
    func isRGBStringEqual(string: String) -> Bool {
        let (redA, grnA, bluA) = NSColor.parseRGB(string: string)
        let redB = Int(round(self.value.redComponent * 255))
        let grnB = Int(round(self.value.greenComponent * 255))
        let bluB = Int(round(self.value.blueComponent * 255))
        return (redA == redB && grnA == grnB && bluA == bluB)
    }
    
    func isHSLStringEqual(string: String) -> Bool {
        let (hueA, saturationA, brightnessA) = NSColor.parseHSL(string: string)
        let hueB = Int(round(self.value.hueComponent * 360))
        let saturationB = Int(round(self.value.saturationComponent * 100))
        let brightnessB = Int(round(self.value.brightnessComponent * 100))
        return (hueA == hueB && saturationA == saturationB && brightnessA == brightnessB)
    }
    
    func isNameStringEqual(string: String) -> Bool {
        return (string == self.nameString)
    }
}

class CCAColourForeground: CCAColour {
    static let sharedInstance = CCAColourForeground(value: NSColor(red: 0, green: 0, blue: 0, alpha: 1.0), notification: "ForegroundColorChangedNotification")
}

class CCAColourBackground: CCAColour {
    static let sharedInstance = CCAColourBackground(value: NSColor(red: 1, green: 1, blue: 1, alpha: 1.0), notification: "BackgroundColorChangedNotification")
}
