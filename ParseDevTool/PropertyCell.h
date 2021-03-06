//
//  PropertyCell.h
//  ParseDevTool
//
//  Created by Ignacio Martin on 13/1/15.
//  Copyright (c) 2015 Niceway. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface PropertyCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *txtKey;
@property (weak, nonatomic) IBOutlet UILabel *txtValue;
@property (weak, nonatomic) PFGeoPoint *geoPoint;
@property (weak, nonatomic) PFRelation *relation;
@property (weak, nonatomic) PFObject *pfObject;
@property (weak, nonatomic) PFFile *pfFile;
@property (weak, nonatomic) NSArray *array;

@end
