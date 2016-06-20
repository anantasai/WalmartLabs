//
//  ViewController.m
//  WalmartLabs
//
//  Created by ananta venkatesh on 6/15/16.
//  Copyright © 2016 ANANTA. All rights reserved.
//

#import "ViewController.h"
#import "Constants.h"
#import "WebServiceManager.h"
#import "ObjectCell.h"
#import "AppDelegate.h"
#import "DetailViewController.h"
#import "ModalObject.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource,WebServiceDelegate>
@property (weak, nonatomic) IBOutlet UITableView *objectsTable;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (nonatomic, strong) NSMutableArray *allObjects;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger totalPages;
@property (nonatomic, strong) NSCache *appCache;
@property (nonatomic, strong) WebServiceManager *wsm;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //set Table view row height
    self.objectsTable.estimatedRowHeight = 81.0;
    self.objectsTable.rowHeight = UITableViewAutomaticDimension;
    //set default values
    self.allObjects = [[NSMutableArray alloc] init];
    self.currentPage = 0;
    self.wsm = [[WebServiceManager alloc] init];
    self.wsm.delegate = self;

    //call Webservice
    [self.wsm getProductsForPage:self.currentPage];
    [self.activityIndicator startAnimating];
    //getting AppCache
    AppDelegate *ad = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    self.appCache = ad.appCache;
    
    //Hide empty cells
    self.objectsTable.tableFooterView = [[UIView alloc] init] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - TableView delegate/data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{// Return the number of rows in the section.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.allObjects.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ObjectCell *cell = (ObjectCell*)[tableView dequeueReusableCellWithIdentifier:@"ObjectCell" forIndexPath:indexPath];
    ModalObject *obj  = self.allObjects[indexPath.row];
    cell.lblPrice.text = obj.price;
    cell.lblName.text = obj.name;
    cell.lblRatings.text = obj.ratingReviews;
    cell.objectImage.image = [UIImage imageNamed:@"default"];
    cell.lblNoStock.hidden = YES;
    if (!obj.inStock) {
        cell.lblNoStock.hidden = NO;
    }
    //Getting image from cache if avialable
    UIImage *cachedImage =   [self.appCache objectForKey:obj.imageURL];;
    if (cachedImage)
    {
        cell.objectImage.image = cachedImage;
    }
    //Downloading and caching the image
    else
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:obj.imageURL]];
            UIImage *image    = nil;
            if (imageData)
                image = [UIImage imageWithData:imageData];
            if (image)
            {
                [self.appCache setObject:image forKey:obj.imageURL];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                UITableViewCell *updateCell = [tableView cellForRowAtIndexPath:indexPath];
                if (updateCell)
                    cell.objectImage.image = [UIImage imageWithData:imageData];
            });
        });
    }    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if(self.objectsTable.contentOffset.y >= (self.objectsTable.contentSize.height - self.objectsTable.bounds.size.height)) {
        
        if(self.currentPage < self.totalPages){
            
            [self.wsm getProductsForPage:++self.currentPage];
            [self.activityIndicator startAnimating];
        }
    }
    
}



#pragma mark - WebServiceManager delegat

- (void) connectionDidFinishSucessFulley: (NSDictionary*) objects{
    NSLog(@"%@", objects);
    dispatch_async(dispatch_get_main_queue(), ^{
        int totalProducts = (int)[objects[@"totalProducts"] integerValue];
        self.totalPages = totalProducts/PAGESIZE;
        for (NSDictionary *dic in objects[@"products"]) {
            ModalObject *mo = [[ModalObject alloc] initWithDictionary:dic];
            [self.allObjects addObject:mo];
        }
        [self.objectsTable reloadData];
        [self.activityIndicator stopAnimating];
    });
}
- (void) ConnectionDidFailWithError: (NSError*) error{
    
  UIAlertController *controller = [UIAlertController alertControllerWithTitle: @"Error!"
                                                                      message: error.localizedDescription
                                                               preferredStyle: UIAlertControllerStyleAlert];
  
  UIAlertAction *alertAction = [UIAlertAction actionWithTitle: @"Dismiss"
                                                        style: UIAlertActionStyleDestructive
                                                      handler: ^(UIAlertAction *action) {
                                                        NSLog(@"Dismiss button tapped!");
                                                        [self.activityIndicator stopAnimating];

                                                      }];
  

  [controller addAction: alertAction];
  
  [self presentViewController: controller animated: YES completion: nil];
}




- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[DetailViewController class]]) {
        DetailViewController *dvc = (DetailViewController*) segue.destinationViewController;
        dvc.allObjects = [NSArray arrayWithArray:self.allObjects];
        NSIndexPath *indexPath = self.objectsTable.indexPathForSelectedRow;
        dvc.selectedIndex = indexPath.row;
    }
}

@end
