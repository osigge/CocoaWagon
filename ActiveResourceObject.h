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
	NSUInteger primaryKey;
	NSMutableDictionary *dictionary;	
}

@property(nonatomic, assign) NSUInteger primaryKey;

-(id)initWithWagon:(CocoaWagon *)aWagon;

/*
 * Use this initializer to create a new instance.
 */
+(id)withWagon:(CocoaWagon *)aWagon;

/*
 * Use this initializer to map a row to a new instance.
 */
+(id)withPrimaryKey:(NSUInteger)aKey row:(NSDictionary *)aRow wagon:(CocoaWagon *)aWagon;

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

-(NSArray *)fields;
-(NSArray *)values;
-(NSDictionary *)dictionary;

-(BOOL)save;
-(BOOL)update;
-(BOOL)destroy;

-(BOOL)newRecord;

@end
