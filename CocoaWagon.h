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
#import "PaginationProtocol.h"
#import "CWFile.h"
#import "CWConstants.h"

@interface NSString (InflectionSupport)

-(NSCharacterSet *)capitals;
-(NSString *)camelize;
-(NSString *)underscore;
-(NSString *)singularize;
-(NSString *)pluralize;

@end

@interface CocoaWagon : NSObject <ActiveResourceProtocol, PaginationProtocol, NSXMLParserDelegate> {
	
	__weak NSObject <CocoaWagonDelegate> *delegate;	
	BOOL willPaginate;
	NSURLConnection *theConnection;
	NSMutableData *receivedData;
	NSString *currentElementName;
	BOOL currentElementHasNodeValue;
	NSMutableString *currentNodeValueCharacters;
	ActiveResourceObject *currentObject;
	NSString *apiKey;
	NSMutableArray *rows;
	BOOL containsErrorMessages;
	NSMutableArray *newObjects;
	NSString *objectId;
	NSInteger action;
	
	NSUInteger currentPage;
	NSUInteger totalPages;
}


@property(nonatomic, assign) BOOL willPaginate;
@property(nonatomic, retain) NSURLConnection *theConnection;
@property(nonatomic, retain) NSMutableData *receivedData;
@property(nonatomic, retain) NSString *currentElementName;
@property(nonatomic, assign) BOOL currentElementHasNodeValue;
@property(nonatomic, retain) NSMutableString *currentNodeValueCharacters;
@property(nonatomic, retain) ActiveResourceObject *currentObject;
@property(nonatomic, retain) NSString *apiKey;
@property(nonatomic, retain) NSMutableArray *rows;
@property(nonatomic, assign) BOOL containsErrorMessages;
@property(nonatomic, retain) NSMutableArray *newObjects;
@property(nonatomic, retain) NSString *objectId;
@property(nonatomic) NSInteger action;

@property(nonatomic) NSUInteger currentPage;
@property(nonatomic) NSUInteger totalPages;




+(void)setBaseURLString:(NSString *)aBaseURLString;
+(NSString *)baseURLString;

/*
 * Pagination expects REST-conform XML and a root node containing corresponding attributes "current_page" and "total_pages" 
 */
-(id)initWithDelegate:(NSObject <CocoaWagonDelegate> *)theDelegate willPaginate:(BOOL)paginate;
-(id)initWithDelegate:(NSObject <CocoaWagonDelegate> *)theDelegate willPaginate:(BOOL)paginate apiKey:(NSString *)aKey;

+(id)newWithDelegate:(NSObject <CocoaWagonDelegate> *)theDelegate;
+(id)newWithDelegate:(NSObject <CocoaWagonDelegate> *)theDelegate apiKey:(NSString *)aKey;

-(BOOL)sendRequest:(NSMutableURLRequest *)theRequest;

-(void)cancelConnection;

/*
 * Returns YES if connection could be established. Otherwise NO. See CocoaWagonDelegate for accessing NSError which contains corresponding error messages
 */
-(BOOL)findAll;
-(BOOL)findAll:(NSInteger)page;

-(ActiveResourceObject *)new;
-(BOOL)create:(ActiveResourceObject *)anObject;
-(BOOL)update:(ActiveResourceObject *)anObject;
-(BOOL)destroy:(ActiveResourceObject *)anObject;

-(NSURL *)resourcesURL;

-(BOOL)processData:(NSData *)data;

@end
