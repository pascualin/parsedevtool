//
//  NWImageVC.m
//  ParseDevTool
//
//  Created by Ignacio Martin on 26/1/15.
//  Copyright (c) 2015 Niceway. All rights reserved.
//

#import "NWImageVC.h"

@interface NWImageVC ()

@end

@implementation NWImageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageView.file = self.pfFile;
    [self.imageView loadInBackground];
    
    self.imageView.contentMode = UIViewContentModeCenter;
    
    if (self.imageView.bounds.size.width > self.imageView.image.size.width && self.imageView.bounds.size.height > self.imageView.image.size.height)
    {
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
}


@end
