//
//  LargeTextVC.h
//  ParseDevTool
//
//  Created by Ignacio Martin on 27/1/15.
//  Copyright (c) 2015 Niceway. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NWBaseVC.h"

@interface LargeTextVC : NWBaseVC

@property (weak, nonatomic) NSString* largeText;
@property (weak, nonatomic) IBOutlet UITextView *txtLargeText;

@end
