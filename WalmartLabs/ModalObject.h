//
//  Modalobject.h
//  WalmartLabs
//
//  Created by ananta venkatesh on 6/15/16.
//  Copyright © 2016 ANANTA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModalObject : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *ratingReviews;
@property (nonatomic, strong) NSString *longDescription;
@property (nonatomic, strong) NSString *shortDescription;
@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, assign) BOOL inStock;

- (instancetype)initWithDictionary:(NSDictionary*)object;

@end
