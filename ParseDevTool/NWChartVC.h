//
//  NWChartVC.h
//  ParseDevTool
//
//  Created by Ignacio Martin on 26/1/15.
//  Copyright (c) 2015 Niceway. All rights reserved.
//

#import <PNChart.h>

@interface NWChartVC : PNBarChart

@property NSArray *reversedDate;
@property NSArray *objects;

-(void)refreshChart;

@end
