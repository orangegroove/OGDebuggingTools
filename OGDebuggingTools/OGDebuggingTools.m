//
//  OGDebuggingTools.m
//  OGDebuggingToolsProject
//
//  Created by Jesper on 8/30/13.
//  Copyright (c) 2013 Orange Groove. All rights reserved.
//

#include "OGDebuggingTools.h"

#pragma mark - Private

static NSString* _OGNameFromCallStackSymbol(NSString* symbol)
{
	if (symbol.length > 51)
		return [symbol substringFromIndex:51];
	
	return symbol;
}

static void _OGLogAny(NSString* format, va_list args)
{
	NSString* string		= [[NSString alloc] initWithFormat:format arguments:args];
	NSArray* skipSymbols	= @[@"_OGLogAny", @"_Z5OGLogAny"];
	NSArray* symbols		= [NSThread callStackSymbols];
	NSString* function		= @"Unknown function";
	
	for (NSString* symbol in symbols) {
		
		NSString* stripped	= _OGNameFromCallStackSymbol(symbol);
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

#pragma mark - Public

NSString* OGCallingFunction(void)
{
	NSArray* symbols = [NSThread callStackSymbols];
	
	if (symbols.count > 1)
		return _OGNameFromCallStackSymbol(symbols[2]);
	
	return nil;
}

void __attribute__((overloadable)) OGLogAny(void)
{
	void * args = NULL;
	
	_OGLogAny(@"", args);
}

void __attribute__((overloadable)) OGLogAny(NSString* format, ...)
{
	va_list args;
	va_start(args, format);
	
	_OGLogAny(format, args);
	
	va_end(args);
}

void __attribute__((overloadable))	OGLogAny(float value)
{
	OGLogAny(@"%f", value);
}

void __attribute__((overloadable))	OGLogAny(double value)
{
	OGLogAny(@"%f", value);
}

void __attribute__((overloadable))	OGLogAny(int value)
{
	OGLogAny(@"%d", value);
}

void __attribute__((overloadable))	OGLogAny(unsigned int value)
{
	OGLogAny(@"%u", value);
}

void __attribute__((overloadable))	OGLogAny(long value)
{
	OGLogAny(@"%ld", value);
}

void __attribute__((overloadable))	OGLogAny(unsigned long value)
{
	OGLogAny(@"%lu", value);
}

void __attribute__((overloadable))	OGLogAny(long long value)
{
	OGLogAny(@"%lld", value);
}

void __attribute__((overloadable))	OGLogAny(unsigned long long value)
{
	OGLogAny(@"%llu", value);
}

void __attribute__((overloadable))	OGLogAny(CGPoint value)
{
	OGLogAny(@"%@", NSStringFromCGPoint(value));
}

void __attribute__((overloadable))	OGLogAny(CGSize value)
{
	OGLogAny(@"%@", NSStringFromCGSize(value));
}

void __attribute__((overloadable))	OGLogAny(CGRect value)
{
	OGLogAny(@"%@", NSStringFromCGRect(value));
}

void __attribute__((overloadable))	OGLogAny(id value)
{
	OGLogAny(@"%@", value);
}
