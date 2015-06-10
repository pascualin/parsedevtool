//
//  ParseAppViewCell.h
//  ParseDevTool
//
//  Created by Ignacio Martin on 13/1/15.
//  Copyright (c) 2015 Niceway. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGSwipeTableCell.h"

@interface ParseAppCell : MGSwipeTableCell

@property (strong, nonatomic) NSObject* parseApp;
@property (weak, nonatomic) IBOutlet UILabel *txtTitle;

@end
