//
//  SBHistoryTableViewController.m
//  sporttracks
//
// The MIT License (MIT)
//
// Copyright (c) 2014 Michael Gachet
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.


#import "SBHistoryTableViewController.h"
#import "SBWorkoutTableViewController.h"
#import "SBAPIManager.h"
#import "SBWorkoutSummary.h"
#import "SBWorkout.h"
#import "NSDate+RFCAndISO.h"

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
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addPressed:)];
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
    NSDate *dateSinceLastRefresh = [[NSUserDefaults standardUserDefaults] valueForKey:@"dateSinceLastRefresh"];
    if (!dateSinceLastRefresh || [dateSinceLastRefresh timeIntervalSinceNow] < -5 * 60) {
        [self triggerRefresh];
    }
}

#pragma mark - Actions
- (void)addPressed:(id)sender
{
    SBWorkout *workout = [[SBWorkout alloc] init];
    workout.startTime = [NSDate date];
    workout.name = @"Skating";
    workout.type = @"Skating";
    workout.distance = @(12000); // 12 km
    workout.duration = @(30. * 60.); // 30 minutes
    workout.notes = @"Nice skating outdoors on icy river next to Dutch windmills... One can dream :-)";
    
    [[SBAPIManager sharedInstance] POSTWorkoutWithData:[workout JSONDataToPost] completionBlock:^(BOOL succeded, NSDictionary *responseData) {
        if (!succeded) {
            return;
        }
        NSArray *URIs = [responseData objectForKey:@"uris"];
        [workout setValue:URIs.firstObject forKey:@"detailsURI"];
    }];
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
             SBWorkoutSummary *summary = [self.workouts objectAtIndex:indexPath.row];
             NSString *workoutId = summary.uniqueId;
             SBWorkout *workout = summary.workout;
             
             if (workout == nil) {
                 workout = [[SBWorkout alloc] init];
                 workout.uniqueId = workoutId;
                 workout.name = @"Download pending...";
                 [summary setWorkout:workout];
                 [workout setSummary:summary];
             }
             SBWorkoutTableViewController *controller = (SBWorkoutTableViewController *)segue.destinationViewController;
             [controller setWorkout:workout];
             
         }
     }
 }



- (void)triggerRefresh {
    [self.refreshControl beginRefreshing];
    [[SBAPIManager sharedInstance] GETWorkoutHistoryWithCompletionBlock:^(BOOL succeded, NSDictionary *responseData) {
        if (!succeded) {
            NSLog(@"Error retrieving workout history...");
            [self.refreshControl endRefreshing];
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
            
            [[NSUserDefaults standardUserDefaults] setValue:[NSDate date] forKey:@"dateSinceLastRefresh"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [self.refreshControl endRefreshing];
            [self.tableView reloadData];
        }
    }];
}
@end
