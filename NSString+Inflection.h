//
//  NSString+Inflection.h
//  CocoaWagon
//
//  Created by Yves Vogl on 01.06.10.
//  Copyright 2010 DEETUNE. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (Inflection)

-(NSString *)underscore;
-(NSString *)singularize;
-(NSString *)pluralize;

@end
