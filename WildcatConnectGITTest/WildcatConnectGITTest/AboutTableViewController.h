//
//  AboutTableViewController.h
//  WildcatConnectGITTest
//
//  Created by Rohith Parvathaneni on 11/3/15.
//  Copyright © 2015 WildcatConnect. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutTableViewController : UITableViewController{
    IBOutlet UIScrollView *scrollerabout;
    
    
    NSMutableArray *linksArray;
    
}
@property (nonatomic, retain) NSMutableArray *linksArray;



@end
