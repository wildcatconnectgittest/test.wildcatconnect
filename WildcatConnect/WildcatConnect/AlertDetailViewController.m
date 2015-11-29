//
//  AlertDetailViewController.m
//  WildcatConnectGITTest
//
//  Created by Kevin Lyons on 11/28/15.
//  Copyright © 2015 WildcatConnect. All rights reserved.
//

#import "AlertDetailViewController.h"

@interface AlertDetailViewController ()

@end

@implementation AlertDetailViewController {
     UILabel *titleLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     
     if (self.showCloseButton) {
          UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStyleDone target:self action:@selector(dismissModalViewControllerAnimated:)];
          self.navigationItem.rightBarButtonItem = barButtonItem;
     }
     
     self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:248.0f/255.0f
                                                                            green:183.0f/255.0f
                                                                             blue:23.0f/255.0f
                                                                            alpha:0.5f];
     
     self.navigationItem.title = @"Alert";
     
     UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
     
     titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width - 20, 100)];
     titleLabel.text = self.alert.titleString;
     [titleLabel setFont:[UIFont systemFontOfSize:24]];
     titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
     titleLabel.numberOfLines = 0;
     [titleLabel sizeToFit];
     [scrollView addSubview:titleLabel];
     
     UILabel *authorDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel.frame.origin.x, titleLabel.frame.origin.y + titleLabel.frame.size.height + 10, self.view.frame.size.width - 20, 100)];
     authorDateLabel.text = [[self.alert.authorString stringByAppendingString:@" | "] stringByAppendingString:self.alert.dateString];
     [authorDateLabel setFont:[UIFont systemFontOfSize:12]];
     authorDateLabel.lineBreakMode = NSLineBreakByWordWrapping;
     authorDateLabel.numberOfLines = 0;
     [authorDateLabel sizeToFit];
     [scrollView addSubview:authorDateLabel];
     
     UIView * separator = [[UIView alloc] initWithFrame:CGRectMake(10, authorDateLabel.frame.origin.y + authorDateLabel.frame.size.height + 10, self.view.frame.size.width - 20, 1)];
     separator.backgroundColor = [UIColor blackColor];
     [scrollView addSubview:separator];
     
     UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(separator.frame.origin.x, separator.frame.origin.y + separator.frame.size.height + 10, self.view.frame.size.width - 20, 100)];
     textView.text = self.alert.contentString;
     textView.font = [UIFont systemFontOfSize:18];
     [textView sizeToFit];
     textView.editable = false;
     textView.scrollEnabled = false;
     textView.dataDetectorTypes = UIDataDetectorTypeLink;
     [scrollView addSubview:textView];
     
          //Takes care of all resizing needs based on sizes.
     self.automaticallyAdjustsScrollViewInsets = YES;
     UIEdgeInsets adjustForTabbarInsets = UIEdgeInsetsMake(0, 0, 60, 0);
     scrollView.contentInset = adjustForTabbarInsets;
     scrollView.scrollIndicatorInsets = adjustForTabbarInsets;
     CGRect contentRect = CGRectZero;
     for (UIView *view in scrollView.subviews) {
          contentRect = CGRectUnion(contentRect, view.frame);
     }
     scrollView.contentSize = contentRect.size;
     [self.view addSubview:scrollView];
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
