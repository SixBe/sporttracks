//
//  SBWorkoutTableViewController.m
//  sporttracks
//
//  Created by Michael on 1/4/14.
//  Copyright (c) 2014 SixBe. All rights reserved.
//

#import "SBWorkoutTableViewController.h"
#import "SBAPIManager.h"
#import "SBWorkout.h"

@interface SBWorkoutTableViewController ()
@property (nonatomic, strong) SBWorkout *workout;
@end

@implementation SBWorkoutTableViewController
#pragma mark - Properties
- (SBWorkout *)workout
{
    if (!_workout) {
        _workout = [[SBWorkout alloc] init];
    }
    return _workout;
}


#pragma mark - Initialization
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

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
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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
    return [[self.workout displayProperties] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"workoutCellID" forIndexPath:indexPath];
    
    NSString *key = [[self.workout displayProperties] objectAtIndex:indexPath.row];
    // Configure the cell...
    [cell.textLabel setText:[self.workout displayNameForKey:key]];
    [cell.detailTextLabel setText:[self.workout displayValueForKey:key]];
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



- (IBAction)triggerRefresh {
    [self.refreshControl beginRefreshing];
    [[SBAPIManager sharedInstance] retrieveWorkoutWithId:self.workoutId completionBlock:^(BOOL succeded, NSDictionary *responseData) {
        if (!succeded) {
            NSLog(@"Error retrieving workout history...");
            return;
        }
        
        NSLog(@"Response data: %@", responseData);
        if ([responseData isKindOfClass:[NSDictionary class]]) {
            [self.workout setupWithJSON:responseData];
            [self.refreshControl endRefreshing];
            [self.tableView reloadData];
        }
    }];
}
@end
