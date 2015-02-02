//
//  NWNavigationVC.m
//  ParseDevTool
//
//  Created by Takeshi Hui on 29/1/15.
//  Copyright (c) 2015 Niceway. All rights reserved.
//

#import "NWNavigationVC.h"

@interface NWNavigationVC ()

@end

@implementation NWNavigationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];

    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[UIImage imageNamed:@"1422885925_back-48.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
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
