//
//  NSManagedObject+OGDebuggingTools.m
//  OGDebuggingToolsProject
//
//  Created by Jesper on 8/30/13.
//  Copyright (c) 2013 Orange Groove. All rights reserved.
//

#import "NSManagedObject+OGDebuggingTools.h"

@implementation NSManagedObject (OGDebuggingTools)

- (NSString *)descriptionOfAttributesWithIndent:(NSInteger)indent
{
	NSMutableString* string		= [NSMutableString string];
	NSDictionary* attributes	= self.entity.attributesByName;
	
	for (NSString* key in attributes) {
		
		id val					= [self valueForKey:key];
		NSMutableString* tabs	= [NSMutableString string];
		
		if (!val)
			val = @"NULL";
		else if ([val isKindOfClass:NSData.class])
			val = [NSString stringWithFormat:@"DATA (length %lu)", (unsigned long)((NSData *)val).length];
		
		for (NSInteger i = 0; i < indent; i++)
			[tabs appendString:@"	"];
		
		[string appendFormat:@"%@%@: %@\n", tabs, key, val];
	}
	
	return [NSString stringWithString:string];
}

- (NSString *)detailedDescription
{
	NSString* objectID			= self.objectID.URIRepresentation.absoluteString;
	NSMutableString* string		= [NSMutableString stringWithFormat:@"%@ (%p) %@\n", NSStringFromClass(self.class), self, objectID];
	NSDictionary* relationships = self.entity.relationshipsByName;
	NSString* nullStr			= @"NULL\n";
	
	[string appendString:[self descriptionOfAttributesWithIndent:1]];
	
	for (NSString* key in relationships) {
		
		NSRelationshipDescription* description	= relationships[key];
		id value								= [self valueForKey:key];
		
		if (description.isToMany) {
			
			if ([value count]) {
				
				NSInteger i = 0;
				
				for (NSManagedObject* obj in value) {
					
					NSString* objID = obj.objectID.URIRepresentation.absoluteString;
					
					[string appendFormat:@"	%@ (%li: %@):\n%@", key, (long)i, objID, [obj descriptionOfAttributesWithIndent:2]];
					i++;
				}
			}
			else
				[string appendFormat:@"	%@: %@", key, nullStr];
		}
		else {
			
			id desc		= [value descriptionOfAttributesWithIndent:2];
			BOOL isNull = !desc;
			
			[string appendFormat:@"	%@:%@%@", key, isNull ? @"" : @"\n", isNull ? nullStr : desc];
		}
	}
	
	return [NSString stringWithString:string];
}

@end
