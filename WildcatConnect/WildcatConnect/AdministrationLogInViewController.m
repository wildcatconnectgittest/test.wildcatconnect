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
#import "UserRegisterStructure.h"

@interface AdministrationLogInViewController ()

@end

@implementation AdministrationLogInViewController {
     BOOL hasChanged;
     BOOL keyboardIsShown;
     UIScrollView *scrollView;
     UITextField *usernameTextField;
     UITextField *passwordTextField;
     UITextField *firstNameTextField;
     UITextField *lastNameTextField;
     UITextField *emailTextField;
     UITextField *regUsernameTextField;
     UITextField *regPasswordTextField;
     UIButton *logButton;
     UIButton *signButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     
     self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:248.0f/255.0f
                                                                            green:183.0f/255.0f
                                                                             blue:23.0f/255.0f
                                                                            alpha:0.5f];
     
     hasChanged = false;
     
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
     
     self.navigationItem.title = @"Account";
     self.navigationController.navigationBar.translucent = NO;
     
     UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width - 20, 50)];
     titleLabel.text = @"Log In";
     [titleLabel setFont:[UIFont systemFontOfSize:16]];
     titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
     titleLabel.numberOfLines = 0;
     [titleLabel sizeToFit];
     [scrollView addSubview:titleLabel];
     
     usernameTextField = [[UITextField alloc] initWithFrame:CGRectMake(titleLabel.frame.origin.x, titleLabel.frame.origin.y + titleLabel.frame.size.height + 10, self.view.frame.size.width - 20, 31)];
     usernameTextField.borderStyle = UITextBorderStyleRoundedRect;
     usernameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
     usernameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
     usernameTextField.placeholder = @"Username";
     usernameTextField.tag = 0;
     [usernameTextField setDelegate:self];
     [scrollView addSubview:usernameTextField];
     
     passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(usernameTextField.frame.origin.x, usernameTextField.frame.origin.y + usernameTextField.frame.size.height + 10, self.view.frame.size.width - 20, 31)];
     passwordTextField.borderStyle = UITextBorderStyleRoundedRect;
     passwordTextField.placeholder = @"Password";
     passwordTextField.secureTextEntry = YES;
     passwordTextField.tag = 1;
     [passwordTextField setDelegate:self];
     [scrollView addSubview:passwordTextField];
     
     logButton = [UIButton buttonWithType:UIButtonTypeSystem];
     [logButton setTitle:@"LOG IN" forState:UIControlStateNormal];
     [logButton sizeToFit];
     [logButton addTarget:self action:@selector(logIn) forControlEvents:UIControlEventTouchUpInside];
     logButton.frame = CGRectMake((self.view.frame.size.width / 2 - logButton.frame.size.width / 2), passwordTextField.frame.origin.y + passwordTextField.frame.size.height + 10, logButton.frame.size.width, logButton.frame.size.height);
     [usernameTextField setDelegate:self];
     [scrollView addSubview:logButton];
     
     UILabel *signLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, logButton.frame.origin.y + logButton.frame.size.height + 10, self.view.frame.size.width - 20, 50)];
     signLabel.text = @"Register";
     [signLabel setFont:[UIFont systemFontOfSize:16]];
     signLabel.lineBreakMode = NSLineBreakByWordWrapping;
     signLabel.numberOfLines = 0;
     [signLabel sizeToFit];
     [scrollView addSubview:signLabel];
     
     firstNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(signLabel.frame.origin.x, signLabel.frame.origin.y + signLabel.frame.size.height + 10, self.view.frame.size.width - 20, 31)];
     firstNameTextField.borderStyle = UITextBorderStyleRoundedRect;
     firstNameTextField.placeholder = @"First Name";
     firstNameTextField.tag = 2;
     [firstNameTextField setDelegate:self];
     [scrollView addSubview:firstNameTextField];
     
     lastNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(signLabel.frame.origin.x, firstNameTextField.frame.origin.y + firstNameTextField.frame.size.height + 10, self.view.frame.size.width - 20, 31)];
     lastNameTextField.borderStyle = UITextBorderStyleRoundedRect;
     lastNameTextField.placeholder = @"Last Name";
     lastNameTextField.tag = 3;
     [lastNameTextField setDelegate:self];
     [scrollView addSubview:lastNameTextField];
     
     emailTextField = [[UITextField alloc] initWithFrame:CGRectMake(signLabel.frame.origin.x, lastNameTextField.frame.origin.y + lastNameTextField.frame.size.height + 10, self.view.frame.size.width - 20, 31)];
     emailTextField.borderStyle = UITextBorderStyleRoundedRect;
     emailTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
     emailTextField.autocorrectionType = UITextAutocorrectionTypeNo;
     emailTextField.placeholder = @"E-Mail";
     emailTextField.tag = 4;
     [emailTextField setDelegate:self];
     [scrollView addSubview:emailTextField];
     
     regUsernameTextField = [[UITextField alloc] initWithFrame:CGRectMake(titleLabel.frame.origin.x, emailTextField.frame.origin.y + emailTextField.frame.size.height + 10, self.view.frame.size.width - 20, 31)];
     regUsernameTextField.borderStyle = UITextBorderStyleRoundedRect;
     regUsernameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
     regUsernameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
     regUsernameTextField.placeholder = @"Username";
     regUsernameTextField.tag = 5;
     [regUsernameTextField setDelegate:self];
     [scrollView addSubview:regUsernameTextField];
     
     regPasswordTextField = [[UITextField alloc] initWithFrame:CGRectMake(regUsernameTextField.frame.origin.x, regUsernameTextField.frame.origin.y + regUsernameTextField.frame.size.height + 10, self.view.frame.size.width - 20, 31)];
     regPasswordTextField.borderStyle = UITextBorderStyleRoundedRect;
     regPasswordTextField.placeholder = @"Password";
     regPasswordTextField.secureTextEntry = YES;
     regPasswordTextField.tag = 6;
     [regPasswordTextField setDelegate:self];
     [scrollView addSubview:regPasswordTextField];
     
     signButton = [UIButton buttonWithType:UIButtonTypeSystem];
     [signButton setTitle:@"REGISTER" forState:UIControlStateNormal];
     [signButton sizeToFit];
     [signButton addTarget:self action:@selector(registerUser) forControlEvents:UIControlEventTouchUpInside];
     signButton.frame = CGRectMake((self.view.frame.size.width / 2 - signButton.frame.size.width / 2), regPasswordTextField.frame.origin.y + regPasswordTextField.frame.size.height + 10, signButton.frame.size.width, signButton.frame.size.height);
     [scrollView addSubview:signButton];
     
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

- (BOOL) validateEmail: (NSString *) candidate {
     NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,10}";
     NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
     
     return [emailTest evaluateWithObject:candidate];
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

- (void)registerUser{
     NSString *username = regUsernameTextField.text;
     NSString *password = regPasswordTextField.text;
     NSString *firstName = firstNameTextField.text;
     NSString *lastName = lastNameTextField.text;
     NSString *email = emailTextField.text;
     if ([username length] == 0 || [password length] == 0 || [firstName length] == 0 || [lastName length] == 0 || [email length] == 0 || [self validateEmail:email] == false) {
          UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Whoops!" message:@"You must enter a valid username and password." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
          [alertView show];
     } else {
          UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 15, signButton.frame.origin.y, 30, 30)];
          [signButton removeFromSuperview];
          [activity setBackgroundColor:[UIColor clearColor]];
          [activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
          [scrollView addSubview:activity];
          [activity startAnimating];
          [self registerMethodWithCompletion:^(NSError *error, NSInteger response) {
               dispatch_async(dispatch_get_main_queue(), ^ {
                    [activity stopAnimating];
                    if (response == 0) {
                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Error registering user. Please try again." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                         [alertView show];
                         regUsernameTextField.text = @"";
                         regPasswordTextField.text = @"";
                         firstNameTextField.text = @"";
                         lastNameTextField.text = @"";
                         emailTextField.text = @"";
                         [self.navigationController popViewControllerAnimated:YES];
                    } else if (response == 1) {
                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Success" message:@"This username or e-mail has already been used. Please try again." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                         [alertView show];
                         [activity removeFromSuperview];
                         signButton = [UIButton buttonWithType:UIButtonTypeSystem];
                         [signButton setTitle:@"REGISTER" forState:UIControlStateNormal];
                         [signButton sizeToFit];
                         [signButton addTarget:self action:@selector(registerUser) forControlEvents:UIControlEventTouchUpInside];
                         signButton.frame = CGRectMake((self.view.frame.size.width / 2 - signButton.frame.size.width / 2), regPasswordTextField.frame.origin.y + regPasswordTextField.frame.size.height + 10, signButton.frame.size.width, signButton.frame.size.height);
                         [scrollView addSubview:signButton];
                    } else if (response == 2) {
                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Success" message:@"You have successfully registered your WildcatConnect account! A member of administration will approve your request and you will then receive a confirmation e-mail." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                         [alertView show];
                         regUsernameTextField.text = @"";
                         regPasswordTextField.text = @"";
                         firstNameTextField.text = @"";
                         lastNameTextField.text = @"";
                         emailTextField.text = @"";
                         [self.navigationController popViewControllerAnimated:YES];
                    }
               });
          } forDictionary:@{ @"username" : username , @"password" : password , @"firstName" : firstName , @"lastName" : lastName , @"email" : email }];
     }
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
     NSInteger nextTag = textField.tag + 1;
          // Try to find next responder
     UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
     if (nextResponder) {
               // Found next responder, so set it.
          [nextResponder becomeFirstResponder];
     } else {
               // Not found, so remove keyboard.
          [textField resignFirstResponder];
     }
     return NO; // We do not want UITextField to insert line-breaks.
}

- (void)registerMethodWithCompletion:(void (^)(NSError *error, NSInteger response))completion forDictionary:(NSDictionary *)dictionary {
     dispatch_group_t serviceGroup = dispatch_group_create();
     dispatch_group_enter(serviceGroup);
     __block NSError *theError;
     __block NSInteger response = -1;
     [PFCloud callFunctionInBackground:@"validateUser" withParameters:@{ @"username" : [dictionary objectForKey:@"username"] , @"email" : [dictionary objectForKey:@"email"] } block:^(id  _Nullable object, NSError * _Nullable error) {
               //
          if ([object integerValue] > 0) {
               response = 1;
               dispatch_group_leave(serviceGroup);
          } else {
               [PFCloud callFunctionInBackground:@"encryptPassword" withParameters:@{ @"password" : [dictionary objectForKey:@"password"] } block:^(id  _Nullable object, NSError * _Nullable error) {
                    if (error != nil) {
                         theError = error;
                         response = 0;
                    }
                         //object contains the encrypted password
                    UserRegisterStructure *URS = [[UserRegisterStructure alloc] init];
                    URS.firstName = [dictionary objectForKey:@"firstName"];
                    URS.lastName = [dictionary objectForKey:@"lastName"];
                    URS.email = [dictionary objectForKey:@"email"];
                    URS.username = [dictionary objectForKey:@"username"];
                    URS.password = object;
                    [URS saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable errorTwo) {
                         if (errorTwo != nil) {
                              theError = errorTwo;
                              response = 0;
                         } else
                              response = 2;
                         dispatch_group_leave(serviceGroup);
                    }];
               }];
          }
     }];
     dispatch_group_notify(serviceGroup, dispatch_get_main_queue(), ^{
          completion(theError, response);
     });
}

- (void)logIn {
     NSString *username = usernameTextField.text;
     NSString *password = passwordTextField.text;
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
