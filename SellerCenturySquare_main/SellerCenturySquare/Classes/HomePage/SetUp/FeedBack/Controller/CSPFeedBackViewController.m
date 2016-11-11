//
//  CSPFeedBackViewController.m
//  SellerCenturySquare
//
//  Created by clz on 15/9/25.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CSPFeedBackViewController.h"
#import "CSPFeedBackTableViewCell.h"
#import "CSPFeedBackTypeView.h"
#import "CSPFeedBackTypeDTO.h"
#import "GUAAlertView.h"

@interface CSPFeedBackViewController ()<UITextViewDelegate,UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong,nonatomic)NSMutableArray *feedBackArray;

@end

@implementation CSPFeedBackViewController{
    
    CSPFeedBackTypeDTO *_feedBackTypeDTO;
    
    BOOL _isSubmitSuccess;
    
    
    GUAAlertView * noTypeAlert;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *rightButtonItem = [self barButtonWithtTitle:@"提交" font:[UIFont systemFontOfSize:13]];
    if (rightButtonItem) {
        self.navigationItem.rightBarButtonItem = rightButtonItem;
    }
    
    //默认值
    _feedBackTypeDTO = [[CSPFeedBackTypeDTO alloc]init];
    _feedBackTypeDTO.typeName = @"询单";
    _feedBackTypeDTO.type = @"7";
    
    [self initArray];
    
    self.progressHUD.delegate = self;
    
    
    // !左按钮
    [self customBackBarButton];
    
    //!添加 点击其他地方收起键盘事件
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    //不加会屏蔽到TableView的点击事件等
    tapGr.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:tapGr];
    
    
}
-(void)hideKeyboard{
    
    [self.view endEditing:YES];
    
    
    
    
}

- (void)customBackBarButton{
    
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"04_商家中心_设置_后退"] style:UIBarButtonItemStylePlain target:self action:@selector(backBarButtonClick:)];
    
    self.navigationItem.leftBarButtonItem = backBarButton;
    
}

- (void)backBarButtonClick:(UIBarButtonItem *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initArray{
    
    self.feedBackArray = [[NSMutableArray alloc]init];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self requestFeedBackType];
    
    //需要加载反馈类型
    
    
}

#pragma mark-加载反馈类型
- (void)requestFeedBackType{
    
    [self progressHUDShowWithString:@"加载反馈类型"];
    
    [HttpManager sendHttpRequestFeedBackTypeSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self.progressHUD hide:YES];
        
        NSDictionary *responseDic = [self conversionWithData:responseObject];
        
        DebugLog(@"responseDic = %@", responseDic);
        
        if ([self isRequestSuccessWithCode:[responseDic objectForKey:CODE]]) {
            
            [self.feedBackArray removeAllObjects];
            
            id data = [responseDic objectForKey:@"data"];
            
            if ([self checkData:data class:[NSArray class]]) {
                
                for (NSDictionary *dic in data) {
                    
                    CSPFeedBackTypeDTO *feedBackTypeDTO = [[CSPFeedBackTypeDTO alloc]init];
                    
                    [feedBackTypeDTO setDictFrom:dic];
                    
                    [self.feedBackArray addObject:feedBackTypeDTO];
                }
            }
            
        }else{
            
            [self alertViewWithTitle:@"提交失败" message:[responseDic objectForKey:ERRORMESSAGE]];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self tipRequestFailureWithErrorCode:error.code];

    }];
    
}

#pragma mark-提交意见反馈
- (void)submitFeedBack{
    
    [self progressHUDShowWithString:@"提交中"];
    
    CSPFeedBackTableViewCell *cell = (CSPFeedBackTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    
    NSString *content = cell.feedBackTextView.text;
    
    DebugLog(@"--------->feedBackType = %@,content = %@", _feedBackTypeDTO.type,content);
    
    if (content.length<1 || [content isEqualToString:@"您遇到什么问题，或者哪些功能建议，欢迎在此提出！我们将持续跟进优化。"]) {
        
        [self progressHUDHiddenWidthString:@"反馈内容不能为空"];
        
        return;
    }
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    [HttpManager sendHttpRequestForGetMerchantAddFeedback:_feedBackTypeDTO.type content:content success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *responseDic = [self conversionWithData:responseObject];
        
        DebugLog(@"responseDic = %@", responseDic);
        
        if ([self isRequestSuccessWithCode:[responseDic objectForKey:CODE]]) {
            
            _isSubmitSuccess = YES;
            
            [self progressHUDHiddenTipSuccessWithString:@"提交成功"];
        
        }else{
            
            [self.progressHUD hide:YES];

            
            [self alertViewWithTitle:@"提交失败" message:[responseDic objectForKey:ERRORMESSAGE]];

            self.navigationItem.rightBarButtonItem.enabled = YES;
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self tipRequestFailureWithErrorCode:error.code];
        
        self.navigationItem.rightBarButtonItem.enabled = YES;

    }];
}

#pragma mark-
#pragma mark-提交
- (void)rightButtonClick:(UIButton *)sender{
    
    [self receiveKeyboard];
    
    [self submitFeedBack];
}

#pragma mark-
#pragma mark-UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CSPFeedBackTableViewCell *cell;
    
    if (indexPath.section == 0) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"CSPFeedBackViewControllerCellID0"];
        
        cell.feedBackTypeLabel.text = _feedBackTypeDTO.typeName;
        
    }else if (indexPath.section == 1){
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"CSPFeedBackViewControllerCellID1"];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        
        return 44.0f;
        
    }else if (indexPath.section == 1){
        
        return 135.0f;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.01f;
    }else{
        return 5.0f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    if (indexPath.row == 0) {
        
        if (!self.feedBackArray.count) {
            
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"反馈类型加载失败，请求重新加载" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//            
//            [alert show];
            
            if (noTypeAlert) {
                
                [noTypeAlert removeFromSuperview];
                
            }
            
            noTypeAlert = [GUAAlertView alertViewWithTitle:@"提示" withTitleClor:nil message:@"反馈类型加载失败，请求重新加载" withMessageColor:nil oKButtonTitle:@"确定" withOkButtonColor:nil cancelButtonTitle:@"取消" withOkCancelColor:nil withView:self.view buttonTouchedAction:^{
                
                [self requestFeedBackType];

                
            } dismissAction:^{
                
                
            }];
            
            [noTypeAlert show];

            
            return;
        }
        
        CSPFeedBackTypeView *feedBackTypeView = [[[NSBundle mainBundle]loadNibNamed:@"CSPFeedBackTypeView" owner:self options:nil]firstObject];
        
        [feedBackTypeView setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,  [UIScreen mainScreen].bounds.size.height)];
        
        feedBackTypeView.feedBackType = _feedBackTypeDTO;
        
        feedBackTypeView.feedBackTypeArray = self.feedBackArray;
        
        [feedBackTypeView reloadUI];
        
        feedBackTypeView.confirmBlock = ^(CSPFeedBackTypeDTO *feedBackTypeDTO){
            
            _feedBackTypeDTO = feedBackTypeDTO;
            
            [self.tableView reloadData];
        
        };
        
        [self.view addSubview:feedBackTypeView];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self receiveKeyboard];
    
}

- (void)receiveKeyboard{
    
    CSPFeedBackTableViewCell *cell = (CSPFeedBackTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    
    [cell.feedBackTextView resignFirstResponder];

}

#pragma mark-
#pragma mark-MBProgressHUDDelegate
- (void)hudWasHidden:(MBProgressHUD *)hud{
    
    if (_isSubmitSuccess) {
        
        self.navigationItem.rightBarButtonItem.enabled = YES;

        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

#pragma mark-
#pragma mark-UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex) {
        
        [self requestFeedBackType];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
