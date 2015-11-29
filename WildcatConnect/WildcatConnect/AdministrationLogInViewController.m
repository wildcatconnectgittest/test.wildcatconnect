//
//  AdministrationLogInViewController.m
//  WildcatConnectGITTest
//
//  Created by Kevin Lyons on 10/4/15.
//  Copyright © 2015 WildcatConnect. All rights reserved.
//

#import "AdministrationLogInViewController.h"
#import <Parse/Parse.h>
#import "AdministrationMainTableViewController.h"

@interface AdministrationLogInViewController ()

@end

@implementation AdministrationLogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     
     self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:248.0f/255.0f
                                                                            green:183.0f/255.0f
                                                                             blue:23.0f/255.0f
                                                                            alpha:0.5f];
     
     self.usernameField.frame = CGRectMake(10, self.usernameField.frame.origin.y, self.view.frame.size.width - 20, self.usernameField.frame.size.height);
     self.passwordField.frame = CGRectMake(10, self.passwordField.frame.origin.y, self.view.frame.size.width - 20, self.passwordField.frame.size.height);
     
     [self.logInButton sizeToFit];
     self.logInButton.frame = CGRectMake(self.view.frame.size.width / 2 - self.logInButton.frame.size.width / 2, self.logInButton.frame.origin.y, self.logInButton.frame.size.width, self.logInButton.frame.size.height);
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

- (IBAction)logInButton:(id)sender {
     NSString *username = self.usernameField.text;
     NSString *password = self.passwordField.text;
     if ([username length] == 0 || [password length] == 0) {
          UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Whoops!" message:@"You must enter a valid username and password." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
          [alertView show];
     } else {
          UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
          [activity setBackgroundColor:[UIColor clearColor]];
          [activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
          UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:activity];
          self.navigationItem.rightBarButtonItem = barButtonItem;
          [activity startAnimating];
          [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * _Nullable user, NSError * _Nullable error) {
               if (! error) {
                    [self performSegueWithIdentifier:@"showAdministrationView" sender:self];
                    [activity stopAnimating];
               } else if (error) {
                    [activity stopAnimating];
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Whoops!" message:@"Error logging in. Please try again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    [alertView show];
               }
          }];
     }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     UIViewController *sourceViewController = segue.sourceViewController;
     UIViewController *destinationController = segue.destinationViewController;
     UINavigationController *navigationController = sourceViewController.navigationController;
          // Pop to root view controller (not animated) before pushing
     [navigationController popToRootViewControllerAnimated:NO];
     [navigationController pushViewController:destinationController animated:YES];
}
@end
