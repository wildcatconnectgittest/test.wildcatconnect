//
//  NewsArticleDetailViewController.m
//  WildcatConnectGITTest
//
//  Created by Rohith Parvathaneni on 9/13/15.
//  Copyright (c) 2015 WildcatConnect. All rights reserved.
//

#import "NewsArticleDetailViewController.h"

@interface NewsArticleDetailViewController ()

@end

@implementation NewsArticleDetailViewController {
     UILabel *likesLabel;
     UILabel *titleLabel;
     UIButton *likesButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
     
     self.navigationItem.title = @"Article";
     
     UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
     
     if ([self.NA.hasImage integerValue] == 1) {
          UIImageView *imageView =[[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - self.image.size.width / 2,10,self.view.frame.size.width - 20, 100)];
          imageView.image = self.image;
          [imageView sizeToFit];
          [scrollView addSubview:imageView];
          
          titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, imageView.frame.origin.y + imageView.frame.size.height + 10, self.view.frame.size.width - 20, 100)];
     } else {
          titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width - 20, 100)];
     }
                    titleLabel.text = self.NA.titleString;
                    [titleLabel setFont:[UIFont systemFontOfSize:24]];
                    titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
                    titleLabel.numberOfLines = 0;
                    [titleLabel sizeToFit];
                    [scrollView addSubview:titleLabel];
                    
                    UILabel *summaryLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel.frame.origin.x, titleLabel.frame.origin.y + titleLabel.frame.size.height + 10, self.view.frame.size.width - 20, 100)];
                    summaryLabel.text = self.NA.summaryString;
                    UIFont *font = [UIFont fontWithName:@"Helvetica Neue" size:16];
                    [summaryLabel setFont:[UIFont fontWithDescriptor:[[font fontDescriptor] fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitItalic] size:font.pointSize]];
                    summaryLabel.lineBreakMode = NSLineBreakByWordWrapping;
                    summaryLabel.numberOfLines = 0;
                    [summaryLabel sizeToFit];
                    [scrollView addSubview:summaryLabel];
                    
                    UILabel *authorDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(summaryLabel.frame.origin.x, summaryLabel.frame.origin.y + summaryLabel.frame.size.height + 10, self.view.frame.size.width - 20, 100)];
                    authorDateLabel.text = [[self.NA.authorString stringByAppendingString:@" | "] stringByAppendingString:self.NA.dateString];
                    [authorDateLabel setFont:[UIFont systemFontOfSize:12]];
                    authorDateLabel.lineBreakMode = NSLineBreakByWordWrapping;
                    authorDateLabel.numberOfLines = 0;
                    [authorDateLabel sizeToFit];
                    [scrollView addSubview:authorDateLabel];
                    
                    likesLabel = [[UILabel alloc] initWithFrame:CGRectMake(authorDateLabel.frame.origin.x, authorDateLabel.frame.origin.y + authorDateLabel.frame.size.height + 10, self.view.frame.size.width - 20, 30)];
                    likesLabel.text = [[self.NA.likes stringValue] stringByAppendingString:@" likes"];
                    [likesLabel setFont:[UIFont systemFontOfSize:16]];
                    [scrollView addSubview:likesLabel];
     
     NSMutableArray *liked = [[NSUserDefaults standardUserDefaults] objectForKey:@"likedNewsArticles"];
     if (liked) {
          if (! [liked containsObject:self.NA.articleID]) {
               likesButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
               [likesButton addTarget:self action:@selector(likeMethod) forControlEvents:UIControlEventTouchUpInside];
               [likesButton setTitle:@"Like this!" forState:UIControlStateNormal];
               [likesButton sizeToFit];
               CGFloat width = likesButton.frame.size.width;
               likesButton.frame = CGRectMake((self.view.frame.size.width - width - 10), likesLabel.frame.origin.y, likesButton.frame.size.width, 30);
               [scrollView addSubview:likesButton];
          }
     } else {
          likesButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
          [likesButton addTarget:self action:@selector(likeMethod) forControlEvents:UIControlEventTouchUpInside];
          [likesButton setTitle:@"Like this!" forState:UIControlStateNormal];
          [likesButton sizeToFit];
          CGFloat width = likesButton.frame.size.width;
          likesButton.frame = CGRectMake((self.view.frame.size.width - width - 10), likesLabel.frame.origin.y, likesButton.frame.size.width, 30);
          [scrollView addSubview:likesButton];
     }
     
                    UIView * separator = [[UIView alloc] initWithFrame:CGRectMake(10, likesLabel.frame.origin.y + likesLabel.frame.size.height + 10, self.view.frame.size.width - 20, 1)];
                    separator.backgroundColor = [UIColor blackColor];
                    [scrollView addSubview:separator];
                    
                    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(separator.frame.origin.x, separator.frame.origin.y + separator.frame.size.height + 10, self.view.frame.size.width - 20, 100)];
                    textView.text = @"This is a test of individual paragraphs within the text..\n\nTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTesting\n\nHere we go baby!!!\n\nhttp://www.kevinalyons.com\n\nhis is a test of individual paragraphs within the text..\n\nTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTesting\n\nHere we goTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTesting\n\nHere we goTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTesting\n\nHere we goTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTesting\n\nHere we goTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTesting\n\nHere we goTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTesting\n\nHere we goTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTesting\n\nHere we goTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTesting\n\nHere we go";
                    [textView sizeToFit];
                    textView.editable = false;
                    textView.scrollEnabled = false;
                    textView.dataDetectorTypes = UIDataDetectorTypeLink;
                    [scrollView addSubview:textView];
                    
                         //Takes care of all resizing needs based on sizes.
                    CGRect contentRect = CGRectZero;
                    for (UIView *view in scrollView.subviews) {
                         contentRect = CGRectUnion(contentRect, view.frame);
                    }
                    scrollView.contentSize = contentRect.size;
                    [self.view addSubview:scrollView];
}

- (void)applyFormattingAtStart:(CGFloat)startingY {
     
}

- (void)getImageWithCompletion:(void (^)(NSError *error, UIImage *image))completion {
     dispatch_group_t serviceGroup = dispatch_group_create();
     dispatch_group_enter(serviceGroup);
     PFFile *imageFile = self.NA.imageFile;
     UIImage *image = [UIImage alloc];
     __block NSError *theError;
     [imageFile getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
          [image initWithData:data];
          if (error) {
               theError = error;
          }
          dispatch_group_leave(serviceGroup);
     }];
     dispatch_group_notify(serviceGroup, dispatch_get_main_queue(), ^ {
          completion(theError, image);
     });
}

- (void)likeMethod {
     NSInteger likes = [self.NA.likes integerValue];
     NSNumber *newLikes = [NSNumber numberWithInt:likes + 1];
     self.NA.likes = newLikes;
     likesLabel.text = [[self.NA.likes stringValue] stringByAppendingString:@" likes"];
     PFQuery *query = [NewsArticleStructure query];
     [query getObjectInBackgroundWithId:self.NA.objectId block:^(PFObject *pfObject, NSError *error) {
          [pfObject setObject:newLikes forKey:@"likes"];
          [pfObject saveInBackground];
     }];
     NSMutableArray *theLikedNews = [[[NSUserDefaults standardUserDefaults] objectForKey:@"likedNewsArticles"] mutableCopy];
     if (! theLikedNews) {
          theLikedNews = [[NSMutableArray alloc] init];
     }
     if (! [theLikedNews containsObject:self.NA.articleID]) {
          [theLikedNews addObject:self.NA.articleID];
          [[NSUserDefaults standardUserDefaults] setObject:theLikedNews forKey:@"likedNewsArticles"];
          [[NSUserDefaults standardUserDefaults] synchronize];
     }
     [likesButton removeFromSuperview];
}

- (instancetype)initWithNewsArticle:(NewsArticleStructure *)newsArticle {
     [super init];
     self.NA = newsArticle;
     self.navigationItem.title = @"Article";
     return self;
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

#pragma mark - UIStateRestoration

NSString *const ViewControllerProductKey = @"ViewControllerProductKey";

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {
    [super encodeRestorableStateWithCoder:coder];
    
    // encode the product
    [coder encodeObject:self.NA forKey:ViewControllerProductKey];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder {
    [super decodeRestorableStateWithCoder:coder];
    
    // restore the product
    self.NA = [coder decodeObjectForKey:ViewControllerProductKey];
}
@end
