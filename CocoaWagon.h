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

@interface NSString (InflectionSupport)

-(NSCharacterSet *)capitals;
-(NSString *)camelize;
-(NSString *)underscore;
-(NSString *)singularize;
-(NSString *)pluralize;

@end


@interface CocoaWagon : NSObject <ActiveResourceProtocol, PaginationProtocol> {
	
	__weak NSObject <CocoaWagonDelegate> *delegate;	
	BOOL willPaginate;
	NSURLConnection *theConnection;
	NSMutableData *receivedData;
	NSString *currentElementName;
	BOOL currentElementHasNodeValue;
	ActiveResourceObject *currentObject;
	NSString *currentFieldName;
	id currentFieldValue;
	NSString *apiKey;
	NSMutableArray *rows;
	
	NSInteger currentPage;
	NSInteger totalPages;
}


@property(nonatomic, assign) BOOL willPaginate;
@property(nonatomic, retain) NSURLConnection *theConnection;
@property(nonatomic, retain) NSMutableData *receivedData;
@property(nonatomic, retain) NSString *currentElementName;
@property(nonatomic, assign) BOOL currentElementHasNodeValue;
@property(nonatomic, retain) ActiveResourceObject *currentObject;
@property(nonatomic, retain) NSString *currentFieldName;
@property(nonatomic, retain) id currentFieldValue;
@property(nonatomic, retain) NSString *apiKey;
@property(nonatomic, retain) NSMutableArray *rows;



+(void)setBaseURLString:(NSString *)aBaseURLString;
+(NSString *)baseURLString;

/*
 * Pagination expects REST-conform XML and a root node containing corresponding attributes "current_page" and "total_pages" 
 */
-(id)initWithDelegate:(NSObject <CocoaWagonDelegate> *)theDelegate willPaginate:(BOOL)paginate;
-(id)initWithApiKey:(NSString *)aKey delegate:(NSObject <CocoaWagonDelegate> *)theDelegate willPaginate:(BOOL)paginate;

/*
 * Returns YES if connection could be established. Otherwise NO. See CocoaWagonDelegate for accessing NSError which contains corresponding error messages
 */
-(BOOL)findAll;
-(BOOL)findAll:(NSInteger)page;

-(NSURL *)resourcesURL;

-(BOOL)processData:(NSData *)data;

@end
