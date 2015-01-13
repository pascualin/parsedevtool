//
//  AppDetailsVC.m
//  ParseDevTool
//
//  Created by Ignacio Martin on 13/1/15.
//  Copyright (c) 2015 Niceway. All rights reserved.
//

#import "AppDetailsVC.h"
#import "AppDelegate.h"
#import "TableCell.h"
#import "TableDetailsVC.h"
#import "AddTableVC.h"

@interface AppDetailsVC ()

@property (strong, nonatomic) NSMutableArray* dataSource;

@end

@implementation AppDetailsVC

@synthesize parseApp;

- (void)refresh {
    [self.dataSource removeAllObjects];

    [self.dataSource addObjectsFromArray:[[parseApp valueForKey:@"tables"] allObjects]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSource = [[NSMutableArray alloc] init];
    
    [self refresh];                      
}

-(void)viewWillAppear:(BOOL)animated
{
    [self refresh];
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject* table = (NSManagedObject*)[self.dataSource objectAtIndex:indexPath.row];
    
    static NSString *cellIdentifier = @"TableCell";
    
    TableCell* cell = (TableCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil){
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"TableCell" owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }
    
    cell.table = table;
    cell.txtTitle.text = [table valueForKey:@"name"];
    
    return cell;
}

#pragma Table View

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toAppDetails"])
    {
        TableDetailsVC *tableDetailsVC = segue.destinationViewController;
        TableCell* cell = (TableCell*)sender;
        tableDetailsVC.table = cell.table;
        tableDetailsVC.parseApp = self.parseApp;
        tableDetailsVC.title = [tableDetailsVC.table valueForKey:@"name"];
    }
    else if ([segue.identifier isEqualToString:@"toAddTable"])
    {
        AddTableVC *addTableVC = segue.destinationViewController;
        addTableVC.parseApp = self.parseApp;
        addTableVC.title = @"Add Table";
    }
}


@end
