//
//  NWUtils.h
//  SmartCasual
//
//  Created by Ignacio Martin on 9/4/15.
//  Copyright (c) 2015 Niceway. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleMobileAds/GoogleMobileAds.h>
#import "AdsDisplayController.h"

@interface NWUtils : NSObject <GADInterstitialDelegate>

@property(nonatomic, strong) GADInterstitial* interstitial;
@property(nonatomic, strong) id<AdsDisplayController> adDisplayController;

+ (id)instance;

-(void)incrementAdsCount;
@end
