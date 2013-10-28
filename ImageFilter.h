//
//  ImageFilter.h
//  CCA
//
//  Created by Cédric Trévisan on 05/03/13.
//
//

#import <Quartz/Quartz.h>
#include <CoreGraphics/CoreGraphics.h>

@interface ImageFilter: NSObject
{
    CGDisplayStreamRef displayStream;
    dispatch_queue_t _capture_queue;
}

- (void)launchSession;

@end
