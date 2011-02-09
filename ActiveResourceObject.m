//
//  ActiveResourceObject.m
//  CocoaWagon
//
//  Created by Yves Vogl on 01.06.10.
//  Copyright 2010 DEETUNE. All rights reserved.
//

#import "ActiveResourceObject.h"
#import "CocoaWagon.h"

@implementation ActiveResourceObject

@synthesize primaryKey, wagon;

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
		self.wagon = aWagon;	
		//wagon = aWagon;
	}
	
	return self;
	
}

-(void)dealloc {	
	[dictionary release];
	self.wagon = nil;
	[super dealloc];
}


+(id)withWagon:(CocoaWagon *)aWagon {

	ActiveResourceObject *object = [[[ActiveResourceObject alloc] initWithWagon:aWagon] autorelease];
	
	if (object != nil) {
		object.primaryKey = 0;
	}
	
	return object;
}

+(id)withPrimaryKey:(NSUInteger)aKey row:(NSDictionary *)aRow wagon:(CocoaWagon *)aWagon {
	
	ActiveResourceObject *object = [ActiveResourceObject withWagon:aWagon];
			
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

-(NSArray *)fields {
	return [dictionary allKeys];
}

-(NSArray *)values {
	return [dictionary allValues];
}

-(NSDictionary *)dictionary {
	// Consider returning a copy of it - at the first thought returning a retained object makes sense to keep the connection to the object when modifying
	return [[dictionary retain] autorelease];
}


-(BOOL)save {
	if ([self newRecord]) {
		return [self.wagon create:self];
	}
	return NO;
}

-(BOOL)update {
	return [self.wagon update:self];	
}

-(BOOL)destroy {
	return [self.wagon destroy:self];	
}

-(BOOL)newRecord {
	return self.primaryKey == 0;
}



@end
