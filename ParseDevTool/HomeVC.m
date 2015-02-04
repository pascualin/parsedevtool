//
//  ViewController.m
//  ParseDevTool
//
//  Created by Ignacio Martin on 9/1/15.
//  Copyright (c) 2015 Niceway. All rights reserved.
//

#import "HomeVC.h"
#import "AppDelegate.h"
#import "ParseAppViewCell.h"
#import "AppDetailsVC.h"
#import "AddParseAppVC.h"
#import <MGSwipeTableCell/MGSwipeButton.h>

@interface HomeVC ()

@property (strong, nonatomic) NSMutableArray* dataSource;

@end

@implementation HomeVC

- (void)refresh
{
    [self.dataSource removeAllObjects];
    AppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* context = [appDelegate managedObjectContext];
    NSEntityDescription* entityDesc = [NSEntityDescription entityForName:@"ParseApp" inManagedObjectContext:context];
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    NSManagedObject* matches = nil;
    
    NSError* error;
    NSArray* objects = [context executeFetchRequest:request error:&error];
    
    if ([objects count] == 0)
    {
        NSLog(@"No matches");
    }
    else
    {
        for (int i = 0; i < [objects count]; i++)
        {
            matches = objects[i];
            [self.dataSource addObject:matches];
        }
    }
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSource = [[NSMutableArray alloc] init];
    
    [self refresh];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refresh];
}

#pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject* parseApp = (NSManagedObject*)[self.dataSource objectAtIndex:indexPath.row];
    
    static NSString *cellIdentifier = @"ParseAppCell";
    
    ParseAppViewCell* cell = (ParseAppViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil){
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ParseAppViewCell" owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }
    cell.rightButtons = @[[MGSwipeButton buttonWithTitle:@"Delete" backgroundColor:[UIColor redColor]],
                          [MGSwipeButton buttonWithTitle:@"Edit" backgroundColor:[UIColor lightGrayColor]]];
    cell.delegate = self;
    cell.parseApp = parseApp;
    cell.txtTitle.text = [parseApp valueForKey:@"name"];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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

-(BOOL) swipeTableCell:(MGSwipeTableCell*) cell tappedButtonAtIndex:(NSInteger) index direction:(MGSwipeDirection)direction fromExpansion:(BOOL) fromExpansion
{
    NSManagedObject* parseApp = (NSManagedObject*)((ParseAppViewCell*)cell).parseApp;
    
    if (index == 0){
        // Trigger Delete
        AppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
        NSManagedObjectContext* context = [appDelegate managedObjectContext];
        [context deleteObject:parseApp];
        NSError* error;
        [context save:&error];
        
        [self refresh];
        
    } else {
        // Trigger Edit
        [self performSegueWithIdentifier: @"toAddApp" sender:parseApp];
        
    }
    return true;
}

#pragma Navigation

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toAppDetails"])
    {
        AppDetailsVC *appDetailsVC = segue.destinationViewController;
        ParseAppViewCell* cell = (ParseAppViewCell*)sender;
        appDetailsVC.parseApp = cell.parseApp;
        appDetailsVC.title = [appDetailsVC.parseApp valueForKey:@"name"];
    } if ([segue.identifier isEqualToString:@"toAddApp"]){
        AddParseAppVC *addParseAppVC = segue.destinationViewController;
        if (![sender isKindOfClass:[UIBarButtonItem class]])
        {
            addParseAppVC.parseApp = sender;
        }
    }
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return (UIInterfaceOrientationMaskPortrait);
}

@end
