//
//  PollDetailViewController.m
//  WildcatConnectGITTest
//
//  Created by Kevin Lyons on 11/8/15.
//  Copyright © 2015 WildcatConnect. All rights reserved.
//

#import "PollDetailViewController.h"

@interface PollDetailViewController ()

@end

@implementation PollDetailViewController {
     UILabel *titleLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
     self.navigationItem.title = @"Poll";
     
     UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
     
     titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width - 20, 100)];
     titleLabel.text = self.pollStructure.pollTitle;
     [titleLabel setFont:[UIFont systemFontOfSize:24]];
     titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
     titleLabel.numberOfLines = 0;
     [titleLabel sizeToFit];
     [scrollView addSubview:titleLabel];
     
     UILabel *questionLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel.frame.origin.x, titleLabel.frame.origin.y + titleLabel.frame.size.height + 10, self.view.frame.size.width - 20, 100)];
     questionLabel.text = self.pollStructure.pollQuestion;
     UIFont *font = [UIFont fontWithName:@"Helvetica Neue" size:16];
     [questionLabel setFont:[UIFont fontWithDescriptor:[[font fontDescriptor] fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitItalic] size:font.pointSize]];
     questionLabel.lineBreakMode = NSLineBreakByWordWrapping;
     questionLabel.numberOfLines = 0;
     [questionLabel sizeToFit];
     [scrollView addSubview:questionLabel];
     
     UIView * separator = [[UIView alloc] initWithFrame:CGRectMake(10, questionLabel.frame.origin.y + questionLabel.frame.size.height + 10, self.view.frame.size.width - 20, 1)];
     separator.backgroundColor = [UIColor blackColor];
     [scrollView addSubview:separator];
     
     if (self.pollStructure.pollType.integerValue == [NSNumber numberWithInt:0].integerValue) {
               //Yes or no only...
          UIButton *yesButton = [UIButton buttonWithType:UIButtonTypeSystem];
          [yesButton setTitle:@"YES" forState:UIControlStateNormal];
          [yesButton setTag:0];
          yesButton.titleLabel.font = [UIFont systemFontOfSize:24];
          [yesButton sizeToFit];
          [yesButton addTarget:self action:@selector(selectMethod:) forControlEvents:UIControlEventTouchUpInside];
          yesButton.frame = CGRectMake(10, separator.frame.origin.y + separator.frame.size.height + 10, yesButton.frame.size.width, yesButton.frame.size.height);
          [scrollView addSubview:yesButton];
          
          UIButton *noButton = [UIButton buttonWithType:UIButtonTypeSystem];
          [noButton setTitle:@"NO" forState:UIControlStateNormal];
          [noButton setTag:1];
          noButton.titleLabel.font = [UIFont systemFontOfSize:24];
          [noButton sizeToFit];
          [noButton addTarget:self action:@selector(selectMethod:) forControlEvents:UIControlEventTouchUpInside];
          noButton.frame = CGRectMake(self.view.frame.size.width - 10 - noButton.frame.size.width, separator.frame.origin.y + separator.frame.size.height + 10, noButton.frame.size.width, noButton.frame.size.height);
          [scrollView addSubview:noButton];
     }
     
     CGRect contentRect = CGRectZero;
     for (UIView *view in scrollView.subviews) {
          contentRect = CGRectUnion(contentRect, view.frame);
     }
     scrollView.contentSize = contentRect.size;
     [self.view addSubview:scrollView];
}

- (void)selectMethod:(id)sender {
     UIButton *button = (UIButton *)sender;
     NSLog(@"%@", button.titleLabel.text);
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
