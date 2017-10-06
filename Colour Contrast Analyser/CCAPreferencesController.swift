//
//  CCAPreferencesViewController.swift
//  Colour Contrast Analyser
//
//  Created by Cédric Trévisan on 19/02/2015.
//  Copyright (c) 2015 Cédric Trévisan. All rights reserved.
//

import Cocoa

class CCAPreferencesController: NSWindowController, NSWindowDelegate {
    
    @IBOutlet var resultText: NSTextView!

    let userDefaults = UserDefaults.standard
    
    override func windowDidLoad() {
        super.windowDidLoad()
        resultText.string = userDefaults.string(forKey: "CCAResultsFormat")!
        self.window?.delegate = self
    }

    func windowWillClose(_ notification: Notification) {
        userDefaults.set(resultText.string, forKey: "CCAResultsFormat")
    }
}
