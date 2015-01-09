//
//  ViewController.m
//  ParseDevTool
//
//  Created by Ignacio Martin on 9/1/15.
//  Copyright (c) 2015 Niceway. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray* name;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.name = [[NSMutableArray alloc] init];
    
    AppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* context = [appDelegate managedObjectContext];
    NSEntityDescription* entityDesc = [NSEntityDescription entityForName:@"ParseApp" inManagedObjectContext:context];
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    NSPredicate* pred = [NSPredicate predicateWithFormat:@"(name = %@)", @"SwopDev"];
    [request setPredicate:pred];
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
            [self.name addObject:[matches valueForKey:@"name"]];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)add:(id)sender
{
    AppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* context = [appDelegate managedObjectContext];
    NSManagedObject* newParseApp;
    newParseApp = [NSEntityDescription insertNewObjectForEntityForName:@"ParseApp" inManagedObjectContext:context];
    [newParseApp setValue:@"SwopDev" forKey:@"name"];
    [self.name addObject:@"SwopDev"];
    NSError* error;
    [context save:&error];
    [self.tableView reloadData];
}

#pragma Table View

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.name.count;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellID = @"cellID";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.textLabel.text = [self.name objectAtIndex:indexPath.row];
    return cell;
}

@end
