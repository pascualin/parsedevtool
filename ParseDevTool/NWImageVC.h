//
//  NWImageVC.h
//  ParseDevTool
//
//  Created by Ignacio Martin on 26/1/15.
//  Copyright (c) 2015 Niceway. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseUI.h>
#import <Parse/Parse.h>
#import "NWBaseVC.h"

@interface NWImageVC : NWBaseVC

@property (weak, nonatomic) IBOutlet PFImageView *imageView;
@property (weak, nonatomic) PFFile *pfFile;

@end
