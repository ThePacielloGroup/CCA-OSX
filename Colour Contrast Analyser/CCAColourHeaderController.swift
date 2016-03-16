//
//  CCAColourHeaderController.swift
//  Colour Contrast Analyser
//
//  Created by Cédric Trévisan on 08/02/2016.
//  Copyright © 2016 Cédric Trévisan. All rights reserved.
//

import Cocoa

class CCAColourHeaderController: NSView {
    
    var color: CCAColour!

    @IBOutlet var view: NSView!
    @IBOutlet weak var title: NSTextField!
    
    var pickerController = CCAPickerController(windowNibName: "ColourPicker")
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
    }
    
    // init for Ibuilder
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        NSBundle.mainBundle().loadNibNamed("ColourHeaderView", owner: self, topLevelObjects: nil)
        
        // Makes XIB View size same
        self.view.frame = self.bounds
        // add XIB's view to Custom NSView Subclass
        self.addSubview(self.view)
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor.whiteColor().CGColor
        self.view.translatesAutoresizingMaskIntoConstraints = false
        
        // these are 10.11-only APIs, but you can use the visual format language or any other autolayout APIs
        self.view.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor).active = true
        self.view.topAnchor.constraintEqualToAnchor(self.topAnchor).active = true
        self.view.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor).active = true
        self.view.trailingAnchor.constraintEqualToAnchor(self.trailingAnchor).active = true
    }
    
    @IBAction func colorPickerClicked(sender: NSButton) {
        pickerController.open(self.color)
    }
    
}

class CCAForegroundColourHeaderController: CCAColourHeaderController {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.title.stringValue = "Foreground Colour"
        self.color = CCAColourForeground.sharedInstance
    }
}

class CCABackgroundColourHeaderController: CCAColourHeaderController {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.title.stringValue = "Background Colour"
        self.color = CCAColourBackground.sharedInstance
    }
}