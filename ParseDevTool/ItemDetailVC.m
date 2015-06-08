//
//  ItemDetailVC.m
//  ParseDevTool
//
//  Created by Ignacio Martin on 13/1/15.
//  Copyright (c) 2015 Niceway. All rights reserved.
//

#import "ItemDetailVC.h"
#import "TableDetailsVC.h"
#import "PropertyCell.h"
#import "NWMapVC.h"
#import "NWImageVC.h"
#import "LargeTextVC.h"
#import "AppDelegate.h"

@interface ItemDetailVC ()

@property (strong, nonatomic) NSMutableArray* dataSource;
@property (strong, nonatomic) PFGeoPoint* geopoint;
@property (strong, nonatomic) PFFile* pfFile;
@property (strong, nonatomic) NSArray* array;
@property (strong, nonatomic) NSString* largeText;

@end

@implementation ItemDetailVC

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = [[NSMutableArray alloc] init];
    
    [self.dataSource addObject:@"objectId"];
    [self.dataSource addObject:@"createdAt"];
    [self.dataSource addObject:@"updatedAt"];
    
    NSArray* sortedArray = [[self.item allKeys] sortedArrayUsingComparator:^(NSString *firstObject, NSString *secondObject)
    {
        return [firstObject caseInsensitiveCompare:secondObject];
    }];
    
    [self.dataSource addObjectsFromArray:sortedArray];
}

#pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* propertyKey = [self.dataSource objectAtIndex:indexPath.row];
    
    static NSString *cellIdentifier = @"PropertyCell";
    
    PropertyCell* cell = (PropertyCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil){
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"PropertyCell" owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }
    
    cell.txtKey.text = propertyKey;
    cell.txtValue.text = @"";
    
    // Set items to null to avoid problems when reusing a cell
    cell.geoPoint = nil;
    cell.relation = nil;
    cell.pfObject = nil;
    cell.pfFile = nil;
    cell.array = nil;
    cell.txtValue.textColor = [UIColor blackColor];
    
    NSObject* temp = [self.item valueForKey:propertyKey];
    
    if ([temp isKindOfClass:[NSString class]])
    {
        cell.txtValue.text = (NSString*)[self.item valueForKey:propertyKey];
    }
    else if ([temp isKindOfClass:[NSNumber class]])
    {
        NSNumber* tempNumber = [self.item objectForKey:propertyKey];
        cell.txtValue.text = [tempNumber stringValue];
    }
    else if ([temp isKindOfClass:[NSDate class]])
    {
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];

        dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        cell.txtValue.text =[dateFormatter stringFromDate:[self.item valueForKey:propertyKey]];
    }
    else if ([temp isKindOfClass:[PFGeoPoint class]])
    {
        PFGeoPoint* geopoint = (PFGeoPoint*)temp;
        cell.geoPoint = geopoint;
        cell.txtValue.text = @"See Map";
        cell.txtValue.textColor = [UIColor blueColor];
        
    }
    else if ([temp isKindOfClass:[PFRelation class]])
    {
        NSLog(@"we have a PFRelation here.");
        PFRelation* relation = (PFRelation*)temp;
        cell.relation = relation;
        cell.txtValue.text = [relation valueForKey:@"_key"];
        cell.txtValue.textColor = [UIColor blueColor];
    }
    else if ([temp isKindOfClass:[PFObject class]])
    {
        NSLog(@"we have a pointer here.");
        PFObject* object = (PFObject*)temp;
        cell.pfObject = object;
        cell.txtValue.text = object.parseClassName;
        cell.txtValue.textColor = [UIColor blueColor];
    }
    else if ([temp isKindOfClass:[PFFile class]])
    {
        // Image
        NSLog(@"we have an image here.");
        cell.pfFile =(PFFile*) temp;
        cell.txtValue.text = @"Image";
        cell.txtValue.textColor = [UIColor blueColor];
    }
    else if ([temp isKindOfClass:[NSArray class]])
    {
        // Array
        NSLog(@"we have an array here.");
        cell.array = (NSArray*) temp;
        cell.txtValue.text = [NSString stringWithFormat:@"Array: %li items.", cell.array.count];
        cell.txtValue.textColor = [UIColor blueColor];
    }
    else
    {
        NSLog(@"someData is an unsupported type:\n%@", temp);
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PropertyCell *cell = (PropertyCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    if (cell.geoPoint)
    {
        self.geopoint = cell.geoPoint;
        [self performSegueWithIdentifier:@"toMap" sender:self];
    }
    else if (cell.pfObject)
    {
        // Pointer
        ItemDetailVC *itemDetailsVC =
        [[UIStoryboard storyboardWithName:@"Main"
                                   bundle:NULL] instantiateViewControllerWithIdentifier:@"ItemDetailVC"];
        
        [cell.pfObject fetchInBackgroundWithBlock:^(PFObject *object, NSError *error)
        {
            if (!error)
            {
                itemDetailsVC.item = object;
                itemDetailsVC.parseApp = self.parseApp;
                itemDetailsVC.parseTable = object.parseClassName;
                itemDetailsVC.title = object.objectId;
                
                [self.navigationController pushViewController:itemDetailsVC animated:YES];
            }
        }];
    }
    else if (cell.relation)
    {
        //Relation
        TableDetailsVC *tableDetailVC =
        [[UIStoryboard storyboardWithName:@"Main"
                                   bundle:NULL] instantiateViewControllerWithIdentifier:@"TableDetailsVC"];
        
        tableDetailVC.relation = cell.relation;
        tableDetailVC.parseApp = self.parseApp;
        
        tableDetailVC.title = [cell.relation valueForKey:@"_key"];
        
         [self.navigationController pushViewController:tableDetailVC animated:YES];
    }
    else if(cell.pfFile)
    {
        // Image
        self.pfFile = cell.pfFile;
        [self performSegueWithIdentifier:@"toImage" sender:self];
    }
    else if(cell.array)
    {
        // Array
        self.array = cell.array;
        if (self.array.count > 0)
        {
            [self performSegueWithIdentifier:@"toArray" sender:self];
        }
    }
    else
    {
        // we might have a long text, lets see
        CGSize size = [cell.txtValue.text sizeWithFont:cell.txtValue.font];
        if (size.width > cell.txtValue.bounds.size.width)
        {
            self.largeText = cell.txtValue.text;
            [self performSegueWithIdentifier:@"toLargeText" sender:self];
        }
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toMap"])
    {
        NWMapVC* mapController = segue.destinationViewController;
        mapController.geopoint = self.geopoint;
    }
    else if ([segue.identifier isEqualToString:@"toImage"])
    {
        NWImageVC* imageController = segue.destinationViewController;
        imageController.pfFile = self.pfFile;
    }
    else if ([segue.identifier isEqualToString:@"toArray"])
    {
        TableDetailsVC* arrayController = segue.destinationViewController;
        arrayController.isArray = YES;
        arrayController.array = self.array;
        PFObject* item;
        if (self.array.count > 0)
        {
            item = [self.array objectAtIndex:0];
        }
        
        AppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
        NSManagedObjectContext* context = [appDelegate managedObjectContext];
        NSEntityDescription *tableDescription = [NSEntityDescription entityForName:@"Table" inManagedObjectContext:context];
        NSManagedObject* newTable;
        newTable = [[NSManagedObject alloc] initWithEntity:tableDescription insertIntoManagedObjectContext:context];
        [newTable setValue:item.parseClassName forKey:@"name"];
        [newTable setValue:@"objectId" forKey:@"displayProperty"];
        
        arrayController.parseTable = newTable;
    }
    else if ([segue.identifier isEqualToString:@"toLargeText"])
    {
        LargeTextVC* textController = segue.destinationViewController;
        textController.largeText = self.largeText;
    }
}

#pragma Table View
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

@end
