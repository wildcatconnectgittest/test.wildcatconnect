//
//  NewsArticleDetailViewController.h
//  WildcatConnectGITTest
//
//  Created by Rohith Parvathaneni on 9/13/15.
//  Copyright (c) 2015 WildcatConnect. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsArticleStructure.h"

@interface NewsArticleDetailViewController : UIViewController




//IBOutlet UIScrollView *scrollerArticle;
@property (retain, nonatomic) IBOutlet UILabel *NADate;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollerArticle;

@property (retain, nonatomic) IBOutlet UIScrollView *NAscroller;
@property (retain, nonatomic) IBOutlet UILabel *NASummary;
@property (retain, nonatomic) IBOutlet UITextView *NAText;
@property (retain, nonatomic) IBOutlet UIImageView *image;
@property (nonatomic,strong) NewsArticleStructure *NA;

@end