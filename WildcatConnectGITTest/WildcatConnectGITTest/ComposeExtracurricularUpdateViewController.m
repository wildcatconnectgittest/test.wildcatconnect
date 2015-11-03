//
//  ComposeExtracurricularUpdateViewController.m
//  WildcatConnectGITTest
//
//  Created by Kevin Lyons on 10/13/15.
//  Copyright © 2015 WildcatConnect. All rights reserved.
//

#import "ComposeExtracurricularUpdateViewController.h"
#import <Parse/Parse.h>
#import "ExtracurricularStructure.h"
#import "ExtracurricularUpdateStructure.h"

@interface ComposeExtracurricularUpdateViewController ()

@end

@implementation ComposeExtracurricularUpdateViewController {
     UILabel *titleLabel;
     UIPickerView *extracurricularPickerView;
     UILabel *messageRemainingLabel;
     UITextView *messageTextView;
     BOOL hasChanged;
     UIView *separator;
     UIButton *postButton;
     UIAlertView *postAlertView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     
     hasChanged = false;
     
          //UIBarButtonItem *bbtnBack = [[UIBarButtonItem alloc] initWithTitle:@"Back"
          //style:UIBarButtonItemStylePlain
          //target:self
          //action:@selector(goBack:)];
     
          //self.navigationItem.leftBarButtonItem = bbtnBack;
          //[bbtnBack release];
     
     self.navigationItem.title = @"Extracurricular Update";
     self.navigationController.navigationBar.translucent = NO;
     
     hasChanged = false;
     
     UIBarButtonItem *bbtnBack = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(goBack:)];
     
     self.navigationItem.leftBarButtonItem = bbtnBack;
     [bbtnBack release];
     
     UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
     [activity setBackgroundColor:[UIColor clearColor]];
     [activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
     UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:activity];
     self.navigationItem.rightBarButtonItem = barButtonItem;
     [activity startAnimating];
     [barButtonItem release];
     
     titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width - 20, 50)];
     titleLabel.text = @"Loading, please wait...";
     [titleLabel setFont:[UIFont systemFontOfSize:16]];
     titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
     titleLabel.numberOfLines = 0;
     [titleLabel sizeToFit];
     [self.view addSubview:titleLabel];
     
     [self getExtracurricularsMethodWithCompletion:^(NSMutableArray *returnArray, NSError *error) {
          self.ECarray = returnArray;
          dispatch_async(dispatch_get_main_queue(), ^ {
               [activity stopAnimating];
               titleLabel.text = @"Select Extracurricular";
               [titleLabel sizeToFit];
               
               extracurricularPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(10, titleLabel.frame.origin.y + titleLabel.frame.size.height + 10, self.view.frame.size.width - 20, 100)];
               extracurricularPickerView.delegate = self;
               extracurricularPickerView.showsSelectionIndicator = YES;
               [self.view addSubview:extracurricularPickerView];
               
               UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, extracurricularPickerView.frame.origin.y + extracurricularPickerView.frame.size.height + 10, self.view.frame.size.width - 20, 100)];
               messageLabel.text = @"Message";
               [messageLabel setFont:[UIFont systemFontOfSize:16]];
               messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
               messageLabel.numberOfLines = 0;
               [messageLabel sizeToFit];
               [self.view addSubview:messageLabel];
               
               messageRemainingLabel = [[UILabel alloc] init];
               messageRemainingLabel.text = @"140 characters remaining";
               [messageRemainingLabel setFont:[UIFont systemFontOfSize:10]];
               [messageRemainingLabel sizeToFit];
               messageRemainingLabel.frame = CGRectMake((self.view.frame.size.width - messageRemainingLabel.frame.size.width - 10), messageLabel.frame.origin.y, messageRemainingLabel.frame.size.width, 20);
               [self.view addSubview:messageRemainingLabel];
               
               messageTextView = [[UITextView alloc] initWithFrame:CGRectMake(messageLabel.frame.origin.x, messageLabel.frame.origin.y + messageLabel.frame.size.height + 10, self.view.frame.size.width - 20, 100)];
               [messageTextView setDelegate:self];
               [messageTextView setFont:[UIFont systemFontOfSize:16]];
               messageTextView.layer.borderWidth = 1.0f;
               messageTextView.layer.borderColor = [[UIColor grayColor] CGColor];
               messageTextView.scrollEnabled = false;
               messageTextView.tag = 3;
               [self.view addSubview:messageTextView];
               
               separator = [[UIView alloc] initWithFrame:CGRectMake(10, messageTextView.frame.origin.y + messageTextView.frame.size.height + 10, self.view.frame.size.width - 20, 1)];
               separator.backgroundColor = [UIColor blackColor];
               [self.view addSubview:separator];
               
               postButton = [UIButton buttonWithType:UIButtonTypeSystem];
               [postButton setTitle:@"POST UPDATE" forState:UIControlStateNormal];
               [postButton sizeToFit];
               [postButton addTarget:self action:@selector(postUpdate) forControlEvents:UIControlEventTouchUpInside];
               postButton.frame = CGRectMake((self.view.frame.size.width - postButton.frame.size.width - 10), separator.frame.origin.y + separator.frame.size.height + 10, postButton.frame.size.width, postButton.frame.size.height);
               [self.view addSubview:postButton];
          });
     }];
     
}

- (void)postUpdateMethodWithCompletion:(void (^)(NSError *error))completion {
     dispatch_group_t serviceGroup = dispatch_group_create();
     dispatch_group_enter(serviceGroup);
     __block NSError *theError;
     ExtracurricularUpdateStructure *extracurricularUpdateStructure = [[ExtracurricularUpdateStructure alloc] init];
     extracurricularUpdateStructure.extracurricularID = self.EC.extracurricularID;
     extracurricularUpdateStructure.messageString = messageTextView.text;
     PFQuery *query = [ExtracurricularUpdateStructure query];
     [query orderByDescending:@"extracurricularUpdateID"];
     [query getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
          ExtracurricularUpdateStructure *structure = (ExtracurricularUpdateStructure *)object;
          extracurricularUpdateStructure.extracurricularUpdateID = [NSNumber numberWithInt:[structure.extracurricularUpdateID integerValue] + 1];
          [extracurricularUpdateStructure saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
               if (error) {
                    theError = error;
               }
               dispatch_group_leave(serviceGroup);
          }];
     }];
     dispatch_group_notify(serviceGroup, dispatch_get_main_queue(), ^{
          completion(theError);
     });
}

- (void)postUpdate {
     if (! [self validateAllFields]) {
          UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please ensure you have correctly filled out all fields!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
          [alertView show];
     } else {
          postAlertView = [[UIAlertView alloc] initWithTitle:@"Confirmation" message:@"Are you sure you want to post this extracurricular update? It will be live to all app users." delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
          [postAlertView show];
     }
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
     if (hasChanged) {
          UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirmation"
                                                          message:@"Are you sure you want to go back? Any changes to this community service update will be lost."
                                                         delegate:self
                                                cancelButtonTitle:@"No"
                                                otherButtonTitles:@"Yes", nil];
          [alert show];
     }
}

- (BOOL)validateAllFields {
     return (self.EC && messageTextView.text.length > 0);
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
          // the user clicked one of the OK/Cancel buttons
     if (actionSheet == postAlertView) {
          if (buttonIndex == 1) {
               UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(10, postButton.frame.origin.y, 30, 30)];
               [activity setBackgroundColor:[UIColor clearColor]];
               [activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
               [self.view addSubview:activity];
               [activity startAnimating];
               [self postUpdateMethodWithCompletion:^(NSError *error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                         [activity stopAnimating];
                         NSMutableArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:@"visitedPagesArray"];
                         if ([array containsObject:[NSString stringWithFormat:@"%lu", (long)1]]) {
                              NSMutableArray *newArray = [array mutableCopy];
                              [newArray removeObject:[NSString stringWithFormat:@"%lu", (long)1]];
                              [[NSUserDefaults standardUserDefaults] setObject:newArray forKey:@"visitedPagesArray"];
                              [[NSUserDefaults standardUserDefaults] synchronize];
                         }
                         [self.navigationController popViewControllerAnimated:YES];
                    });
               }];
          }
          
     } else {
          if (buttonIndex == 1) {
               [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2] animated:YES];
          }
     }
}

- (void)goBack:(UIBarButtonItem *)sender
{
     if (hasChanged) {
          UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirmation"
                                                          message:@"Are you sure you want to go back? Any changes to this article will be lost."
                                                         delegate:self
                                                cancelButtonTitle:@"No"
                                                otherButtonTitles:@"Yes", nil];
          [alert show];
     }
     else {
          [self.navigationController popViewControllerAnimated:YES];
     }
}

-(void)textViewDidChange:(UITextView *)textView
{
     hasChanged = true;
     if (textView == messageTextView) {
          int len = textView.text.length;
          if (140 - len <= 10) {
               if (140 - len == 1) {
                    messageRemainingLabel.text= [[NSString stringWithFormat:@"%i",140-len] stringByAppendingString:@" character remaining"];
               } else {
                    
                    messageRemainingLabel.text= [[NSString stringWithFormat:@"%i",140-len] stringByAppendingString:@" characters remaining"];
               }
               messageRemainingLabel.textColor = [UIColor redColor];
               [messageRemainingLabel sizeToFit];
               messageRemainingLabel.frame = CGRectMake((self.view.frame.size.width - messageRemainingLabel.frame.size.width - 10), messageRemainingLabel.frame.origin.y, messageRemainingLabel.frame.size.width, 20);
          } else {
               messageRemainingLabel.text= [[NSString stringWithFormat:@"%i",140-len] stringByAppendingString:@" characters remaining"];
               messageRemainingLabel.textColor = [UIColor blackColor];
               [messageRemainingLabel sizeToFit];
               messageRemainingLabel.frame = CGRectMake((self.view.frame.size.width - messageRemainingLabel.frame.size.width - 10), messageRemainingLabel.frame.origin.y, messageRemainingLabel.frame.size.width, 20);
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
     if (textView == messageTextView) {
          return [self isAcceptableTextLength:textView.text.length + string.length - range.length forMaximum:140 existsMaximum:YES];
     }
     else return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
          // Handle the selection
     if (row == 0) {
               //Do nothing, top one selected...
     } else {
          self.EC = (ExtracurricularStructure *)self.ECarray[row - 1];
     }
}

     // tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
     
     return self.ECarray.count + 1;
     
}

     // tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
     return 1;
}

     // tell the picker the title for a given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
     
     if (row == 0) {
          return @"SELECT";
     } else {
          ExtracurricularStructure *EC = (ExtracurricularStructure *)self.ECarray[row - 1];
          
          return EC.titleString;
     }
}

     // tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
     int sectionWidth = 300;
     
     return sectionWidth;
}

- (void)getExtracurricularsMethodWithCompletion:(void (^)(NSMutableArray *returnArray, NSError *error))completion {
     dispatch_group_t serviceGroup = dispatch_group_create();
     dispatch_group_enter(serviceGroup);
     __block NSError *theError;
     NSMutableArray *returnArray = [NSMutableArray array];
     PFQuery *query = [ExtracurricularStructure query];
     [query orderByAscending:@"titleString"];
     [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
          [returnArray addObjectsFromArray:objects];
          if (error) {
               theError = error;
          }
          dispatch_group_leave(serviceGroup);
     }];
     dispatch_group_notify(serviceGroup, dispatch_get_main_queue(), ^ {
          completion(returnArray, theError);
     });
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
