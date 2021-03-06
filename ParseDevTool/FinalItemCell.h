//
//  ItemCell.h
//  ParseDevTool
//
//  Created by Ignacio Martin on 13/1/15.
//  Copyright (c) 2015 Niceway. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface FinalItemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *txtObjectId;
@property (weak, nonatomic) PFObject* item;
@property (weak, nonatomic) IBOutlet UILabel *txtError;

@end
