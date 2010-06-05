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

@synthesize theConnection, receivedData, currentElementName, currentElementHasNodeValue, currentObject, currentFieldName, currentFieldValue, apiKey, rows;

-(id)init {	
	self = [super init];
	
	if (self != nil) {
		if ([[self class] isEqual:[CocoaWagon class]]) {
			[NSException raise:@"Abstract Class Exception" format:@"Error, attempting to instantiate CocoaWagon directly."];
			[self release]; 
			return nil; 
		}
		
		self.rows = [NSMutableArray new];
	}
	
	return self;	
}

-(id)initWithDelegate:(NSObject <CocoaWagonDelegate> *)theDelegate {
	
	self = [self init];
	
	if (self != nil) {
		delegate = theDelegate;
	}
	
	return self;	
}


-(id)initWithApiKey:(NSString *)aKey delegate:(NSObject <CocoaWagonDelegate> *)theDelegate {
	
	self = [self initWithDelegate:theDelegate];
	
	if (self != nil) {
		self.apiKey = aKey;
	}
	
	return self;
}

-(void)dealloc {	
	delegate = nil;
	self.theConnection = nil;
	self.receivedData = nil;
	self.currentElementName = nil;
	self.currentObject = nil;
	self.currentFieldName = nil;
	self.currentFieldValue = nil;
	self.apiKey = nil;
	self.rows = nil;
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

+(BOOL)willPaginate {
	return NO;
}

// ToDo: Implement similar methods as found in Rails willPaginate gem (e.g. totalPages, nextPage, prevPage etc.)


#pragma mark API Methods

-(BOOL)findAll {
	
	// ToDo: Send API key if it's present
	
	NSURLRequest *theRequest = [NSURLRequest requestWithURL:[self resourcesURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
	
	theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	
	if (theConnection) {
		receivedData = [[NSMutableData data] retain];
		
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
	
    [receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	
	if ([delegate respondsToSelector:@selector(didReceiveData:)] ) {
		[delegate didReceiveData:data];
	}
	
    [receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	
    [connection release];
    [receivedData release];
	
	if ([delegate respondsToSelector:@selector(didFailWithError:)] ) {
		[delegate didFailWithError:error];
	}	
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	
	if ([delegate respondsToSelector:@selector(willProcessData:)] ) {
		[delegate willProcessData:receivedData];
	}	
		
	if (![self processData:receivedData]) {
		
		if ([delegate respondsToSelector:@selector(didFailWithError:)] ) {
			
			NSError *error = [NSError errorWithDomain:@"Could not parse XML data." 
												 code:-1 
											 userInfo:[NSDictionary dictionaryWithObject:receivedData forKey:@"data"]];
			
			[delegate didFailWithError:error];
		}	
	}

    [connection release];
    [receivedData release];
}


#pragma mark XML processing

-(BOOL)processData:(NSData *)data {	
	NSXMLParser *xmlParser = [[[NSXMLParser alloc] initWithData:data] autorelease];
	[xmlParser setDelegate:self];
	return [xmlParser parse];
}

#pragma mark NSXMLParser Delegates


- (void)parserDidStartDocument:(NSXMLParser *)parser {
	[self.rows removeAllObjects];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
			
    if ([elementName isEqualToString:[self resourceName]]) { // Found a relevant object node

		NSLog(@"Found resource node: %@", elementName);
		
		self.currentObject = [ActiveResourceObject withWagon:self];
		
    } else if (self.currentObject != nil) { // Within a relevant object node
		
		NSLog(@"Found nested node within resource: %@", elementName);
		
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
	if (self.currentObject != nil && self.currentElementName != nil) {
		
		if (self.currentFieldName != self.currentElementName) {

			self.currentFieldName = self.currentElementName;
			if (self.currentElementHasNodeValue) {
				
				NSLog(@"Setting content for field: %@\r\n%@", self.currentElementName, string);
				
				[self.currentObject setObject:string forKey:[self.currentFieldName camelize]];
			} else {
				[self.currentObject setObject:[NSNull null] forKey:[self.currentFieldName camelize]];
				self.currentFieldName = nil;
			}
		} else {			
			NSLog(@"Row done: %@", self.currentElementName);			
			self.currentFieldName = nil;
		}
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	if ([elementName isEqualToString:[self resourceName]]) {
		NSLog(@"Adding new object to array");
		[self.rows addObject:self.currentObject];	
		self.currentElementName = nil;
	}
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
	
	if ([delegate respondsToSelector:@selector(didFinishWithResults:)] ) {
		[delegate didFinishWithResults:[NSArray arrayWithArray:self.rows]];
	}
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



@end
