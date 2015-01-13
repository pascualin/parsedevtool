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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveNewTable:(id)sender
{
    if ((self.txtApplicationId.text.length > 0) && (self.txtClientKey.text.length > 0) && (self.txtName.text.length > 0))
    {
        AppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
        NSManagedObjectContext* context = [appDelegate managedObjectContext];
        NSManagedObject* newParseApp;
        newParseApp = [NSEntityDescription insertNewObjectForEntityForName:@"ParseApp" inManagedObjectContext:context];
        [newParseApp setValue:self.txtName.text forKey:@"name"];
        [newParseApp setValue:self.txtApplicationId.text forKey:@"applicationId"];
        [newParseApp setValue:self.txtClientKey.text forKey:@"clientKey"];
        
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
