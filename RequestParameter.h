//
//  RequestParameter.h
//  CocoaWagon
//
//  Created by Yves Vogl on 09.06.10.
//  Copyright 2010 DEETUNE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (URLEncodingAdditions)

- (NSString *)URLEncodedString;
- (NSString *)URLDecodedString;

@end


@interface RequestParameter : NSObject {

    NSString *name;
    NSString *value;
	NSString *scope;
}

@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *value;
@property(nonatomic, copy) NSString *scope;

+ (id)requestParameterWithName:(NSString *)aName value:(NSString *)aValue;
- (id)initWithName:(NSString *)aName value:(NSString *)aValue;
- (id)initWithName:(NSString *)aName value:(NSString *)aValue scope:(NSString *)aScope;

- (NSString *)URLEncodedName;
- (NSString *)URLEncodedValue;
- (NSString *)URLEncodedNameValuePair;
- (NSString *)scopedURLEncodedNameValuePair;


@end
