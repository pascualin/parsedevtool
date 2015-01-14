//
//  TableChartDetailVC.m
//  ParseDevTool
//
//  Created by Takeshi Hui on 14/1/15.
//  Copyright (c) 2015 Niceway. All rights reserved.
//

#import "TableChartDetailVC.h"

@interface TableChartDetailVC ()

@end

@implementation TableChartDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _tableDetailVC = [[TableDetailsVC alloc] init];
    _tableDetailVC.table = self.table;
    _tableDetailVC.parseApp = self.parseApp;
    
    [self addChildViewController:_tableDetailVC];
    [self.view addSubview:_tableDetailVC.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
