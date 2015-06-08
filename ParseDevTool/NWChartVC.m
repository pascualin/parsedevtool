//
//  NWChartVC.m
//  ParseDevTool
//
//  Created by Ignacio Martin on 27/1/15.
//  Copyright (c) 2015 Niceway. All rights reserved.
//

#import "NWChartVC.h"

@interface NWChartVC ()

@property BOOL isChartLoaded;
@end

@implementation NWChartVC

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    self.chartView.objects = self.objects;
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(orientationChanged:)
     name:UIDeviceOrientationDidChangeNotification
     object:[UIDevice currentDevice]];
    
    self.title = @"Creation history";
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
}

- (void) orientationChanged:(NSNotification *)note
{
    UIDevice * device = note.object;
    switch(device.orientation)
    {
        case UIDeviceOrientationPortrait:
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
            break;
        default:
            break;
    };
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if (!self.isChartLoaded)
    {
        self.chartView.frame = self.view.frame;
        self.chartView.bounds = self.view.bounds;
        self.isChartLoaded = YES;
        [self.chartView refreshChart];
    }
}

-(BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

- (IBAction)dismiss:(id)sender
{
    if ([[[UIDevice currentDevice] valueForKey:@"orientation"] isEqualToNumber:[NSNumber numberWithInt:UIInterfaceOrientationPortrait]] )
    {
        NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft];
        [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    }
    
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
}
@end
