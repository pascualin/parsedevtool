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
#import <Parse/Parse.h>

@interface AppDetailsVC ()

@property (strong, nonatomic) NSMutableArray* dataSource;

@end

@implementation AppDetailsVC

@synthesize parseApp;

//- (NSUInteger)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationMaskPortrait;
//}

- (void)refresh
{
    [self.dataSource removeAllObjects];
    
    // We need to retrieve the data for the app again
    AppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* context = [appDelegate managedObjectContext];
    
    self.parseApp = [context objectWithID:[(NSManagedObject*)self.parseApp objectID]];
    
    // and we read the relation with tables
    [self.dataSource addObjectsFromArray:[[parseApp valueForKey:@"tables"] allObjects]];
    
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dataSource = [[NSMutableArray alloc] init];
    
    NSString* applicationId = [self.parseApp valueForKey:@"applicationId"];
    NSString* clientKey = [self.parseApp valueForKey:@"clientKey"];
    
    [Parse setApplicationId:applicationId
                  clientKey:clientKey];
    
    [self refresh];                      
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
    
    cell.parseTable = table;
    cell.txtTitle.text = [table valueForKey:@"name"];
    
    return cell;
}

#pragma Table View

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        AppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
        NSManagedObjectContext* context = [appDelegate managedObjectContext];
        
        NSManagedObject* table = (NSManagedObject*)[self.dataSource objectAtIndex:indexPath.row];
        
        [context deleteObject:table];
        
        NSError* error;
        if (![context save:&error]) {
            NSLog(@"Couldn't save: %@", error);
        }
        
        [self refresh];
    }
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toTableDetails"])
    {
        TableDetailsVC *tableDetailVC = segue.destinationViewController;
        TableCell* cell = (TableCell*)sender;
        
        tableDetailVC.parseTable = cell.parseTable;
        tableDetailVC.parseApp = self.parseApp;
        
        tableDetailVC.title = [tableDetailVC.parseTable valueForKey:@"name"];
    }
    else if ([segue.identifier isEqualToString:@"toAddTable"])
    {
        AddTableVC *addTableVC = segue.destinationViewController;
        addTableVC.parseApp = self.parseApp;
        addTableVC.title = @"Add Table";
    }
}


@end
