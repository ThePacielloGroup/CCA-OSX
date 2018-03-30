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
    internal var valueWithOpacity: NSColor?

    internal var hexStringVal: String?
    internal var rgbStringVal: String?
    internal var hslStringVal: String?
    internal var nameStringVal: String?
    internal var notification: String
    internal var background: NSColor? = NSColor(red: 1, green: 1, blue: 1, alpha: 1.0)
    
    var colorWithOpacity: NSColor {
        get {
            if (self.valueWithOpacity == nil) {
                return self.value
            }
            return self.valueWithOpacity!
        }
    }
    
    var hexString: String {
        get {
            if (self.hexStringVal == nil) {
                self.hexStringVal = self.colorWithOpacity.hexString
            }
            return self.hexStringVal!
        }
    }

    var rgbString: String {
        get {
            if (self.rgbStringVal == nil) {
                self.rgbStringVal = self.colorWithOpacity.rgbString
            }
            return self.rgbStringVal!
        }
    }

    var hslString: String {
        get {
            if (self.hslStringVal == nil) {
                self.hslStringVal = self.colorWithOpacity.hslString
            }
            return self.hslStringVal!
        }
    }
    
    var nameString: String {
        get {
            if (self.nameStringVal == nil) {
                self.nameStringVal = self.colorWithOpacity.nameString
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
        let redB = self.colorWithOpacity.getRInt()
        let grnB = self.colorWithOpacity.getGInt()
        let bluB = self.colorWithOpacity.getBInt()
        return (redA == redB && grnA == grnB && bluA == bluB)
    }
    
    func isRGBStringEqual(string: String) -> Bool {
        let (redA, grnA, bluA) = NSColor.parseRGB(string: string)
        let redB = self.colorWithOpacity.getRInt()
        let grnB = self.colorWithOpacity.getGInt()
        let bluB = self.colorWithOpacity.getBInt()
        return (redA == redB && grnA == grnB && bluA == bluB)
    }
    
    func isHSLStringEqual(string: String) -> Bool {
        let (hueA, saturationA, brightnessA) = NSColor.parseHSL(string: string)
        let hueB = Int(round(self.colorWithOpacity.hueComponent * 360))
        let saturationB = Int(round(self.colorWithOpacity.saturationComponent * 100))
        let brightnessB = Int(round(self.colorWithOpacity.brightnessComponent * 100))
        return (hueA == hueB && saturationA == saturationB && brightnessA == brightnessB)
    }
    
    func isNameStringEqual(string: String) -> Bool {
        return (string == self.nameString)
    }
}

class CCAColourForeground: CCAColour {
    static let sharedInstance = CCAColourForeground(value: NSColor(red: 0, green: 0, blue: 0, alpha: 1.0), notification: "ForegroundColorChangedNotification")
    
    @objc func backgroundUpdate(_ notification: Notification) {
        let color = notification.userInfo!["color"] as! NSColor
        self.background = color
        self.updateValueWithOpacity()
    }
    
    override func update(_ value: NSColor) {
        self.value = value
        self.updateValueWithOpacity()
    }
    
    func updateValueWithOpacity() {
        // https://stackoverflow.com/a/11615135/3909342
        if (self.background != nil && self.value.alphaComponent < 1) {
            let alpha = 1 - self.value.alphaComponent
            let r: CGFloat = self.value.alphaComponent * self.value.redComponent + (alpha * self.background!.redComponent)
            let g: CGFloat = self.value.alphaComponent * self.value.greenComponent + (alpha * self.background!.greenComponent)
            let b: CGFloat = self.value.alphaComponent * self.value.blueComponent + (alpha * self.background!.blueComponent)
            self.valueWithOpacity = NSColor(red: r, green: g, blue: b, alpha: 1.0)
        } else {
            self.valueWithOpacity = nil
        }
        self.hexStringVal = nil
        self.rgbStringVal = nil
        self.hslStringVal = nil
        self.nameStringVal = nil
        let userInfo = ["color" : self.value, "colorWithOpacity": self.colorWithOpacity]
        NotificationCenter.default.post(name: Notification.Name(rawValue: self.notification), object: nil, userInfo: userInfo)
    }

    override init(value: NSColor, notification: String) {
        super.init(value: value, notification: notification)
        NotificationCenter.default.addObserver(self, selector: #selector(CCAColourForeground.backgroundUpdate(_:)), name: NSNotification.Name(rawValue: "BackgroundColorChangedNotification"), object: nil)
    }
}

class CCAColourBackground: CCAColour {
    static let sharedInstance = CCAColourBackground(value: NSColor(red: 1, green: 1, blue: 1, alpha: 1.0), notification: "BackgroundColorChangedNotification")
}
