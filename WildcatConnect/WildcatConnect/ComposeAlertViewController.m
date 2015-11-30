//
//  ComposeAlertViewController.m
//  WildcatConnectGITTest
//
//  Created by Kevin Lyons on 11/28/15.
//  Copyright © 2015 WildcatConnect. All rights reserved.
//

#import "ComposeAlertViewController.h"
#import <Parse/Parse.h>
#import "AlertStructure.h"

@interface ComposeAlertViewController ()

@end

@implementation ComposeAlertViewController {
     BOOL hasChanged;
     BOOL keyboardIsShown;
     UIScrollView *scrollView;
     UILabel *titleRemainingLabel;
     UITextView *titleTextView;
     UIAlertView *postAlertView;
     UITextView *authorTextView;
     UITextView *dateTextView;
     UITextView *alertTextView;
     UIView *separator;
     UIButton *postButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     
     self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:248.0f/255.0f
                                                                            green:183.0f/255.0f
                                                                             blue:23.0f/255.0f
                                                                            alpha:0.5f];
     
     hasChanged = false;
     
     UIBarButtonItem *bbtnBack = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(goBack:)];
     
     self.navigationItem.leftBarButtonItem = bbtnBack;
     
     [[NSNotificationCenter defaultCenter] addObserver:self
                                              selector:@selector(keyboardWillShow:)
                                                  name:UIKeyboardWillShowNotification
                                                object:self.view.window];
          // register for keyboard notifications
     [[NSNotificationCenter defaultCenter] addObserver:self
                                              selector:@selector(keyboardWillHide:)
                                                  name:UIKeyboardWillHideNotification
                                                object:self.view.window];
     keyboardIsShown = NO;
     
     scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
     scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
     
     self.navigationItem.title = @"Alert";
     self.navigationController.navigationBar.translucent = NO;
     
     UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width - 20, 50)];
     titleLabel.text = @"Alert Title";
     [titleLabel setFont:[UIFont systemFontOfSize:16]];
     titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
     titleLabel.numberOfLines = 0;
     [titleLabel sizeToFit];
     [scrollView addSubview:titleLabel];
     
     titleRemainingLabel = [[UILabel alloc] init];
     titleRemainingLabel.text = @"50 characters remaining";
     [titleRemainingLabel setFont:[UIFont systemFontOfSize:10]];
     [titleRemainingLabel sizeToFit];
     titleRemainingLabel.frame = CGRectMake((self.view.frame.size.width - titleRemainingLabel.frame.size.width - 10), titleLabel.frame.origin.y, titleRemainingLabel.frame.size.width, 20);
     [scrollView addSubview:titleRemainingLabel];
     
     titleTextView = [[UITextView alloc] initWithFrame:CGRectMake(titleLabel.frame.origin.x, titleLabel.frame.origin.y + titleLabel.frame.size.height + 10, self.view.frame.size.width - 20, 70)];
     [titleTextView setDelegate:self];
     [titleTextView setFont:[UIFont systemFontOfSize:16]];
     titleTextView.layer.borderWidth = 1.0f;
     titleTextView.layer.borderColor = [[UIColor grayColor] CGColor];
     titleTextView.scrollEnabled = false;
     titleTextView.tag = 0;
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
     authorTextView.scrollEnabled = false;
     authorTextView.tag = 1;
     NSString *lastName = [[PFUser currentUser] objectForKey:@"lastName"];
     NSString *firstName = [[PFUser currentUser] objectForKey:@"firstName"];
     NSString *authorString = [[firstName stringByAppendingString:@" "] stringByAppendingString:lastName];
     authorTextView.text = authorString;
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
     dateTextView.scrollEnabled = false;
     dateTextView.tag = 2;
     [scrollView addSubview:dateTextView];
     
     UILabel *articleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, dateTextView.frame.origin.y + dateTextView.frame.size.height + 10, self.view.frame.size.width - 20, 100)];
     articleLabel.text = @"Alert Text";
     [articleLabel setFont:[UIFont systemFontOfSize:16]];
     articleLabel.lineBreakMode = NSLineBreakByWordWrapping;
     articleLabel.numberOfLines = 0;
     [articleLabel sizeToFit];
     [scrollView addSubview:articleLabel];
     
     alertTextView = [[UITextView alloc] initWithFrame:CGRectMake(articleLabel.frame.origin.x, articleLabel.frame.origin.y + articleLabel.frame.size.height + 10, self.view.frame.size.width - 20, 200)];
     [alertTextView setDelegate:self];
     [alertTextView setFont:[UIFont systemFontOfSize:16]];
     alertTextView.layer.borderWidth = 1.0f;
     alertTextView.layer.borderColor = [[UIColor grayColor] CGColor];
     alertTextView.dataDetectorTypes = UIDataDetectorTypeLink;
     alertTextView.tag = 4;
     [scrollView addSubview:alertTextView];
     
     separator = [[UIView alloc] initWithFrame:CGRectMake(10, alertTextView.frame.origin.y + alertTextView.frame.size.height + 10, self.view.frame.size.width - 20, 1)];
     separator.backgroundColor = [UIColor blackColor];
     [scrollView addSubview:separator];
     
     postButton = [UIButton buttonWithType:UIButtonTypeSystem];
     [postButton setTitle:@"POST ALERT" forState:UIControlStateNormal];
     [postButton sizeToFit];
     [postButton addTarget:self action:@selector(postAlert) forControlEvents:UIControlEventTouchUpInside];
     postButton.frame = CGRectMake((self.view.frame.size.width - postButton.frame.size.width - 10), separator.frame.origin.y + separator.frame.size.height + 10, postButton.frame.size.width, postButton.frame.size.height);
     [scrollView addSubview:postButton];
     
          //self.automaticallyAdjustsScrollViewInsets = YES;
     UIEdgeInsets adjustForTabbarInsets = UIEdgeInsetsMake(0, 0, 70, 0);
     scrollView.contentInset = adjustForTabbarInsets;
     scrollView.scrollIndicatorInsets = adjustForTabbarInsets;
     CGRect contentRect = CGRectZero;
     for (UIView *view in scrollView.subviews) {
          contentRect = CGRectUnion(contentRect, view.frame);
     }
     scrollView.contentSize = contentRect.size;
     [self.view addSubview:scrollView];
}

- (void)postAlert {
     if (! [self validateAllFields]) {
          UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please ensure you have correctly filled out all fields!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
          [alertView show];
     } else {
          postAlertView = [[UIAlertView alloc] initWithTitle:@"Confirmation" message:@"Are you sure you want to post this alert? It will be live to all app users." delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
          [postAlertView show];
     }
}

- (BOOL)validateAllFields {
     return (titleTextView.text.length > 0 && authorTextView.text.length > 0 && dateTextView.text.length > 0 && alertTextView.text.length > 0);
}

-(void)textViewDidChange:(UITextView *)textView
{
     hasChanged = true;
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
               titleRemainingLabel.frame = CGRectMake((self.view.frame.size.width - titleRemainingLabel.frame.size.width - 10), titleRemainingLabel.frame.origin.y, titleRemainingLabel.frame.size.width, 20);
          } else {
               titleRemainingLabel.text= [[NSString stringWithFormat:@"%i",50-len] stringByAppendingString:@" characters remaining"];
               titleRemainingLabel.textColor = [UIColor blackColor];
               [titleRemainingLabel sizeToFit];
               titleRemainingLabel.frame = CGRectMake((self.view.frame.size.width - titleRemainingLabel.frame.size.width - 10), titleRemainingLabel.frame.origin.y, titleRemainingLabel.frame.size.width, 20);
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
          if([string isEqualToString:@"\n"])
          {
               [textView resignFirstResponder];
               
               return NO;
          } else
               return [self isAcceptableTextLength:textView.text.length + string.length - range.length forMaximum:50 existsMaximum:YES];
     } else if (textView == authorTextView || textView == dateTextView) {
          if([string isEqualToString:@"\n"])
          {
               [textView resignFirstResponder];
               
               return NO;
          } return NO;
     } else if (textView == alertTextView) {
          return [self isAcceptableTextLength:textView.text.length + string.length - range.length forMaximum:0 existsMaximum:NO];
     }
     else return nil;
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
          // the user clicked one of the OK/Cancel buttons
     if (actionSheet == postAlertView) {
          if (buttonIndex == 1) {
               UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(10, postButton.frame.origin.y, 30, 30)];
               [activity setBackgroundColor:[UIColor clearColor]];
               [activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
               [scrollView addSubview:activity];
               [activity startAnimating];
                    [self postArticleMethodWithCompletion:^(NSError *error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                         [activity stopAnimating];
                         [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"reloadAlertsPage"];
                         [[NSUserDefaults standardUserDefaults] synchronize];
                         [self.navigationController popViewControllerAnimated:YES];
                    });
               }];
          }
     }
     else {
          if (buttonIndex == 1) {
               [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2] animated:YES];
          }
     }
}

- (void)postArticleMethodWithCompletion:(void (^)(NSError *error))completion {
     dispatch_group_t serviceGroup = dispatch_group_create();
     dispatch_group_enter(serviceGroup);
     __block NSError *theError;
     __block NSString *theString;
     AlertStructure *alertStructure = [[AlertStructure alloc] init];
     alertStructure.titleString = titleTextView.text;
     alertStructure.authorString = authorTextView.text;
     alertStructure.dateString = dateTextView.text;
     alertStructure.contentString = alertTextView.text;
     PFQuery *query = [AlertStructure query];
     [query orderByDescending:@"alertID"];
     [query getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
          AlertStructure *structure = (AlertStructure *)object;
          NSString *currentID = structure.alertID;
          NSNumber *theNumber = [NSNumber numberWithInt:([structure.alertID integerValue] + 1)];
          NSLog(@"%@", theNumber);
          theString = alertStructure.alertID;
          [alertStructure saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
               if (error) {
                    theError = error;
               }
               
                    // Create our Installation query
               NSDictionary *data = @{
                                      @"alert" : titleTextView.text,
                                      @"badge" : @"Increment",
                                      @"sounds" : @"default",
                                      @"a" : theString
                                      };
               PFQuery *pushQuery = [PFInstallation query];
               [pushQuery whereKey:@"installationId" notEqualTo:[[PFInstallation currentInstallation] installationId]];
               PFPush *push = [[PFPush alloc] init];
               [push setQuery:pushQuery];
               [push setData:data];
               [push sendPushInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                    if (error) {
                         NSLog(@"%@", error);
                    } else {
                         dispatch_group_leave(serviceGroup);
                    }
               }];
          }];
     }];
     dispatch_group_notify(serviceGroup, dispatch_get_main_queue(), ^{
          completion(theError);
     });
}

- (void)goBack:(UIBarButtonItem *)sender
{
     if (hasChanged) {
          UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirmation"
                                                          message:@"Are you sure you want to go back? Any changes to this alert will be lost."
                                                         delegate:self
                                                cancelButtonTitle:@"No"
                                                otherButtonTitles:@"Yes", nil];
          [alert show];
     }
     else {
          [self.navigationController popViewControllerAnimated:YES];
     }
}

- (void)keyboardWillHide:(NSNotification *)n
{
     
     scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
     
     keyboardIsShown = NO;
     
     self.automaticallyAdjustsScrollViewInsets = YES;
     UIEdgeInsets adjustForTabbarInsets = UIEdgeInsetsMake(0, 0, 70, 0);
     scrollView.contentInset = adjustForTabbarInsets;
     scrollView.scrollIndicatorInsets = adjustForTabbarInsets;
     CGRect contentRect = CGRectZero;
     for (UIView *view in scrollView.subviews) {
          contentRect = CGRectUnion(contentRect, view.frame);
     }
     scrollView.contentSize = contentRect.size;
     [self.view addSubview:scrollView];
}

- (void)keyboardWillShow:(NSNotification *)n
{
          // This is an ivar I'm using to ensure that we do not do the frame size adjustment on the `UIScrollView` if the keyboard is already shown.  This can happen if the user, after fixing editing a `UITextField`, scrolls the resized `UIScrollView` to another `UITextField` and attempts to edit the next `UITextField`.  If we were to resize the `UIScrollView` again, it would be disastrous.  NOTE: The keyboard notification will fire even when the keyboard is already shown.
     if (keyboardIsShown) {
          return;
     }
     
     NSDictionary* userInfo = [n userInfo];
     
          // get the size of the keyboard
     CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
     
          // resize the noteView
     CGRect viewFrame = scrollView.frame;
          // I'm also subtracting a constant kTabBarHeight because my UIScrollView was offset by the UITabBar so really only the portion of the keyboard that is leftover pass the UITabBar is obscuring my UIScrollView.
     viewFrame.size.height -= (keyboardSize.height - 1);
     
     [UIView beginAnimations:nil context:NULL];
     [UIView setAnimationBeginsFromCurrentState:YES];
     [scrollView setFrame:viewFrame];
     [UIView commitAnimations];
     keyboardIsShown = YES;
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
