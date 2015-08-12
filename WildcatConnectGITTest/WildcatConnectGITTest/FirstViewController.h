//
//  FirstViewController.h
//  WildcatConnectGITTest
//
//  Created by Kevin Lyons on 8/12/15.
//  Copyright (c) 2015 WildcatConnect. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstViewController : UIViewController {
    IBOutlet UIScrollView *scrollerhome;
    __weak IBOutlet UILabel *dateLabel;
    __weak IBOutlet UILabel *dayLabel;
    __weak IBOutlet UITextView *bellSchedLabel;
    __weak IBOutlet UITextView *homeInfoLabel;
}


@end

