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


-(id)init {
	
	self = [super init];
	
	if (self != nil) {
		dictionary = [[NSMutableDictionary alloc] init];	
	}
	
	return self;
}

-(void)dealloc {	
	self.fields = nil;
	[dictionary release];
	[super dealloc];
}


+(id)withFieldSet:(NSArray *)aFieldSet {

	ActiveResourceObject *object = [ActiveResourceObject new];
	
	if (object != nil) {
		object.primaryKey = 0;
		object.fields = aFieldSet;		
	}
	
	return object;
}

+(id)withPrimaryKey:(NSInteger)aKey row:(NSDictionary *)aRow {
	
	NSArray *fields = [aRow allKeys];
	
	ActiveResourceObject *object = [ActiveResourceObject withFieldSet:fields];
			
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
