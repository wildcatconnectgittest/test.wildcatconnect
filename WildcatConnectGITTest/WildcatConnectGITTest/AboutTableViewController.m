//
//  AboutTableViewController.m
//  WildcatConnectGITTest
//
//  Created by Kevin Lyons on 11/5/15.
//  Copyright © 2015 WildcatConnect. All rights reserved.
//

#import "AboutTableViewController.h"

@interface AboutTableViewController ()

@end

@implementation AboutTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
     
     self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
     return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
     if (section == 0) {
          return @"APP SUPPORT";
     } else if (section == 1) {
          return @"DEVELOPMENT";
     } else return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     if (section == 0) {
          return 1;
     } else return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
     if (indexPath.section == 0) {
          return 50;
     } else if (indexPath.section == 1) {
          if (indexPath.row == 0) {
               return 100;
          }
          else return 50;
     }
     else return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CellIdentifier"];
     if (indexPath.section == 0) {
          cell.textLabel.text = @"Report a problem";
          return cell;
     } else if (indexPath.section == 1) {
          if (indexPath.row == 0) {
                    //List out developers...
               cell.textLabel.numberOfLines = 6;
               cell.textLabel.text = @"lsadlfjlsdjflsadjflsajdlfjasljflsdjlfjsadlfjlksadjflksjadfjsladjflasflsfjssjflasjdlfjlasdjflsadjflajsdlfjasdlajflasdjflsdjfljsdlfjsdlakjflksdjfljsljfsad";
               return cell;
          } else if (indexPath.row == 1) {
                    //Get involved!!!
               cell.textLabel.text = @"Join the development team";
               return cell;
          }
          return cell;
     }
     return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
          //Handle selection
     [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
     if (indexPath.section == 0) {

          NSString *URLEMail = @"mailto:wildcatconnectgittest@gmail.com?subject=WildcatConnect App Issue&body=";
          
          UIDevice *device  = [UIDevice currentDevice];
          NSString *name    = [device name];
          NSString *model   = [device model];
          NSString *systemVersion = device.systemVersion;
          
          URLEMail = [[[[[[[[URLEMail stringByAppendingString:@"Device Name = "] stringByAppendingString:name] stringByAppendingString:@"\n"] stringByAppendingString:@"System Version = "] stringByAppendingString:systemVersion] stringByAppendingString:@"\n"] stringByAppendingString:@"Device Model = "] stringByAppendingString:model];
          
          NSString *url = [URLEMail stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding ];
          [[UIApplication sharedApplication]  openURL: [NSURL URLWithString: url]];
     } else if (indexPath.section == 0 && indexPath.row == 1) {
               //
     }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
