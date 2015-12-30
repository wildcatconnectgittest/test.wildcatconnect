//
//  DisclaimerViewController.m
//  WildcatConnect
//
//  Created by Kevin Lyons on 12/29/15.
//  Copyright © 2015 WildcatConnect. All rights reserved.
//

#import "DisclaimerViewController.h"

@interface DisclaimerViewController ()

@end

@implementation DisclaimerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     
     self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:248.0f/255.0f
                                                                            green:183.0f/255.0f
                                                                             blue:23.0f/255.0f
                                                                            alpha:0.5f];
     UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width - 20, self.view.frame.size.height)];
     textView.text = @"Copyright \u00A9 WildcatConnect, 2015. All rights reserved.\n\nhttp://www.wildcatconnect.org\n\nDISCLAIMER";
     textView.font = [UIFont systemFontOfSize:18];
     textView.editable = false;
     textView.scrollEnabled = true;
     textView.dataDetectorTypes = UIDataDetectorTypeLink;
     [self.view addSubview:textView];
     
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
