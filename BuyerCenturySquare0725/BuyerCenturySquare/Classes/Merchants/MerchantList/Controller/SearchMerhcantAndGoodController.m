//
//  SearchMerhcantAndGoodController.m
//  BuyerCenturySquare
//
//  Created by 左键视觉 on 16/3/21.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "SearchMerhcantAndGoodController.h"
#import "MerchantAndGoodSelectView.h"
#import "SearchHistoryDefaults.h"//!读取、保存历史记录单例
#import "SearchMerchatResultController.h"//!商家搜索 结果页
#import "GoodsSearchViewController.h"//!商品搜索结果页
#import "CustomBarButtonItem.h"
#import "GUAAlertView.h"

@interface SearchMerhcantAndGoodController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{

    UIView * searchView;
    UITextField *  navSearchTextField;//!搜索的textfield
    UIButton * searchBtn;
    UIButton * selectTempBtn;
    
    UITableView * _tableView;
    
    //!历史搜索记录
    NSMutableArray * merchantHistoryArray;
    NSMutableArray * goodsHistoryArray;
    
    UIView * keyTapView;//!键盘弹起时的透明view
    BOOL isEditing;//!是否在输入状态下
    
    GUAAlertView * alerView;
    
    //!暂无数据的label
    UILabel * noDataLabel;
    
}


@property(nonatomic,assign)MerchantAndGoodSelectView * headerSelectView;

@end

@implementation SearchMerhcantAndGoodController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //!创建tableView
    [self createUI];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
    tap.cancelsTouchesInView = NO;
    [_tableView addGestureRecognizer:tap];
    
    
}
-(void)tapClick{

    if (keyTapView) {
        
        [keyTapView removeFromSuperview];
        keyTapView = nil;
        
    }
    [navSearchTextField resignFirstResponder];
    
    
}
-(void)viewWillAppear:(BOOL)animated{


    [super viewWillAppear:animated];

    //!导航
    [self createNav];
    
    //!读取历史
    [self readHistoryList];
    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];


}
-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    
    //!移除导航上的控件
    if (_headerSelectView) {
        
        [_headerSelectView removeFromSuperview];

    }
    
    if (navSearchTextField) {
        
        [navSearchTextField removeFromSuperview];

    }
    if (searchBtn) {
        
        [searchBtn removeFromSuperview];

    }
    
    if (searchView) {
        
        [searchView removeFromSuperview];

    }
    
    
    //!保存历史搜索记录
    [self saveSearchHistory];
    
    
}

-(void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    
    [navSearchTextField becomeFirstResponder];//!一进来就弹起键盘


}

#pragma mark 导航

-(void)createNav{

    //!左导航
//    [self addCustombackButtonItem];
    self.navigationItem.leftBarButtonItem = [[CustomBarButtonItem alloc]initWithCustomView:[CustomViews leftBackBtnMethod:@selector(backClick) target:self]];

    
    //!商家、商品分类切换view
    _headerSelectView = [[[NSBundle mainBundle]loadNibNamed:@"MerchantAndGoodSelectView" owner:self options:nil]lastObject];
    _headerSelectView.frame = CGRectMake(15+10 + 27, (self.navigationController.navigationBar.frame.size.height - _headerSelectView.frame.size.height/2)/2, _headerSelectView.frame.size.width, _headerSelectView.frame.size.height/2);//!先只显示一半
    
    
    [_headerSelectView setDataisFromMerchant:self.isSearchMerchant];//!设置按钮上面的数据，如果是从搜索商家传入yes
    [_headerSelectView setBackgroundColor:[UIColor clearColor]];
    
    _headerSelectView.changHightBlock = ^(BOOL isSelect){//!参数：是否点击按钮的标志（这个搜索界面没用到这个参数）
    
        CGFloat hight;
        if (_headerSelectView.frame.size.height >= 60) {//!展开的时候，现在要收起
            
            hight = _headerSelectView.frame.size.height/2;
            
            selectTempBtn.hidden = YES;
            
            
        }else{
        
            hight = _headerSelectView.frame.size.height*2;
            //!对这样的写法深深的致歉，现在实在没有找到办法如何解决 这个选中框第二个按钮不在nav 部分无法点中的问题 ，只好在展开的时候，显示一个透明的按钮在 下面
            
            if (!selectTempBtn) {
                
                selectTempBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                selectTempBtn.frame = CGRectMake(_headerSelectView.frame.origin.x, 0, _headerSelectView.firstBtn.frame.size.width, 30);
                [selectTempBtn setBackgroundColor:[UIColor clearColor]];
                [selectTempBtn addTarget:self action:@selector(tempBtnClick) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:selectTempBtn];
                
            }
            
            selectTempBtn.hidden = NO;
            
            
        }
        
        _headerSelectView.frame =CGRectMake(15+10 + 27, _headerSelectView.frame.origin.y, _headerSelectView.frame.size.width,hight);
    
        //!获取到第一个按钮的数据，判断是商家还是商品; 切换之后需要把textfield的内容情况
        if ([_headerSelectView.firstBtn.titleLabel.text isEqualToString:@"商家"]) {
            
            
            if (self.isSearchMerchant) {//!如果之前搜索的就是商家，textfield里面的内容不变,如果不是，要情况textfield的内容
                
                
            }else{
            
                self.isSearchMerchant = YES;
                navSearchTextField.placeholder = @"搜索商家";
                
                navSearchTextField.text = @"";
            }
            
            
            
        }else{
        
            if (self.isSearchMerchant == NO) {//!如果之前搜索的就是商品，textfield的内容不变,如果不是，要情况textfield的内容

                
                
                
            }else{
            
                self.isSearchMerchant = NO;
                navSearchTextField.placeholder = @"搜索商品";
                navSearchTextField.text = @"";
            }
          

        }
        
//        [_tableView reloadData];
        [self reloadDatas];
        
    };
    [self.navigationController.navigationBar addSubview:_headerSelectView];
    
    
    
    //!搜索框
    float searchWidth = self.navigationController.navigationBar.frame.size.width - CGRectGetMaxX(_headerSelectView.frame) - 6 - 7;
    
    searchView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_headerSelectView.frame) +6, _headerSelectView.frame.origin.y, searchWidth, _headerSelectView.frame.size.height)];
    [searchView setBackgroundColor:[UIColor colorWithHexValue:0xf0f0f0 alpha:1]];

    
    navSearchTextField = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, searchWidth - 10 - 26, searchView.frame.size.height)];//!10是距离前面的距离，20是后面搜索按钮的大小和按钮距离后面的距离

//    [navSearchTextField becomeFirstResponder];//!一进来就弹起键盘
    
    
    //!获取到第一个按钮的数据，判断是商家还是商品
    if ([_headerSelectView.firstBtn.titleLabel.text isEqualToString:@"商家"]) {
        
        navSearchTextField.placeholder = @"搜索商家";
        
    }else{
        
        navSearchTextField.placeholder = @"搜索商品";
    }
    
    [navSearchTextField setFont:[UIFont systemFontOfSize:13]];
    [navSearchTextField setBackgroundColor:[UIColor colorWithHexValue:0xf0f0f0 alpha:1]];
    navSearchTextField.delegate = self;
    navSearchTextField.returnKeyType = UIReturnKeySearch;
    [searchView addSubview:navSearchTextField];
    
    
    searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(searchView.frame.size.width - 26, (searchView.frame.size.height - 20)/2, 26, 20);
    [searchBtn setImage:[UIImage imageNamed:@"serchImage"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [searchView addSubview:searchBtn];
    
    
    [self.navigationController.navigationBar addSubview:searchView];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    

}
-(void)tempBtnClick{

    [_headerSelectView secondBtnClick];

}
- (void)backClick{
    
    DebugLog(@"搜索页面点击返回按钮");

    [self.navigationController popViewControllerAnimated:YES];
    
}
#pragma mark 创建界面
-(void)createUI{

    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height ) style:UITableViewStyleGrouped];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView setBackgroundColor:[UIColor whiteColor]];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    noDataLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    [noDataLabel setText:@"暂无商家历史搜索记录"];
    noDataLabel.textAlignment = NSTextAlignmentCenter;
    [noDataLabel setTextColor:[UIColor colorWithHexValue:0x999999 alpha:1]];
    [self.view addSubview:noDataLabel];
    
    noDataLabel.center = CGPointMake(self.view.center.x, self.view.center.y - self.navigationController.navigationBar.frame.size.height);
    noDataLabel.hidden = YES;

    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    //!搜索的是商家
    if (self.isSearchMerchant) {
        
        return merchantHistoryArray.count;
        
    }else{
        
        return goodsHistoryArray.count;
    
    }
    
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell ) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
        
        cell.textLabel.textColor = [UIColor colorWithHexValue:0x000000 alpha:1];
        [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
        
        //!分割线
        UILabel * filterLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 45 - 1, self.view.frame.size.width - 15, 0.5)];
        [filterLabel setBackgroundColor:[UIColor colorWithHexValue:0xc8c7cc alpha:1]];
        [cell.contentView addSubview:filterLabel];
        
        
    }

    //!搜索的是商家
    if (self.isSearchMerchant) {
       
        if (merchantHistoryArray.count) {
            
            cell.textLabel.text = merchantHistoryArray[indexPath.row];
         
            
            
        }else{
        
            cell.textLabel.text = @"";
        
        }
        
    }else{//!搜索的是商品
    
        if (goodsHistoryArray.count) {
            
            cell.textLabel.text = goodsHistoryArray[indexPath.row];
            
        }else{
            
            cell.textLabel.text = @"";
        
        }
    
    }
    
    

    return cell;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 45;

}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    //!历史搜索的view
    UIView * historyView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 45)];
    [historyView setBackgroundColor:[UIColor whiteColor]];
    
    
    UILabel * historyLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 100, historyView.frame.size.height)];
    historyLabel.text = @"历史搜索";
    [historyLabel setFont:[UIFont systemFontOfSize:14]];
    [historyLabel setTextColor:[UIColor colorWithHexValue:0x666666 alpha:1]];
    
    [historyView addSubview:historyLabel];
    
    
    //!分割线
    UILabel * filterLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, historyView.frame.size.height - 0.5, historyView.frame.size.width - 15, 0.5)];
    [filterLabel setBackgroundColor:[UIColor colorWithHexValue:0xc8c7cc alpha:1]];
    [historyView addSubview:filterLabel];
    
    
    return historyView;

}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 45;

}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80)];
    [footerView setBackgroundColor:[UIColor whiteColor]];

    if ((self.isSearchMerchant && merchantHistoryArray.count) || (!self.isSearchMerchant && goodsHistoryArray.count) ) {//!有搜索记录的时候显示清除按钮
        
        UIButton * clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        clearBtn.frame = CGRectMake(0, 0, 110, 40);
        [clearBtn setTitle:@"清  除" forState:UIControlStateNormal];
        [clearBtn setTitleColor:[UIColor colorWithHexValue:0xfd4f57 alpha:1] forState:UIControlStateNormal];
        clearBtn.layer.cornerRadius = 2;
        clearBtn.layer.masksToBounds = YES;
        clearBtn.layer.borderWidth = 0.5;
        clearBtn.layer.borderColor = [UIColor colorWithHexValue:0xfd4f57 alpha:1].CGColor;
        clearBtn.center = footerView.center;
        [clearBtn addTarget:self action:@selector(clearBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:clearBtn];
    }
    
    
    return footerView;

}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 80;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell * selectCell = [tableView cellForRowAtIndexPath:indexPath];
    
    [self searchInfo:selectCell.textLabel.text isFromSelect:YES];
    

}
#pragma mark 搜索按钮
-(void)searchBtnClick{
    
    if (isEditing) {//!输入状态下点击按钮，是删除文字功能
        
        navSearchTextField.text = @"";
        
    }else{//!非输入状态下点击按钮是搜索功能
    
        [self searchInfo:navSearchTextField.text isFromSelect:NO];

    
    }
    
    
}


#pragma mark textfield delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{

    
    //!搜索
    [self searchInfo:navSearchTextField.text isFromSelect:NO];
    
    return YES;
    
}
-(void)searchInfo:(NSString *)searchText isFromSelect:(BOOL)fromSelect{

    //!先让按钮失效
    [self putSearchBtnEnable];
    
    [navSearchTextField resignFirstResponder];

    //!获取去除空格后的长度，如果长度>0,搜索 并保存到数组里面
    NSString * repalceStr = [searchText stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (!repalceStr.length) {
        
        [self.view makeMessage:@"请输入搜索内容" duration:1.0 position:@"center"];
        
        //!让按钮恢复
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(putSearchBtnEnable) userInfo:nil repeats:NO];
        
        
        return;
    }
    
    //!从点击进入的，就不放到数组里面
    if (!fromSelect) {
        
        //!1、保存到数组
        if (self.isSearchMerchant) {//!搜索的是商家
            
            //!变量查看数组中是否存在这个搜索的内容，如果存在就把以前的移除掉，重新放到数组的第一位
            NSString * nowStr = [searchText stringByReplacingOccurrencesOfString:@" " withString:@""];
            
            for (int i = 0; i < merchantHistoryArray.count; i++) {
                
                NSString * arrStr = [merchantHistoryArray[i] stringByReplacingOccurrencesOfString:@" " withString:@""];
                
                if ([nowStr isEqualToString:arrStr]) {//!存在数组中，移除掉
                    
                    [merchantHistoryArray removeObjectAtIndex:i];
                    
                    break;
                    
                }

                
            }
            //!把数据放到第一位
            [merchantHistoryArray insertObject:searchText atIndex:0];
            
            if (merchantHistoryArray.count >10) {
                
                [merchantHistoryArray removeLastObject];
            }
            
            
        }else{//!搜索的是商品
            
            //!变量查看数组中是否存在这个搜索的内容，如果不存在就放到数组里面,存在就移除后再放到数组
            NSString * nowStr = [searchText stringByReplacingOccurrencesOfString:@" " withString:@""];
            
            for (int i = 0; i<goodsHistoryArray.count; i++) {
                
                NSString * arrStr = [goodsHistoryArray[i] stringByReplacingOccurrencesOfString:@" " withString:@""];
                
                if ([nowStr isEqualToString:arrStr]) {
                    
                    [goodsHistoryArray removeObjectAtIndex:i];
                    break;
                }
                
            }
            [goodsHistoryArray insertObject:searchText atIndex:0];
            if (goodsHistoryArray.count >10) {
                
                [goodsHistoryArray removeLastObject];
            }
           
            
        }
//        [_tableView reloadData];
        [self reloadDatas];

        
    }
    
    //!让按钮恢复
    [self putSearchBtnEnable];
    
    //2、请求数据
    if (self.isSearchMerchant) {//!搜索的是商家
        
        SearchMerchatResultController * merchantResultVC = [[SearchMerchatResultController alloc]init];
        merchantResultVC.searchContent = searchText;
        merchantResultVC.isSearchMerchant = YES;
        
        merchantResultVC.isSearchMerchantBlock = ^(BOOL isMerchant){
        
            self.isSearchMerchant = isMerchant;
        
        };
        
        [self.navigationController pushViewController:merchantResultVC animated:YES];
        
    }else{
    
        GoodsSearchViewController * searchVC = [[GoodsSearchViewController alloc]init];
        searchVC.searchContent = searchText;
        
        searchVC.isSearchMerchantBlock = ^(BOOL isMerchant){
        
            self.isSearchMerchant = isMerchant;
            
        };
        [self.navigationController pushViewController:searchVC animated:YES];
    
    
    }
    

}
//!点击的时候按钮失效，提示框弹出完成后完成
-(void)putSearchBtnEnable{

    searchBtn.enabled = !searchBtn.enabled;

}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{

    //!弹起键盘时候的透明view  点击透明view，键盘收回
    if (!keyTapView) {
        
        keyTapView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [keyTapView setBackgroundColor:[UIColor clearColor]];
        
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
        [keyTapView addGestureRecognizer:tapGesture];
        
        [self.view addSubview:keyTapView];
    }
    
    //!输入状态下，按钮的为删除按钮
    [searchBtn setImage:[UIImage imageNamed:@"searchDelete"] forState:UIControlStateNormal];
    isEditing = YES;//!标记为在输入状态下
    
    return YES;

    
}


-(void)textFieldDidEndEditing:(UITextField *)textField{

    
    //!不刷新的状态下，按钮为搜索按钮
    [searchBtn setImage:[UIImage imageNamed:@"serchImage"] forState:UIControlStateNormal];
    isEditing = NO;//!标记为不在输入状态下

    
    //!去除键盘，去除透明的view
    
    [self tapClick];
    
}


#pragma mark 读取历史搜索记录
-(void)readHistoryList{

    SearchHistoryDefaults * historyDefautlts = [SearchHistoryDefaults shareManager];
    [historyDefautlts readHistoryInfo];//!读取历史数据
   
    
    merchantHistoryArray = historyDefautlts.merchantHistoryArray;
    goodsHistoryArray = historyDefautlts.goodsHistoryArray;
    
//    [_tableView reloadData];
    [self reloadDatas];

    
}

#pragma mark 保存历史搜索记录
-(void)saveSearchHistory{

    SearchHistoryDefaults * historyDefautlts = [SearchHistoryDefaults shareManager];
    
    historyDefautlts.merchantHistoryArray = merchantHistoryArray;
    historyDefautlts.goodsHistoryArray = goodsHistoryArray;
  
    [historyDefautlts history_Save];
    
    
}
#pragma mark 清除搜索历史记录
-(void)clearBtnClick{
    
  
    if (self.isSearchMerchant) {//!搜索的是商家
        
        if (!merchantHistoryArray || merchantHistoryArray.count == 0) {
            
            [self.view makeMessage:@"暂无商家历史搜索记录" duration:2.0 position:@"center"];
            
            return;
        }
        
    }else{//!搜索的是商品
    
        if (!goodsHistoryArray || goodsHistoryArray.count == 0) {
            
            
            [self.view makeMessage:@"暂无商品历史搜索记录" duration:2.0 position:@"center"];
            
            return;
            
            
        }
    
    
    
    }
    
    
    if (alerView) {
        
        [alerView removeFromSuperview];
        
    }
    
    __weak SearchMerhcantAndGoodController * searchVC = self;
    alerView = [GUAAlertView alertViewWithTitle:nil withTitleClor:nil message:@"确认要删除搜索历史吗？" withMessageColor:nil oKButtonTitle:@"确定" withOkButtonColor:nil cancelButtonTitle:@"取消" withOkCancelColor:nil withView:self.view  buttonTouchedAction:^{
        
        [searchVC clearSearchHistory];
        
    } dismissAction:nil];
    
    [alerView show];
    

}
-(void)clearSearchHistory{

    SearchHistoryDefaults * historyDefautlts = [SearchHistoryDefaults shareManager];

    if (self.isSearchMerchant) {//!搜索的是商家
        
        [historyDefautlts clearMerchantSeatchHistory];
        
        [merchantHistoryArray removeAllObjects];
        
    }else{
    
        [historyDefautlts clearGoodsSeatchHistory];
        
        [goodsHistoryArray removeAllObjects];
    }
    
    
//    [_tableView reloadData];
    
    [self reloadDatas];

}

-(void)reloadDatas{

    [_tableView reloadData];
    
    if (self.isSearchMerchant && merchantHistoryArray.count == 0) {
        
        [noDataLabel setText:@"暂无商家历史搜索记录"];
        noDataLabel.hidden = NO;
        [self.view bringSubviewToFront:noDataLabel];
    
    }else if(!self.isSearchMerchant && goodsHistoryArray.count == 0){
    
        [noDataLabel setText:@"暂无商品历史搜索记录"];
        noDataLabel.hidden = NO;
        [self.view bringSubviewToFront:noDataLabel];

    }else{
    
        noDataLabel.hidden = YES;

    }

    


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
