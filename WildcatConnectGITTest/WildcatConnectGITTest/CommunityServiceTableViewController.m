//
//  CommunityServiceTableViewController.m
//  WildcatConnectGITTest
//
//  Created by Rohith Parvathaneni on 8/17/15.
//  Copyright (c) 2015 WildcatConnect. All rights reserved.
//

#import "CommunityServiceTableViewController.h"
#import "CommunityServiceStructure.h"
@interface CommunityServiceTableViewController ()

@end

@implementation CommunityServiceTableViewController{
    UIActivityIndicatorView *activity;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // NSLog(@"%@", self.IsNewNumber);
    //if (self.IsNewNumber != [NSNumber numberWithInt:1]) {
    activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [activity setBackgroundColor:[UIColor clearColor]];
    [activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:activity];
    self.navigationItem.rightBarButtonItem = barButton;
    [activity startAnimating];
    [self testMethodWithCompletion:^(NSError *error, NSMutableArray *returnArrayA) {
        NSLog(@"Done!");
        NSLog(@"%@", returnArrayA);
        self.allOpps = returnArrayA;
        [self testMethodThreeWithCompletion:^(NSMutableArray *returnArrayB, NSMutableArray *returnArray2) {
            //first is old - B
            //new ones
            NSLog(@"%@", returnArrayB);
            NSLog(@"%@", returnArray2);
            self.newOpps = returnArray2;
            self.oldOpps = returnArrayB;
            dispatch_async(dispatch_get_main_queue(), ^ {
                [activity stopAnimating];
                                 [self.tableView reloadData];
                UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(viewDidLoad)];
                self.navigationItem.rightBarButtonItem = barButtonItem;
            });
        } withArray:returnArrayA];
    }];
    //   }
    /*  else {
     UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(viewDidLoad)];
     self.navigationItem.rightBarButtonItem = barButtonItem;
     self.loadNumber = [NSNumber numberWithInt:0];
     }*/
    
    
    
    // Do any additional setup after loading the view.
}



- (void)testMethodWithCompletion:(void (^)(NSError *error, NSMutableArray *returnArray))completion {
    //Define errors to be processed when everything is complete.
    //One error per service; in this example we'll have two
    __block NSError *firstError = nil;
    //Create the dispatch group
    dispatch_group_t serviceGroup = dispatch_group_create();
    //Start the first service
    dispatch_group_enter(serviceGroup);
    NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    PFQuery *query = [CommunityServiceStructure query];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [returnArray addObjectsFromArray:objects];
        firstError = error;
        dispatch_group_leave(serviceGroup);
    }];
    dispatch_group_notify(serviceGroup, dispatch_get_main_queue(), ^{
        NSError *overallError = nil;
        if (firstError)
            overallError = firstError;
        completion(overallError, returnArray);
    });
}





- (void)testMethodTwoWithCompletion:(void (^)(NSError *error, NSMutableArray *returnArray))completion withArray:(NSMutableArray *)array {
    /*CommunityServiceStructure *commServiceStructure;
     for (int i = 0; i < upcomingOpps.count; i++) {
     commServiceStructure = (CommunityServiceStructure *)[upcomingOpps objectAtIndex:i];
     PFFile *file = commServiceStructure.imageFile;
     NSData *data = [file getData];
     UIImage *image = [UIImage imageWithData:data];
     image = [[AppManager getInstance] imageFromImage:image scaledToWidth:70];
     [self.commmImages addObject:image];
     }*/
    __block NSError *theError = nil;
    dispatch_group_t theServiceGroup = dispatch_group_create();
    dispatch_group_enter(theServiceGroup);
    CommunityServiceStructure *commServiceStructure;
    NSLog(@"Doing it...");
    NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    NSLog(@"%lu", (unsigned long)array.count);
    for (int i = 0; i < array.count; i++) {
        NSLog(@"%i", i);
        commServiceStructure = (CommunityServiceStructure *)[array objectAtIndex:i];
        /*if (commServiceStructure.hasImage == [NSNumber numberWithInt:1]) {
         PFFile *file = newsArticleStructure.imageFile;
         [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
         UIImage *image = [UIImage imageWithData:data];
         image = [[AppManager getInstance] imageFromImage:image scaledToWidth:70];
         [returnArray addObject:image];
         if (i == array.count - 1)
         dispatch_group_leave(theServiceGroup);
         }];
         }
         else {
         [returnArray addObject:[[NSObject alloc] init]];
         if (i == array.count - 1)
         dispatch_group_leave(theServiceGroup);
         }*/
    }
    dispatch_group_notify(theServiceGroup, dispatch_get_main_queue(), ^{
        NSError *overallError = nil;
        if (theError)
            overallError = theError;
        completion(overallError, returnArray);
    });
}



- (void)testMethodThreeWithCompletion:(void (^)(NSMutableArray *returnArray, NSMutableArray *returnArray2))completion withArray:(NSMutableArray *)array {
    __block NSError *theError = nil;
    dispatch_group_t theServiceGroup = dispatch_group_create();
    dispatch_group_enter(theServiceGroup);
    CommunityServiceStructure *commServiceStructure;
    NSLog(@"CheckOne");
    NSMutableArray *returnArray =[[NSMutableArray alloc]init];//old
    NSMutableArray *returnArray2 =[[NSMutableArray alloc]init];//new
    for(int a = 0; a < array.count; a++ )
    {
        NSLog(@"CheckA");
        commServiceStructure = (CommunityServiceStructure *)[array objectAtIndex:a];
        if(commServiceStructure.IsNewNumber == [NSNumber numberWithInt:0])
        {
            [returnArray addObject:commServiceStructure];
        }
        else if (commServiceStructure.IsNewNumber == [NSNumber numberWithInt:1]) {
            [returnArray2 addObject:commServiceStructure];
        }
        if (a == array.count -1)
            dispatch_group_leave(theServiceGroup);
    }
    dispatch_group_notify(theServiceGroup, dispatch_get_main_queue(), ^{
        NSError *overallError = nil;
        if (theError)
            overallError = theError;
        completion(returnArray, returnArray2);
    });
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    NSLog(@"Just did thisfjslsdjflsdfjsdl.");
    NSLog(@"%lu", (unsigned long)self.allOpps.count);
    if (self.allOpps.count == 0)
        return 1;
    else {
        if (section == 0)
            return self.newOpps.count;
        else if (section == 1)
            return self.oldOpps.count;
        return nil;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Configure the cell...
    if (self.allOpps.count == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CellIdentifier"];
        cell.textLabel.text = @"No data to display.";
        return  cell;
    } else {
        if (indexPath.section == 0) {
            CommunityServiceStructure *commServiceStructure = ((CommunityServiceStructure *)[self.newOpps objectAtIndex:indexPath.row]);
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CellIdentifier"];
            cell.textLabel.text = commServiceStructure.commTitleString;
            cell.detailTextLabel.text = commServiceStructure.commSummaryString;
            cell.detailTextLabel.numberOfLines = 4;
            //if (commServiceStructure.hasImage == [NSNumber numberWithInt:1])
                //cell.imageView.image = (UIImage *)[self.commImages objectAtIndex:indexPath.row];
            return cell;
        } else if (indexPath.section == 1) {
            CommunityServiceStructure *commServiceStructure = ((CommunityServiceStructure *)[self.oldOpps objectAtIndex:indexPath.row]);
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CellIdentifier"];
            cell.textLabel.text = commServiceStructure.commTitleString;
            cell.detailTextLabel.text = commServiceStructure.commSummaryString;
            cell.detailTextLabel.numberOfLines = 4;
            //if (commServiceStructure.hasImage == [NSNumber numberWithInt:1])
                //cell.imageView.image = (UIImage *)[self.commImages objectAtIndex:indexPath.row];
            return cell;
        }
        else return nil;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (self.allOpps.count == 0)
        return @"";
    else {
        if (section == 0)
            return @"NEW OPPORTUNITIES";
        else if (section == 1)
            return @"OLD OPPORTUNITIES";
    }
    return nil;
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
