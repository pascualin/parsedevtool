//
//  NWUtils.m
//  SmartCasual
//
//  Created by Ignacio Martin on 9/4/15.
//  Copyright (c) 2015 Niceway. All rights reserved.
//

#import "NWUtils.h"

@implementation NWUtils

+ (id)instance
{
    static NWUtils *instance = nil;
    @synchronized(self) {
        if (instance == nil)
        {
            instance = [[self alloc] init];
            instance.interstitial = [instance createAndLoadInterstitial];
        }
    }
    return instance;
}

- (GADInterstitial *)createAndLoadInterstitial
{
    GADInterstitial *interstitial = [[GADInterstitial alloc] initWithAdUnitID:@"ca-app-pub-4192187297198298/6288062768"];
    interstitial.delegate = self;
    [interstitial loadRequest:[GADRequest request]];
    return interstitial;
}

-(void)interstitialDidDismissScreen:(GADInterstitial *)ad
{
    if (self.adDisplayController)
    {
        [self.adDisplayController performClosedAdsAction];
    }
    self.interstitial = [self createAndLoadInterstitial];
}

-(void)incrementAdsCount
{
    NSInteger totalDisplays = [[NSUserDefaults standardUserDefaults] integerForKey:@"totalFullScreenAdsDisplayed"];
    totalDisplays++;
    [[NSUserDefaults standardUserDefaults] setInteger:totalDisplays forKey:@"totalFullScreenAdsDisplayed"];
    //NSLog([NSString stringWithFormat:@"Full screen ads scenarios count: %li", totalDisplays]);
}

@end
