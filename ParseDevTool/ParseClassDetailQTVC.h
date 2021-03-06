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
#import "NWBaseQTVC.h"

@interface ParseClassDetailQTVC : NWBaseQTVC

@property (strong, nonatomic) NSObject* parseTable;
@property (strong, nonatomic) NSObject* parseApp;
@property (strong, nonatomic) PFRelation* relation;
@property (strong, nonatomic) NSArray* array;
@property (nonatomic) BOOL isArray;
@property (nonatomic, strong) IBOutletCollection(UIBarButtonItem) NSArray* rightBarButtonItemsCollection;

@property (strong, nonatomic) PFObject* item;

@end
