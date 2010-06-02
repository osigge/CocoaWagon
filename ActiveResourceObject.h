//
//  ActiveResourceObject.h
//  CocoaWagon
//
//  Created by Yves Vogl on 01.06.10.
//  Copyright 2010 DEETUNE. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CocoaWagon;


@interface ActiveResourceObject : NSObject {	
	CocoaWagon *wagon;
	NSInteger primaryKey;
	NSArray *fields;
	NSMutableDictionary *dictionary;	
}

@property(nonatomic, assign) NSInteger primaryKey;
@property(nonatomic, retain) NSArray *fields;

-(id)initWithWagon:(CocoaWagon *)aWagon;

/*
 * Use this initializer to create a new instance.
 */
+(id)withFieldSet:(NSArray *)aFieldSet wagon:(CocoaWagon *)aWagon;

/*
 * Use this initializer to map a row to a new instance.
 */
+(id)withPrimaryKey:(NSInteger)aKey row:(NSDictionary *)aRow  wagon:(CocoaWagon *)aWagon;

/*
 * Sets a row value
 */ 
-(void)setObject:(id)anObject forKey:(NSString *)aKey;

/*
 * Gets a row value
 */ 
-(id)objectForKey:(NSString *)aKey;

/*
 * Sets a complete row by assigning values from an dictionary by using its keys to identify the corresponding fields
 */ 
-(void)addEntriesFromDictionary:(NSDictionary *)aDictionary;

@end
