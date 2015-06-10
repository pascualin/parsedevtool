//
//  AddTableVC.h
//  ParseDevTool
//
//  Created by Ignacio Martin on 13/1/15.
//  Copyright (c) 2015 Niceway. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NWBaseVC.h"

@interface AddAppVC : NWBaseVC <UIBarPositioningDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtApplicationName;
@property (weak, nonatomic) IBOutlet UITextField *txtApplicationId;
@property (weak, nonatomic) IBOutlet UITextField *txtClientKey;
@property (strong, nonatomic) NSObject *parseApp;

@end
