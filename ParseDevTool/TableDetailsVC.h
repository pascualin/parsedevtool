//
//  TableDetailsVC.h
//  ParseDevTool
//
//  Created by Ignacio Martin on 13/1/15.
//  Copyright (c) 2015 Niceway. All rights reserved.
//

#import "PFQueryTableViewController.h"
#import <ParseUI.h>
#import "PNChart.h"
#import "PNChartLabel.h"

@interface TableDetailsVC : PFQueryTableViewController

@property (strong, nonatomic) NSObject* parseTable;
@property (strong, nonatomic) NSObject* parseApp;

@property (strong, nonatomic) IBOutlet PNBarChart *barChart;

@end
