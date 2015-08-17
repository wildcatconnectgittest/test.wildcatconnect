//
//  NewsCenterTableViewController.h
//  WildcatConnectGITTest
//
//  Created by Kevin Lyons on 8/12/15.
//  Copyright (c) 2015 WildcatConnect. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsCenterTableViewController : UITableViewController {
 
       
    

     NSMutableArray *newsArticles;
     NSMutableArray *newsArticleImages;
     NSNumber *loadNumber;
}

@property (nonatomic, retain) NSMutableArray *newsArticles;
@property (nonatomic, retain) NSMutableArray *newsArticleImages;
@property (nonatomic, retain) NSNumber *loadNumber;

- (instancetype)initWithLoadNumber:(NSNumber *)theLoadNumber;

@end
