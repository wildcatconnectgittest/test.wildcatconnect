//
//  FirstViewController.m
//  WildcatConnectGITTest
//
//  Created by Kevin Lyons on 8/12/15.
//  Copyright (c) 2015 WildcatConnect. All rights reserved.
//

#import "FirstViewController.h"
#import <Parse/Parse.h>
#import "NewsArticleStructure.h"
#import "AppManager.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
	[super viewDidLoad];
    [scrollerhome setScrollEnabled:YES];
    [scrollerhome setContentSize:CGSizeMake([[UIScreen mainScreen]bounds].size.width, 1000)];
    CGSize ScreenSize = [[UIScreen mainScreen] bounds].size;
    self.view.frame = CGRectMake(0, 0, ScreenSize.width, ScreenSize.height);
	// Do any additional setup after loading the view, typically from a nib.
     //Saving object
     /*PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
     testObject[@"foo"] = @"bar";
      [testObject saveInBackground];*/
          //Saving custom subclass of PF Object.
     /*TestStructure *testStructure = [[TestStructure alloc] init];
     testStructure.isSelected = 1;
     testStructure.testStructureIndex = 5;
     testStructure.testStructureName = @"Testing...";
     [testStructure saveInBackground];*/
          //Querying objects...
     /*PFQuery *query = [TestStructure query];
     [query whereKey:@"isSelected" equalTo:[NSNumber numberWithInt:1]];
     [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
          if (! error) {
               TestStructure *testStructure = [objects firstObject];
               NSString *name = testStructure.testStructureName;
               NSLog(@"%@", name);
          }
     }];*/
     /*PFQuery *query = [NewsArticleStructure query];
     [query whereKey:@"likes" greaterThan:[NSNumber numberWithInt:50]];
     [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
          if (! error) {
               NewsArticleStructure *structure = [objects firstObject];
          }
     }];*/
          //App wide manager init...
     AppManager *appManager = [AppManager getInstance];
          //Reading text files from internet...
     /*NSURL *URL = [NSURL URLWithString:@"http://kevinalyons.com/assets/testFile.txt"];
     NSError *error;
     NSString *content = [NSString stringWithContentsOfURL:URL encoding:NSASCIIStringEncoding error:&error];
     NSLog(@"%@", content);*/
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
