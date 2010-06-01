//
//  ActiveResourceObject.m
//  CocoaWagon
//
//  Created by Yves Vogl on 01.06.10.
//  Copyright 2010 DEETUNE. All rights reserved.
//

#import "ActiveResourceObject.h"
#import "NSString+Inflection.h"

@implementation ActiveResourceObject

@synthesize primaryKey;


+(id)withFieldSet:(NSArray *)aFieldSet {

	ActiveResourceObject *object = [ActiveResourceObject new];
	
	if (object != nil) {
		object.primaryKey = nil;
	}
	
	return object;
}

+(id)withPrimaryKey:(NSInteger)aKey row:(NSDictionary *)aRow {
	
	NSArray *fields = [aRow allKeys];
	
	ActiveResourceObject *object = [ActiveResourceObject withFieldSet:fields];
			
	if (object != nil) {
		object.primaryKey = aKey;
		[object addEntriesFromDictionary row];
	}
	
	return object;	
}





/*
// ToDo: 
// ToDo: Add a CocoaWagon instance as delegate and forward calls to "save" etc. to it



- (void)forwardInvocation:(NSInvocation *)invocation {

    SEL aSelector = [invocation selector];
		
	NSString *key = NSStringFromSelector(aSelector);
		
	if ([self objectForKey:[key underscore]]) {
	} else {
        [self doesNotRecognizeSelector:aSelector];
	}
}


- (BOOL)respondsToSelector:(SEL)aSelector {
	if ([super respondsToSelector:aSelector] || [self objectForKey:[NSStringFromSelector(aSelector) underscore]] != nil) {
		return YES;
	}	
	// ToDo: Extend to check for methods defined by associated CocoaWagon instance.
	return NO;
}
 */

@end
