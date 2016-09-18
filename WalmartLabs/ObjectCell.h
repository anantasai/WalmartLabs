//
//  ObjectCell.h
//  WalmartLabs
//
//  Created by ananta venkatesh on 6/15/16.
//  Copyright © 2016 ANANTA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ObjectCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblRatings;
@property (weak, nonatomic) IBOutlet UILabel *lblNoStock;

@property (weak, nonatomic) IBOutlet UIImageView *objectImage;


@end
