//
//  TableDetailsVC.m
//  ParseDevTool
//
//  Created by Ignacio Martin on 13/1/15.
//  Copyright (c) 2015 Niceway. All rights reserved.
//

#import "ParseClassDetailQTVC.h"
#import "FinalItemCell.h"
#import <Parse/Parse.h>
#import "ItemDetailVC.h"
#import "EditClassDetail.h"
#import "NWUtils.h"
#import "AdsDisplayController.h"

@interface ParseClassDetailQTVC () <AdsDisplayController>

@property BOOL isScreenActive;
@property BOOL isShowingAd;

@end

@implementation ParseClassDetailQTVC

- (NSUInteger)supportedInterfaceOrientations
{
    if(!self.isShowingAd)
    {
        return UIInterfaceOrientationMaskPortrait;
    }
    else
    {
        return (UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeRight | UIInterfaceOrientationMaskLandscapeLeft);
    }
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

- (void)startListeningToOrientationChanges
{
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];
}

-(void)viewDidLoad
{
    NWUtils* utils = [NWUtils instance];
    
    #ifdef ISFREE
        NSLog(@"Free version - Full screen ads");
        NSInteger totalDisplays = [[NSUserDefaults standardUserDefaults] integerForKey:@"totalFullScreenAdsDisplayed"];
        if (!totalDisplays)
        {
            totalDisplays = 0;
        }

        double rest = fmod(totalDisplays, 10.0f);
        [utils incrementAdsCount];
        
        if (rest == 0)
        {
            if ([utils.interstitial isReady])
            {
                self.isShowingAd = YES;
                utils.adDisplayController = self;
                [utils.interstitial presentFromRootViewController:self];
            }
        }
    #else
        NSLog(@"Pro version - No full screen ads");
    #endif
    
    [self startListeningToOrientationChanges];
    
    self.parseClassName = [self.parseTable valueForKey:@"name"];
    self.paginationEnabled = YES;
    self.objectsPerPage = 1000;
    
    if(self.isArray)
    {
        [PFObject fetchAllInBackground:self.array block:^(NSArray* objects, NSError* error)
         {
             if(!error)
             {
                 self.array = objects;
                 [self.tableView reloadData];
             }
         }];
    }
    
    [super viewDidLoad];
}

- (void) orientationChanged:(NSNotification *)note
{
    if (self.isScreenActive && !self.isShowingAd)
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isArray)
    {
        return self.array.count;
    }
    else
    {
        return self.objects.count;
    }
}

-(nullable PFObject *)objectAtIndexPath:(nullable NSIndexPath *)indexPath
{
    if (self.isArray)
    {
        return self.array[indexPath.row];
    }
    else
    {
        return self.objects[indexPath.row];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(NSObject *)object
{
    PFObject* item = (PFObject*) object;

    if (self.isArray)
    {
        item = [self.array objectAtIndex:indexPath.row];
    }
    
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
    if (self.isArray)
    {
        [self objectsDidLoad:nil];
        return nil;
    }
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
        EditClassDetail *editTableVC = [[segue.destinationViewController viewControllers] objectAtIndex:0];
        editTableVC.parseTable = self.parseTable;
        editTableVC.parseApp = self.parseApp;
        self.isScreenActive = NO;
    }
}

-(void)performClosedAdsAction
{
    self.isShowingAd = NO;
    self.isScreenActive = YES;
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
}

@end
