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
	NSURLConnection *theConnection;
	NSMutableData *receivedData;
	NSString *apiKey;
	NSArray *fields;
	
}

@property(nonatomic, retain) NSURLConnection *theConnection;
@property(nonatomic, retain) NSMutableData *receivedData;
@property(nonatomic, retain) NSString *apiKey;
@property(nonatomic, retain) NSArray *fields;


+(void)setBaseURLString:(NSString *)aBaseURLString;
+(NSString *)baseURLString;


-(id)initWithDelegate:(NSObject <CocoaWagonDelegate> *)theDelegate;

/*
 * Use this initializer for public available remote API methods
 */

-(id)initWithApiKey:(NSString *)aKey delegate:(NSObject <CocoaWagonDelegate> *)theDelegate;

/*
 * Returns YES if connection could be established. Otherwise NO. See CocoaWagonDelegate for accessing NSError which contains corresponding error messages
 */
-(BOOL)all;

-(NSURL *)resourcesURL;

-(void)processData:(NSData *)data;

@end
