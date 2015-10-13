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
     UIPickerView *extracurricularPickerView;
     UITextView *authorTextView;
     UITextView *dateTextView;
     UILabel *summaryRemainingLabel;
     UITextView *summaryTextView;
     UITextView *articleTextView;
     UILabel *imageLabel;
     UILabel *currentImageLabel;
     UIImageView *imageView;
     UIButton *imageButton;
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
     
     UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
     [activity setBackgroundColor:[UIColor clearColor]];
     [activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
     UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:activity];
     self.navigationItem.rightBarButtonItem = barButtonItem;
     [activity startAnimating];
     [barButtonItem release];
     
     [self getExtracurricularsMethodWithCompletion:^(NSMutableArray *returnArray, NSError *error) {
          self.ECarray = returnArray;
          dispatch_async(dispatch_get_main_queue(), ^ {
               [activity stopAnimating];
               UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width - 20, 50)];
               titleLabel.text = @"Select Extracurricular";
               [titleLabel setFont:[UIFont systemFontOfSize:16]];
               titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
               titleLabel.numberOfLines = 0;
               [titleLabel sizeToFit];
               [self.view addSubview:titleLabel];
               
               extracurricularPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(10, titleLabel.frame.origin.y + titleLabel.frame.size.height + 10, self.view.frame.size.width - 20, 200)];
               extracurricularPickerView.delegate = self;
               extracurricularPickerView.showsSelectionIndicator = YES;
               [self.view addSubview:extracurricularPickerView];
          });
     }];
     
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
          // Handle the selection
}

     // tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
     
     return self.ECarray.count;
}

     // tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
     return 1;
}

     // tell the picker the title for a given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
     
     ExtracurricularStructure *EC = (ExtracurricularStructure *)self.ECarray[row];
     
     return EC.titleString;
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
