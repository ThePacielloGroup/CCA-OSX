//
//  NSLuminosityLevelField.swift
//  Colour Contrast Analyser
//
//  Created by Cédric Trévisan on 02/02/2015.
//  Copyright (c) 2015 Cédric Trévisan. All rights reserved.
//

import Cocoa

class CCALuminosityLevelField: NSTextField {
    @IBOutlet weak var statusImage:NSImageView!
    var currentStatus:Bool = false
    var level:String?
    var pass:Bool? {
        didSet {
            if pass == true {
                setPass()
            } else {
                setFail()
            }
        }
    }
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        // Drawing code here.
    }

    func setFail() {
        if (currentStatus == true) {
            self.stringValue = NSLocalizedString("fail", comment:"Fail") + " " + level!
            self.statusImage.image = NSImage(named: NSImage.Name(rawValue: "No"))
            currentStatus = false;
        }
    }
    
    func setPass() {
        if (currentStatus == false) {
            self.stringValue = NSLocalizedString("pass", comment:"Pass") + " " + level!
            self.statusImage.image = NSImage(named: NSImage.Name(rawValue: "Yes"))
            currentStatus = true;
        }
    }
    
}
