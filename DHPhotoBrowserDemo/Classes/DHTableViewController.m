//
//  DHTableViewController.m
//  DHPhotoBrowserDemo
//
//  Created by duan on 2019/3/6.
//  Copyright © 2019年 duan. All rights reserved.
//

#import "DHTableViewController.h"
#import "DHPicTableViewCell.h"

@interface DHTableViewController ()

@end

@implementation DHTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DHPicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier"];
    if (!cell) {
        cell = [[DHPicTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"reuseIdentifier"];
        cell.superVC = self;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100 ;
}

@end
