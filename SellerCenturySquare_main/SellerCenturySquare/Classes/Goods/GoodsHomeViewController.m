//
//  GoodsHomeViewController.m
//  SellerCenturySquare
//
//  Created by 左键视觉 on 16/6/17.
//  Copyright © 2016年 pactera. All rights reserved.
// ！！！！！！！!剩下 请求数据，把数据放到里面

#import "GoodsHomeViewController.h"
#import "GoodsManageTableViewCell.h"
#import "AudiAndFilterTableViewCell.h"//!审核及筛选cell
#import "ManageGoodsViewController.h"//!商品管理页面
#import "HttpManager.h"
#import "GoodsMainDTO.h"//!主页信息的dto
#import "MyUserDefault.h"
#import "RDVTabBarItem.h"
#import "GoodsShareViewController.h"
//零售商品参考图
#import "GoodReferenceViewController.h"
@interface GoodsHomeViewController ()<UITableViewDelegate,UITableViewDataSource>
{

    UITableView * _tableView;
    
    //!主页信息的dto
    GoodsMainDTO * goodsMainDTO;
    
    
}
@end

@implementation GoodsHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"商品";
    
    //!创建界面
    [self createUI];
    
    
    // !如果是子账号 就不进去请求
    if ([self isNotMatser]) {
        
        return ;
        
    }
}
-(void)viewWillAppear:(BOOL)animated{


    [super viewWillAppear:animated];
    
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
    
    
    // !如果是子账号 就提示无权查看
    if ([self isNotMatser]) {
        
        [self.view makeMessage:@"您暂无商品管理权力" duration:2.0f position:@"center"];
        
        [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(changeSelectVc) userInfo:nil repeats:NO];
        
        return;
        
    }
    

    //!如果有新上架的商品 去除本地标志以及tabbar的提示
    if ([MyUserDefault defaultLoad_upGoods]) {
        
        [MyUserDefault removeUpGoods];
        
        // !移除bage
        RDVTabBarItem * barItem = [self rdv_tabBarItem] ;
        
        barItem.badgeValue = @"";
        
    }
    
    
    //!请求数据
    [self requestData];
    
 
}
#pragma mark 判断是否是子账号
- (BOOL)isNotMatser{
    
    NSString * isMaster = [MyUserDefault JudgeUserAccount];
    
    // !(0/YES:主账户 1/NO:子账户)
    if ([isMaster isKindOfClass:[NSString class]] && isMaster != nil) {
        
        // !如果是子账号登录，则返回上一次点击index
        if ([isMaster isEqualToString:@"1"]) {
            
            return YES;
            
        }
        
        
    }
    
    return NO;
    
}
// !当用户无权利查看时，返回上一个选择的界面
- (void)changeSelectVc{
    
    // !当前选中的tabbar是商品
    if (self.rdv_tabBarController.selectedIndex == 4) {
        
        [self.rdv_tabBarController setSelectedIndex:self.rdv_tabBarController.lastSelectedIndex];
        
    }
    
}
#pragma mark 创建界面
-(void)createUI{


    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setBackgroundColor:[UIColor colorWithHex:0xefeff4]];
    [self.view addSubview:_tableView];
    
    //!让cell自适应高度
    _tableView.estimatedRowHeight = 44.0;
    _tableView.rowHeight = UITableViewAutomaticDimension;


    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 1;

}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 3;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    
    //!第0行
    if (!indexPath.section) {
        
        GoodsManageTableViewCell * managerCell = [[[NSBundle mainBundle]loadNibNamed:@"GoodsManageTableViewCell" owner:nil options:nil]lastObject];
        
        [managerCell configData:goodsMainDTO];
        
        
        managerCell.intGoodsManageVC = ^(int selectType){
        
            
            //!批发_在售:1； 零售_在售：2； 新发布:3； 全部_在售：4；
            [self intoGoodsMangageVC:selectType];
            
        
        };
        
        return managerCell;
        
        
    }else if (indexPath.section == 1){
    
        AudiAndFilterTableViewCell * audiCell = [[[NSBundle mainBundle]loadNibNamed:@"AudiAndFilterTableViewCell" owner:nil options:nil]lastObject];
        
        
        [audiCell configWithFilter:NO withNum:[goodsMainDTO.pendingAuditNum integerValue]];
        
        
        return audiCell;
    
    }else{
    
        AudiAndFilterTableViewCell * filterCell = [[[NSBundle mainBundle]loadNibNamed:@"AudiAndFilterTableViewCell" owner:nil options:nil]lastObject];
        
        [filterCell configWithFilter:YES withNum:[goodsMainDTO.newsRefPicNum integerValue]];

        return filterCell;
    
    
    }
    
    

}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 0.00001;

}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 10;

}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 10)];
    [footerView setBackgroundColor:[UIColor colorWithHex:0xefeff4]];
    
    return footerView;
    

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (!indexPath.section) {//管理商品页面
        
        [self intoGoodsMangageVC:4];
        
    }else if(indexPath.section == 1){
        GoodsShareViewController *shareMore = [[GoodsShareViewController alloc] initWithNibName:@"GoodsShareViewController" bundle:nil];
        [self.navigationController pushViewController:shareMore animated:YES];
    }else if (indexPath.section == 2)
    {
        
        GoodReferenceViewController * reference = [[GoodReferenceViewController alloc]initWithNibName:@"GoodReferenceViewController" bundle:nil];
    
        [self.navigationController pushViewController:reference animated:YES];
    
    }
    
}

//!点击各个按钮的时候会传入这些对应的值，进入商品列表传入的值可以后期根据 后台订的值修改传入什么！！！！！！！！！！

//!批发_在售:1； 零售_在售：2； 新发布:3； 全部_在售：4；
-(void)intoGoodsMangageVC:(int)selectType{

    ManageGoodsViewController * managerGoodsVC = [[ManageGoodsViewController alloc]init];
    
   //!ManageGoodsViewController:销售渠道 -1 全部； 0 批发； 1 零售 ；2批发和零售
    
    if (selectType == 1) {//!批发_在售
        
        managerGoodsVC.type = @"0";
        
    }else if (selectType == 2){//!零售_在售
    
        managerGoodsVC.type = @"1";
    
    }else{//!全部_在售、新发布 的时候， 看 全部_在售
    
        managerGoodsVC.type = @"-1";
        
    }
    
    //!进入 新发布
    if (selectType == 3) {
        
        managerGoodsVC.isIntoNews = YES;
        
    }
    
    
    [self.navigationController pushViewController:managerGoodsVC animated:YES];
    
    
}


#pragma mark 请求数据
-(void)requestData{
    
    [HttpManager sendHttpRequestForGoodsMainSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *responseDic =  [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([responseDic[@"code"] isEqualToString:@"000"]) {
        
            goodsMainDTO = [[GoodsMainDTO alloc]initWithDictionary:responseDic[@"data"]];
            
            [_tableView reloadData];
        
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       
        
        
    }];


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
