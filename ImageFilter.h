//
//  ImageFilter.h
//  CCA
//
//  Created by Cédric Trévisan on 05/03/13.
//
//

#import <Cocoa/Cocoa.h>
#import <AVFoundation/AVCaptureOutput.h>

@class AVCaptureSession, AVCaptureScreenInput, AVCaptureMovieFileOutput;

@interface ImageFilter : NSObject <AVCaptureFileOutputDelegate,AVCaptureFileOutputRecordingDelegate>

@property (strong) AVCaptureSession *captureSession;
@property (strong) AVCaptureScreenInput *captureScreenInput;

-(void)createSession;

@end
