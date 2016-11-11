//
//  CPSSearchGoodsViewController.m
//  SellerCenturySquare
//
//  Created by clz on 15/8/25.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CPSSearchGoodsViewController.h"
#import "CPSSearchGoodsViewCell.h"
#import "CPSGoodsSearchTableViewHeadView.h"
#import "CSPDropDownChooseView.h"
#import "GetEditGoodsListDTO.h"
#import "EditGoodsDTO.h"
#import "RefreshControl.h"
#import "CPSGoodsDetailsEditViewController.h"
#import "EditGoodsViewController.h"

static NSString *const queryTermsArticleNumberStr = @"0";

static NSString *const queryTermsGoodsNameStr = @"1";

@interface CPSSearchGoodsViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,RefreshControlDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet CSPDropDownChooseView *dropDownChooseView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dropDownChooseViewHeight;

@property (weak, nonatomic) IBOutlet UILabel *tipNoDataLabel;

@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (weak, nonatomic) IBOutlet UILabel *searchResultLabel;

@property (strong, nonatomic)NSMutableArray *resourceDataArray;

@property (strong, nonatomic)RefreshControl *refreshControl;


@property (strong, nonatomic) IBOutlet UIView *topBgView;


- (IBAction)searchButtonClick:(id)sender;

@end

@implementation CPSSearchGoodsViewController{
    
    NSInteger _pageNo;
    
    BOOL _isRefresh;
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"商品";
    
    [self customBackBarButton];
    
    _pageNo = 1;
    
    self.tipNoDataLabel.hidden = YES;

    
    self.dropDownChooseView.setFrameBlock = ^(BOOL isDropDown){
        if (isDropDown) {
            self.dropDownChooseViewHeight.constant = 60;

        }else{
            self.dropDownChooseViewHeight.constant = 30;

        }
    };
    
    self.textField.backgroundColor = HEX_COLOR(0xf0f0f0FF);
    
    self.textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    self.textField.layer.borderWidth = 0.5;
    
    self.resourceDataArray = [[NSMutableArray alloc]init];
    
    self.searchResultLabel.hidden = YES;
    
    self.refreshControl = [[RefreshControl alloc]initWithScrollView:self.tableView delegate:self];
    
    //!添加 点击其他地方收起键盘事件
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    //不加会屏蔽到TableView的点击事件等
    tapGr.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:tapGr];
    
    //!设置顶部的背景颜色，为了有分割效果
    [self.topBgView setBackgroundColor:[UIColor colorWithHex:0xefeff4 alpha:1]];
    
    [self.searchResultLabel setTextColor:[UIColor colorWithHex:0x666666 alpha:1]];
    
    //!自动适应高度
    self.tableView.estimatedRowHeight = 44.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    
    
}
-(void)hideKeyboard{
    
    [self.view endEditing:YES];
    
}
-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.resourceDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"CPSSearchGoodsViewCellID";
    
    CPSSearchGoodsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (self.resourceDataArray.count) {
        
        EditGoodsDTO *editGoods = [self.resourceDataArray objectAtIndex:indexPath.section];
        
        [cell configData:editGoods];
        
    }
  

    return cell;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    EditGoodsDTO *editGoods = [self.resourceDataArray objectAtIndex:section];

    static NSString *headViewID = @"headViewID";
    
    CPSGoodsSearchTableViewHeadView *goodsSearchTableViewHeadView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headViewID];
    
    if (!goodsSearchTableViewHeadView) {
        
        goodsSearchTableViewHeadView = [[[NSBundle mainBundle]loadNibNamed:@"CPSGoodsSearchTableViewHeadView" owner:self options:nil]firstObject];
    }
    
    goodsSearchTableViewHeadView.articleNumberLabel.text = [NSString stringWithFormat:@"货号：%@",editGoods.goodsWillNo];
    
    //1新发布,2在售, 3下架（默认在售）
    if ([editGoods.goodsStatus isEqualToString:@"1"]) {
        
        goodsSearchTableViewHeadView.saleTypeLabel.text = @"新发布";

    }else if ([editGoods.goodsStatus isEqualToString:@"2"]){
        
        goodsSearchTableViewHeadView.saleTypeLabel.text = @"在售";
        
    }else if ([editGoods.goodsStatus isEqualToString:@"3"]){
        
        goodsSearchTableViewHeadView.saleTypeLabel.text = @"下架";
    }else{
    
        goodsSearchTableViewHeadView.saleTypeLabel.text = @"编辑中";

    
    }
    
    return goodsSearchTableViewHeadView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    EditGoodsDTO *editGoods = [self.resourceDataArray objectAtIndex:indexPath.section];

    //进入编辑详情页面
    EditGoodsViewController * editVC = [[EditGoodsViewController alloc]init];
    editVC.goodsNo = editGoods.goodsNo;
    [self.navigationController pushViewController:editVC animated:YES];
    
}

#pragma mark-UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark-搜索
- (IBAction)searchButtonClick:(id)sender {
    
    if (!_isRefresh) {
        _pageNo = 1;
    }
    
    [self.textField resignFirstResponder];
    
    EditGoodsModel *editGoodsModel = [[EditGoodsModel alloc]init];

    NSString *text = self.dropDownChooseView.mainButton.titleLabel.text;
    
    if ([text isEqualToString:@"货号"]) {
        
        editGoodsModel.queryType = queryTermsArticleNumberStr;

    }else if ([text isEqualToString:@"名称"]){
        
        editGoodsModel.queryType = queryTermsGoodsNameStr;
    }
    
    DebugLog(@" editGoodsModel.queryType = %@", editGoodsModel.queryType);
    
    [self progressHUDShowWithString:@"搜索中"];
    
    if (self.textField.text.length<1) {
        
        [self progressHUDHiddenWidthString:@"查询条件不能为空"];
        self.tipNoDataLabel.hidden = YES;

        return;
    }
    
    //1新发布,2在售, 3下架（默认在售） 不传则是全部
//    editGoodsModel.goodsStatus = self.goodsStatus;
    
    editGoodsModel.goodsStatus = @"";

    
    //需要修改
    editGoodsModel.pageNo = [NSNumber numberWithInteger:_pageNo];
    
    editGoodsModel.pageSize = [NSNumber numberWithInteger:PAGESIZE];
    
//    editGoodsModel.param = [self.textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    editGoodsModel.param = self.textField.text;
    
    editGoodsModel.channelType = @(-1);//!全部
    
    
    [HttpManager sendHttpRequestForGetEditGoodsList:editGoodsModel success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self.refreshControl finishRefreshingDirection:RefreshDirectionBottom];
        
        [self.progressHUD hide:YES];
        
        NSDictionary *responseDic = [self conversionWithData:responseObject];
        
        
        if ([self isRequestSuccessWithCode:[responseDic objectForKey:CODE]]) {
            
            id data = [responseDic objectForKey:@"data"];
            
            if (!_isRefresh) {
                
                [self.resourceDataArray removeAllObjects];

            }
            
            //判断数据合法
            if ([self checkData:data class:[NSDictionary class]]) {
                
                GetEditGoodsListDTO *getEditGoodsList = [[GetEditGoodsListDTO alloc]init];
                
                [getEditGoodsList setDictFrom:data];
                
                self.searchResultLabel.text = [NSString stringWithFormat:@"搜索结果（%@）",getEditGoodsList.totalCount.stringValue];
                
                id goodsList = [data objectForKey:@"goodslist"];
                
                //判断数据合法
                if ([self checkData:goodsList class:[NSArray class]]) {
                    
                    for (NSDictionary *goodsListDic in goodsList) {
                        
                        EditGoodsDTO *editGoods = [[EditGoodsDTO alloc]init];
                        
                        [editGoods setDictFrom:goodsListDic];
                        
                        [self.resourceDataArray addObject:editGoods];
                    }
                }
            }
            
            [self.tableView reloadData];
            
            if (self.resourceDataArray.count) {
                self.tipNoDataLabel.hidden = YES;
                self.searchResultLabel.hidden = NO;
                
                if (self.resourceDataArray.count>PAGESIZE) {
                    
                    self.refreshControl.bottomEnabled = YES;
                }else{
                    self.refreshControl.bottomEnabled = NO;
                }
            }else{
                self.tipNoDataLabel.hidden = NO;
                self.searchResultLabel.hidden = YES;
            }
            
            
        }else{
            
            [self alertViewWithTitle:@"获取失败" message:[responseDic objectForKey:ERRORMESSAGE]];

        }
        
        if (_isRefresh) {
            _isRefresh = NO;
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self.refreshControl finishRefreshingDirection:RefreshDirectionBottom];
        
        if (_isRefresh) {
            _isRefresh = NO;
        }
        
        [self tipRequestFailureWithErrorCode:error.code];
        
    }];
}

#pragma mark-RefreshControlDelegate
- (void)refreshControl:(RefreshControl *)refreshControl didEngageRefreshDirection:(RefreshDirection) direction{
    
    if (direction==RefreshDirectionTop)
        
    {
        
    }else if (direction == RefreshDirectionBottom){
        
        _pageNo++;
        
        _isRefresh = YES;
        
        [self searchButtonClick:nil];
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
