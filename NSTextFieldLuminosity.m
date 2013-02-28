#import "NSTextFieldLuminosity.h"

@implementation NSTextFieldLuminosity

-(void)initWithLevel:(Level)l Size:(FontSize)s
{
	level = l;
	size = s;
	currentStatus = YES;
	[self setFail];
}

-(void)validateText:(float)contrastRatio
{
	if (level == LEVEL_AA && size == SIZE_NORMAL) {
		if (contrastRatio < 4.5) {
			[self setFail];
		} else {
			[self setPass];
		}
	} else if (level == LEVEL_AAA && size == SIZE_NORMAL) {
		if (contrastRatio < 7) {
			[self setFail];
		} else {
			[self setPass];
		}
	} else if (level == LEVEL_AA && size == SIZE_LARGE) {
		if (contrastRatio < 3) {
			[self setFail];
		} else {
			[self setPass];
		}
	} else { // level == LEVEL_AAA && size == SIZE_LARGE
		if (contrastRatio < 4.5) {
			[self setFail];
		} else {
			[self setPass];
		}
	}
}

-(void)setFail
{
	if (currentStatus == YES) {
		[self setText:[NSApp Localisation:@"Fail"]];
		[statusImage setImage:[NSImage imageNamed:@"No"]];
		currentStatus = NO;
	}
}

-(void)setPass
{
	if (currentStatus == NO) {
		[self setText:[NSApp Localisation:@"Pass"]];
		[statusImage setImage:[NSImage imageNamed:@"Yes"]];
		currentStatus = YES;
	}
}

-(void)setText:(NSString *)text
{
	if (level == LEVEL_AA) {
		text = [text stringByAppendingString:@" (AA)"];
	} else { // level == LEVEL_AAA
		text = [text stringByAppendingString:@" (AAA)"];
	}
	[super setStringValue:text];
}

-(NSString *)getStatus
{
	NSString *res;
	if (size == SIZE_NORMAL) {
		res = [NSApp Localisation:@"Text"];
	} else { // SIZE_LARGE
		res = [NSApp Localisation:@"Large text"];
	}
	
	res = [res stringByAppendingString:@" "];
	
	if (currentStatus == YES) {
		res = [res stringByAppendingString:[NSApp Localisation:@"passed at level"]];
	} else { // NO
		res = [res stringByAppendingString:[NSApp Localisation:@"failed at level"]];
	}
	
	if (level == LEVEL_AA) {
		res = [res stringByAppendingString:@" AA"];
	} else { // level == LEVEL_AAA
		res = [res stringByAppendingString:@" AAA"];
	}
	return res;
}

@end
