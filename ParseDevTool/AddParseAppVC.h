//
//  AddTableVC.h
//  ParseDevTool
//
//  Created by Ignacio Martin on 13/1/15.
//  Copyright (c) 2015 Niceway. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NWBaseVC.h"

@interface AddParseAppVC : NWBaseVC

@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextField *txtApplicationId;
@property (weak, nonatomic) IBOutlet UITextField *txtClientKey;
@end
