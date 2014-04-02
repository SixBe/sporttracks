//
//  SBHistoryTableViewController.m
//  sporttracks
//
//  Created by Michael on 31/3/14.
//  Copyright (c) 2014 SixBe. All rights reserved.
//

#import "SBHistoryTableViewController.h"
#import "SBWorkoutTableViewController.h"
#import "SBAPIManager.h"
#import "SBWorkoutSummary.h"

@interface SBHistoryTableViewController ()
@property (nonatomic, strong) NSMutableArray *workouts;
- (IBAction)triggerRefresh;
@end

@implementation SBHistoryTableViewController

#pragma mark - Memory management
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - View life cycle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self triggerRefresh];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.workouts count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"historyCellID" forIndexPath:indexPath];
    
    // Configure the cell...
    SBWorkoutSummary *workout = [self.workouts objectAtIndex:indexPath.row];
    [cell.textLabel setText:[NSString stringWithFormat:@"%@ - %@", [workout displayValueForKey:@"duration"], [workout displayValueForKey:@"distance"]]];
    [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@", [workout displayValueForKey:@"startTime"]]];
    [cell.imageView setImage:[workout imageForActivityType:workout.type]];
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
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
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Table view delegate



 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
     if ([segue.identifier isEqualToString:@"showWorkout"]) {
         NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
         if (indexPath) {
             NSString *workoutId = [[self.workouts objectAtIndex:indexPath.row] uniqueId];
             
             SBWorkoutTableViewController *controller = (SBWorkoutTableViewController *)segue.destinationViewController;
             [controller setWorkoutId:workoutId];
             
         }
     }
 }



- (IBAction)triggerRefresh {
    [self.refreshControl beginRefreshing];
    [[SBAPIManager sharedInstance] retrieveWorkoutHistoryWithCompletionBlock:^(BOOL succeded, NSDictionary *responseData) {
        if (!succeded) {
            NSLog(@"Error retrieving workout history...");
            return;
        }
        
        NSLog(@"Response data: %@", responseData);
        if ([responseData isKindOfClass:[NSDictionary class]]) {
            NSArray *items = [responseData objectForKey:@"items"];
            NSMutableArray *workouts = [[NSMutableArray alloc] initWithCapacity:[responseData count]];
            [(NSArray *)items enumerateObjectsWithOptions:0 usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                SBWorkoutSummary *workout = [[SBWorkoutSummary alloc] init];
                [workout setupWithJSON:obj];
                [workouts addObject:workout];
            }];
            self.workouts = [workouts copy];
            [self.refreshControl endRefreshing];
            [self.tableView reloadData];
        }
    }];
}
@end
