//
//  Modalobject.m
//  WalmartLabs
//
//  Created by ananta venkatesh on 6/15/16.
//  Copyright © 2016 ANANTA. All rights reserved.
//

#import "ModalObject.h"

@implementation ModalObject
- (instancetype)initWithDictionary:(NSDictionary*)object
{
    self = [super init];
    if (self) {
        self.name = object[@"productName"];
        self.price = object[@"price"];
        self.imageURL = object[@"productImage"];
        self.longDescription = object[@"longDescription"];
        self.shortDescription = object[@"shortDescription"];
        self.ratingReviews = [NSString stringWithFormat:@"%@ (%@)", object[@"reviewRating"], object[@"reviewCount"]];
        if ([object[@"inStock"] integerValue] == 1) {
            self.inStock = YES;
        }else{
            self.inStock = NO;
        }
    }
    return self;
}
@end
