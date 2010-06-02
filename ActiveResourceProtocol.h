//
//  ActiveResourceProtocol.h
//  CocoaWagon
//
//  Created by Yves Vogl on 02.06.10.
//  Copyright 2010 DEETUNE. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ActiveResourceProtocol


@optional

-(NSString *)resourceBaseURL;
-(NSString *)resourceName;
-(NSString *)format;

@end
