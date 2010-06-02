//
//  CocoaWagon.m
//  CocoaWagon
//
//  Created by Yves Vogl on 01.06.10.
//  Copyright 2010 DEETUNE. All rights reserved.
//

#import "CocoaWagon.h"
#import "NSString+Inflection.h"

@implementation CocoaWagon

@synthesize apiKey, fields;

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


-(id)initWithApiKey:(NSString *)aKey delegate:(NSObject <CocoaWagonDelegate> *)theDelegate {
	
	self = [self initWithDelegate:theDelegate];
	
	if (self != nil) {
		self.apiKey = aKey;
	}
	
	return self;
}

-(void)dealloc {	
	delegate = nil;
	self.apiKey = nil;
	self.fields = nil;
	[super dealloc];	
}


#pragma mark API Methods

-(NSArray *)all {
	/*
	self.resourceURL + [[self resourceName] + [self format]
	
	/fotos.xml
	*/
	NSMutableArray *objects = [NSMutableArray new];

	return (NSArray *)objects;
}

#pragma mark ActiveResource Protocol
						
-(NSString *)resourceBaseURL {
	return @"https://example.com";
}

/*
 * Resource name will be derived from class name
 */
-(NSString *)resourceName {
	return [[[self class] description] underscore];
}

/*
 * Communication format.
 */
-(NSString *)format {
	return @"xml";
}

-(NSURL *)resourceURL {
	return [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", [self resourceBaseURL], [self resourceName]]];
}



@end
