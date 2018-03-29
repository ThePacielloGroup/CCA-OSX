//
//  Colour Contrast Analyser
//
//  Created by Cédric on 28/03/2018.
//  Copyright © 2018 Cédric Trévisan. All rights reserved.
//

import Foundation

class RGBAColorFormatter : Formatter {
    override func getObjectValue(_ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?, for string: String, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
        obj?.pointee = string as AnyObject
//        error?.pointee = "Test"
        return true
    }
    
    override func string(for obj: Any?) -> String? {
        if let string = obj as? String {
            return string
        }
        return nil
    }
    
    override func isPartialStringValid(_ partialString: String, newEditingString newString: AutoreleasingUnsafeMutablePointer<NSString?>?, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {

        if partialString.isEmpty { return true }  //allow empty field

        let disallowedChars = NSCharacterSet(charactersIn: "0123456789RGBArgba() ,.").inverted
        if let _ = partialString.rangeOfCharacter(from: disallowedChars, options:.caseInsensitive) {
            error?.pointee = "Invalid RGB/RGBA entry."
            return false
        }
        newString?.pointee = partialString.uppercased() as NSString
        return true
    }        
}
