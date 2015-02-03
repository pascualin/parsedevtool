//
//  NWNavigationVC.m
//  ParseDevTool
//
//  Created by Takeshi Hui on 29/1/15.
//  Copyright (c) 2015 Niceway. All rights reserved.
//

#import "NWNavigationVC.h"
#import "GADBannerView.h"
#import "GADRequest.h"
#import <CJPAdController.h>

@interface NWNavigationVC ()

@property (strong, nonatomic) GADBannerView *bannerView;

@end

@implementation NWNavigationVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];

    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[UIImage imageNamed:@"1422885925_back-48.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    #ifdef ISFREE
//        [self.toolbar setHidden:NO];
//        self.bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];
//        self.bannerView.adUnitID = @"ca-app-pub-4192187297198298/6243306365";
//        self.bannerView.rootViewController = self;
//    
//        GADRequest *request = [GADRequest request];
//        request.testDevices = @[ GAD_SIMULATOR_ID ];
//        [self.bannerView loadRequest:request];
//        [self.bannerView setFrame:CGRectMake(0, [[UIScreen mainScreen] bounds].size.height - self.bannerView.frame.size.height, self.bannerView.frame.size.width, self.bannerView.frame.size.height)];
//    
//        [self.toolbar insertSubview:self.bannerView aboveSubview:self.toolbar];
    #endif
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return self.topViewController.supportedInterfaceOrientations;
}

@end
