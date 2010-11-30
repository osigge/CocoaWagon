//
//  CocoaWagon.m
//  CocoaWagon
//
//  Created by Yves Vogl on 01.06.10.
//  Copyright 2010 DEETUNE. All rights reserved.
//

#import "CocoaWagon.h"
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

@synthesize willPaginate, theConnection, receivedData, currentElementName, currentElementHasNodeValue, currentNodeValueCharacters, currentObject, apiKey, rows, containsErrorMessages, newObjects, totalPages, currentPage, objectId, action;

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
		[self release];
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
	self.objectId = nil;
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
	NSLog(@"COCOWAGON RETAIN COUNT findAll BEGIN: %i", [self retainCount]);
	self.action = CWRead;
	
	NSURL *url;
	
	if (page > 0) {
		url = [self pageURL:page];
	} else {
		url = [self resourcesURL];
	}
	
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
	[theRequest setValue:@"application/xml" forHTTPHeaderField:@"Content-Type"];	
	[theRequest addValue:@"application/xml" forHTTPHeaderField:@"Accept"];
	NSLog(@"COCOWAGON RETAIN COUNT findAll END: %i", [self retainCount]);	
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

-(BOOL)create:(ActiveResourceObject *)anObject {
	self.action = CWCreate;
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:[self resourcesURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
	[theRequest setValue:@"application/xml" forHTTPHeaderField:@"Content-Type"];	
	[theRequest addValue:@"application/xml" forHTTPHeaderField:@"Accept"];
	[theRequest setHTTPMethod:@"POST"];
	[theRequest setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", MULTIPART_FORM_DATA_BOUNDARY] forHTTPHeaderField:@"Content-Type"];		
	
	NSMutableData *postData = [NSMutableData new];
	
	NSEnumerator *enumerator = [[anObject dictionary] keyEnumerator];
	NSString *key;
	id object;
	
//	[anObject setObject:@"post" forKey:@"_method"];
//	[anObject setObject:@"create" forKey:@"action"];
	
	while ((key = [enumerator nextObject])) {
		
		object = [anObject objectForKey:key];
		
		[postData appendData:[[NSString stringWithFormat:@"--%@\r\n", MULTIPART_FORM_DATA_BOUNDARY] dataUsingEncoding:NSASCIIStringEncoding]];
		
		NSString *scope = [NSString stringWithFormat:@"%@[%@]", [self resourceName], key];
		
		if ([object isKindOfClass:[CWFile class]]) {
			CWFile *payload = object;
			[postData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\nContent-Type: %@\r\nContent-Transfer-Encoding: binary\r\n\r\n", scope, payload.filename, payload.filetype] dataUsingEncoding:NSASCIIStringEncoding]];
			[postData appendData:payload.filedata];								
		} else {						
			NSString *payload = object;			
			[postData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", scope] dataUsingEncoding:NSASCIIStringEncoding]];			
			[postData appendData:[payload dataUsingEncoding:NSASCIIStringEncoding]];			
		}
		
		[postData appendData:[@"\r\n" dataUsingEncoding:NSASCIIStringEncoding]];
		
	}
	
	[postData appendData:[[NSString stringWithFormat:@"--%@--\r\n", MULTIPART_FORM_DATA_BOUNDARY] dataUsingEncoding:NSASCIIStringEncoding]];		
	[theRequest setValue:[NSString stringWithFormat:@"%d", [postData length]] forHTTPHeaderField:@"Content-Length"];
	[theRequest setHTTPBody:postData];
	[postData release];
	
	return [self sendRequest:theRequest];
}

- (BOOL)update:(ActiveResourceObject *)anObject {
	self.action = CWUpdate;
	self.objectId = [anObject objectForKey:@"id"];
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:[self resourcesURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
	[theRequest setValue:@"application/xml" forHTTPHeaderField:@"Content-Type"];	
	[theRequest addValue:@"application/xml" forHTTPHeaderField:@"Accept"];
	[theRequest setHTTPMethod:@"PUT"];
	[theRequest setCachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData];
	[theRequest setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", MULTIPART_FORM_DATA_BOUNDARY] forHTTPHeaderField:@"Content-Type"];
	NSMutableData *putData = [NSMutableData new];
	
	NSEnumerator *enumerator = [[anObject dictionary] keyEnumerator];
	NSString *key;
	id object;
	
	while ((key = [enumerator nextObject])) {
		
		object = [anObject objectForKey:key];
		if([object isKindOfClass:[NSNull class]] || 
		   [key isEqualToString:@"id"] ||
		   [key isEqualToString:@"createdAt"] ||
		   [key isEqualToString:@"updatedAt"]){
			object = nil;
			continue;
		}

		[putData appendData:[[NSString stringWithFormat:@"--%@\r\n", MULTIPART_FORM_DATA_BOUNDARY] dataUsingEncoding:NSASCIIStringEncoding]];
		
		NSString *scope = [NSString stringWithFormat:@"%@[%@]", [self resourceName], [key underscore]];
		
		if ([object isKindOfClass:[CWFile class]]) {
			CWFile *payload = object;
			[putData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\nContent-Type: %@\r\nContent-Transfer-Encoding: binary\r\n\r\n", scope, payload.filename, payload.filetype] dataUsingEncoding:NSASCIIStringEncoding]];
			[putData appendData:payload.filedata];								
		} else {						
			NSString *payload = object;			
			[putData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", scope] dataUsingEncoding:NSASCIIStringEncoding]];			
			[putData appendData:[payload dataUsingEncoding:NSASCIIStringEncoding]];			
		}
		
		[putData appendData:[@"\r\n" dataUsingEncoding:NSASCIIStringEncoding]];
		
	}
	
	
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"_method", @"put", 
							@"action", @"update", 
							@"id", [anObject objectForKey:@"id"],
							@"controller", [[self resourceName] pluralize], nil];
	
	NSEnumerator *paramsEnumerator = [params keyEnumerator];
	NSString *paramsKey;
	id paramsValue;
	
	while ((paramsKey = [paramsEnumerator nextObject])) {
		
		paramsValue = [params objectForKey:paramsKey];
		
		[putData appendData:[[NSString stringWithFormat:@"--%@\r\n", MULTIPART_FORM_DATA_BOUNDARY] dataUsingEncoding:NSASCIIStringEncoding]];
		NSString *payload = paramsValue;			
		[putData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", paramsKey] dataUsingEncoding:NSASCIIStringEncoding]];			
		[putData appendData:[payload dataUsingEncoding:NSASCIIStringEncoding]];
		[putData appendData:[@"\r\n" dataUsingEncoding:NSASCIIStringEncoding]];
		
	}
	
	[putData appendData:[[NSString stringWithFormat:@"--%@--\r\n", MULTIPART_FORM_DATA_BOUNDARY] dataUsingEncoding:NSASCIIStringEncoding]];		
	[theRequest setValue:[NSString stringWithFormat:@"%d", [putData length]] forHTTPHeaderField:@"Content-Length"];	

	[theRequest setHTTPBody:putData];
	[putData release];
		
	return [self sendRequest:theRequest];
}

-(BOOL)destroy:(ActiveResourceObject *)anObject{
	self.action = CWDelete;
	self.objectId = [anObject objectForKey:@"id"];
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:[self resourcesURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
	[theRequest setValue:@"application/xml" forHTTPHeaderField:@"Content-Type"];	
	[theRequest addValue:@"application/xml" forHTTPHeaderField:@"Accept"];
	[theRequest setHTTPMethod:@"DELETE"];
	[theRequest setCachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData];
	[theRequest setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", MULTIPART_FORM_DATA_BOUNDARY] forHTTPHeaderField:@"Content-Type"];
	NSMutableData *destroyData = [NSMutableData new];
	
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"_method", @"delete", 
							@"action", @"destroy", 
							@"id", [anObject objectForKey:@"id"],
							@"controller", [[self resourceName] pluralize], nil];
	
	NSEnumerator *enumerator = [params keyEnumerator];
	NSString *paramsKey;
	id object;
	
	while ((paramsKey = [enumerator nextObject])) {
		
		object = [params objectForKey:paramsKey];
		
		[destroyData appendData:[[NSString stringWithFormat:@"--%@\r\n", MULTIPART_FORM_DATA_BOUNDARY] dataUsingEncoding:NSASCIIStringEncoding]];
		NSString *payload = object;			
		[destroyData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", paramsKey] dataUsingEncoding:NSASCIIStringEncoding]];			
		[destroyData appendData:[payload dataUsingEncoding:NSASCIIStringEncoding]];
		[destroyData appendData:[@"\r\n" dataUsingEncoding:NSASCIIStringEncoding]];
		
	}
	
	[destroyData appendData:[[NSString stringWithFormat:@"--%@--\r\n", MULTIPART_FORM_DATA_BOUNDARY] dataUsingEncoding:NSASCIIStringEncoding]];		
	[theRequest setValue:[NSString stringWithFormat:@"%d", [destroyData length]] forHTTPHeaderField:@"Content-Length"];	
	
	[theRequest setHTTPBody:destroyData];
	[destroyData release];
	
	return [self sendRequest:theRequest];
}


-(BOOL)sendRequest:(NSMutableURLRequest *)theRequest {
	NSLog(@"COCOWAGON RETAIN COUNT sendRequest BEGIN: %i", [self retainCount]);
	// ToDo: Send API key if it's present
	
	NSArray *availableCookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:baseURLString]];
    NSDictionary *headers = [NSHTTPCookie requestHeaderFieldsWithCookies:availableCookies];
	
    [theRequest setAllHTTPHeaderFields:headers];
	[theRequest setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];  
	
	NSLog(@"HTTP Request Header: \r\n%@", [theRequest allHTTPHeaderFields]);
	
	if ([theRequest HTTPBody] != nil) {
		NSLog(@"HTTP Request Body: \r\n%@", [[[NSString alloc] initWithData:[theRequest HTTPBody] encoding:NSASCIIStringEncoding] autorelease]);
	}
	
	self.theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	
	NSLog(@"COCOWAGON RETAIN COUNT sendRequest END: %i", [self retainCount]);
	NSLog(@"URL -------  %@", [[theRequest URL] absoluteString]);
	
	if ([NSURLConnection canHandleRequest:theRequest]) {
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


-(void)cancelConnection{
	[self.theConnection cancel];
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
		NSLog(@"BaseURLString:%@", baseURLString);
	}
	
    [self.receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	
	if ([delegate respondsToSelector:@selector(didReceiveData:)] ) {
		[delegate didReceiveData:data];
	}
	
    [self.receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite {
	if ([delegate respondsToSelector:@selector(didSendBodyData:totalBytesWritten:totalBytesExpectedToWrite:)] ) {
		[delegate didSendBodyData:bytesWritten totalBytesWritten:totalBytesWritten totalBytesExpectedToWrite:totalBytesExpectedToWrite];
	}	
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	
    self.theConnection = nil;
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
		if ([delegate respondsToSelector:@selector(didFinishWithResults:fromClass:action:)]) {
			[delegate didFinishWithResults:nil fromClass:self action:self.action];
		}
	}
	
    self.theConnection = nil;
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
		
		//NSLog(@"Found root node: %@", elementName);
		
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
			
			//NSLog(@"Collecting characters for field: %@\r\n%@", self.currentElementName, string);			
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
		
		//NSLog(@"Resource node done. Adding new object to array");
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
		if ([delegate respondsToSelector:@selector(didFinishWithResults:fromClass:action:)]) {
			[delegate didFinishWithResults:[NSArray arrayWithArray:self.rows] fromClass:self action:self.action];
		}
	}
	
	[self.rows removeAllObjects];	
}


#pragma mark ActiveResource Protocol

-(NSURL *)resourcesURL {
	NSString *urlString;
	if(self.objectId){
		urlString = [NSString stringWithFormat:@"%@/%@/%@.%@", [self resourceBaseURL], [self resourcesName], self.objectId, [self format]];
	}else {
		urlString = [NSString stringWithFormat:@"%@/%@.%@", [self resourceBaseURL], [self resourcesName], [self format]];
	}

	return [NSURL URLWithString:urlString];
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

-(NSURL *)pageURL:(NSUInteger)page {
	return [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@/%i.%@", [self resourceBaseURL], [self resourcesName], self.parameterName, page, [self format]]];
}



@end
