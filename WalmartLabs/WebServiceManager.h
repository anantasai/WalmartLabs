//
//  WebServiceManger.h
//  WalmartLabs
//
//  Created by ananta venkatesh on 6/15/16.
//  Copyright © 2016 ANANTA. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WebServiceDelegate <NSObject>

- (void) connectionDidFinishSucessFulley: (NSDictionary*) objects ;
- (void) ConnectionDidFailWithError: (NSError*) error;
@end

@interface WebServiceManager : NSObject

@property (nonatomic, weak) id<WebServiceDelegate> delegate;


- (void) getProductsForPage: (NSInteger) pageNumber;
@end
