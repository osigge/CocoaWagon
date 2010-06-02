//
//  ActiveResourceProtocol.h
//  CocoaWagon
//
//  Created by Yves Vogl on 02.06.10.
//  Copyright 2010 DEETUNE. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ActiveResourceProtocol

-(NSString *)resourceBaseURL;

@optional

-(NSString *)resourceName;
-(NSString *)format;

@end
