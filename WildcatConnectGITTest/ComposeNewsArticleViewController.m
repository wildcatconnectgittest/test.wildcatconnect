//
//  ComposeNewsArticleViewController.m
//  WildcatConnectGITTest
//
//  Created by Kevin Lyons on 10/10/15.
//  Copyright © 2015 WildcatConnect. All rights reserved.
//

#import "ComposeNewsArticleViewController.h"
#import "AppManager.h"
#import "NewsArticleStructure.h"

@interface ComposeNewsArticleViewController ()

@end

@implementation ComposeNewsArticleViewController {
     UIScrollView *scrollView;
     UILabel *titleRemainingLabel;
     UITextView *titleTextView;
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
     
     UIBarButtonItem *bbtnBack = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(goBack:)];
     
     self.navigationItem.leftBarButtonItem = bbtnBack;
     [bbtnBack release];
     
     self.navigationItem.title = @"News Article";
     
     scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
     
     UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width - 20, 50)];
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
     summaryRemainingLabel.frame = CGRectMake((self.view.frame.size.width - summaryRemainingLabel.frame.size.width - 10), summaryLabel.frame.origin.y, summaryRemainingLabel.frame.size.width, 20);
     [scrollView addSubview:summaryRemainingLabel];
     
     summaryTextView = [[UITextView alloc] initWithFrame:CGRectMake(summaryLabel.frame.origin.x, summaryLabel.frame.origin.y + summaryLabel.frame.size.height + 10, self.view.frame.size.width - 20, 70)];
     [summaryTextView setDelegate:self];
     [summaryTextView setFont:[UIFont systemFontOfSize:16]];
     summaryTextView.layer.borderWidth = 1.0f;
     summaryTextView.layer.borderColor = [[UIColor grayColor] CGColor];
     summaryTextView.scrollEnabled = false;
     summaryTextView.tag = 3;
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
     articleTextView.tag = 4;
     [scrollView addSubview:articleTextView];
     
     imageLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, articleTextView.frame.origin.y + articleTextView.frame.size.height + 10, self.view.frame.size.width - 20, 100)];
     imageLabel.text = @"Image";
     [imageLabel setFont:[UIFont systemFontOfSize:16]];
     imageLabel.lineBreakMode = NSLineBreakByWordWrapping;
     imageLabel.numberOfLines = 0;
     [imageLabel sizeToFit];
     [scrollView addSubview:imageLabel];
     
     imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, imageLabel.frame.origin.y + imageLabel.frame.size.height + 10, self.view.frame.size.width - 20, 100)];
     [imageView sizeToFit];
     [scrollView addSubview:imageView];
     
     currentImageLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, imageLabel.frame.origin.y + imageLabel.frame.size.height + 10, self.view.frame.size.width - 20, 100)];
     UIFont *font = [UIFont systemFontOfSize:10];
     [currentImageLabel setFont:[UIFont fontWithDescriptor:[[font fontDescriptor] fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitItalic] size:font.pointSize]];
     currentImageLabel.text = @"No image selected.";
     currentImageLabel.lineBreakMode = NSLineBreakByWordWrapping;
     currentImageLabel.numberOfLines = 0;
     [currentImageLabel sizeToFit];
     [scrollView addSubview:currentImageLabel];
     
     imageButton = [UIButton buttonWithType:UIButtonTypeSystem];
     [imageButton setTitle:@"Select Image" forState:UIControlStateNormal];
     [imageButton sizeToFit];
     [imageButton addTarget:self action:@selector(selectImage) forControlEvents:UIControlEventTouchUpInside];
     imageButton.frame = CGRectMake(10, currentImageLabel.frame.origin.y + currentImageLabel.frame.size.height + 10, imageButton.frame.size.width, imageButton.frame.size.height);
     [scrollView addSubview:imageButton];
     
     separator = [[UIView alloc] initWithFrame:CGRectMake(10, imageButton.frame.origin.y + imageButton.frame.size.height + 10, self.view.frame.size.width - 20, 1)];
     separator.backgroundColor = [UIColor blackColor];
     [scrollView addSubview:separator];
     
     postButton = [UIButton buttonWithType:UIButtonTypeSystem];
     [postButton setTitle:@"POST ARTICLE" forState:UIControlStateNormal];
     [postButton sizeToFit];
     [postButton addTarget:self action:@selector(postArticle) forControlEvents:UIControlEventTouchUpInside];
     postButton.frame = CGRectMake((self.view.frame.size.width - postButton.frame.size.width - 10), separator.frame.origin.y + separator.frame.size.height + 10, postButton.frame.size.width, postButton.frame.size.height);
     [scrollView addSubview:postButton];
     
          //Takes care of all resizing needs based on sizes.
     self.automaticallyAdjustsScrollViewInsets = YES;
     UIEdgeInsets adjustForTabbarInsets = UIEdgeInsetsMake(0, 0, 2, 0);
     scrollView.contentInset = adjustForTabbarInsets;
     scrollView.scrollIndicatorInsets = adjustForTabbarInsets;
     CGRect contentRect = CGRectZero;
     for (UIView *view in scrollView.subviews) {
          contentRect = CGRectUnion(contentRect, view.frame);
     }
     scrollView.contentSize = contentRect.size;
     [self.view addSubview:scrollView];
}

- (void)postArticle {
     if (! [self validateAllFields]) {
          UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please ensure you have correctly filled out all fields!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
          [alertView show];
     } else {
          postAlertView = [[UIAlertView alloc] initWithTitle:@"Confirmation" message:@"Are you sure you want to post this article? It will be live to all app users." delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
          [postAlertView show];
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

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
     
     hasChanged = true;
     
     [currentImageLabel removeFromSuperview];
     
     UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
     imageView.image = [[AppManager getInstance] imageFromImage:chosenImage scaledToWidth:self.view.frame.size.width - 20];
     [imageView sizeToFit];
     imageView.frame = CGRectMake(10, imageLabel.frame.origin.y + imageLabel.frame.size.height + 10, imageView.frame.size.width, imageView.frame.size.height);
     [scrollView addSubview:imageView];
     
     [imageButton setTitle:@"Remove Image" forState:UIControlStateNormal];
     
     [imageButton sizeToFit];
     
     imageButton.frame = CGRectMake(10, imageView.frame.origin.y + imageView.frame.size.height + 10, imageButton.frame.size.width, imageButton.frame.size.height);
     
     separator.frame = CGRectMake(10, imageButton.frame.origin.y + imageButton.frame.size.height + 10, self.view.frame.size.width - 20, 1);
     
     postButton.frame = CGRectMake((self.view.frame.size.width - postButton.frame.size.width - 10), separator.frame.origin.y + separator.frame.size.height + 10, postButton.frame.size.width, postButton.frame.size.height);

     CGRect contentRect = CGRectZero;
     for (UIView *view in scrollView.subviews) {
          contentRect = CGRectUnion(contentRect, view.frame);
     }
     scrollView.contentSize = contentRect.size;
     
     [picker dismissViewControllerAnimated:YES completion:NULL];
     
}

- (void)selectImage {
     if (! imageView.image) {
          UIImagePickerController *picker = [[UIImagePickerController alloc] init];
          picker.delegate = self;
          picker.allowsEditing = YES;
          picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
          
          [self presentViewController:picker animated:YES completion:NULL];
     } else {
          imageView.image = nil;
          imageView.frame = CGRectMake(0, 0, 0, 0);
          [imageView removeFromSuperview];
          currentImageLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, imageLabel.frame.origin.y + imageLabel.frame.size.height + 10, self.view.frame.size.width - 20, 100)];
          UIFont *font = [UIFont systemFontOfSize:10];
          [currentImageLabel setFont:[UIFont fontWithDescriptor:[[font fontDescriptor] fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitItalic] size:font.pointSize]];
          currentImageLabel.text = @"No image selected.";
          currentImageLabel.lineBreakMode = NSLineBreakByWordWrapping;
          currentImageLabel.numberOfLines = 0;
          [currentImageLabel sizeToFit];
          [scrollView addSubview:currentImageLabel];
          [imageButton setTitle:@"Select Image" forState:UIControlStateNormal];
          [imageButton sizeToFit];
          imageButton.frame = CGRectMake(10, currentImageLabel.frame.origin.y + currentImageLabel.frame.size.height + 10, imageButton.frame.size.width, imageButton.frame.size.height);
          separator.frame = CGRectMake(10, imageButton.frame.origin.y + imageButton.frame.size.height + 10, self.view.frame.size.width - 20, 1);
          
          postButton.frame = CGRectMake((self.view.frame.size.width - postButton.frame.size.width - 10), separator.frame.origin.y + separator.frame.size.height + 10, postButton.frame.size.width, postButton.frame.size.height);
          CGRect contentRect = CGRectZero;
          for (UIView *view in scrollView.subviews) {
               if ([view class] != [UIImageView class]) {                    contentRect = CGRectUnion(contentRect, view.frame);
               }
          }
          scrollView.contentSize = contentRect.size;
     }
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
                         NSMutableArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:@"visitedPagesArray"];
                         if ([array containsObject:[NSString stringWithFormat:@"%lu", (long)0]]) {
                              NSMutableArray *newArray = [array mutableCopy];
                              [newArray removeObject:[NSString stringWithFormat:@"%lu", (long)0]];
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

- (void)postArticleMethodWithCompletion:(void (^)(NSError *error))completion {
     dispatch_group_t serviceGroup = dispatch_group_create();
     dispatch_group_enter(serviceGroup);
     __block NSError *theError;
     NewsArticleStructure *newsArticleStructure = [[NewsArticleStructure alloc] init];
     newsArticleStructure.titleString = titleTextView.text;
     newsArticleStructure.authorString = authorTextView.text;
     newsArticleStructure.dateString = dateTextView.text;
     newsArticleStructure.summaryString = summaryTextView.text;
     newsArticleStructure.contentURLString = articleTextView.text;
     newsArticleStructure.likes = [NSNumber numberWithInt:0];
     PFQuery *query = [NewsArticleStructure query];
     [query orderByDescending:@"articleID"];
     [query getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
          NewsArticleStructure *structure = (NewsArticleStructure *)object;
          newsArticleStructure.articleID = [NSNumber numberWithInt:[structure.articleID integerValue] + 1];
          if (imageView.image) {
               newsArticleStructure.hasImage = [NSNumber numberWithInt:1];
               NSData *data = UIImagePNGRepresentation(imageView.image);
               PFFile *imageFile = [PFFile fileWithData:data];
               newsArticleStructure.imageFile = imageFile;
          } else {
               newsArticleStructure.hasImage = [NSNumber numberWithInt:0];
          }
          [newsArticleStructure saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
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

- (void)getCountMethodWithCompletion:(void (^)(NSInteger count))completion {
     dispatch_group_t serviceGroup = dispatch_group_create();
     dispatch_group_enter(serviceGroup);
     PFQuery *query = [NewsArticleStructure query];
     __block int count;
     [query countObjectsInBackgroundWithBlock:^(int number, NSError * _Nullable error) {
          count = number;
          dispatch_group_leave(serviceGroup);
     }];
     dispatch_group_notify(serviceGroup, dispatch_get_main_queue(), ^ {
          completion(count);
     });
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
               summaryRemainingLabel.frame = CGRectMake((self.view.frame.size.width - summaryRemainingLabel.frame.size.width - 10), summaryRemainingLabel.frame.origin.y, summaryRemainingLabel.frame.size.width, 20);
          } else {
               summaryRemainingLabel.text= [[NSString stringWithFormat:@"%i",60-len] stringByAppendingString:@" characters remaining"];
               summaryRemainingLabel.textColor = [UIColor blackColor];
               [summaryRemainingLabel sizeToFit];
               summaryRemainingLabel.frame = CGRectMake((self.view.frame.size.width - summaryRemainingLabel.frame.size.width - 10), summaryRemainingLabel.frame.origin.y, summaryRemainingLabel.frame.size.width, 20);
          }
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

#pragma mark - Helper Methods

- (BOOL)validateAllFields {
     return (titleTextView.text.length > 0 && authorTextView.text.length > 0 && dateTextView.text.length > 0 && summaryTextView.text.length > 0 && articleTextView.text.length > 0);
}

@end
