//
//  NWBaseVC.m
//  ParseDevTool
//
//  Created by Ignacio Martin on 27/1/15.
//  Copyright (c) 2015 Niceway. All rights reserved.
//

#import "NWBaseVC.h"

@interface NWBaseVC ()

@end

@implementation NWBaseVC

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

-(BOOL)shouldAutorotate
{
    return NO;
}

@end
