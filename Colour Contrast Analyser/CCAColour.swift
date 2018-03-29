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
    private var rgbaStringVal: String?
    private var notification: String
    
    var hexString: String {
        get {
            if (self.hexStringVal == nil) {
                self.hexStringVal = self.value.hexString
            }
            return self.hexStringVal!
        }
    }

    var rgbaString: String {
        get {
            if (self.rgbaStringVal == nil) {
                self.rgbaStringVal = self.value.rgbaString
            }
            return self.rgbaStringVal!
        }
    }
    
    fileprivate init(value: NSColor, notification: String) {
        self.value = value
        self.notification = notification
    }
    
    func update(_ value: NSColor) {
        self.value = value
        self.hexStringVal = nil
        self.rgbaStringVal = nil
        let userInfo = ["color" : self.value]
        NotificationCenter.default.post(name: Notification.Name(rawValue: self.notification), object: nil, userInfo: userInfo)
    }
    
    func isHexStringEqual(string: String) -> Bool {
        let color = NSColor(hexString: string, alpha: 1.0)
        return (color?.hexString == self.hexString)
    }
    
    func isRGBAStringEqual(string: String) -> Bool {
        let color = NSColor(rgbaString: string)
        return (color?.rgbaString == self.rgbaString)
    }
}

class CCAColourForeground: CCAColour {
    static let sharedInstance = CCAColourForeground(value: NSColor(red: 0, green: 0, blue: 0, alpha: 1.0), notification: "ForegroundColorChangedNotification")
}

class CCAColourBackground: CCAColour {
    static let sharedInstance = CCAColourBackground(value: NSColor(red: 1, green: 1, blue: 1, alpha: 1.0), notification: "BackgroundColorChangedNotification")
}
