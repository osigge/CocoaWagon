//
//  CocoaWagon.m
//  CocoaWagon
//
//  Created by Yves Vogl on 01.06.10.
//  Copyright 2010 DEETUNE. All rights reserved.
//

#import "CocoaWagon.h"


@implementation CocoaWagon

@synthesize resourceURL, apiKey;

-(id)init {	
	self = [super init];
	
	if (self != nil) {
		if ([[self class] isEqual:[CocoaWagon class]]) {
			[NSException raise:@"Abstract Class Exception" format:@"Error, attempting to instantiate CocoaWagon directly."];
			[self release]; 
			return nil; 
		}
	}
	
	return self;	
}


-(id)initWithResourceURL:(NSString *)anURLString {
	self = [self init];

	if (self != nil) {
		self.resourceURL = [NSURL URLWithString:anURLString];
	}
	
	return self;
}


-(id)initWithResourceURL:(NSString *)anURLString apiKey:(NSString *)aKey {
	
	self = [self initWithResourceURL:anURLString];
	
	if (self != nil) {
		self.apiKey = aKey;
	}
	
	return self;
}


-(void)dealloc {	
	self.resourceURL = nil;
	self.apiKey = nil;
	[super dealloc];	
}


#pragma mark API Methods

-(NSDictionary *)all {
	
	NSMutableDictionary *objects = [NSMutableDictionary new];
	
	ActiveResourceObject *object = [ActiveResourceObject withPrimaryKey:1];
	
	
	
	//Ac contains id as key
	
	return (NSDictionary *)objects;
}

// Note: Class attributes are set programmatically and added as Keys to a NSDictionary. The dictionary itself is added to a global dictionary.
// ToDo: Define didRespondWithStatusCode etc. as delegates in a protocol



@end
