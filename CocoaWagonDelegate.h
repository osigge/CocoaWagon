//
//  CocoaWagonDelegate.h
//  CocoaWagon
//
//  Created by Yves Vogl on 02.06.10.
//  Copyright 2010 DEETUNE. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol CocoaWagonDelegate

-(void)didFinishWithResults:(NSArray *)results;

@optional

/*
 * Returns error on connection failure. You may access the underlying NSURLRequest through [[error userInfo] objectForKey:@"request"]
 */
-(void)didFailWithError:(NSError *)error;
-(void)didReceiveResponse:(NSHTTPURLResponse *)response;
-(void)didSendRequest:(NSURLRequest *)request;
-(void)didReceiveData:(NSData *)data;
-(void)willProcessData:(NSData *)data;


@end

