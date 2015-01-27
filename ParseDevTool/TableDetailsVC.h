//
//  TableDetailsVC.h
//  ParseDevTool
//
//  Created by Ignacio Martin on 13/1/15.
//  Copyright (c) 2015 Niceway. All rights reserved.
//

#import "PFQueryTableViewController.h"
#import <Parse/Parse.h>
#import <ParseUI.h>
#import "NWChartVC.h"
#import "PNChartLabel.h"

@interface TableDetailsVC : PFQueryTableViewController

@property (strong, nonatomic) NSObject* parseTable;
@property (strong, nonatomic) NSObject* parseApp;
@property (strong, nonatomic) PFRelation* relation;

@property (strong, nonatomic) PFObject* item;

@end
