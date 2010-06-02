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
#import "ActiveResourceProtocol.h"


@interface CocoaWagon : NSObject <ActiveResourceProtocol> {
	
	__weak NSObject <CocoaWagonDelegate> *delegate;	
	NSString *apiKey;
	NSArray *fields;
}

@property(nonatomic, retain) NSString *apiKey;
@property(nonatomic, retain) NSArray *fields;


-(id)initWithDelegate:(NSObject <CocoaWagonDelegate> *)theDelegate;

/*
 * Use this initializer for public available remote API methods
 */

-(id)initWithApiKey:(NSString *)aKey delegate:(NSObject <CocoaWagonDelegate> *)theDelegate;


-(NSArray *)all;

-(NSURL *)resourceURL;

@end
