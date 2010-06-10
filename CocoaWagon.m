//
//  CocoaWagon.m
//  CocoaWagon
//
//  Created by Yves Vogl on 01.06.10.
//  Copyright 2010 DEETUNE. All rights reserved.
//

#import "CocoaWagon.h"
#import "RequestParameter.h"

@implementation NSString (InflectionSupport)

- (NSCharacterSet *)capitals {
	return [NSCharacterSet uppercaseLetterCharacterSet];
}

- (NSString *)camelize {
	
	unichar *buffer = calloc([self length], sizeof(unichar));
	[self getCharacters:buffer ];
	NSMutableString *string = [NSMutableString string];
	
	BOOL capitalizeNext = NO;
	NSCharacterSet *delimiters = [NSCharacterSet characterSetWithCharactersInString:@"-_"];
	
	for (int i = 0; i < [self length]; i++) {
		NSString *currentChar = [NSString stringWithCharacters:buffer+i length:1];
		
		if([delimiters characterIsMember:buffer[i]]) {
			capitalizeNext = YES;
		} else {
			if(capitalizeNext) {
				[string appendString:[currentChar uppercaseString]];
				capitalizeNext = NO;
			} else {
				[string appendString:currentChar];
			}
		}
	}
	
	free(buffer);
	return string;
}


-(NSString *)underscore {
	
	unichar *buffer = calloc([self length], sizeof(unichar));
	[self getCharacters:buffer];
	
	NSMutableString *underscoredString = [NSMutableString string];
	
	NSString *currentChar;
	
	for (int i = 0; i < [self length]; i++) {
		currentChar = [NSString stringWithCharacters:buffer + i length:1];
		
		if([[self capitals] characterIsMember:buffer[i]] && i > 0) {
			[underscoredString appendFormat:@"_%@", [currentChar lowercaseString]];
		} else {
			[underscoredString appendString:[currentChar lowercaseString]];
		}
	}
	
	free(buffer);
	
	return underscoredString;
}

-(NSString *)singularize {
    return [[self lowercaseString] hasSuffix:@"s"] ? [self substringToIndex:[self length] - 1] : self;
}

-(NSString *)pluralize {
    return [[self lowercaseString] hasSuffix:@"s"] ? self : [self stringByAppendingString:@"s"];
}

@end


@implementation CocoaWagon

static NSString *baseURLString;

@synthesize willPaginate, theConnection, receivedData, currentElementName, currentElementHasNodeValue, currentNodeValueCharacters, currentObject, apiKey, rows, containsErrorMessages, newObjects, totalPages, currentPage;

-(id)init {	
	self = [super init];
	
	if (self != nil) {
		if ([[self class] isEqual:[CocoaWagon class]]) {
			[NSException raise:@"Abstract Class Exception" format:@"Error, attempting to instantiate CocoaWagon directly."];
			[self release]; 
			return nil; 
		}
		
		self.rows = [[NSMutableArray new] autorelease];
	}
	
	return self;	
}

-(id)initWithDelegate:(NSObject <CocoaWagonDelegate> *)theDelegate willPaginate:(BOOL)paginate {
	
	self = [self init];
	
	if (self != nil) {
		delegate = theDelegate;
		self.willPaginate = paginate;
	}
	
	return self;	
}

-(id)initWithDelegate:(NSObject <CocoaWagonDelegate> *)theDelegate willPaginate:(BOOL)paginate apiKey:(NSString *)aKey {
	
	self = [self initWithDelegate:theDelegate willPaginate:paginate];
	
	if (self != nil) {
		self.apiKey = aKey;
	}
	
	return self;
}

+(id)newWithDelegate:(NSObject <CocoaWagonDelegate> *)theDelegate {
	
	id instance = [[[[self class] alloc] initWithDelegate:theDelegate willPaginate:NO] autorelease];
	
	if (instance != nil) {
		
	}
	
	return instance;
	
}

+(id)newWithDelegate:(NSObject <CocoaWagonDelegate> *)theDelegate apiKey:(NSString *)aKey {
	
	id instance = [[[[self class] alloc] initWithDelegate:theDelegate willPaginate:NO apiKey:aKey] autorelease];
	
	if (instance != nil) {
		
	}
	
	return instance;
	
}


-(void)dealloc {	
	delegate = nil;
	self.theConnection = nil;
	self.receivedData = nil;
	self.currentElementName = nil;
	self.currentNodeValueCharacters = nil;
	self.currentObject = nil;
	self.apiKey = nil;
	self.rows = nil;
	self.newObjects = nil;
	[super dealloc];	
}

+(void)setBaseURLString:(NSString *)aBaseURLString  {
	
	if (aBaseURLString != baseURLString) {
		[baseURLString release];
		baseURLString = [aBaseURLString retain];
	}
	
}

+(NSString *)baseURLString {
	return [[baseURLString retain] autorelease];
}



#pragma mark API Methods

// ToDo: Consider moving methods like findAll to an ClassMethod to maintain classic ORM pattern

-(BOOL)findAll:(NSInteger)page {
	
	// ToDo: Send API key if it's present
	
	NSURL *url;
	
	if (page > 0) {
		url = [self pageURL:page];
	} else {
		url = [self resourcesURL];
	}
	
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
	
	return [self sendRequest:theRequest];
	
}

-(BOOL)findAll {
	return [self findAll:0];
}


-(ActiveResourceObject *)new {
	
	ActiveResourceObject *newObject = [ActiveResourceObject withWagon:self];
	
	if (self.newObjects) {
		[self.newObjects addObject:newObject];
	} else {
		[self.newObjects arrayByAddingObject:newObject];
	}
	
	return newObject;
	
}

-(BOOL)create:(ActiveResourceObject *)object {
	// ToDo: Send API key if it's present
	
	
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:[self resourcesURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
	[theRequest setHTTPMethod:@"POST"];
	
	NSMutableArray *encodedParameters = [NSMutableArray new];
	RequestParameter *parameter;
	
	NSEnumerator *enumerator = [[object dictionary] keyEnumerator];
	NSString *key;
	
	while ((key = [enumerator nextObject])) {
		parameter = [[RequestParameter alloc] initWithName:key value:[object objectForKey:key] scope:[self resourceName]];
		NSString *encodedParameterPair = [parameter scopedURLEncodedNameValuePair];
		[encodedParameters addObject:encodedParameterPair];
		[parameter release];
	}
	
	NSData *postData = [[encodedParameters componentsJoinedByString:@"&"] dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
	[encodedParameters release];
	[theRequest setHTTPBody:postData];
	[theRequest setValue:[NSString stringWithFormat:@"%d", [postData length]] forHTTPHeaderField:@"Content-Length"];
	[theRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	
	return [self sendRequest:theRequest];
}

-(BOOL)sendRequest:(NSMutableURLRequest *)theRequest {
	
	
	NSArray *availableCookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:baseURLString]];
    NSDictionary *headers = [NSHTTPCookie requestHeaderFieldsWithCookies:availableCookies];
	
    [theRequest setAllHTTPHeaderFields:headers];
	
	NSLog(@"HTTP Request Header: \r\n%@", [theRequest allHTTPHeaderFields]);
	
	self.theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	
	if (self.theConnection) {
		self.receivedData = [NSMutableData data];
		
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
		
		if ([delegate respondsToSelector:@selector(didSendRequest:)] ) {
			[delegate didSendRequest:theRequest];
		}
		
	} else {		
		
		if ([delegate respondsToSelector:@selector(didFailWithError:)] ) {
			
			NSError *error = [NSError errorWithDomain:@"Could not establish connection." 
												 code:-1 
											 userInfo:[NSDictionary dictionaryWithObject:theRequest forKey:@"request"]];			
			
			[delegate didFailWithError:error];
			return NO;
		}		
	}
	
	return YES;
}


#pragma mark NSURLConnection Delegates


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSHTTPURLResponse *)response {
	
	if ([delegate respondsToSelector:@selector(didReceiveResponse:)] ) {
		[delegate didReceiveResponse:response];
	}
	
	NSLog(@"Got HTTP Response Headers: \r\n%@", [response allHeaderFields]);
	
    NSArray *all = [NSHTTPCookie cookiesWithResponseHeaderFields:[response allHeaderFields] forURL:[NSURL URLWithString:baseURLString]];
	
	if (all.count > 0) {
		NSLog(@"Storing %d cookies", all.count);
		[[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookies:all forURL:[NSURL URLWithString:baseURLString] mainDocumentURL:nil];
	}
	
    [self.receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	
	if ([delegate respondsToSelector:@selector(didReceiveData:)] ) {
		[delegate didReceiveData:data];
	}
	
    [self.receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	
    [connection release];
    self.receivedData = nil;
	
	if ([delegate respondsToSelector:@selector(didFailWithError:)] ) {
		[delegate didFailWithError:error];
	}	
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	
	if ([self.receivedData length] > 1) {
		if ([delegate respondsToSelector:@selector(willProcessData:)] ) {
			[delegate willProcessData:self.receivedData];
		}	
		
		if (![self processData:self.receivedData]) {
			
			if ([delegate respondsToSelector:@selector(didFailWithError:)] ) {
				
				NSError *error = [NSError errorWithDomain:@"Could not parse XML data." 
													 code:-1 
												 userInfo:[NSDictionary dictionaryWithObject:self.receivedData forKey:@"data"]];
				
				[delegate didFailWithError:error];
			}	
		}
		
	} else {
		if ([delegate respondsToSelector:@selector(didFinishWithResults:)]) {
			[delegate didFinishWithResults:nil];
		}
	}
	
    [connection release];
	self.receivedData = nil;
}


#pragma mark XML processing

-(BOOL)processData:(NSData *)data {	
	NSXMLParser *xmlParser = [[[NSXMLParser alloc] initWithData:data] autorelease];
	[xmlParser setDelegate:self];
	NSLog(@"\r\n\r\n%@\r\n", [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease]);
	return [xmlParser parse];
}

#pragma mark NSXMLParser Delegates

- (void)parserDidStartDocument:(NSXMLParser *)parser {
	[self.rows removeAllObjects];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
	
    if ([elementName isEqualToString:[self resourcesName]]) { // Found root node
		
		NSLog(@"Found root node: %@", elementName);
		
		if (self.willPaginate) {
			self.totalPages = [[attributeDict objectForKey:@"total_pages"] intValue];
			self.currentPage = [[attributeDict objectForKey:@"current_page"] intValue];
			NSLog(@"Resource will paginate. Loaded page %i of %i", self.currentPage, self.totalPages);
		}
		
		self.containsErrorMessages = NO;
		
	} else if ([elementName isEqualToString:@"errors"]) { // Found errors node at root level
		
		NSLog(@"Found errors node at root level");
		self.containsErrorMessages = YES;		
		
	} else if ([elementName isEqualToString:[self resourceName]] || (self.containsErrorMessages && [elementName isEqualToString:@"error"])) { // Found a relevant object node
		
		NSLog(@"Found resource node: %@", elementName);
		
		if (self.containsErrorMessages) {
			self.currentObject = [[[ActiveResourceObject alloc] init] autorelease];
			self.currentElementName = elementName;
			self.currentElementHasNodeValue = YES;
		} else {
			self.currentObject = [ActiveResourceObject withWagon:self];
		}
		
    } else if (self.currentObject != nil) { // Within a relevant object node
		
		NSLog(@"Found nested content node within resource: %@", elementName);		
		self.currentElementName = elementName;
		
		if ([[attributeDict objectForKey:@"nil"] isEqualToString:@"true"]) {
			NSLog(@"This is an empty node");
			self.currentElementHasNodeValue = NO;
		} else {
			self.currentElementHasNodeValue = YES;
		}		
		
	} else {
		self.currentObject = nil;
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	
	if (self.currentObject != nil && self.currentElementName != nil) { // We've an open, named and relevant node with a value
		
		if (self.currentElementHasNodeValue) { // It's some characters
			
			if (self.currentNodeValueCharacters == nil) { // Prepare container for collecting them
				self.currentNodeValueCharacters = [NSMutableString stringWithCapacity:[string length]];
			}
			
			NSLog(@"Collecting characters for field: %@\r\n%@", self.currentElementName, string);			
			[self.currentNodeValueCharacters appendString:string];
		}
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	
	if ([elementName isEqualToString:[self resourceName]] || (self.containsErrorMessages && [elementName isEqualToString:@"error"])) {

		if ((self.containsErrorMessages && [elementName isEqualToString:@"error"])) {			
			NSLog(@"Content node done. Setting content for field: %@\r\n%@", self.currentElementName, self.currentNodeValueCharacters);		
			[self.currentObject setObject:self.currentNodeValueCharacters forKey:[self.currentElementName camelize]];
			self.currentNodeValueCharacters = nil;
		}
		
		NSLog(@"Resource node done. Adding new object to array");
		[self.rows addObject:self.currentObject];	
		self.currentElementName = nil;
		
	} else if (self.currentElementName != nil) {

		if (self.currentNodeValueCharacters != nil) {		
			NSLog(@"Content node done. Setting content for field: %@\r\n%@", self.currentElementName, self.currentNodeValueCharacters);		
			[self.currentObject setObject:self.currentNodeValueCharacters forKey:[self.currentElementName camelize]];
			self.currentNodeValueCharacters = nil;
		} else {
			NSLog(@"Content node done. There weren't any characters found for: %@", self.currentElementName);	
			[self.currentObject setObject:[NSNull null] forKey:[self.currentElementName camelize]];
		}
		self.currentElementName = nil;
	}
}

/*
 * See RFC 2616 10 Status Code Definitions for details
 * http://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html
 */
- (void)parserDidEndDocument:(NSXMLParser *)parser {
	
	if (self.containsErrorMessages) {
		
		if ([delegate respondsToSelector:@selector(didFinishWithErrors:)]) {		
			
			NSMutableArray *errors = [NSMutableArray new];
			NSEnumerator *enumerator = [self.rows objectEnumerator];
			ActiveResourceObject *anObject;
			
			while (anObject = [enumerator nextObject]) {
				[errors addObject:[anObject objectForKey:@"error"]];
			}			
			
			[delegate didFinishWithErrors:[NSArray arrayWithArray:errors]];		
			[errors release];
		}		
	} else {		
		if ([delegate respondsToSelector:@selector(didFinishWithResults:)]) {
			[delegate didFinishWithResults:[NSArray arrayWithArray:self.rows]];
		}
	}
	
	[self.rows removeAllObjects];	
}


#pragma mark ActiveResource Protocol

-(NSURL *)resourcesURL {
	return [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@.%@", [self resourceBaseURL], [self resourcesName], [self format]]];
}

-(NSString *)resourceBaseURL {
	return [CocoaWagon baseURLString];
}

/*
 * Resource name will be derived from class name
 */
-(NSString *)resourcesName {
	return [[self resourceName] pluralize];
}

-(NSString *)resourceName {
	return [[[self class] description] underscore];
}

/*
 * Communication format.
 */
-(NSString *)format {
	return @"xml";
}

#pragma mark PaginationProtocol

-(NSString *)parameterName {	
	return @"page";	
}

-(BOOL)nextPage {
	if (self.willPaginate && self.currentPage < self.totalPages) {
		
		NSInteger page = self.currentPage + 1;
		
		return [self findAll:page];
	} else {
		return NO;
	}	
}

-(BOOL)previousPage {
	if (self.willPaginate && self.currentPage > 1) {
		NSInteger page = self.currentPage - 1;
		
		return [self findAll:page];
	} else {
		return NO;
	}	
}

-(NSURL *)pageURL:(NSInteger)page {
	return [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@/%i.%@", [self resourceBaseURL], [self resourcesName], self.parameterName, page, [self format]]];
}



@end
