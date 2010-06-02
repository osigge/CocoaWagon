//
//  CocoaWagonDelegate.h
//  CocoaWagon
//
//  Created by Yves Vogl on 02.06.10.
//  Copyright 2010 DEETUNE. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol CocoaWagonDelegate

-(void)didFinishWithResults:(NSArray *)results statusCode:(NSInteger)statusCode;
-(void)didFailWithError:(NSError *)error;

@optional

-(void)didRespondWithStatusCode:(NSInteger)statusCode;


@end
