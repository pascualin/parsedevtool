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
#import "EditTableVC.h"

@interface TableDetailsVC ()

@end

@implementation TableDetailsVC

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

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

-(void)viewWillAppear:(BOOL)animated
{
    [self loadObjects];
}

-(void)objectsDidLoad:(NSError *)error
{
    [super objectsDidLoad:error];

    UINavigationBar* navBar = (UINavigationBar*)self.navigationItem.titleView;
    if (self.relation)
    {
        navBar.topItem.title = [NSString stringWithFormat:@"%@ (%lu)", [self.relation valueForKey:@"key"], (unsigned long)self.objects.count];
    }
    else
    {
        navBar.topItem.title = [NSString stringWithFormat:@"%@ (%lu)", [self.parseTable valueForKey:@"name"], (unsigned long)self.objects.count];
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
    NSObject* assignableText = [item valueForKey:[self.parseTable valueForKey:@"displayProperty"]];
    if ([assignableText isKindOfClass:[NSString class]])
    {
        cell.txtObjectId.text = (NSString*)assignableText;
    }
    else
    {
        cell.txtObjectId.text = @"!!Invalid display property!!";
    }
    
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
    if ([segue.identifier isEqualToString:@"toChart"])
    {
        NWChartVC *chartVC = segue.destinationViewController;
        chartVC.objects = self.objects;
    }
    if ([segue.identifier isEqualToString:@"toEditTable"])
    {
        EditTableVC *editTableVC = segue.destinationViewController;
        editTableVC.parseTable = self.parseTable;
        editTableVC.parseApp = self.parseApp;
    }
}
@end
