//
//  SplashScreenViewController.m
//  WildcatConnectGITTest
//
//  Created by Kevin Lyons on 8/13/15.
//  Copyright (c) 2015 WildcatConnect. All rights reserved.
//

#import "SplashScreenViewController.h"
#import "AppManager.h"
#import "NewsArticleStructure.h"

@implementation SplashScreenViewController {
     AppManager *manager;
     UIActivityIndicatorView *activity;
     int locationY;
     NSOperationQueue *opQue;
}


@synthesize StartImage;
@synthesize statusLabel;

- (void)viewDidLoad {
    
    UIImage *Simage = [UIImage imageNamed:@"wildcat.jpeg"];
    [StartImage setImage:Simage];
    
    [super viewDidLoad];
     self.navigationController.navigationBarHidden = YES;
     opQue = [[NSOperationQueue alloc] init];
     locationY = statusLabel.frame.origin.y;
     manager = [AppManager getInstance];
     activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width) / 2 - 15, 300, 30, 30)];
     [activity setBackgroundColor:[UIColor clearColor]];
     [activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
     [self.view addSubview:activity];
     [activity startAnimating];
     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
          [manager loadAllData:activity forViewController:self];
     });
}

- (void)didReceiveMemoryWarning {
     [super didReceiveMemoryWarning];
          // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [StartImage release];
    [super dealloc];
}
@end
