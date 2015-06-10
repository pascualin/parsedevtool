//
//  AddTableVC.h
//  ParseDevTool
//
//  Created by Ignacio Martin on 13/1/15.
//  Copyright (c) 2015 Niceway. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NWBaseVC.h"

@interface AddClassVC : NWBaseVC  <UIBarPositioningDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextField *txtDisplayname;
@property (strong, nonatomic) NSObject* parseApp;

@end
