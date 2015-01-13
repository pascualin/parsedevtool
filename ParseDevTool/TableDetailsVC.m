//
//  TableDetailsVC.m
//  ParseDevTool
//
//  Created by Ignacio Martin on 13/1/15.
//  Copyright (c) 2015 Niceway. All rights reserved.
//

#import "TableDetailsVC.h"
#import "ItemCell.h"
#import <Parse/Parse.h>

@interface TableDetailsVC ()

@end

@implementation TableDetailsVC

@synthesize table;
@synthesize parseApp;

-(void)viewDidLoad
{
    self.parseClassName = [table valueForKey:@"name"];
    [super viewDidLoad];
}

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        self.parseClassName = [table valueForKey:@"name"];
        
        self.pullToRefreshEnabled = YES;
        self.paginationEnabled = YES;
        self.objectsPerPage = 25;
    }
    return self;
}

-(void)objectsDidLoad:(NSError *)error
{
    [super objectsDidLoad:error];
    self.title = [NSString stringWithFormat:@"%@ (%lu)", [self.table valueForKey:@"name"], (unsigned long)self.objects.count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(NSObject *)object
{
    PFObject* item = (PFObject*) object;
    static NSString *cellIdentifier = @"IntemCell";
    
    ItemCell* cell = (ItemCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil){
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ItemCell" owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }
    
    cell.item = item;
    cell.txtObjectId.text = item.objectId;
    
    return cell;

}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}
@end
