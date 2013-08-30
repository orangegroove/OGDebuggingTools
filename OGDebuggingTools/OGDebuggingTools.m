//
//  OGDebuggingTools.m
//  OGDebuggingToolsProject
//
//  Created by Jesper on 8/30/13.
//  Copyright (c) 2013 Orange Groove. All rights reserved.
//

#include "OGDebuggingTools.h"

static void _OGLog(NSString* format, va_list args)
{
	NSString* string		= [[NSString alloc] initWithFormat:format arguments:args];
	NSArray* skipSymbols	= @[@"_OGLog", @"_Z5OGLog"];
	NSArray* symbols		= [NSThread callStackSymbols];
	NSString* function		= @"Unknown function";
	
	for (NSString* symbol in symbols) {
		
		NSString* stripped	= [symbol substringFromIndex:51];
		BOOL skip			= NO;
		
		for (NSString* skipSymbol in skipSymbols)
			if ([stripped hasPrefix:skipSymbol]) {
				
				skip = YES;
				break;
			}
		
		if (skip)
			continue;
		
		function = stripped;
		break;
	}
	
	NSLog(@"\n%@\n%@", function, string);
}

void __attribute__((overloadable)) OGLog(void)
{
	void * args = NULL;
	
	_OGLog(@"", args);
}

void __attribute__((overloadable)) OGLog(NSString* format, ...)
{
	va_list args;
	va_start(args, format);
	
	_OGLog(format, args);
	
	va_end(args);
}

void __attribute__((overloadable))	OGLog(float value)
{
	OGLog(@"%f", value);
}

void __attribute__((overloadable))	OGLog(double value)
{
	OGLog(@"%f", value);
}

void __attribute__((overloadable))	OGLog(int value)
{
	OGLog(@"%d", value);
}

void __attribute__((overloadable))	OGLog(unsigned int value)
{
	OGLog(@"%d", value);
}

void __attribute__((overloadable))	OGLog(long value)
{
	OGLog(@"%ld", value);
}

void __attribute__((overloadable))	OGLog(long long value)
{
	OGLog(@"%lld", value);
}

void __attribute__((overloadable))	OGLog(id value)
{
	OGLog(@"%@", value);
}
