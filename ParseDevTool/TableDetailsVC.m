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

@property BOOL isScreenActive;

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
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];
}

- (void) orientationChanged:(NSNotification *)note
{
    if (self.isScreenActive)
    {
        UIDevice * device = note.object;
        switch(device.orientation)
        {
            case UIDeviceOrientationLandscapeRight:
                [self performSegueWithIdentifier:@"toChart" sender:self];
                break;
                
            case UIDeviceOrientationLandscapeLeft:
                [self performSegueWithIdentifier:@"toChart" sender:self];
                break;
                
            default:
                break;
        };
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.isScreenActive = YES;
    [self loadObjects];
}

-(void)objectsDidLoad:(NSError *)error
{
    [super objectsDidLoad:error];

    if (self.relation)
    {
        self.navigationItem.title = [NSString stringWithFormat:@"%@ (%lu)", [self.relation valueForKey:@"key"], (unsigned long)self.objects.count];
    }
    else
    {
       self.navigationItem.title = [NSString stringWithFormat:@"%@ (%lu)", [self.parseTable valueForKey:@"name"], (unsigned long)self.objects.count];
    }

}

- (void) setRightBarButtonItemsCollection:(NSArray *)rightBarButtonItemsCollection {
    self.navigationItem.rightBarButtonItems = [rightBarButtonItemsCollection
                                sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"tag" ascending:YES]]];
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
    
    cell.txtError.text = @"";
    
    NSString* displayProperty = [self.parseTable valueForKey:@"displayProperty"];
    NSObject* assignableText = [item valueForKey:displayProperty];
    if (displayProperty.length > 0)
    {
        if ([assignableText isKindOfClass:[NSString class]])
        {
            cell.txtObjectId.text = (NSString*)assignableText;
        }
        else
        {
            cell.txtError.text = [NSString stringWithFormat:@"Undefined property %@", displayProperty];
            cell.txtObjectId.text = item.objectId;
        }
    }
    else
    {
        cell.txtObjectId.text = item.objectId;
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
    return 44;
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
        self.isScreenActive = NO;
    }
    if ([segue.identifier isEqualToString:@"toChart"])
    {
        NWChartVC *chartVC = segue.destinationViewController;
        chartVC.objects = self.objects;
        self.isScreenActive = NO;
    }
    if ([segue.identifier isEqualToString:@"toEditTable"])
    {
        EditTableVC *editTableVC = segue.destinationViewController;
        editTableVC.parseTable = self.parseTable;
        editTableVC.parseApp = self.parseApp;
        self.isScreenActive = NO;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.objects.count;
}

@end
