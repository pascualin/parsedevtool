//
//  TableDetailsVC.m
//  ParseDevTool
//
//  Created by Ignacio Martin on 13/1/15.
//  Copyright (c) 2015 Niceway. All rights reserved.
//

#import "TableDetailsVC.h"
#import "FinalItemCell.h"
#import <Parse/Parse.h>
#import "ItemDetailVC.h"

@interface TableDetailsVC ()

@end

@implementation TableDetailsVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        self.pullToRefreshEnabled = YES;
        self.paginationEnabled = YES;
        self.objectsPerPage = 1000;
    }
    return self;
}

-(void)viewDidLoad
{
    self.parseClassName = [self.parseTable valueForKey:@"name"];
    self.paginationEnabled = YES;
    self.objectsPerPage = 1000;
    
    [super viewDidLoad];
    
    self.barChart = [[PNBarChart alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200.0)];
    // Set up X-asix
    // Get dates from 6 days
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"GMT"]; // UTC is same as GMT
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"MMM DD"];

    NSDate *now = [NSDate date];
    
    NSMutableArray *results = [NSMutableArray arrayWithCapacity:8];
    
    for (int i = 0; i < 6; i++)
    {
        NSDate *date = [NSDate dateWithTimeInterval:-(i * (60 * 60 * 24)) sinceDate:now];
        [results addObject:[dateFormatter stringFromDate:date]];
    }
    self.reversedDate = [[results reverseObjectEnumerator] allObjects];
    
    [self.barChart setXLabels:self.reversedDate];
    
    self.barChart.yLabelFormatter = ^(CGFloat yValue){
        CGFloat yValueParsed = yValue;
        NSString * labelText = [NSString stringWithFormat:@"%1.f",yValueParsed];
        return labelText;
    };

    // Set up Data
    // TODO: Chunk new users by dat and put in array
    [self.barChart setYValues:@[@1, @5, @1, @20, @1, @4]];
    
    // Display chart
    [self.barChart strokeChart];
    [self.view addSubview:self.barChart];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(NSObject *)object
{
    PFObject* item = (PFObject*) object;
    static NSString *cellIdentifier = @"FinalItemCell";
    
    FinalItemCell* cell = (FinalItemCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil){
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"FinalItemCell" owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }
    
    cell.item = item;
    cell.txtObjectId.text = item.objectId;
    
    return cell;
}

-(void)objectsDidLoad:(NSError *)error
{
    [super objectsDidLoad:error];
    self.title = [NSString stringWithFormat:@"%@ (%lu)", [self.parseTable valueForKey:@"name"], (unsigned long)self.objects.count];
}

//-(PFQuery *)queryForTable
//{
//    PFQuery* query = [PFQuery queryWithClassName:self.parseClassName];
//    query.limit = 1000;
//    return query;
//}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 43;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toItemDetails"])
    {
        ItemDetailVC *itemDetailsVC = segue.destinationViewController;
        FinalItemCell* cell = (FinalItemCell*)sender;
        itemDetailsVC.item = cell.item;
        itemDetailsVC.parseApp = self.parseApp;
        itemDetailsVC.parseTable = self.parseTable;
        itemDetailsVC.title = itemDetailsVC.item.objectId;
    }
}
@end
