//
//  CocoaWagonDelegate.h
//  CocoaWagon
//
//  Created by Yves Vogl on 02.06.10.
//  Copyright 2010 DEETUNE. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol CocoaWagonDelegate

@required

-(void)didFinishWithResults:(NSArray *)results fromClass:(NSObject *)class action:(NSInteger)action;

@optional

/*
 * Returns error on connection failure. You may access the underlying NSURLRequest through [[error userInfo] objectForKey:@"request"]
 */
-(void)didFailWithError:(NSError *)error;
-(void)didReceiveResponse:(NSHTTPURLResponse *)response;
-(void)didSendRequest:(NSURLRequest *)request;
-(void)didReceiveData:(NSData *)data;
-(void)willProcessData:(NSData *)data;
-(void)didFinishWithErrors:(NSArray *)errors;
-(void)didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite;

@end

