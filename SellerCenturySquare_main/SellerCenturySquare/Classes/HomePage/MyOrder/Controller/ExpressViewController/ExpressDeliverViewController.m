//
//  ExpressDeliverViewController.m
//  SellerCenturySquare
//
//  Created by 左键视觉 on 16/3/26.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "ExpressDeliverViewController.h"
#import "SelectExpressViewCell.h"//!选择快递公司 cell
#import "WriteExpressNoViewCell.h"//!填写采购单号 cell
#import "SelectExpressViewController.h"//!选择快递公司
#import "GUAAlertView.h"

@interface ExpressDeliverViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UITableView * _tableView;
    
    SelectExpressViewCell * selectCell;
    WriteExpressNoViewCell * writeCell;
    
    NSDictionary * selectCompanyDic;
    
    GUAAlertView * alertView;
}
@end

@implementation ExpressDeliverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    //!创建导航
    [self createNav];
    
    //!创建tableView
    [self createUI];
    
    
}
-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    

}
#pragma mark 创建导航
-(void)createNav{

    //!左导航
    [self customBackBarButton];
    
    self.title = @"录入快递单发货";
    
    [self.view setBackgroundColor:[UIColor colorWithHex:0xefeff4 alpha:1]];
    
    

}
#pragma mark 创建tableView
-(void)createUI{

    //!tableView
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height - 54 ) style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setBackgroundColor:[UIColor colorWithHex:0xefeff4 alpha:1]];
    [self.view addSubview:_tableView];

    //!轻击收起键盘的手势
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
    tapGesture.cancelsTouchesInView = NO;
    [_tableView addGestureRecognizer:tapGesture];
    
    //!确定发货按钮
    UIButton * sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sendBtn.frame = CGRectMake(0, self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height - 20 - 54, self.view.frame.size.width, 54) ;
    
    [sendBtn setTitle:@"确定发货" forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendBtn setBackgroundColor:[UIColor blackColor]];
    [sendBtn addTarget:self action:@selector(sendBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendBtn];
    
}
-(void)tapClick{

    [self.view endEditing:YES];

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 2;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    //!选择快递公司
    if (indexPath.row == 0) {
        
        selectCell = [[[NSBundle mainBundle]loadNibNamed:@"SelectExpressViewCell" owner:nil options:nil]lastObject];
        
        return selectCell;
    
    }else{//!填写采购单号
    
        writeCell = [[[NSBundle mainBundle]loadNibNamed:@"WriteExpressNoViewCell" owner:nil options:nil]lastObject];
        writeCell.expressNoTextFiled.delegate = self;
        writeCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return writeCell;
    
    }
    


}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    //!选择快递公司
    if (indexPath.row == 0) {
        
        return 45;
        
    }else{//!填写采购单号
                
        return 66;
        
    }


}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    
    [footerView setBackgroundColor:[UIColor colorWithHex:0xefeff4 alpha:1]];
    
    return footerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 0.00001;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //!去除点击效果
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SelectExpressViewController * selectExpressVC = [[SelectExpressViewController alloc]init];
    
    selectExpressVC.selectBlock = ^(NSMutableDictionary * companyDic){
    
        selectCompanyDic = companyDic;
        
        selectCell.expressNameLabel.text = selectCompanyDic[@"companyName"];
        
        
    };
    
    
    [self.navigationController pushViewController:selectExpressVC animated:YES];
   

}





#pragma mark 确定发货
-(void)sendBtnClick{
    
    
    if (!selectCompanyDic) {
        
        [self.view makeMessage:@"请选择快递公司" duration:2.0 position:@"center"];

        return;
    }

    NSString * expressNo = writeCell.expressNoTextFiled.text;
    if (expressNo.length == 0 ) {
        
        [self.view makeMessage:@"请输入快递单号" duration:2.0 position:@"center"];
        
        return;
    }else if (expressNo.length >100){
    
        [self.view makeMessage:@"已输入的快递公司和单号有误，请重新输入！" duration:2.0 position:@"center"];
        
        return;
    }
    
    
    if (alertView) {
        
        [alertView removeFromSuperview];
    
    }

    NSString * expressName = [NSString stringWithFormat:@"快递公司:%@\n快递单号：%@",selectCompanyDic[@"companyName"],writeCell.expressNoTextFiled.text];
    
    alertView = [GUAAlertView alertViewWithTitle:@"确定发货？" withTitleClor:nil message:expressName withMessageColor:nil oKButtonTitle:@"确定" withOkButtonColor:nil cancelButtonTitle:@"取消" withOkCancelColor:nil withView:self.view buttonTouchedAction:^{
        
        [MBProgressHUD showHUDAddedTo:self.view  animated:YES];
        
        [HttpManager sendHttpRequestForOrderDeliverOrderCodes:self.orderCode type:@"2" picUrl:@"" logisticTrackNo:writeCell.expressNoTextFiled.text logisticCode:selectCompanyDic[@"companyCode"] logisticName:selectCompanyDic[@"companyName"] success:^(AFHTTPRequestOperation *operation, id responseObject) {
           
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            if ([dict[@"code"] isEqualToString:@"000"]) {
                
                [self.view makeMessage:@"发货完成" duration:2.0 position:@"center"];
                
                //!两秒后pop后原来的界面
                [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(popVC) userInfo:nil repeats:NO];
                
                if (self.takeExpressSuccessBlock) {
                    
                    self.takeExpressSuccessBlock();
                    
                }
                
                
            }else{
            
                [self.view makeMessage:dict[ERRORMESSAGE] duration:2.0 position:@"center"];
            
            }
            
        
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.view makeMessage:@"加载失败，目前的网络不顺畅!请检查手机是否联网。" duration:2.0 position:@"center"];

        
        }];
        
        
    } dismissAction:nil];
    
    [alertView show];

}
-(void)popVC{

    [self.navigationController popViewControllerAnimated:YES];


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
