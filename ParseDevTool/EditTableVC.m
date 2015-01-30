//
//  EditTableVC.m
//  ParseDevTool
//
//  Created by Ignacio Martin on 30/1/15.
//  Copyright (c) 2015 Niceway. All rights reserved.
//

#import "EditTableVC.h"
#import "AppDelegate.h"

@interface EditTableVC ()

@end

@implementation EditTableVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.txtDisplayProperty.text = [self.parseTable valueForKey:@"displayProperty"];
}


- (IBAction)saveTable:(id)sender
{
    AppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* context = [appDelegate managedObjectContext];

    if ([self.txtDisplayProperty.text length] > 0)
    {
        [self.parseTable setValue:self.txtDisplayProperty.text forKey:@"displayProperty"];
    }
    else
    {
        [self.parseTable setValue:@"objectId" forKey:@"displayProperty"];
    }
    
    NSError* error;
    [context save:&error];
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancel:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
