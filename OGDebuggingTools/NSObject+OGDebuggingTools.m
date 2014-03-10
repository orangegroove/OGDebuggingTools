//
//  NSObject+OGDebuggingTools.m
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

#import <objc/runtime.h>
#import <JRSwizzle/JRSwizzle.h>
#import "NSObject+OGDebuggingTools.h"

static const void*		kDeallocTrackingEnabledKey	= "OGDebuggingToolsDeallocTrackingEnabledKey";
static const void*		kDeallocTrackingNoteKey		= "OGDebuggingToolsDeallocTrackingNoteKey";
static const NSNumber*	kDeallocTrackingSwizzled	= nil;

#pragma mark -
@implementation NSObject (OGDebuggingTools)

@dynamic
deallocTracking;

#pragma mark - Lifecycle

- (void)swizzledTrackingDealloc
{
	if (self.deallocTracking) {
		
		NSMutableString* string = [NSMutableString stringWithFormat:@"Deallocated: <%@:%p>", NSStringFromClass(self.class), self];
		NSString* note			= objc_getAssociatedObject(self, kDeallocTrackingNoteKey);
		
		if (note)
			[string appendFormat:@" %@", note];
		
		NSLog(@"%@", string);
	}
}

#ifdef DEBUG

- (void)setDeallocTrackingWithNote:(NSString *)note
{
	objc_setAssociatedObject(self, kDeallocTrackingEnabledKey, @YES, OBJC_ASSOCIATION_RETAIN);
	objc_setAssociatedObject(self, kDeallocTrackingNoteKey, note, OBJC_ASSOCIATION_COPY);
	
	if (!kDeallocTrackingSwizzled.boolValue) {
		
		kDeallocTrackingSwizzled = @YES;
		
		NSError* error;
		if (![NSObject jr_swizzleMethod:NSSelectorFromString(@"dealloc")
							 withMethod:@selector(swizzledTrackingDealloc)
								  error:&error])
			NSLog(@"Could not swizzle dealloc: %@", error);
	}
}

- (void)setDeallocTracking:(BOOL)deallocTracking
{
	if (deallocTracking)
		[self setDeallocTrackingWithNote:nil];
	else
		objc_setAssociatedObject(self, kDeallocTrackingEnabledKey, nil, OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)deallocTracking
{
	return ((NSNumber *)objc_getAssociatedObject(self, kDeallocTrackingEnabledKey)).boolValue;
}

#else

- (void)setDeallocTrackingWithNote:(NSString *)note
{
}

- (void)setDeallocTracking:(BOOL)referenceTracking
{
}

- (BOOL)deallocTracking
{
	return NO;
}

#endif

- (NSString *)detailedDescription
{
	unsigned int outCount;
	objc_property_t* properties	= class_copyPropertyList(self.class, &outCount);
	NSMutableString* string		= [NSMutableString stringWithFormat:@"%@ <%p>", NSStringFromClass(self.class), self];
	
	for (unsigned int i = 0; i < outCount; i++) {
		
		objc_property_t property	= properties[i];
		const char* propName		= property_getName(property);
		
		if (propName) {
			
			NSString* key	= [NSString stringWithCString:propName encoding:NSUTF8StringEncoding];
			id value		= [self valueForKey:key];
			
			if (!value)
				[string appendString:@"\n    %@: NULL"];
			else if ([value isKindOfClass:NSData.class])
				[string appendFormat:@"\n    %@ (%@): length %lu", key, NSStringFromClass([value class]), (unsigned long)((NSData *)value).length];
			else
				[string appendFormat:@"\n    %@ (%@): %@", key, NSStringFromClass([value class]), value];
			
		}
	}
	
	free(properties);
	
	return [NSString stringWithString:string];
}

@end
