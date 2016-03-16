//
//  CCAColourPreviewController.swift
//  Colour Contrast Analyser
//
//  Created by Cédric Trévisan on 08/02/2016.
//  Copyright © 2016 Cédric Trévisan. All rights reserved.
//

import Cocoa

class CCAColourPreviewController: NSView {

    var color: CCAColour!

    @IBOutlet var view: NSView!
    @IBOutlet weak var hexField: NSTextField!
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
    }

    // init for Ibuilder
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        NSBundle.mainBundle().loadNibNamed("ColourPreviewView", owner: self, topLevelObjects: nil)
        
        // Makes XIB View size same
        self.view.frame = self.bounds
        // add XIB's view to Custom NSView Subclass
        self.addSubview(self.view)
        self.view.wantsLayer = true
        self.view.translatesAutoresizingMaskIntoConstraints = false
        
        // these are 10.11-only APIs, but you can use the visual format language or any other autolayout APIs
        self.view.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor).active = true
        self.view.topAnchor.constraintEqualToAnchor(self.topAnchor).active = true
        self.view.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor).active = true
        self.view.trailingAnchor.constraintEqualToAnchor(self.trailingAnchor).active = true
    }
    
    @IBAction func hexChanged(sender: NSTextField) {
        if (validateHex(sender.stringValue)) {
            hexField.backgroundColor = NSColor.whiteColor()
            self.color.update(NSColor(hexString: sender.stringValue)!)
        } else {
            hexField.backgroundColor = NSColor.redColor()
        }
    }

    func update(notification: NSNotification) {
        self.updateHex()
        self.updatePreview()
    }
    
    func updatePreview() {
        self.view.layer?.backgroundColor = self.color.value.CGColor
    }
    
    func updateHex() {
        self.hexField.stringValue = self.color.hexvalue
        
    }
    
    func validateHex(value: String) -> Bool {
        let regexp = try! NSRegularExpression(pattern: "^#?([0-9A-Fa-f]{6})|([0-9A-Fa-f]{3})$", options: NSRegularExpressionOptions.CaseInsensitive)
        let valueRange = NSRange(location:0, length: value.characters.count )
        let result = regexp.rangeOfFirstMatchInString(value, options: .Anchored, range: valueRange)
        if (result.location == NSNotFound) {
            // regexp validation failed
            return false
        }
        else {
            return true
        }
    }
}

class CCAForegroundColourPreviewController: CCAColourPreviewController {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.color = CCAColourForeground.sharedInstance
        self.updateHex()
        self.updatePreview()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "update:", name: "ForegroundColorChangedNotification", object: nil)
    }
}

class CCABackgroundColourPreviewController: CCAColourPreviewController {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.color = CCAColourBackground.sharedInstance
        self.updateHex()
        self.updatePreview()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "update:", name: "BackgroundColorChangedNotification", object: nil)
    }
}