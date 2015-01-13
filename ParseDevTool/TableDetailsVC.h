//
//  TableDetailsVC.h
//  ParseDevTool
//
//  Created by Ignacio Martin on 13/1/15.
//  Copyright (c) 2015 Niceway. All rights reserved.
//

#import "PFQueryTableViewController.h"
#import <ParseUI.h>

@interface TableDetailsVC : PFQueryTableViewController

@property (strong, nonatomic) NSObject* table;
@property (strong, nonatomic) NSObject* parseApp;

@end
