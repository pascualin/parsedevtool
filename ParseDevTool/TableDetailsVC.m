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
}

-(void)objectsDidLoad:(NSError *)error
{
    [super objectsDidLoad:error];
    
    self.barChart.objects = self.objects;
    [self.barChart refreshChart];
    
    if (self.relation)
    {
        self.title = [NSString stringWithFormat:@"%@ (%lu)", [self.relation valueForKey:@"key"], (unsigned long)self.objects.count];
    }
    else
    {
        self.title = [NSString stringWithFormat:@"%@ (%lu)", [self.parseTable valueForKey:@"name"], (unsigned long)self.objects.count];
    }

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

-(PFQuery *)queryForTable
{
    PFQuery* query;
    if (self.relation)
    {
        query = [self.relation query];
    }
    else
    {
        query = [super queryForTable];
    }
    return query;
}

#pragma mark - UITableViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.barChart.frame = CGRectMake(0, self.tableView.contentOffset.y + self.navigationController.navigationBar.frame.size.height + 20, self.barChart.frame.size.width, self.barChart.frame.size.height);
}

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
