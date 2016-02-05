import Cocoa

extension NSColor {
    
    convenience init?(redInt: Int, greenInt: Int, blueInt:Int) {
        self.init(red: CGFloat(redInt) / 255.0, green: CGFloat(greenInt) / 255.0, blue: CGFloat(blueInt) / 255.0, alpha: 1.0)
    }

    convenience init?(redDouble: Double, greenDouble: Double, blueDouble:Double) {
        self.init(red: CGFloat(redDouble), green: CGFloat(greenDouble), blue: CGFloat(blueDouble), alpha: 1.0)
    }
  /**
    Create non-autoreleased color with in the given hex string
    Alpha will be set as 1 by default
    
    :param:   hexString
    :returns: color with the given hex string
  */
  convenience init?(hexString: String) {
    self.init(hexString: hexString, alpha: 1.0)
  }

  /**
    Create non-autoreleased color with in the given hex string and alpha
    
    :param:   hexString
    :param:   alpha
    :returns: color with the given hex string and alpha
  */
  convenience init?(hexString: String, alpha: Float) {
    var hex = hexString
    
    // Check for hash and remove the hash
    if hex.hasPrefix("#") {
      hex = hex.substringFromIndex(hex.startIndex.advancedBy(1))
    }
    
    if (hex.rangeOfString("(^[0-9A-Fa-f]{6}$)|(^[0-9A-Fa-f]{3}$)", options: .RegularExpressionSearch) != nil) {
        // Deal with 3 character Hex strings
        if (hex.characters.count == 3) {
          let redHex   = hex.substringToIndex(hex.startIndex.advancedBy(1))
          let greenHex = hex.substringWithRange(Range<String.Index>(start: hex.startIndex.advancedBy(1), end: hex.startIndex.advancedBy(2)))
          let blueHex  = hex.substringFromIndex(hex.startIndex.advancedBy(2))
          
          hex = redHex + redHex + greenHex + greenHex + blueHex + blueHex
        }

        let redHex = hex.substringToIndex(hex.startIndex.advancedBy(2))
        let greenHex = hex.substringWithRange(Range<String.Index>(start: hex.startIndex.advancedBy(2), end: hex.startIndex.advancedBy(4)))
        let blueHex = hex.substringWithRange(Range<String.Index>(start: hex.startIndex.advancedBy(4), end: hex.startIndex.advancedBy(6)))
        
        var redInt:   CUnsignedInt = 0
        var greenInt: CUnsignedInt = 0
        var blueInt:  CUnsignedInt = 0

        NSScanner(string: redHex).scanHexInt(&redInt)
        NSScanner(string: greenHex).scanHexInt(&greenInt)
        NSScanner(string: blueHex).scanHexInt(&blueInt)

        self.init(red: CGFloat(redInt) / 255.0, green: CGFloat(greenInt) / 255.0, blue: CGFloat(blueInt) / 255.0, alpha: CGFloat(alpha))
    }
    else {
        // Note:
        // The swift 1.1 compiler is currently unable to destroy partially initialized classes in all cases,
        // so it disallows formation of a situation where it would have to.  We consider this a bug to be fixed
        // in future releases, not a feature. -- Apple Forum
        self.init()
        return nil
    }
  }

  /**
    Create non-autoreleased color with in the given hex value
    Alpha will be set as 1 by default
    
    :param:   hex
    :returns: color with the given hex value
  */
  convenience init?(hex: Int) {
    self.init(hex: hex, alpha: 1.0)
  }
  
  /**
    Create non-autoreleased color with in the given hex value and alpha
    
    :param:   hex
    :param:   alpha
    :returns: color with the given hex value and alpha
  */
  convenience init?(hex: Int, alpha: Float) {
    let hexString = NSString(format: "%2X", hex) as String
    self.init(hexString: hexString, alpha: alpha)
  }

    func getHexString() -> String {
        let red = Int(round(self.redComponent * 0xFF))
        let grn = Int(round(self.greenComponent * 0xFF))
        let blu = Int(round(self.blueComponent * 0xFF))
        let hexString = NSString(format: "#%02X%02X%02X", red, grn, blu) as String
        return hexString
    }
    
    func getRInt() -> Int {
        return Int(round(self.redComponent * 255))
    }
    func getGInt() -> Int {
        return Int(round(self.greenComponent * 255))
    }
    func getBInt() -> Int {
        return Int(round(self.blueComponent * 255))
    }
    func getRDouble() -> Double {
        return Double(round(self.redComponent * 255))
    }
    func getGDouble() -> Double {
        return Double(round(self.greenComponent * 255))
    }
    func getBDouble() -> Double {
        return Double(round(self.blueComponent * 255))
    }
    
    
    func getSRGBColor() -> NSColor {
        let sRGB:NSColorSpace = NSColorSpace.genericRGBColorSpace()
        let components = [self.redComponent, self.greenComponent, self.blueComponent]
        return NSColor(colorSpace:sRGB, components:components, count:4);
    }
    
    func grayScaleComponent() -> CGFloat {
        return (
            0.29900 * self.redComponent +
            0.58700 * self.greenComponent +
            0.11400 * self.blueComponent
        )
    }
    
    func isBlack() -> Bool {
        return (self.redComponent == 0 && self.greenComponent == 0 && self.blueComponent == 0)
    }
}
