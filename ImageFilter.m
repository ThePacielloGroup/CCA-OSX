//
//  ImageFilter.m
//  CCA
//
//  Created by Cédric Trévisan on 05/03/13.
//
//

#import "ImageFilter.h"
#import <AVFoundation/AVFoundation.h>

@interface ImageFilter ()

@property IBOutlet NSView *captureView;

@property (strong, nonatomic) NSObject *uIImage;

-(void)addCaptureVideoPreview;

@end

@implementation ImageFilter
{
    CGDirectDisplayID           display;
    AVCaptureMovieFileOutput    *captureMovieFileOutput;
}

#pragma mark Capture

-(void)createSession
{
    /* Create a capture session. */
    self.captureSession = [[AVCaptureSession alloc] init];
	if ([self.captureSession canSetSessionPreset:AVCaptureSessionPresetHigh])
    {
      /* Specifies capture settings suitable for high quality video and audio output. */
		[self.captureSession setSessionPreset:AVCaptureSessionPresetHigh];
    }

    /* Add the main display as a capture input. */
    display = CGMainDisplayID();
    self.captureScreenInput = [[AVCaptureScreenInput alloc] initWithDisplayID:display];
    
//    CGRect cropRect = [self.captureView frame];
    
    /* Set the bounding rectangle of the screen area to be captured, in pixels. */
//    [self.captureScreenInput setCropRect:cropRect];
    
    if ([self.captureSession canAddInput:self.captureScreenInput])
    {
        [self.captureSession addInput:self.captureScreenInput];
    }
    
    /* Add a movie file output + delegate. */
    captureMovieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
    [captureMovieFileOutput setDelegate:self];
    if ([self.captureSession canAddOutput:captureMovieFileOutput])
    {
        [self.captureSession addOutput:captureMovieFileOutput];
    }
    
    /* Register for notifications of errors during the capture session so we can display an alert. */
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(captureSessionRuntimeErrorDidOccur:) name:AVCaptureSessionRuntimeErrorNotification object:self.captureSession];
    
    [self addCaptureVideoPreview];
    
    /* Start the capture session running. */
    [self.captureSession startRunning];
}

/*
 AVCaptureVideoPreviewLayer is a subclass of CALayer that you use to display
 video as it is being captured by an input device.
 
 You use this preview layer in conjunction with an AV capture session.
 */
-(void)addCaptureVideoPreview
{
    NSLog(@"A");
    /* Create a video preview layer. */
	AVCaptureVideoPreviewLayer *videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
    NSLog(@"B");
    
    /* Configure it.*/
	[videoPreviewLayer setFrame:[[self.captureView layer] bounds]];
//	[videoPreviewLayer setAutoresizingMask:kCALayerWidthSizable|kCALayerHeightSizable];
    NSLog(@"C");
    
    /* Add the preview layer as a sublayer to the view. */
    [[self.captureView layer] addSublayer:videoPreviewLayer];
    /* Specify the background color of the layer. */
//	[[self.captureView layer] setBackgroundColor:CGColorGetConstantColor(kCGColorBlack)];
    NSLog(@"D");
}

// AVCaptureFileOutputRecordingDelegate methods

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error
{
    NSLog(@"Did finish recording to %@ due to error %@", [outputFileURL description], [error description]);
    
    // Stop running the session
//    [mSession stopRunning];
    
    // Release the session
//    [mSession release];
//    mSession = nil;
}

- (BOOL)captureOutputShouldProvideSampleAccurateRecordingStart:(AVCaptureOutput *)captureOutput
{
	// We don't require frame accurate start when we start a recording. If we answer YES, the capture output
    // applies outputSettings immediately when the session starts previewing, resulting in higher CPU usage
    // and shorter battery life.
	return NO;
}

- (void)captureSessionRuntimeErrorDidOccur:(NSNotification *)notification
{
	NSError *error = [[notification userInfo] objectForKey:AVCaptureSessionErrorKey];
	if ([error localizedDescription]) {
		if ([error localizedFailureReason]) {
			NSRunAlertPanel(@"AVScreenShack Alert",
							[NSString stringWithFormat:@"%@\n\n%@", [error localizedDescription], [error localizedFailureReason]],
							nil, nil, nil);
		}
		else {
			NSRunAlertPanel(@"AVScreenShack Alert",
							[NSString stringWithFormat:@"%@", [error localizedDescription]],
							nil, nil, nil);
		}
	}
	else {
		NSRunAlertPanel(@"AVScreenShack Alert",
						@"An unknown error occured",
				 		nil, nil, nil);
	}
}

@end
