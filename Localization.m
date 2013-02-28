//
//  Localization.m
//  CCA
//
//  Created by Cedric Trevisan on 23/06/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "Localization.h"

@implementation NSApplication (askedString)

- (NSString *)Localisation:(NSString *)key 
{
    return NSLocalizedStringFromTable(key, @"Localized", nil) ;
}

@end
