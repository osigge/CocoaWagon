//
//  CocoaWagon.h
//  CocoaWagon
//
//  Created by Yves Vogl on 01.06.10.
//  Copyright 2010 DEETUNE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ActiveResourceObject.h"


@interface CocoaWagon : NSObject {
	NSURL *resourceURL;
	NSString *apiKey;
	NSArray *fields;
}

@property(nonatomic, retain) NSURL *resourceURL;
@property(nonatomic, retain) NSString *apiKey;
@property(nonatomic, retain) NSArray *fields;

/*
 * Use this initializer for public available API methods
 */

-(id)initWithResourceURL:(NSString *)anURLString;


/*
 * Use this initializer if API methods require authentication
 */

-(id)initWithResourceURL:(NSString *)anURLString apiKey:(NSString *)aKey;


-(NSArray *)all;

@end
