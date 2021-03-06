//
//  EditTableVC.h
//  ParseDevTool
//
//  Created by Ignacio Martin on 30/1/15.
//  Copyright (c) 2015 Niceway. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NWBaseVC.h"

@interface EditClassDetail : NWBaseVC <UIBarPositioningDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtDisplayProperty;
@property (strong, nonatomic) NSObject* parseTable;
@property (strong, nonatomic) NSObject* parseApp;

@end
