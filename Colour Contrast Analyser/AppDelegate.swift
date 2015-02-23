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
    
    @IBOutlet weak var mainWindow: NSWindow!
    @IBOutlet weak var foreground: ForegroundColorController!
    @IBOutlet weak var background: BackgroundColorController!
    @IBOutlet weak var luminosity: CCALuminosityControler!
    @IBOutlet weak var colorBrightnessDifference: CCAColourBrightnessDifferenceController!

    @IBOutlet weak var foregroundSliders: NSView!
    @IBOutlet weak var backgroundSliders: NSView!

    var currentSender: ColorController?
    
    var pickerController:CCAPickerController = CCAPickerController(windowNibName: "ColorPicker")
    var preferencesController:CCAPreferencesController = CCAPreferencesController(windowNibName: "Preferences")
    
    var currentTag:Int = 0
    
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        var col1 = NSColor.labelColor()
        var col2 = NSColor.blackColor()
        
        // Initialise Preferences
        if userDefaults.stringForKey("CCAResultsFormat") == nil {
            userDefaults.setObject(NSLocalizedString("results_format", comment:"Initial Results format text"), forKey: "CCAResultsFormat")
        }
        
        // Insert code here to initialize your application
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "pickerColorSelected:", name: "ColorSelectedNotification", object: nil)
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
    
    func pickerColorSelected(notification: NSNotification){
        pickerController.close()
        // Unhide the mouse
        CGDisplayShowCursor(CGMainDisplayID())
        if currentTag == 1 { // Foreground
            foreground.colorPickerSelected(pickerController.color!)
        } else if currentTag == 2 { // Background
            background.colorPickerSelected(pickerController.color!)
        }
        currentTag = 0
    }
    
    @IBAction func showHelp(sender: AnyObject) {
        let ws = NSWorkspace.sharedWorkspace()
        ws.openURL(NSURL(string: cca_url)!)
    }
    
    @IBAction func showPreferences(sender: AnyObject) {
        preferencesController.showWindow(nil)
    }
    
    @IBAction func copyResults(sender: AnyObject) {
        var results:String = userDefaults.stringForKey("CCAResultsFormat")!
        results = results.replace("%F", withString: foreground.color.getHexString())
        results = results.replace("%B", withString: background.color.getHexString())
        results = results.replace("%L", withString: luminosity.contrastRatioString!)
        results = results.replace("%AAN ", withString:((luminosity.passAA == true) ? NSLocalizedString("passed_normal_AA", comment:"Normal text passed at level AA") : NSLocalizedString("failed_normal_AA", comment:"Normal text failed at level AA")))
        results = results.replace("%AAAN", withString:((luminosity.passAAA == true) ? NSLocalizedString("passed_normal_AAA", comment:"Normal text passed at level AAA") : NSLocalizedString("failed_normal_AAA", comment:"Normal text failed at level AAA")))
        results = results.replace("%AAL", withString:((luminosity.passAALarge == true) ? NSLocalizedString("passed_large_AA", comment:"Large text passed at level AA") : NSLocalizedString("failed_large_AA", comment:"Large text failed at level AA")))
        results = results.replace("%AAAL", withString:((luminosity.passAAALarge == true) ? NSLocalizedString("passed_large_AAA", comment:"Large text passed at level AAA") : NSLocalizedString("failed_large_AAA", comment:"Large text failed at level AAA")))
        let pasteBoard = NSPasteboard.generalPasteboard()
        pasteBoard.clearContents()
        pasteBoard.writeObjects([results])
    }
    
    //method called, when button "Show Modal Window" is pressed
    @IBAction func buttonColorPickerPressed(sender: AnyObject) {
        currentTag = sender.tag()

        // Hide the mouse
        CGDisplayHideCursor(CGMainDisplayID())
        pickerController.showWindow(nil)
    }
    @IBAction func showRGBSliders(sender: NSButton) {
        if sender.tag == 1 { // foreground
            switch sender.state {
            case NSOffState:
                foregroundSliders.hidden = true
                println("Button Off")
            case NSOnState:
                foregroundSliders.hidden = false
                println("Button On")
            default: break
            }
        } else { // background
            switch sender.state {
            case NSOffState:
                backgroundSliders.hidden = true
                println("Button Off")
            case NSOnState:
                backgroundSliders.hidden = false
                println("Button On")
            default: break
            }
        }
    }
    
    func switchRGBSliders(state: Bool) {
    
        if (state) {
            self.foregroundSliders.hidden = false
            self.backgroundSliders.hidden = false
/*
            //		[self moveView:resultsBox y:-156];
            [self moveView:foregroundBox y:78];
            //		[self moveView:backgroundBox y:78];
            [self resizeBox:backgroundBox diff:78];
            [self resizeBox:foregroundBox diff:78];
            [self resizeWindowDiff:156];
            
            [self showView:foregroundSliderBox OnView:foregroundBox];
            [self showView:backgroundSliderBox OnView:backgroundBox];
            [menuShowSliders setState:NSOnState];*/
        } else {
            self.foregroundSliders.hidden = true
            self.backgroundSliders.hidden = true
/*            [self hideView:foregroundSliderBox];
            [self hideView:backgroundSliderBox];
            [menuShowSliders setState:NSOffState];
            
            [self resizeWindowDiff:-156];
            [self resizeBox:foregroundBox diff:-78];
            [self resizeBox:backgroundBox diff:-78];
            //		[self moveView:backgroundBox y:-78];
            [self moveView:foregroundBox y:-78];
            //		[self moveView:resultsBox y:156];*/
        }
        mainWindow.contentView.setNeedsDisplay()
    }
}

extension String
{
    func replace(target: String, withString: String) -> String
    {
        return self.stringByReplacingOccurrencesOfString(target, withString: withString, options: NSStringCompareOptions.LiteralSearch, range: nil)
    }
}
