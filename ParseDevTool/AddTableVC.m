//
//  AddTableVC.m
//  ParseDevTool
//
//  Created by Ignacio Martin on 13/1/15.
//  Copyright (c) 2015 Niceway. All rights reserved.
//

#import "AddTableVC.h"
#import "AppDelegate.h"

@interface AddTableVC ()

@end

@implementation AddTableVC

- (IBAction)saveNewTable:(id)sender
{
    if ((self.txtName.text.length > 0))
    {
        AppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
        NSManagedObjectContext* context = [appDelegate managedObjectContext];
        NSEntityDescription *tableDescription = [NSEntityDescription entityForName:@"Table" inManagedObjectContext:context];
        NSManagedObject* newTable;
        newTable = [[NSManagedObject alloc] initWithEntity:tableDescription insertIntoManagedObjectContext:context];
        [newTable setValue:self.txtName.text forKey:@"name"];
        
        NSMutableSet *tables = [(NSManagedObject*)self.parseApp mutableSetValueForKey:@"tables"];
        [tables addObject:newTable];
        
        NSError* error;
        [context save:&error];
        
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        // user needs to enter a name
    }
}

- (IBAction)cancelSave:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end