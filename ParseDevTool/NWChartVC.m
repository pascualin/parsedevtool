//
//  NWChartVC.m
//  ParseDevTool
//
//  Created by Ignacio Martin on 27/1/15.
//  Copyright (c) 2015 Niceway. All rights reserved.
//

#import "NWChartVC.h"

@interface NWChartVC ()

@end

@implementation NWChartVC

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    self.chartView.objects = self.objects;
    [self.chartView refreshChart];
}

-(BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeLeft;
}

- (IBAction)dismiss:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}
@end
