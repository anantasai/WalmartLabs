//
//  WebServiceManger.m
//  WalmartLabs
// 
//  Created by ananta venkatesh on 6/15/16.
//  Copyright © 2016 ANANTA. All rights reserved.
//

#import "WebServiceManager.h"
#import "Constants.h"

@implementation WebServiceManager


- (void) getProductsForPage: (NSInteger) pageNumber
{
    NSString *apiURL = [NSString stringWithFormat:@"%@/%ld/%d",PRODUCTSLIST,(long)pageNumber, PAGESIZE];
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:apiURL]
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                
                if (!error) {
                    
                    NSError *jsonError = nil;
                    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
                    if([self.delegate respondsToSelector:@selector(connectionDidFinishSucessFulley:)])
                    {
                        [self.delegate connectionDidFinishSucessFulley:jsonObject];
                    }
                    
                }else{
                    if([self.delegate respondsToSelector:@selector(ConnectionDidFailWithError:)])
                    {
                        [self.delegate ConnectionDidFailWithError:error];
                    }
                }
            }] resume];

}
@end
