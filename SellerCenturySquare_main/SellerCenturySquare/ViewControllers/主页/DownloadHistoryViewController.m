//
//  DownloadHistoryViewController.m
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/8/12.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "DownloadHistoryViewController.h"

#import "HasDownloadTableViewCell.h"
@interface DownloadHistoryViewController ()
@property (nonatomic,assign)BOOL allSelectedState;
@end

@implementation DownloadHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - Private Functions
- (IBAction)allSelectedButtonClicked:(id)sender {
    _allSelectedState = !_allSelectedState;
    if (_allSelectedState) {
        _allSelectedButton.selected = YES;
    }else{
        _allSelectedButton.selected = NO;
    }
    
    [self.tableView reloadData];
}



#pragma mark - TableView Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HasDownloadTableViewCell *hasDownloadCell = [tableView dequeueReusableCellWithIdentifier:@"HasDownloadTableViewCell"];
    
    if (!hasDownloadCell) {
        
        [tableView registerNib:[UINib nibWithNibName:@"HasDownloadTableViewCell" bundle:nil] forCellReuseIdentifier:@"HasDownloadTableViewCell"];
        hasDownloadCell = [tableView dequeueReusableCellWithIdentifier:@"HasDownloadTableViewCell"];
    }
    
    [hasDownloadCell updateOnEditState:YES];
    
    if (_allSelectedState) {
        [hasDownloadCell allSelectedState:YES];
    }else{
        [hasDownloadCell allSelectedState:NO];
    }
    
    return hasDownloadCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    CGFloat height =cell.frame.size.height;
    
    return height;
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
