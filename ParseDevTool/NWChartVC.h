//
//  NWChartVC.h
//  ParseDevTool
//
//  Created by Ignacio Martin on 27/1/15.
//  Copyright (c) 2015 Niceway. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NWChartView.h"

@interface NWChartVC : UIViewController

@property (strong, nonatomic) NSArray* objects;
@property (strong, nonatomic) IBOutlet NWChartView *chartView;

@end
