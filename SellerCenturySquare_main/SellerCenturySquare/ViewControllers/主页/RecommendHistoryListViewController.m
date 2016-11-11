//
//  RecommendHistoryListViewController.m
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/9/18.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "RecommendHistoryListViewController.h"
#import "GetRecommendRecordListDTO.h"
#import "RecommendRecordDTO.h"
#import "GoodsPicDTO.h"
#import "RecommendHistoryTableViewCell.h"
#import "CSPRecommendDetailViewController.h"
@interface RecommendHistoryListViewController ()
{
    NSMutableArray *selectList;
    BOOL selectAll;
}
@end

@implementation RecommendHistoryListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    selectList = [[NSMutableArray alloc]init];
    selectAll = NO;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(checkDetailInfo:) name:kCheckDetailInfoNotification object:nil];
    
    [self customBackBarButton];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [self tabbarHidden:YES];
    [self getRecommendHistoryList];
    
    
}

- (void)viewDidDisappear:(BOOL)animated{
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Functions

- (IBAction)selectedAllButtonClicked:(id)sender {

    _selectAllButton.selected = !_selectAllButton.selected;
    
    if (_selectAllButton.selected) {
        
        selectAll = YES;
        [self.tableView setEditing:YES animated:YES];
        [self selectAllIndexPath];
        [self.tableView reloadData];

    }else{
        selectList = [[NSMutableArray alloc]init];
        selectAll = NO;
        [self.tableView setEditing:YES animated:YES];
        [self.tableView reloadData];
        
    }
}

- (void)selectAllIndexPath{
    
    selectList = [[NSMutableArray alloc]init];
    
    for (int i=0; i<_getRecommendRecordListDTO.recommendRecordDTOList.count; i++) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];

        [selectList addObject:indexPath];
    }
}

- (IBAction)delButtonClicked:(id)sender {
    
    UIBarButtonItem *item = (UIBarButtonItem*)sender;
    
    if (self.tableView.editing) {
        
        [self.tableView setEditing:NO animated:YES];
        _deleteView.hidden = YES;
        _sendButton.hidden = NO;
        [item setTitle:nil];
        [item setImage:[UIImage imageNamed:@"推荐_删除"]];
    }else{
        
        [self.tableView setEditing:YES animated:YES];
        [item setTitle:@"完成"];
    
        _deleteView.hidden = NO;
        _sendButton.hidden = YES;
        
        NSDictionary *fontDic = [[NSDictionary alloc]initWithObjectsAndKeys:[UIFont systemFontOfSize:12],NSFontAttributeName, nil];
        
        [item setTitleTextAttributes:fontDic forState:UIControlStateNormal];
        [item setTitleTextAttributes:fontDic forState:UIControlStateHighlighted];
        [item setImage:nil];
    }
    
}

//详细页面
- (void)checkDetailInfo:(NSNotification *)note{
    
    NSDictionary *dic = [note userInfo];
    
    RecommendRecordDTO *recommendDTO = dic[@"dto"];
    
    CSPRecommendDetailViewController *recommendDetailDTO = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPRecommendDetailViewController"];
    
    recommendDetailDTO.recommendRecordDTO = recommendDTO;
    
    [self.navigationController pushViewController:recommendDetailDTO animated:YES];
    
}

- (IBAction)bottomDeleteButtonClicked:(id)sender {
    
    NSMutableArray *delList = [[NSMutableArray alloc]init];
    
    for (NSIndexPath *indexPath in selectList) {
        
        [delList addObject:_getRecommendRecordListDTO.recommendRecordDTOList[indexPath.row]];
    }
    
    NSString *identifys = [[NSString alloc]init];

    for (RecommendRecordDTO *tmpDTO in delList) {
        
        if (identifys.length==0) {
            
            identifys = [tmpDTO.Id stringValue];
        }else{
            
            identifys = [identifys stringByAppendingFormat:@",%@",tmpDTO.Id];
        }
        
        [_getRecommendRecordListDTO.recommendRecordDTOList removeObject:tmpDTO];
    }
    
    if (identifys.length>0) {
        
        [self delHistoryRequest:identifys];
    }
    
    [self.tableView deleteRowsAtIndexPaths:selectList withRowAnimation:UITableViewRowAnimationFade];
    
    selectList = [[NSMutableArray alloc]init];
}

#pragma mark - HttpRequest
- (void)getRecommendHistoryList{
    
    NSNumber* pageNo = [[NSNumber alloc] initWithInt:1];
    NSNumber* pageSize = [[NSNumber alloc] initWithInt:20];;
    
    [HttpManager sendHttpRequestForGetRecommendRecordList:pageNo pageSize:pageSize  success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            NSLog(@" 推荐商品记录列表接口  返回正常编码");
            if ([[dic objectForKey:@"data"] isKindOfClass:[NSDictionary class]])
            {
                _getRecommendRecordListDTO = [[GetRecommendRecordListDTO alloc]init];
        
                [_getRecommendRecordListDTO setDictFrom:[dic objectForKey:@"data"]];

                if(_getRecommendRecordListDTO.recommendRecordDTOList.count==0){
                    
                    _noticeView.hidden = NO;
                    _delBarButton.enabled = NO;
                }else{
                    _noticeView.hidden = YES;
                    _delBarButton.enabled = YES;
                }
                if (!_getRecommendRecordListDTO.recommendRecordDTOList.count) {
                    [self.tableView setEditing:NO animated:YES];
                    _deleteView.hidden = YES;
                    _sendButton.hidden = NO;
                    [_delBarButton setTitle:nil];
                    [_delBarButton setImage:[UIImage imageNamed:@"推荐_删除"]];
                }
                //_getRecommendRecordListDTO.recommendRecordDTOList.count
                [self.tableView reloadData];
            }
        }else{
            
            NSLog(@" 推荐商品记录列表接口 返回异常编码 errorMessage = %@",[dic objectForKey:@"errorMessage"]);
        }
        
        NSLog(@"dic = %@",dic);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"testGetRecommendRecordList 失败");
        NSLog(@"The error description is %@\n",[error localizedDescription]);
        
    } ];

}

- (void)delHistoryRequest:(NSString*)identify{
    
    [HttpManager sendHttpRequestForDeleteRecommendRecord:identify success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            NSLog(@" 推荐商品记录删除接口  返回正常编码");
            [self getRecommendHistoryList];
            
        }else{
            
            NSLog(@" 推荐商品记录删除接口 返回异常编码 errorMessage = %@",[dic objectForKey:@"errorMessage"]);
        }
        
        NSLog(@"dic = %@",dic);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"testGetDeleteRecommendRecord 失败");
        NSLog(@"The error description is %@\n",[error localizedDescription]);
        
    } ];
    
}

#pragma mark - TableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _getRecommendRecordListDTO.recommendRecordDTOList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RecommendHistoryTableViewCell *recommendHistoryCell = [tableView dequeueReusableCellWithIdentifier:@"RecommendHistoryTableViewCell"];
    
    if (!recommendHistoryCell) {
        
        [tableView registerNib:[UINib nibWithNibName:@"RecommendHistoryTableViewCell" bundle:nil] forCellReuseIdentifier:@"RecommendHistoryTableViewCell"];
        recommendHistoryCell = [tableView dequeueReusableCellWithIdentifier:@"RecommendHistoryTableViewCell"];
    }
    
    // Configure the cell...
    RecommendRecordDTO *recommendRecordDTO = [[RecommendRecordDTO alloc]init];
    
    recommendRecordDTO = _getRecommendRecordListDTO.recommendRecordDTOList[indexPath.row];
    
    recommendHistoryCell.recommendRecordDTO = recommendRecordDTO;
    
    if (selectAll) {
    
        
        recommendHistoryCell.selected = YES;
        
    }else{
        
        recommendHistoryCell.selected = NO;
        
    }
    
    return recommendHistoryCell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    CGFloat height =cell.frame.size.height;
    
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section==0) {
        return 0.1;
    }else{
        
        return 10;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(editingStyle == UITableViewCellEditingStyleDelete){
        
        RecommendRecordDTO *recommendRecordDTO = _getRecommendRecordListDTO.recommendRecordDTOList[indexPath.row];

        [self delHistoryRequest:[recommendRecordDTO.Id stringValue]];

        [_getRecommendRecordListDTO.recommendRecordDTOList removeObjectAtIndex:indexPath.row];
        
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete|UITableViewCellEditingStyleInsert;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.editing) {
        [selectList addObject:indexPath];
    }else {
       RecommendRecordDTO *recommendRecordDTO = _getRecommendRecordListDTO.recommendRecordDTOList[indexPath.row];
        CSPRecommendDetailViewController *recommendDetailDTO = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPRecommendDetailViewController"];
        
        recommendDetailDTO.recommendRecordDTO = recommendRecordDTO;
        
        [self.navigationController pushViewController:recommendDetailDTO animated:YES];
        

    }
    
    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [selectList removeObject:indexPath];
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
