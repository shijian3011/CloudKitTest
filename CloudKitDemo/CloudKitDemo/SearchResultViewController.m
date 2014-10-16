//
//  SearchResultViewController.m
//  CloudKitDemo
//
//  Created by SHIJIAN on 14-10-14.
//  Copyright (c) 2014年 SHIJIAN. All rights reserved.
//

#import "SearchResultViewController.h"
#import <CloudKit/CloudKit.h>
#import "NearbyCell.h"
#import "UIImageView+WebCache.h"
@interface SearchResultViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation SearchResultViewController

//美国苹果总部坐标
//  latitude = 37.785834
//  longitude = -122.406417

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.allowsSelection = NO;
    UINib * customNib = [UINib nibWithNibName:@"NearbyCell" bundle:nil];
    [self.tableView registerNib:customNib forCellReuseIdentifier:@"nearby"];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Nearby";
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.items.count;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NearbyCell * cell = [tableView dequeueReusableCellWithIdentifier:@"nearby"];
    CKRecord * record = [self.items objectAtIndex:indexPath.row];
    cell.nameLabel.text = [record objectForKey:@"Name"];
    CKAsset * set = [record objectForKey:@"CoverPhoto"];
    [cell.nearbyImageView setImageWithURL:set.fileURL];
    return cell;
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
