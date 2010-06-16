//
//  CWFile.h
//  CocoaWagon
//
//  Created by Yves Vogl on 16.06.10.
//  Copyright 2010 DEETUNE. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CWFile : NSObject {
	NSString *filename;
	NSString *filetype;
	NSData *filedata;
}

@property(nonatomic, copy) NSString *filename;
@property(nonatomic, copy) NSString *filetype;
@property(nonatomic, copy) NSData *filedata;

-(id)initWithData:(NSData *)data;
-(id)initWithData:(NSData *)data name:(NSString *)aFileName;
-(id)initWithData:(NSData *)data name:(NSString *)aFileName mimeType:(NSString *)aMimeType;

+(CWFile *)fileWithData:(NSData *)data name:(NSString *)aFileName;
+(CWFile *)fileWithData:(NSData *)data name:(NSString *)aFileName mimeType:(NSString *)aMimeType;


@end
