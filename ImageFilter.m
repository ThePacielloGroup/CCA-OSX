//
//  ImageFilter.m
//  CCA
//
//  Created by Cédric Trévisan on 05/03/13.
//
//

#include <CoreGraphics/CoreGraphics.h>
#import "ImageFilter.h"

@implementation ImageFilter

- (void)launchSession
{
    _capture_queue = dispatch_queue_create("CCA", DISPATCH_QUEUE_SERIAL);
    
    if (!_capture_queue)
    {
        NSLog(@"Could not create desktop capture dispatch queue");
    }

    // create a new CGDisplayStream
    CGDirectDisplayID display_id;
    display_id = CGMainDisplayID();
    
    CGDisplayModeRef mode = CGDisplayCopyDisplayMode(display_id);
    size_t pixelWidth = CGDisplayModeGetPixelWidth(mode);
    size_t pixelHeight = CGDisplayModeGetPixelHeight(mode);
    
    CGDisplayModeRelease(mode);
    
    displayStream = CGDisplayStreamCreateWithDispatchQueue(display_id, pixelWidth, pixelHeight, 'BGRA', NULL, _capture_queue, ^(CGDisplayStreamFrameStatus status, uint64_t displayTime, IOSurfaceRef frameSurface, CGDisplayStreamUpdateRef updateRef)
                                                           {
                                                               NSLog(@"test");
                                                               if(status == kCGDisplayStreamFrameStatusFrameComplete && frameSurface)
                                                               {
                                                                   NSLog(@"test2");
                                                                   // As per CGDisplayStreams header
//                                                                   IOSurfaceIncrementUseCount(frameSurface);
                                                                   // -emitNewFrame: retains the frame
//                                                                   [self emitNewFrame:frameSurface];
                                                               }
                                                           });
    CGDisplayStreamStart(displayStream);
}

@end