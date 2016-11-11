//
//  PicsDownloadViewController.m
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/8/11.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "PicsDownloadViewController.h"

#import "HasDownloadTableViewCell.h"
@interface PicsDownloadViewController ()
@property (nonatomic,assign)BOOL editState;

@end

@implementation PicsDownloadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _editState = NO;
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    
    [self tabbarHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Functions

//已下载状态
- (IBAction)hasDownloadButtonClicked:(id)sender {
    [_hasDownloadButton setBackgroundColor:[UIColor whiteColor]];
    [_downloadingButton setBackgroundColor:[UIColor darkGrayColor]];
    
    [_hasDownloadButton setSelected:YES];
    [_downloadingButton setSelected:NO];
}

//正下载状态
- (IBAction)downloadingButtonClicked:(id)sender {
    
    [_hasDownloadButton setBackgroundColor:[UIColor darkGrayColor]];
    [_downloadingButton setBackgroundColor:[UIColor whiteColor]];
    
    [_hasDownloadButton setSelected:NO];
    [_downloadingButton setSelected:YES];
}

//编辑按钮
- (IBAction)editButtonClicked:(id)sender {
    
    _editButton.selected = !_editButton.selected;
    if (_editButton.selected) {
        //编辑状态
        _editState = YES;
        [self updateEditStateBottomBar:YES];
    }else{
        //完成状态
        _editState = NO;
        [self updateEditStateBottomBar:NO];
    }
    [_tableView reloadData];
    
    
}

//Bottom Bar切换
- (void)updateEditStateBottomBar:(BOOL)editState{
    
    if (editState) {
        //编辑状态
        _leaveL.hidden = YES;
        _leaveNumL.hidden = YES;
        _buyButton.hidden = YES;
        
        _selectAllButton.hidden = NO;
        _selectAllL.hidden = NO;
        _downloadAgainButton.hidden = NO;
        _clearButton.hidden = NO;
        
        
    }else{
        //完成状态（正常状态）
        _leaveL.hidden = NO;
        _leaveNumL.hidden = NO;
        _buyButton.hidden = NO;
        
        _selectAllButton.hidden = YES;
        _selectAllL.hidden = YES;
        _downloadAgainButton.hidden = YES;
        _clearButton.hidden = YES;
        
    }
    
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
    
    if (_editState) {
        
        [hasDownloadCell updateOnEditState:YES];
    }else{
        [hasDownloadCell updateOnEditState:NO];
    }
    
    return hasDownloadCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    CGFloat height =cell.frame.size.height;
    
    return height;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    [self navigationBarSettingShow:YES];
}


@end
