//
//  AdministrationLogInViewController.h
//  WildcatConnectGITTest
//
//  Created by Kevin Lyons on 10/4/15.
//  Copyright © 2015 WildcatConnect. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdministrationLogInViewController : UIViewController

@property (retain, nonatomic) IBOutlet UITextField *usernameField;
@property (retain, nonatomic) IBOutlet UITextField *passwordField;

- (IBAction)logInButton:(id)sender;

@end
