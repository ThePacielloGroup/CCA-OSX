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
    
    var pickerController = CCAPickerController(windowNibName: NSNib.Name(rawValue: "ColourPicker"))
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
    }
    
    // init for Ibuilder
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        Bundle.main.loadNibNamed(NSNib.Name(rawValue: "ColourHeaderView"), owner: self, topLevelObjects: nil)
        
        // Makes XIB View size same
        self.view.frame = self.bounds
        // add XIB's view to Custom NSView Subclass
        self.addSubview(self.view)
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor.white.cgColor
        self.view.translatesAutoresizingMaskIntoConstraints = false
        
        // these are 10.11-only APIs, but you can use the visual format language or any other autolayout APIs
        self.view.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.view.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.view.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.view.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }
    
    @IBAction func colorPickerClicked(_ sender: NSButton) {
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
