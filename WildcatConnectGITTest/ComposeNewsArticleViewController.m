//
//  ComposeNewsArticleViewController.m
//  WildcatConnectGITTest
//
//  Created by Kevin Lyons on 10/10/15.
//  Copyright © 2015 WildcatConnect. All rights reserved.
//

#import "ComposeNewsArticleViewController.h"

@interface ComposeNewsArticleViewController ()

@end

@implementation ComposeNewsArticleViewController {
     UILabel *titleRemainingLabel;
     UITextView *titleTextView;
     UITextView *authorTextView;
     UITextView *dateTextView;
     UILabel *summaryRemainingLabel;
     UITextView *summaryTextView;
     UITextView *articleTextView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     
     UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelMethod)];
     self.navigationItem.rightBarButtonItem = cancelButton;
     [cancelButton release];
     
     UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
     
     UILabel *typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width - 20, 30)];
     typeLabel.text = @"Compose News Article";
     UIFont *font = [UIFont fontWithName:@"Helvetica Neue" size:20];
     [typeLabel setFont:[UIFont fontWithDescriptor:[[font fontDescriptor] fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold] size:font.pointSize]];
     typeLabel.lineBreakMode = NSLineBreakByWordWrapping;
     typeLabel.numberOfLines = 0;
     typeLabel.textAlignment = NSTextAlignmentCenter;
     [scrollView addSubview:typeLabel];
     
     UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, typeLabel.frame.origin.y + typeLabel.frame.size.height + 10, self.view.frame.size.width - 20, 50)];
     titleLabel.text = @"Title";
     [titleLabel setFont:[UIFont systemFontOfSize:16]];
     titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
     titleLabel.numberOfLines = 0;
     [titleLabel sizeToFit];
     [scrollView addSubview:titleLabel];
     
     titleRemainingLabel = [[UILabel alloc] init];
     titleRemainingLabel.text = @"50 characters remaining";
     [titleRemainingLabel setFont:[UIFont systemFontOfSize:10]];
     [titleRemainingLabel sizeToFit];
     titleRemainingLabel.frame = CGRectMake((self.view.frame.size.width - titleRemainingLabel.frame.size.width - 10), titleLabel.frame.origin.y, titleRemainingLabel.frame.size.width, 30);
     [scrollView addSubview:titleRemainingLabel];
     
     titleTextView = [[UITextView alloc] initWithFrame:CGRectMake(titleLabel.frame.origin.x, titleLabel.frame.origin.y + titleLabel.frame.size.height + 10, self.view.frame.size.width - 20, 70)];
     [titleTextView setDelegate:self];
     [titleTextView setFont:[UIFont systemFontOfSize:16]];
     titleTextView.layer.borderWidth = 1.0f;
     titleTextView.layer.borderColor = [[UIColor grayColor] CGColor];
     [scrollView addSubview:titleTextView];
     
     UILabel *authorLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, titleTextView.frame.origin.y + titleTextView.frame.size.height + 10, self.view.frame.size.width - 20, 100)];
     authorLabel.text = @"Author";
     [authorLabel setFont:[UIFont systemFontOfSize:16]];
     authorLabel.lineBreakMode = NSLineBreakByWordWrapping;
     authorLabel.numberOfLines = 0;
     [authorLabel sizeToFit];
     [scrollView addSubview:authorLabel];
     
     authorTextView = [[UITextView alloc] initWithFrame:CGRectMake(authorLabel.frame.origin.x, authorLabel.frame.origin.y + titleLabel.frame.size.height + 10, self.view.frame.size.width - 20, 35)];
     [authorTextView setDelegate:self];
     [authorTextView setFont:[UIFont systemFontOfSize:16]];
     authorTextView.layer.borderWidth = 1.0f;
     authorTextView.layer.borderColor = [[UIColor grayColor] CGColor];
     [scrollView addSubview:authorTextView];
     
     UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, authorTextView.frame.origin.y + authorTextView.frame.size.height + 10, self.view.frame.size.width - 20, 100)];
     dateLabel.text = @"Date (MM-dd-YYYY)";
     [dateLabel setFont:[UIFont systemFontOfSize:16]];
     dateLabel.lineBreakMode = NSLineBreakByWordWrapping;
     dateLabel.numberOfLines = 0;
     [dateLabel sizeToFit];
     [scrollView addSubview:dateLabel];
     
     dateTextView = [[UITextView alloc] initWithFrame:CGRectMake(dateLabel.frame.origin.x, dateLabel.frame.origin.y + dateLabel.frame.size.height + 10, self.view.frame.size.width - 20, 35)];
     [dateTextView setDelegate:self];
     [dateTextView setFont:[UIFont systemFontOfSize:16]];
     dateTextView.layer.borderWidth = 1.0f;
     dateTextView.layer.borderColor = [[UIColor grayColor] CGColor];
     NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
     [dateFormatter setDateFormat:@"MM-dd-yyyy"];
     NSDate *today = [NSDate date];
     dateTextView.text = [dateFormatter stringFromDate:today];
     [scrollView addSubview:dateTextView];
     
     UILabel *summaryLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, dateTextView.frame.origin.y + dateTextView.frame.size.height + 10, self.view.frame.size.width - 20, 100)];
     summaryLabel.text = @"Summary";
     [summaryLabel setFont:[UIFont systemFontOfSize:16]];
     summaryLabel.lineBreakMode = NSLineBreakByWordWrapping;
     summaryLabel.numberOfLines = 0;
     [summaryLabel sizeToFit];
     [scrollView addSubview:summaryLabel];
     
     summaryRemainingLabel = [[UILabel alloc] init];
     summaryRemainingLabel.text = @"60 characters remaining";
     [summaryRemainingLabel setFont:[UIFont systemFontOfSize:10]];
     [summaryRemainingLabel sizeToFit];
     summaryRemainingLabel.frame = CGRectMake((self.view.frame.size.width - summaryRemainingLabel.frame.size.width - 10), summaryLabel.frame.origin.y, summaryRemainingLabel.frame.size.width, 30);
     [scrollView addSubview:summaryRemainingLabel];
     
     summaryTextView = [[UITextView alloc] initWithFrame:CGRectMake(summaryLabel.frame.origin.x, summaryLabel.frame.origin.y + summaryLabel.frame.size.height + 10, self.view.frame.size.width - 20, 70)];
     [summaryTextView setDelegate:self];
     [summaryTextView setFont:[UIFont systemFontOfSize:16]];
     summaryTextView.layer.borderWidth = 1.0f;
     summaryTextView.layer.borderColor = [[UIColor grayColor] CGColor];
     [scrollView addSubview:summaryTextView];
     
     UILabel *articleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, summaryTextView.frame.origin.y + summaryTextView.frame.size.height + 10, self.view.frame.size.width - 20, 100)];
     articleLabel.text = @"Article Text";
     [articleLabel setFont:[UIFont systemFontOfSize:16]];
     articleLabel.lineBreakMode = NSLineBreakByWordWrapping;
     articleLabel.numberOfLines = 0;
     [articleLabel sizeToFit];
     [scrollView addSubview:articleLabel];
     
     articleTextView = [[UITextView alloc] initWithFrame:CGRectMake(articleLabel.frame.origin.x, articleLabel.frame.origin.y + articleLabel.frame.size.height + 10, self.view.frame.size.width - 20, 200)];
     [articleTextView setDelegate:self];
     [articleTextView setFont:[UIFont systemFontOfSize:16]];
     articleTextView.layer.borderWidth = 1.0f;
     articleTextView.layer.borderColor = [[UIColor grayColor] CGColor];
     articleTextView.dataDetectorTypes = UIDataDetectorTypeLink;
     [scrollView addSubview:articleTextView];
     
          //Takes care of all resizing needs based on sizes.
     UIEdgeInsets adjustForTabbarInsets = UIEdgeInsetsMake(0, 0, 10, 0);
     scrollView.contentInset = adjustForTabbarInsets;
     scrollView.scrollIndicatorInsets = adjustForTabbarInsets;
     CGRect contentRect = CGRectZero;
     for (UIView *view in scrollView.subviews) {
          contentRect = CGRectUnion(contentRect, view.frame);
     }
     scrollView.contentSize = contentRect.size;
     [self.view addSubview:scrollView];
}

- (void)cancelMethod {
     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Confirmation" message:@"Are you sure you want to cancel this news article? All progress will be lost." delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
     [alertView show];
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
          // the user clicked one of the OK/Cancel buttons
     if (buttonIndex == 1) {
          [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2] animated:YES];
     }
}

-(void)textViewDidChange:(UITextView *)textView
{
     if (textView == titleTextView) {
          int len = textView.text.length;
          if (50 - len <= 10) {
               if (50 - len == 1) {
                    titleRemainingLabel.text= [[NSString stringWithFormat:@"%i",50-len] stringByAppendingString:@" character remaining"];
               } else {
                    
                    titleRemainingLabel.text= [[NSString stringWithFormat:@"%i",50-len] stringByAppendingString:@" characters remaining"];
               }
               titleRemainingLabel.textColor = [UIColor redColor];
               [titleRemainingLabel sizeToFit];
               titleRemainingLabel.frame = CGRectMake((self.view.frame.size.width - titleRemainingLabel.frame.size.width - 10), titleRemainingLabel.frame.origin.y, titleRemainingLabel.frame.size.width, 30);
          } else {
               titleRemainingLabel.text= [[NSString stringWithFormat:@"%i",50-len] stringByAppendingString:@" characters remaining"];
               titleRemainingLabel.textColor = [UIColor blackColor];
               [titleRemainingLabel sizeToFit];
               titleRemainingLabel.frame = CGRectMake((self.view.frame.size.width - titleRemainingLabel.frame.size.width - 10), titleRemainingLabel.frame.origin.y, titleRemainingLabel.frame.size.width, 30);
          }
     } else if (textView == summaryTextView) {
          int len = textView.text.length;
          if (60 - len <= 10) {
               if (60 - len == 1) {
                    summaryRemainingLabel.text= [[NSString stringWithFormat:@"%i",60-len] stringByAppendingString:@" character remaining"];
               } else {
                    
                    summaryRemainingLabel.text= [[NSString stringWithFormat:@"%i",60-len] stringByAppendingString:@" characters remaining"];
               }
               summaryRemainingLabel.textColor = [UIColor redColor];
               [summaryRemainingLabel sizeToFit];
               summaryRemainingLabel.frame = CGRectMake((self.view.frame.size.width - summaryRemainingLabel.frame.size.width - 10), summaryRemainingLabel.frame.origin.y, summaryRemainingLabel.frame.size.width, 30);
          } else {
               summaryRemainingLabel.text= [[NSString stringWithFormat:@"%i",60-len] stringByAppendingString:@" characters remaining"];
               summaryRemainingLabel.textColor = [UIColor blackColor];
               [summaryRemainingLabel sizeToFit];
               summaryRemainingLabel.frame = CGRectMake((self.view.frame.size.width - summaryRemainingLabel.frame.size.width - 10), summaryRemainingLabel.frame.origin.y, summaryRemainingLabel.frame.size.width, 30);
          }
     }
}

- (BOOL)isAcceptableTextLength:(NSUInteger)length forMaximum:(NSUInteger)maximum existsMaximum:(BOOL)exists {
     if (exists) {
          return length <= maximum;
     }
     else return true;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)string {
     if (textView == titleTextView) {
          return [self isAcceptableTextLength:textView.text.length + string.length - range.length forMaximum:50 existsMaximum:YES];
     }
     else if (textView == authorTextView) {
          return [self isAcceptableTextLength:textView.text.length + string.length - range.length forMaximum:30 existsMaximum:YES];
     }
     else if (textView == dateTextView) {
          return [self isAcceptableTextLength:textView.text.length + string.length - range.length forMaximum:10 existsMaximum:YES];
     }
     else if (textView == summaryTextView) {
          return [self isAcceptableTextLength:textView.text.length + string.length - range.length forMaximum:60 existsMaximum:YES];
     } else if (textView == articleTextView) {
          return [self isAcceptableTextLength:textView.text.length + string.length - range.length forMaximum:0 existsMaximum:NO];
     }
     else return nil;
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
