//
//  CocoaWagon.m
//  CocoaWagon
//
//  Created by Yves Vogl on 01.06.10.
//  Copyright 2010 DEETUNE. All rights reserved.
//

#import "CocoaWagon.h"


@implementation CocoaWagon

@synthesize resourceURL, apiKey, fields;

-(id)init {	
	self = [super init];
	
	if (self != nil) {
		if ([[self class] isEqual:[CocoaWagon class]]) {
			[NSException raise:@"Abstract Class Exception" format:@"Error, attempting to instantiate CocoaWagon directly."];
			[self release]; 
			return nil; 
		}
		
		self.fields = [NSArray arrayWithObject:@"id"];
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
	self.fields = nil;
	[super dealloc];	
}


#pragma mark API Methods

-(NSDictionary *)all {
	
	NSMutableArray *objects = [NSMutableArray new];
	
	// Primarykey will be added by API
	NSInteger primaryKey = 42;
	
	ActiveResourceObject *object = [ActiveResourceObject withPrimaryKey:primaryKey fieldSet:self.fields];	
	[objects addObject:object];
	return (NSArray *)objects;
}


// ToDo: Define didRespondWithStatusCode etc. as delegates in a protocol



@end
