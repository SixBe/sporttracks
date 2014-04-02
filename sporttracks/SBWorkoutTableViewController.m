//
//  SBWorkoutTableViewController.m
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


#import "SBWorkoutTableViewController.h"
#import "SBEditableTableViewCell.h"
#import "SBAPIManager.h"
#import "SBWorkout.h"

@interface SBWorkoutTableViewController () <SBEditableTableViewCellDelegate>
@end

@implementation SBWorkoutTableViewController
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
    [self.navigationItem setRightBarButtonItem:self.editButtonItem animated:NO];
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
    
    if (self.workout.startTime == nil) {
        [self triggerRefresh];
    }
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



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (void)triggerRefresh {
    [self.refreshControl beginRefreshing];
    [[SBAPIManager sharedInstance] GETWorkoutWithId:self.workout.uniqueId completionBlock:^(BOOL succeded, NSDictionary *responseData) {
        if (!succeded) {
            NSLog(@"Error retrieving workout history...");
            [self.refreshControl endRefreshing];
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

- (void)editableCell:(SBEditableTableViewCell *)cell didEndEditingText:(NSString *)oldText newText:(NSString *)newText
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSString *key = [[self.workout displayProperties] objectAtIndex:indexPath.row];
    
    if (![oldText isEqualToString:newText]) {
        // Process newText to remove all units
        NSString *unitString = [self.workout displayUnitForKey:key];
        [newText stringByReplacingOccurrencesOfString:unitString withString:@""];
        [self.workout setValue:newText forKey:key];
    }
}

@end
