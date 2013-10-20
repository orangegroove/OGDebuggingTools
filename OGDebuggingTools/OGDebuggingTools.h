//
//  OGDebuggingTools.h
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

#import <Foundation/Foundation.h>

#import "NSManagedObject+OGDebuggingTools.h"
#import "NSObject+OGDebuggingTools.h"
#import "UIView+OGDebuggingTools.h"

#define OGLog(f, ...) NSLog((@"\n%s[%d] <- %@\n" f),__func__,__LINE__,OGCallingFunction(),##__VA_ARGS__)

NSString*									OGCallingFunction(void);
void		__attribute__((overloadable))	OGLogAny(void);
void		__attribute__((overloadable))	OGLogAny(NSString* format, ...);
void		__attribute__((overloadable))	OGLogAny(float value);
void		__attribute__((overloadable))	OGLogAny(double value);
void		__attribute__((overloadable))	OGLogAny(int value);
void		__attribute__((overloadable))	OGLogAny(unsigned int value);
void		__attribute__((overloadable))	OGLogAny(long value);
void		__attribute__((overloadable))	OGLogAny(unsigned long value);
void		__attribute__((overloadable))	OGLogAny(long long value);
void		__attribute__((overloadable))	OGLogAny(unsigned long long value);
void		__attribute__((overloadable))	OGLogAny(CGPoint value);
void		__attribute__((overloadable))	OGLogAny(CGSize value);
void		__attribute__((overloadable))	OGLogAny(CGRect value);
void		__attribute__((overloadable))	OGLogAny(id value);
