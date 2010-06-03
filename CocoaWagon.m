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

-(NSString *)underscore {
	
	unichar *buffer = calloc([self length], sizeof(unichar));
	[self getCharacters:buffer];
	
	NSMutableString *underscoredString = [NSMutableString string];
	
	NSString *currentChar;
	
	for (int i = 0; i < [self length]; i++) {
		currentChar = [NSString stringWithCharacters:buffer + i length:1];
		
		if([[self capitals] characterIsMember:buffer[i]]) {
			[underscoredString appendFormat:@"_%@", [currentChar lowercaseString]];
		} else {
			[underscoredString appendString:currentChar];
		}
	}
	
	free(buffer);
	
	return underscoredString;
}

-(NSString *)singularize {
    return [self hasSuffix:@"s"] ? [self substringToIndex:[self length] - 1] : self;
}

-(NSString *)pluralize {
    return [self hasSuffix:@"s"] ? self : [self stringByAppendingString:@"s"];
}

@end


@implementation CocoaWagon

static NSString *baseURLString;

@synthesize theConnection, receivedData, xmlParser, apiKey, fields, rows;

-(id)init {	
	self = [super init];
	
	if (self != nil) {
		if ([[self class] isEqual:[CocoaWagon class]]) {
			[NSException raise:@"Abstract Class Exception" format:@"Error, attempting to instantiate CocoaWagon directly."];
			[self release]; 
			return nil; 
		}
		
		self.fields = [NSArray arrayWithObject:@"id"];
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
	self.xmlParser = nil;
	self.apiKey = nil;
	self.fields = nil;
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


#pragma mark API Methods

-(BOOL)findAll {
	
	// ToDo: Send API key if it's present
	
	NSURLRequest *theRequest = [NSURLRequest requestWithURL:[self resourcesURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
	
	theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	
	if (theConnection) {
		receivedData = [[NSMutableData data] retain];
		
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
	
    [connection release];
    [receivedData release];
	
	if ([delegate respondsToSelector:@selector(didFailWithError:)] ) {
		[delegate didFailWithError:error];
	}	
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	
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
	self.xmlParser = [[NSXMLParser alloc] initWithData:data];
	[self.xmlParser setDelegate:self];
    [self.xmlParser setShouldResolveExternalEntities:YES];
	return [self.xmlParser parse];
}

#pragma mark NSXMLParser Delegates

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
	
    if ([elementName isEqualToString:[self resourceName]]) {
		ActiveResourceObject *row = [ActiveResourceObject withFieldSet:self.fields wagon:self];
		
		// <location rating="2" photo_id="9" user_id="24">/system/photos/9/small/P4210023.jpg?1271874392</location>
		
		// ToDo:
		
		// 1. Add nodevalue for key "location"
		// 2. Add attribute values for each attribute
		// 3. Add those things above only if their keys is included in keys
		
		//[row setObject:<#(id)anObject#> forKey:<#(NSString *)aKey#>];
		
		[self.rows addObject:row];
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
