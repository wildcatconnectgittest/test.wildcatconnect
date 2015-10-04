//
//  NewsArticleDetailViewController.m
//  WildcatConnectGITTest
//
//  Created by Rohith Parvathaneni on 9/13/15.
//  Copyright (c) 2015 WildcatConnect. All rights reserved.
//

#import "NewsArticleDetailViewController.h"

@interface NewsArticleDetailViewController ()

@end

@implementation NewsArticleDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_scrollerArticle setScrollEnabled:YES];
    [_scrollerArticle setContentSize:CGSizeMake([[UIScreen mainScreen]bounds].size.width, 1000)];
    CGSize ScreenSize = [[UIScreen mainScreen] bounds].size;
    self.view.frame = CGRectMake(0, 0, ScreenSize.width, ScreenSize.height);

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UIStateRestoration

NSString *const ViewControllerProductKey = @"ViewControllerProductKey";

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {
    [super encodeRestorableStateWithCoder:coder];
    
    // encode the product
    [coder encodeObject:self.NA forKey:ViewControllerProductKey];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder {
    [super decodeRestorableStateWithCoder:coder];
    
    // restore the product
    self.NA = [coder decodeObjectForKey:ViewControllerProductKey];
}



- (void)dealloc {
    [_NAText release];
    [_image release];
    [_image release];
    [_NAText release];
    [_NASummary release];
    [_NADate release];
    [_NAscroller release];
    [_scrollerArticle release];
    [super dealloc];
}
@end
