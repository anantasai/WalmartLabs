//
//  DetailViewController.m
//  WalmartLabs
//
//  Created by ananta venkatesh on 6/15/16.
//  Copyright © 2016 ANANTA. All rights reserved.
//

#import "DetailViewController.h"
#import "AppDelegate.h"
#import "ModalObject.h"

@interface DetailViewController ()
@property (nonatomic, strong) NSCache *appCache;
@property (weak, nonatomic) IBOutlet UILabel *lblName;

@property (weak, nonatomic) IBOutlet UILabel *lblRating;
@property (weak, nonatomic) IBOutlet UILabel *lblStock;
@property (weak, nonatomic) IBOutlet UILabel *lblShortDescription;

@property (weak, nonatomic) IBOutlet UITextView *tvwLongDiscription;
@property (weak, nonatomic) IBOutlet UIButton *btnPrice;
@property (weak, nonatomic) IBOutlet UIImageView *objectImageView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;


@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //getting AppCahe
    AppDelegate *ad = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    self.appCache = ad.appCache;
    [self updateUIWithObject:self.allObjects[self.selectedIndex]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateUIWithObject:(ModalObject*)object
{
    self.lblName.text = object.name;
    self.lblRating.text = [NSString stringWithFormat:@"Ratings : %@", object.ratingReviews];
    self.lblShortDescription.attributedText = [[NSAttributedString alloc]
                                               initWithData: [object.shortDescription dataUsingEncoding:NSUnicodeStringEncoding]
                                               options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                               documentAttributes: nil
                                               error: nil
                                               ];
    self.tvwLongDiscription.attributedText = [[NSAttributedString alloc]
                                              initWithData: [object.longDescription dataUsingEncoding:NSUnicodeStringEncoding]
                                              options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                              documentAttributes: nil
                                              error: nil
                                              ];
    [self.btnPrice setTitle:object.price forState:UIControlStateNormal];
  self.priceLabel.text =object.price;
  
    if (object.inStock) {
        self.lblStock.text = @"In Stock";
    }else{
        self.lblStock.text = @"Not in Stock";
    }
    
    UIImage *cachedImage =   [self.appCache objectForKey:object.imageURL];;
    if (cachedImage)
    {
        self.objectImageView.image = cachedImage;
    }
    else
    {
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:object.imageURL]];
            UIImage *image    = nil;
            if (imageData)
                image = [UIImage imageWithData:imageData];
            
            if (image)
            {
                
                [self.appCache setObject:image forKey:object.imageURL];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.objectImageView.image = [UIImage imageWithData:imageData];
            });
        });
    }

}
@end
