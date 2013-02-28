/* NSTextFieldLuminosity */

#import <Cocoa/Cocoa.h>
#import "Localization.h"

	typedef enum {
		LEVEL_AA,
		LEVEL_AAA
	} Level;
	
	typedef enum {
		SIZE_NORMAL,
		SIZE_LARGE
	} FontSize;
	
@interface NSTextFieldLuminosity : NSTextField
{
	Level level;
	FontSize size;
	bool currentStatus;
	IBOutlet NSImageView *statusImage;
}

-(void)initWithLevel:(Level)l Size:(FontSize)s;
-(void)validateText:(float)contrastRatio;
-(void)setFail;
-(void)setPass;
-(void)setText:(NSString *)text;
-(NSString *)getStatus;

@end
