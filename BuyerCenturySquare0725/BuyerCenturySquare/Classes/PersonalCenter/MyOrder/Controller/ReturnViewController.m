//
//  ReturnViewController.m
//  BuyerCenturySquare
//
//  Created by 左键视觉 on 16/5/23.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "ReturnViewController.h"
#import "ReturnTableViewCell.h"
#import "ReturnApplyViewController.h"//!退换货申请vc

static float hight = 77;

@interface ReturnViewController ()<UITableViewDelegate,UITableViewDataSource>
{

    UITableView * _selectTableView;
    
    NSArray * titleArray;
    NSArray * detailArray;

}
@end

@implementation ReturnViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //!导航
    [self createNav];

    titleArray = @[@"退货退款",@"仅退款",@"换货"];
    
    detailArray = @[@"已收到货，需退还已收到的货物并退款",@"未收到货，或与商家协商同意后进行退款",@"与商家协商换货"];
    
    //!创建界面
    [self makeUI];
    
    //!隐藏tabbar
    [[self rdv_tabBarController] setTabBarHidden:YES];

    
}
#pragma mark 导航
-(void)createNav{

    self.title = @"退/换货";

    //!返回键
    [self addCustombackButtonItem];

}
#pragma mark 创建界面
-(void)makeUI{

    
    _selectTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, hight * 3) style:UITableViewStylePlain];
    _selectTableView.delegate = self;
    _selectTableView.dataSource = self;
    _selectTableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_selectTableView];

    
    [self.view setBackgroundColor:[UIColor colorWithHexValue:0xefeff4 alpha:1]];
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 3;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return hight;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{


    ReturnTableViewCell * cell = [[[NSBundle mainBundle]loadNibNamed:@"ReturnTableViewCell" owner:self options:nil]lastObject];
    cell.titleLabel.text = titleArray[indexPath.row];
    
    cell.detailLabel.text = detailArray[indexPath.row];

    
    return cell;
    

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    ReturnApplyViewController * appleVC = [[ReturnApplyViewController alloc]init];
    appleVC.refundType = [NSString stringWithFormat:@"%ld",(long)indexPath.row];//!选中第几行传入
    appleVC.orderDetailInfo = self.orderDetailInfo;
    [self.navigationController pushViewController:appleVC animated:YES];
    
    

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
