//
//  ResultsController.swift
//  Colour Contrast Analyser
//
//  Created by Cédric Trévisan on 27/01/2015.
//  Copyright (c) 2015 Cédric Trévisan. All rights reserved.
//

import Cocoa

class CCAColourBrightnessDifferenceController: NSViewController {
    @IBOutlet weak var colourDifferenceText: NSTextField!
    @IBOutlet weak var brightnessDifferenceText: NSTextField!
    @IBOutlet weak var colourBrightnessSample: CCAColourBrightnessDifferenceField!
    
    @IBOutlet weak var menuShowRGBSliders: NSMenuItem!
    var fColor: NSColor = NSColor(red: 0, green: 0, blue: 0, alpha: 1.0)
    var bColor: NSColor = NSColor(red: 1, green: 1, blue: 1, alpha: 1.0)
    
    var colourDifferenceValue:Int?
    var brightnessDifferenceValue:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        self.updateResults()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateForeground:", name: "ForegroundColorChangedNotification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateBackground:", name: "BackgroundColorChangedNotification", object: nil)
    }
    
    func updateResults() {
        brightnessDifferenceValue = ColourBrightnessDifference.getBrightnessDifference(self.fColor, bc:self.bColor)
        colourDifferenceValue = ColourBrightnessDifference.getColourDifference(self.fColor, bc:self.bColor)
        colourDifferenceText.stringValue = String(format: NSLocalizedString("colour_diff", comment:"Colour difference: %d (minimum 500)"), colourDifferenceValue!)
        brightnessDifferenceText.stringValue = String(format: NSLocalizedString("brightness_diff", comment:"Brightness difference: %d (minimum 125)"), brightnessDifferenceValue!)
        colourBrightnessSample.validateColourBrightnessDifference(brightnessDifferenceValue!, colour: colourDifferenceValue!)
    }
    func updateForeground(notification: NSNotification) {
        self.fColor = notification.userInfo!["color"] as! NSColor
        self.updateResults()
        
        var color:NSColor = self.fColor
        // Fix for #3 : use almost black color
        if (color.isBlack()) {
            color = NSColor(red: 0.000001, green: 0, blue: 0, alpha: 1.0)
        }
        colourBrightnessSample.textColor = color
    }
    func updateBackground(notification: NSNotification) {
        self.bColor = notification.userInfo!["color"] as! NSColor
        self.updateResults()
        colourBrightnessSample.backgroundColor = self.bColor
    }
}
