//
//  ItemDetailVC.h
//  ParseDevTool
//
//  Created by Ignacio Martin on 13/1/15.
//  Copyright (c) 2015 Niceway. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ItemDetailVC : UITableViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSObject* parseApp;
@property (strong, nonatomic) NSObject* parseTable;
@property (strong, nonatomic) PFObject* item;

@end
