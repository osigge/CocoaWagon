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

@interface NSString (InflectionSupport)

-(NSCharacterSet *)capitals;
-(NSString *)camelize;
-(NSString *)underscore;
-(NSString *)singularize;
-(NSString *)pluralize;

@end


@interface CocoaWagon : NSObject <ActiveResourceProtocol> {
	
	__weak NSObject <CocoaWagonDelegate> *delegate;	
	NSURLConnection *theConnection;
	NSMutableData *receivedData;
	NSXMLParser *xmlParser;
	NSString *currentElementName;
	BOOL currentElementHasNodeValue;
	ActiveResourceObject *currentObject;
	NSString *currentFieldName;
	id currentFieldValue;
	NSString *apiKey;
	NSMutableArray *rows;
}

@property(nonatomic, retain) NSURLConnection *theConnection;
@property(nonatomic, retain) NSMutableData *receivedData;
@property(nonatomic, retain) NSXMLParser *xmlParser;
@property(nonatomic, retain) NSString *currentElementName;
@property(nonatomic, assign) BOOL currentElementHasNodeValue;
@property(nonatomic, retain) ActiveResourceObject *currentObject;
@property(nonatomic, retain) NSString *currentFieldName;
@property(nonatomic, retain) id currentFieldValue;
@property(nonatomic, retain) NSString *apiKey;
@property(nonatomic, retain) NSMutableArray *rows;



+(void)setBaseURLString:(NSString *)aBaseURLString;
+(NSString *)baseURLString;

+(BOOL)willPaginate;


-(id)initWithDelegate:(NSObject <CocoaWagonDelegate> *)theDelegate;

/*
 * Use this initializer for public available remote API methods
 */

-(id)initWithApiKey:(NSString *)aKey delegate:(NSObject <CocoaWagonDelegate> *)theDelegate;

/*
 * Returns YES if connection could be established. Otherwise NO. See CocoaWagonDelegate for accessing NSError which contains corresponding error messages
 */
-(BOOL)findAll;

-(NSURL *)resourcesURL;

-(BOOL)processData:(NSData *)data;

@end
