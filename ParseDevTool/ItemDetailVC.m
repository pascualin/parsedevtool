//
//  ItemDetailVC.m
//  ParseDevTool
//
//  Created by Ignacio Martin on 13/1/15.
//  Copyright (c) 2015 Niceway. All rights reserved.
//

#import "ItemDetailVC.h"
#import "PropertyCell.h"

@interface ItemDetailVC ()

@property (strong, nonatomic) NSMutableArray* dataSource;

@end

@implementation ItemDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = [[NSMutableArray alloc] init];
    
    [self.dataSource addObject:@"objectId"];
    [self.dataSource addObject:@"createdAt"];
    [self.dataSource addObject:@"updatedAt"];
    
    [self.dataSource addObjectsFromArray:[self.item allKeys]];
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
    
    NSObject* temp = [self.item valueForKey:propertyKey];
    
    if ([temp isKindOfClass:[NSString class]])
    {
        cell.txtValue.text = (NSString*)[self.item valueForKey:propertyKey];
    }
    else if ([temp isKindOfClass:[NSData class]])
    {
        NSLog(@"someData is a bag of bits.");
    }
    else if ([temp isKindOfClass:[NSNumber class]])
    {
        cell.txtValue.text = [(NSNumber*)[self.item valueForKey:propertyKey] stringValue];
    }
    else if ([temp isKindOfClass:[NSDate class]])
    {
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];

        dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        cell.txtValue.text =[dateFormatter stringFromDate:[self.item valueForKey:propertyKey]];
    }
    else if ([temp isKindOfClass:[PFRelation class]])
    {
        NSLog(@"we have a PFRelation here.");
    }
    else
    {
        NSLog(@"someData is an unsupported type:\n%@", temp);
    }
    
    return cell;
}

#pragma Table View
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

@end
