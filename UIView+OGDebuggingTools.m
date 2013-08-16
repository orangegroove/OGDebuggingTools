//
//  UIView+OGDebuggingTools.m
//
//  Created by Jesper <jesper@orangegroove.net>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to
//  deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//  IN THE SOFTWARE.
//

#import "UIView+OGDebuggingTools.h"

@interface UIView (OGDebuggingToolsPrivate)

+ (NSString *)logStringForSubviewsOfView:(UIView *)view depth:(NSInteger)depth;
+ (NSString *)logDescriptionOfView:(UIView *)view;
+ (NSString *)string:(NSString *)string repeated:(NSInteger)repeated;

@end
@implementation UIView (OGDebuggingTools)

#pragma mark - Public

+ (void)logViewHierarchy
{
	NSMutableString* string = [NSMutableString string];
	
	for (UIWindow* window in [UIApplication sharedApplication].windows) {
		
		[string appendString:[self logDescriptionOfView:window]];
		[string appendString:[self logStringForSubviewsOfView:window depth:1]];
	}
	
	NSLog(@"\n%@\n", string);
}

- (void)logSubviewHierarchy
{
	NSMutableString* string = [NSMutableString string];
	
	[string appendString:[self.class logDescriptionOfView:self]];
	[string appendString:[self.class logStringForSubviewsOfView:self depth:1]];
	
	NSLog(@"\n%@\n", string);
}

#pragma mark - Helpers

+ (NSString *)logStringForSubviewsOfView:(UIView *)view depth:(NSInteger)depth
{
	NSMutableString* string = [NSMutableString stringWithFormat:@"%@%@\n", [self string:@"	" repeated:depth], [self logDescriptionOfView:view]];
	
	for (UIView* subview in view.subviews)
		[string appendString:[self logStringForSubviewsOfView:subview depth:depth+1]];
	
	return string;
}

+ (NSString *)logDescriptionOfView:(UIView *)view
{
	return [NSString stringWithFormat:@"%@", view];
}

+ (NSString *)string:(NSString *)string repeated:(NSInteger)repeated
{
	if (repeated < 1)
		return @"";
	
	NSMutableString* repeatedString = [NSMutableString string];
	
	for (NSInteger i = 0; i < repeated; i++)
		[repeatedString appendString:string];
	
	return [NSString stringWithString:repeatedString];
}

@end
