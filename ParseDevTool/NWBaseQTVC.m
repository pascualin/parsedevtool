//
//  NWBaseQTVC.m
//  ParseDevTool
//
//  Created by Ignacio Martin on 30/1/15.
//  Copyright (c) 2015 Niceway. All rights reserved.
//

#import "NWBaseQTVC.h"
#import <GAITracker.h>
#import <GAI.h>
#import <GAIFields.h>
#import <GAIDictionaryBuilder.h>

@interface NWBaseQTVC ()

@property (strong, nonatomic) NSString* analyticsDescriptiveName;

@end

@implementation NWBaseQTVC

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
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
}

@end
