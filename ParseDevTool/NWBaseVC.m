//
//  NWBaseVC.m
//  ParseDevTool
//
//  Created by Ignacio Martin on 30/1/15.
//  Copyright (c) 2015 Niceway. All rights reserved.
//

#import "NWBaseVC.h"
#import <GAITracker.h>
#import <GAI.h>
#import <GAIFields.h>
#import <GAIDictionaryBuilder.h>
#import "GADBannerView.h"
#import "GADRequest.h"


@interface NWBaseVC ()

@property (strong, nonatomic) NSString* analyticsDescriptiveName;
@property (weak, nonatomic) IBOutlet GADBannerView *bannerView;

@end

@implementation NWBaseVC


-(void)viewDidLoad
{
    [super viewDidLoad];
    
    #ifdef ISFREE
        self.bannerView.adUnitID = @"ca-app-pub-4192187297198298/6243306365";
        self.bannerView.rootViewController = self;
        
        GADRequest *request = [GADRequest request];
        // Enable test ads on simulators.
        request.testDevices = @[ GAD_SIMULATOR_ID ];
        [self.bannerView loadRequest:request];
    #else
        self.bannerView.frame = CGRectMake(0, 0, 0, 0);
        self.bannerView.bounds = CGRectMake(0, 0, 0, 0);
    #endif
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.analyticsDescriptiveName.length > 0)
    {
        [self sendGoogleAnalyticsTracker:self.analyticsDescriptiveName];
    }
    else
    {
        [self sendGoogleAnalyticsTracker:NSStringFromClass([self class])];
    }
}

- (void) sendGoogleAnalyticsTracker:(NSString *)screenName
{
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:screenName];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}

@end
