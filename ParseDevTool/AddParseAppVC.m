//
//  AddTableVC.m
//  ParseDevTool
//
//  Created by Ignacio Martin on 13/1/15.
//  Copyright (c) 2015 Niceway. All rights reserved.
//

#import "AddParseAppVC.h"
#import "AppDelegate.h"

@interface AddParseAppVC ()

@end

@implementation AddParseAppVC

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self.txtApplicationName becomeFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.txtApplicationName)
    {
        [self.txtApplicationId becomeFirstResponder];
    }else if ( textField == self.txtApplicationId)
    {
        [self.txtClientKey becomeFirstResponder];
    } else
    {
        [textField resignFirstResponder];
        [self saveNewParseApp:textField];
    }
    return YES;
}

- (IBAction)saveNewParseApp:(id)sender
{
    if ((self.txtApplicationId.text.length > 0) && (self.txtClientKey.text.length > 0) && (self.txtApplicationName.text.length > 0))
    {
        AppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
        NSManagedObjectContext* context = [appDelegate managedObjectContext];
        NSEntityDescription *parseAppDescription = [NSEntityDescription entityForName:@"ParseApp" inManagedObjectContext:context];
        NSEntityDescription *tableDescription = [NSEntityDescription entityForName:@"Table" inManagedObjectContext:context];
        NSManagedObject* newParseApp;
        newParseApp = [[NSManagedObject alloc] initWithEntity:parseAppDescription insertIntoManagedObjectContext:context];
        [newParseApp setValue:self.txtApplicationName.text forKey:@"name"];
        [newParseApp setValue:self.txtApplicationId.text forKey:@"applicationId"];
        [newParseApp setValue:self.txtClientKey.text forKey:@"clientKey"];
        
        // Now we create the default User table
        NSManagedObject *userTable = [[NSManagedObject alloc] initWithEntity:tableDescription insertIntoManagedObjectContext:context];
        
        // Set table name
        [userTable setValue:@"_User" forKey:@"name"];
        [userTable setValue:@"username" forKey:@"displayProperty"];
        
        // Create Relationship
        NSMutableSet *tables = [newParseApp mutableSetValueForKey:@"tables"];
        [tables addObject:userTable];
        
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

-(UIBarPosition)positionForBar:(id<UIBarPositioning>)bar
{    
    return UIBarPositionTopAttached;
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationPortrait;
}

@end
