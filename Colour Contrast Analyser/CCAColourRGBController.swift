//
//  CCAColourRGBController.swift
//  Colour Contrast Analyser
//
//  Created by Cédric Trévisan on 08/02/2016.
//  Copyright © 2016 Cédric Trévisan. All rights reserved.
//

import Cocoa

class CCAColourRGBController: NSView {

    var color: CCAColour!

    @IBOutlet var view: NSView!
    @IBOutlet weak var redSlider: NSSlider!
    @IBOutlet weak var greenSlider: NSSlider!
    @IBOutlet weak var blueSlider: NSSlider!
    @IBOutlet weak var rField: NSTextField!
    @IBOutlet weak var gField: NSTextField!
    @IBOutlet weak var bField: NSTextField!
    @IBOutlet weak var rView: NSView!
    @IBOutlet weak var gView: NSView!
    @IBOutlet weak var bView: NSView!
    @IBOutlet weak var showhide: NSButton!
    var rgbHidden: Bool = true

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
    }

    // init for Ibuilder
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        NSBundle.mainBundle().loadNibNamed("ColourRGBView", owner: self, topLevelObjects: nil)
        
        // Makes XIB View size same
        self.view.frame = self.bounds
        // add XIB's view to Custom NSView Subclass
        self.addSubview(self.view)
        self.view.translatesAutoresizingMaskIntoConstraints = false
        
        // these are 10.11-only APIs, but you can use the visual format language or any other autolayout APIs
        self.view.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor).active = true
        self.view.topAnchor.constraintEqualToAnchor(self.topAnchor).active = true
        self.view.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor).active = true
        self.view.trailingAnchor.constraintEqualToAnchor(self.trailingAnchor).active = true
        self.hideRGB(true)
    }
    
    @IBAction func sliderChanged(sender: NSSlider) {
        self.color.update(NSColor(redInt: redSlider.integerValue, greenInt: greenSlider.integerValue, blueInt: blueSlider.integerValue)!)
    }
    
    @IBAction func rgbChanged(sender: NSTextField) {
        self.color.update(NSColor(redInt: rField.integerValue, greenInt: gField.integerValue, blueInt: bField.integerValue)!)
    }
    
    @IBAction func disclosureClicked(sender: AnyObject) {
        self.hideRGB(!self.rgbHidden)
    }
    
    func hideRGB(value:Bool) {
        self.rView.hidden = value
        self.gView.hidden = value
        self.bView.hidden = value
        self.rgbHidden = value
    }
    
    func update(notification: NSNotification) {
        self.updateSliders()
        self.updateRGB()
    }
    
    func updateSliders() {
        self.redSlider.integerValue = self.color.value.getRInt()
        self.greenSlider.integerValue = self.color.value.getGInt()
        self.blueSlider.integerValue = self.color.value.getBInt()
    }
    func updateRGB() {
        self.rField.integerValue = self.color.value.getRInt()
        self.gField.integerValue = self.color.value.getGInt()
        self.bField.integerValue = self.color.value.getBInt()
    }
}

class CCAForegroundColourRGBController: CCAColourRGBController {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.color = CCAColourForeground.sharedInstance
        self.updateSliders()
        self.updateRGB()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "update:", name: "ForegroundColorChangedNotification", object: nil)
    }
}

class CCABackgroundColourRGBController: CCAColourRGBController {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.color = CCAColourBackground.sharedInstance
        self.updateSliders()
        self.updateRGB()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "update:", name: "BackgroundColorChangedNotification", object: nil)
    }
}