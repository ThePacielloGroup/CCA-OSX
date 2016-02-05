//
//  CCALuminosityControler.swift
//  Colour Contrast Analyser
//
//  Created by Cédric Trévisan on 19/02/2015.
//  Copyright (c) 2015 Cédric Trévisan. All rights reserved.
//

import Cocoa

class CCALuminosityControler: NSViewController {
    
    @IBOutlet weak var ratioText: NSTextField!
    @IBOutlet weak var textAA: CCALuminosityLevelField!
    @IBOutlet weak var textAAA: CCALuminosityLevelField!
    @IBOutlet weak var largeTextAA: CCALuminosityLevelField!
    @IBOutlet weak var largeTextAAA: CCALuminosityLevelField!

    var fColor: NSColor = NSColor(red: 0, green: 0, blue: 0, alpha: 1.0)
    var bColor: NSColor = NSColor(red: 1, green: 1, blue: 1, alpha: 1.0)
    
    var luminosityValue:Double?
    var contrastRatioString:String?
    var passAA:Bool?
    var passAAA:Bool?
    var passAALarge:Bool?
    var passAAALarge:Bool?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        textAA.level = "AA"
        textAAA.level = "AAA"
        largeTextAA.level = "AA"
        largeTextAAA.level = "AAA"

        self.updateResults()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateForeground:", name: "ForegroundColorChangedNotification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateBackground:", name: "BackgroundColorChangedNotification", object: nil)
    }
    
    func updateResults() {
        luminosityValue = Luminosity.getResult(self.fColor, bColor:self.bColor)
        contrastRatioString = String(format:"%.2f:1", luminosityValue!)
        ratioText.stringValue = String(format:NSLocalizedString("contrast_ratio", comment:"Contrast Ratio: %.2f:1"), luminosityValue!)
        passAA = true
        passAAA = true
        passAALarge = true
        passAAALarge = true
        if luminosityValue < 7 {
            passAAA = false
        }
        if luminosityValue < 4.5 {
            passAA = false
            passAAALarge = false
        }
        if luminosityValue < 3 {
            passAALarge = false
        }
        textAA.pass = passAA
        textAAA.pass = passAAA
        largeTextAA.pass = passAALarge
        largeTextAAA.pass = passAAALarge
    }
    func updateForeground(notification: NSNotification) {
        self.fColor = notification.userInfo!["color"] as! NSColor
        self.updateResults()
        
        var color:NSColor = self.fColor
        // Fix for #3 : use almost black color
        if (color.isBlack()) {
            color = NSColor(red: 0.000001, green: 0, blue: 0, alpha: 1.0)
        }
        textAA.textColor = color
        textAAA.textColor = color
        largeTextAA.textColor = color
        largeTextAAA.textColor = color
    }
    func updateBackground(notification: NSNotification) {
        self.bColor = notification.userInfo!["color"] as! NSColor
        self.updateResults()
        textAA.backgroundColor = self.bColor
        textAAA.backgroundColor = self.bColor
        largeTextAA.backgroundColor = self.bColor
        largeTextAAA.backgroundColor = self.bColor
    }
}