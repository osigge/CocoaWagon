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

@synthesize primaryKey, fields;

// ToDo: Forward remote actions to wagon instance unless it's nil

-(id)init {
	
	self = [super init];
	
	if (self != nil) {
		dictionary = [[NSMutableDictionary alloc] init];	
	}
	
	return self;
}

-(id)initWithWagon:(CocoaWagon *)aWagon {
	
	self = [self init];
	
	if (self != nil) {
		wagon = [aWagon retain];	
	}
	
	return self;
	
}

-(void)dealloc {	
	self.fields = nil;
	[dictionary release];
	[wagon release];
	[super dealloc];
}


+(id)withFieldSet:(NSArray *)aFieldSet wagon:(CocoaWagon *)aWagon {

	ActiveResourceObject *object = [[[ActiveResourceObject alloc] initWithWagon:aWagon] autorelease];
	
	if (object != nil) {
		object.primaryKey = 0;
		object.fields = aFieldSet;		
	}
	
	return object;
}

+(id)withPrimaryKey:(NSInteger)aKey row:(NSDictionary *)aRow wagon:(CocoaWagon *)aWagon {
	
	NSArray *fields = [aRow allKeys];
	
	ActiveResourceObject *object = [ActiveResourceObject withFieldSet:fields wagon:aWagon];
			
	if (object != nil) {
		object.primaryKey = aKey;
		[object addEntriesFromDictionary:aRow];
	}
	
	return object;	
}

-(void)addEntriesFromDictionary:(NSDictionary *)aDictionary {
	[dictionary addEntriesFromDictionary:aDictionary];
}

-(void)setObject:(id)anObject forKey:(NSString *)aKey {
	[dictionary setObject:anObject forKey:aKey];
}

-(id)objectForKey:(NSString *)aKey {
	return [dictionary objectForKey:aKey];
}




@end
