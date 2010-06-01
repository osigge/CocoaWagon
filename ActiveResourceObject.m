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


+(id)withPrimaryKey:(NSInteger)aKey {

	ActiveResourceObject *object = [ActiveResourceObject new];
	
	if (object != nil) {
		[object setObject:[NSNumber numberWithInt:aKey] forKey:@"primaryKey"];
	}
	
	return object;
}


// ToDo: Make properties writable and implement dirty object tracking for object updating capabilities
// ToDo: Add a CocoaWagon instance as delegate and forward calls to "save" etc. to it



- (void)forwardInvocation:(NSInvocation *)invocation {

    SEL aSelector = [invocation selector];
	
	NSLog(@"Try to access dynamic property: %@", NSStringFromSelector(aSelector));
	
	NSString *key = NSStringFromSelector(aSelector);
		
	if ([self objectForKey:[key underscore]]) {
	} else {
        [self doesNotRecognizeSelector:aSelector];
	}
}


- (BOOL)respondsToSelector:(SEL)aSelector {
	if ([super respondsToSelector:aSelector]) {
		return YES;
	}	
	return NO;
}

@end
