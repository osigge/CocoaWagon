//
//  CocoaWagon.h
//  CocoaWagon
//
//  Created by Yves Vogl on 01.06.10.
//  Copyright 2010 DEETUNE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ActiveResourceObject.h"
#import "CocoaWagonDelegate.h"


@interface CocoaWagon : NSObject {
	
	__weak NSObject <CocoaWagonDelegate> *delegate;
	
	NSURL *resourceURL;
	NSString *apiKey;
	NSArray *fields;
}

@property(nonatomic, retain) NSURL *resourceURL;
@property(nonatomic, retain) NSString *apiKey;
@property(nonatomic, retain) NSArray *fields;


-(id)initWithDelegate:(NSObject <CocoaWagonDelegate> *)theDelegate;

/*
 * Use this initializer for public available remote API methods
 */

-(id)initWithResourceURL:(NSString *)anURLString delegate:(NSObject <CocoaWagonDelegate> *)theDelegate;


/*
 * Use this initializer if remote API methods require authentication
 */

-(id)initWithResourceURL:(NSString *)anURLString apiKey:(NSString *)aKey delegate:(NSObject <CocoaWagonDelegate> *)theDelegate;


-(NSArray *)all;

@end
