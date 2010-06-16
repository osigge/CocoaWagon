//
//  CWFile.m
//  CocoaWagon
//
//  Created by Yves Vogl on 16.06.10.
//  Copyright 2010 DEETUNE. All rights reserved.
//

#import "CWFile.h"


@implementation CWFile

@synthesize filename, filetype, filedata;


-(id)initWithData:(NSData *)data {
	
	self = [self init];
	
	if (self != nil) {
		self.filedata = data;
		self.filename = [NSString stringWithFormat:@"%d", time(NULL)];
		self.filetype = @"application/octet-stream";		
	}
	
	return self;	
}

-(id)initWithData:(NSData *)data name:(NSString *)aFileName {
	
	self = [self initWithData:data];
	
	if (self != nil) {
		self.filename = aFileName;
		// TODO: Guess filetype from filename extension
		// self.filetype = @"application/octet-stream";	
	}
	
	return self;		
}

-(id)initWithData:(NSData *)data name:(NSString *)aFileName mimeType:(NSString *)aMimeType {
	
	self = [self initWithData:data name:aFileName];
	
	if (self != nil) {
		self.filetype = aMimeType;
	}
	
	return self;
	
}

+(CWFile *)fileWithData:(NSData *)data name:(NSString *)aFileName {
	return [[[CWFile alloc] initWithData:data name:aFileName] autorelease];
}

+(CWFile *)fileWithData:(NSData *)data name:(NSString *)aFileName mimeType:(NSString *)aMimeType {	
	return [[[CWFile alloc] initWithData:data name:aFileName mimeType:aMimeType] autorelease];
}

-(void)dealloc {
	self.filename = nil;
	self.filetype = nil;
	self.filedata = nil;
	[super dealloc];
}

@end
