//
//  ViewController.h
//  ParseDevTool
//
//  Created by Ignacio Martin on 9/1/15.
//  Copyright (c) 2015 Niceway. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NWBaseTVC.h"

@interface HomeVC : NWBaseTVC <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

