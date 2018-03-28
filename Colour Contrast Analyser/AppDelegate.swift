//
//  AppDelegate.swift
//  Colour Contrast Analyser
//
//  Created by Cédric Trévisan on 26/01/2015.
//  Copyright (c) 2015 Cédric Trévisan. All rights reserved.
//

import Cocoa
import CoreGraphics

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    let cca_url = "http://www.paciellogroup.com/resources/contrast-analyser.html"
    
    var foreground: CCAColourForeground = CCAColourForeground.sharedInstance
    var background: CCAColourBackground = CCAColourBackground.sharedInstance

    @IBOutlet weak var mainWindow: NSWindow!
    @IBOutlet weak var luminosity: CCALuminosityControler!
    @IBOutlet weak var colorBrightnessDifference: CCAColourBrightnessDifferenceController!
    @IBOutlet weak var colorProfilesMenu: NSMenu!
    
    var preferencesController = CCAPreferencesController(windowNibName: NSNib.Name(rawValue: "Preferences"))
    
    let userDefaults = UserDefaults.standard
    
    // Called on ColorProfiles menuitem selection
    @objc func setColorProfile(sender : NSMenuItem) {
        let screenNumber = sender.parent?.representedObject as! CGDirectDisplayID
        let colorProfile = sender.representedObject as! NSColorSpace

        // Save into preferences
        var data = userDefaults.object(forKey: "CCAColorProfiles") as! Data
        var colorProfiles = NSKeyedUnarchiver.unarchiveObject(with: data) as! [CGDirectDisplayID : NSColorSpace]
        colorProfiles[screenNumber] = colorProfile
        data = NSKeyedArchiver.archivedData(withRootObject: colorProfiles as Any)
        userDefaults.set(data, forKey: "CCAColorProfiles")

        // Clear and set menuitems state
        for menuItem in (sender.menu?.items)! {
            if (colorProfile.isEqual(menuItem.representedObject)) {
                menuItem.state = NSControl.StateValue(rawValue: 1)
            } else {
                menuItem.state = NSControl.StateValue(rawValue: 0)
            }
        }
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Initialise Preferences
        if userDefaults.string(forKey: "CCAResultsFormat") == nil {
            userDefaults.set(NSLocalizedString("results_format", comment:"Initial Results format text"), forKey: "CCAResultsFormat")
        }
        
        var colorProfiles = [CGDirectDisplayID: NSColorSpace]()
        
        if userDefaults.object(forKey: "CCAColorProfiles") == nil {
            let data = NSKeyedArchiver.archivedData(withRootObject: colorProfiles as Any)
            userDefaults.set(data, forKey: "CCAColorProfiles")
        } else {
            let data = userDefaults.object(forKey: "CCAColorProfiles") as! Data
            colorProfiles = NSKeyedUnarchiver.unarchiveObject(with: data) as! [CGDirectDisplayID : NSColorSpace]
        }

        // Create the color profile menu
        let colorSpaces = NSColorSpace.availableColorSpaces(with: .RGB)
        colorProfilesMenu.removeAllItems()
        let screens = NSScreen.screens
        for screen in screens {
            let screenNumber = screen.number
            if (colorProfiles[screenNumber] == nil) {
                // Init with screen color profile
                colorProfiles[screenNumber] = screen.colorSpace
            }
            // Save the default preferences
            let data = NSKeyedArchiver.archivedData(withRootObject: colorProfiles as Any)
            userDefaults.set(data, forKey: "CCAColorProfiles")
            
            let screenColorProfile = colorProfiles[screenNumber]

            let colorSpacesMenu = NSMenu()
            for colorSpace in colorSpaces {
                let menuItem = NSMenuItem(title: colorSpace.localizedName!, action: #selector(AppDelegate.setColorProfile(sender:)), keyEquivalent: "")
                menuItem.representedObject = colorSpace
                if (colorSpace.isEqual(screenColorProfile)) {
                    menuItem.state = NSControl.StateValue(rawValue: 1)
                }
                colorSpacesMenu.addItem(menuItem)
            }

            let menuItem = NSMenuItem(title:screen.displayName, action:nil,  keyEquivalent:"")
            menuItem.representedObject = screenNumber
            menuItem.submenu = colorSpacesMenu
            colorProfilesMenu.addItem(menuItem)

        }
        colorProfilesMenu.update()
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
