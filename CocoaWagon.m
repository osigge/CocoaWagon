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

-(id)initWithDelegate:(NSObject <CocoaWagonDelegate> *)theDelegate {
	
	self = [self init];
	
	if (self != nil) {
		delegate = theDelegate;
	}
	
	return self;	
}


-(id)initWithResourceURL:(NSString *)anURLString delegate:(NSObject <CocoaWagonDelegate> *)theDelegate {
	
	self = [self initWithDelegate:theDelegate];
	
	if (self != nil) {
		self.resourceURL = [NSURL URLWithString:anURLString];
	}
	
	return self;
}


-(id)initWithResourceURL:(NSString *)anURLString apiKey:(NSString *)aKey delegate:(NSObject <CocoaWagonDelegate> *)theDelegate {
	
	self = [self initWithResourceURL:anURLString delegate:theDelegate];
	
	if (self != nil) {
		self.apiKey = aKey;
	}
	
	return self;
}


-(void)dealloc {	
	delegate = nil;
	self.resourceURL = nil;
	self.apiKey = nil;
	self.fields = nil;
	[super dealloc];	
}


#pragma mark API Methods

-(NSArray *)all {
	
	NSMutableArray *objects = [NSMutableArray new];

	return (NSArray *)objects;
}



@end
