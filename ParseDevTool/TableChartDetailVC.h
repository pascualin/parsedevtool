//
//  TableChartDetailVC.h
//  ParseDevTool
//
//  Created by Takeshi Hui on 14/1/15.
//  Copyright (c) 2015 Niceway. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseUI.h>
#import "TableDetailsVC.h"

@interface TableChartDetailVC : UIViewController


@property (strong, nonatomic) IBOutlet TableDetailsVC *tableDetailVC;

@property (strong, nonatomic) NSObject* table;
@property (strong, nonatomic) NSObject* parseApp;

@end
