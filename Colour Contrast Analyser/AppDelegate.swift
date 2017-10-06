//
//  AppDelegate.swift
//  Colour Contrast Analyser
//
//  Created by Cédric Trévisan on 26/01/2015.
//  Copyright (c) 2015 Cédric Trévisan. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    let cca_url = "http://www.paciellogroup.com/resources/contrast-analyser.html"
    
    var foreground: CCAColourForeground = CCAColourForeground.sharedInstance
    var background: CCAColourBackground = CCAColourBackground.sharedInstance

    @IBOutlet weak var mainWindow: NSWindow!
    @IBOutlet weak var luminosity: CCALuminosityControler!
    @IBOutlet weak var colorBrightnessDifference: CCAColourBrightnessDifferenceController!

    var preferencesController = CCAPreferencesController(windowNibName: NSNib.Name(rawValue: "Preferences"))

    
    let userDefaults = UserDefaults.standard
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Initialise Preferences
        if userDefaults.string(forKey: "CCAResultsFormat") == nil {
            userDefaults.set(NSLocalizedString("results_format", comment:"Initial Results format text"), forKey: "CCAResultsFormat")
        }
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
   
    @IBAction func showHelp(_ sender: AnyObject) {
        let ws = NSWorkspace.shared
        ws.open(URL(string: cca_url)!)
    }
    
    @IBAction func showPreferences(_ sender: AnyObject) {
        preferencesController.showWindow(nil)
    }
    
    @IBAction func copyResults(_ sender: AnyObject) {
        var results:String = userDefaults.string(forKey: "CCAResultsFormat")!
        results = results.replace("%F", withString: foreground.value.getHexString())
        results = results.replace("%B", withString: background.value.getHexString())
        results = results.replace("%L", withString: luminosity.contrastRatioString!)
        results = results.replace("%AAN ", withString:((luminosity.passAA == true) ? NSLocalizedString("passed_normal_AA", comment:"Normal text passed at level AA") : NSLocalizedString("failed_normal_AA", comment:"Normal text failed at level AA")))
        results = results.replace("%AAAN", withString:((luminosity.passAAA == true) ? NSLocalizedString("passed_normal_AAA", comment:"Normal text passed at level AAA") : NSLocalizedString("failed_normal_AAA", comment:"Normal text failed at level AAA")))
        results = results.replace("%AAL", withString:((luminosity.passAALarge == true) ? NSLocalizedString("passed_large_AA", comment:"Large text passed at level AA") : NSLocalizedString("failed_large_AA", comment:"Large text failed at level AA")))
        results = results.replace("%AAAL", withString:((luminosity.passAAALarge == true) ? NSLocalizedString("passed_large_AAA", comment:"Large text passed at level AAA") : NSLocalizedString("failed_large_AAA", comment:"Large text failed at level AAA")))
        let pasteBoard = NSPasteboard.general
        pasteBoard.clearContents()
        pasteBoard.writeObjects([results as NSPasteboardWriting])
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}

extension String
{
    func replace(_ target: String, withString: String) -> String
    {
        return self.replacingOccurrences(of: target, with: withString, options: NSString.CompareOptions.literal, range: nil)
    }
}
