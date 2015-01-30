//
//  NWMapViewController.h
//  Pamperr
//
//  Created by Ignacio Martín on 10/07/2014.
//  Copyright (c) 2014 Niceway Asia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface NWMapVC : UIViewController

@property (strong,nonatomic) PFGeoPoint* geopoint;

@end
