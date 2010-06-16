//
//  PaginationProtocol.h
//  CocoaWagon
//
//  Created by Yves Vogl on 08.06.10.
//  Copyright 2010 DEETUNE. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol PaginationProtocol

@property(nonatomic, assign) NSUInteger currentPage;
@property(nonatomic, assign) NSUInteger totalPages;

-(NSString *)parameterName;
-(BOOL)nextPage;
-(BOOL)previousPage;
-(NSURL *)pageURL:(NSUInteger)page;

@end
