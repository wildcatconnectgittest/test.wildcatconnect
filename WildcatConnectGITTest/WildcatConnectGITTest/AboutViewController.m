//
//  AboutViewController.m
//  WildcatConnectGITTest
//
//  Created by Rohith Parvathaneni on 8/12/15.
//  Copyright (c) 2015 WildcatConnect. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [scrollerabout setScrollEnabled:YES];
    [scrollerabout setContentSize:CGSizeMake(320, 1000)];
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

@end
