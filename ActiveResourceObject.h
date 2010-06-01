//
//  ActiveResourceObject.h
//  CocoaWagon
//
//  Created by Yves Vogl on 01.06.10.
//  Copyright 2010 DEETUNE. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ActiveResourceObject : NSMutableDictionary {

	NSInteger primaryKey;
	NSArray *fields;
	
}

@property(nonatomic, readwrite) NSInteger primaryKey;
@property(nonatomic, readonly) NSArray *fields;

/*
 * Use this initializer to create a new instance.
 */
+(id)withFieldSet:(NSArray *)aFieldSet;

/*
 * Use this initializer to map a row to a new instance.
 */
+(id)withPrimaryKey:(NSInteger)aKey row:(NSDictionary *)aRow;


@end
