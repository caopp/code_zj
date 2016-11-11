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
#import "FeedbackTypePickerView.h"
# define Time 0.5

@interface CSPFeedBackViewController ()<UITextViewDelegate,UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate,UIAlertViewDelegate>
{
    FeedbackTypePickerView *feedbackTypePicker;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong,nonatomic)NSMutableArray *feedBackArray;

@end

@implementation CSPFeedBackViewController{
    
    CSPFeedBackTypeDTO *_feedBackTypeDTO;
    
    BOOL _isSubmitSuccess;
    
    GUAAlertView *numAlertView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addCustombackButtonItem];
    
    self.title = NSLocalizedString(@"feedType", @"意见反馈");
    
    UIBarButtonItem *rightButtonItem = [self barButtonWithtTitle:NSLocalizedString(@"submit",  @"提交")  font:[UIFont systemFontOfSize:13]];
    if (rightButtonItem) {
        self.navigationItem.rightBarButtonItem = rightButtonItem;
    }
    
    
    //默认值
    _feedBackTypeDTO = [[CSPFeedBackTypeDTO alloc]init];
    _feedBackTypeDTO.typeName = @"购买支付";
    _feedBackTypeDTO.type = @"2";
    
    [self initArray];
    
    self.progressHUD.delegate = self;
    
//    //进行加载选择视图
//    feedbackTypePicker = [[[NSBundle mainBundle]loadNibNamed:@"FeedbackTypePickerView" owner:self options:nil]lastObject];
//    feedbackTypePicker.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 300);
//    [self.view addSubview:feedbackTypePicker];
//
//    //进行手势添加
//    
//    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addGesture:)];
//    tapGesture.cancelsTouchesInView = YES;
//    [self.view addGestureRecognizer:tapGesture];
//    
}
//添加手势
-(void)addGesture:(UITapGestureRecognizer *)gesture
{
    
    NSLog(@"gesture === %d",gesture.enabled);
    
////    编辑结束
//    [self.view endEditing:YES];
//    进行动画展示
    [UIView animateWithDuration:0.5 animations:^{
        feedbackTypePicker.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT + 115);
    }];

    
}

- (void)initArray{
    
    self.feedBackArray = [[NSMutableArray alloc]init];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
     [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
    [self requestFeedBackType];
    
}


#pragma mark-加载反馈类型
- (void)requestFeedBackType{
    
    [self progressHUDShowWithString:NSLocalizedString(@"getFeedType", @"加载反馈类型")];
    
    [HttpManager sendHttpRequestFeedBackTypeSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self.progressHUD hide:YES];
        
        NSDictionary *responseDic = [self conversionWithData:responseObject];
                
        if ([self isRequestSuccessWithCode:[responseDic objectForKey:@"code"]]) {
            
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
            
            [self alertViewWithTitle:@"加载失败" message:[responseDic objectForKey:@"errorMessage"]];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self.progressHUD hide:YES];

    }];

    
}

#pragma mark-提交意见反馈
- (void)submitFeedBack{
    
    [self progressHUDShowWithString:@"提交中"];
    
    CSPFeedBackTableViewCell *cell = (CSPFeedBackTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    
    NSString *content = cell.feedBackTextView.text;
    
    NSString *alertStr = NSLocalizedString(@"feedAlert", @"您遇到什么问题，或者哪些功能建议，欢迎在此提出！我们将持续跟进优化。");
    
    if (content.length<1 || [content isEqualToString:alertStr]) {
        
        [self progressHUDHiddenWidthString:NSLocalizedString(@"contentNil", @"反馈内容不能为空")];
        
        return;
        
    }
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    [HttpManager sendHttpRequestForaddFeedback:_feedBackTypeDTO.type content:content success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *responseDic = [self conversionWithData:responseObject];
                
        if ([self isRequestSuccessWithCode:[responseDic objectForKey:@"code"]]) {
            
            _isSubmitSuccess = YES;
            
            [self progressHUDHiddenTipSuccessWithString:NSLocalizedString(@"feedSucceed", @"反馈成功")];
        
        }else{
            
            [self.progressHUD hide:YES];

            
            [self alertViewWithTitle:@"提交失败" message:[responseDic objectForKey:@"errorMessage"]];

            self.navigationItem.rightBarButtonItem.enabled = YES;

        }
        

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self progressHUDHiddenTipSuccessWithString:@"反馈失败"];
       
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
        cell.alertBlock = ^(){
        
            
            if (numAlertView) {
                
                [numAlertView removeFromSuperview];
                
            }
            [self.view endEditing:YES];
            
            numAlertView = [GUAAlertView alertViewWithTitle:@"提示" withTitleClor:nil message:@"不可以超过200字" withMessageColor:nil oKButtonTitle:@"确定" withOkButtonColor:nil cancelButtonTitle:nil withOkCancelColor:nil withView:self.view buttonTouchedAction:^{
                
            } dismissAction:nil];
            
            [numAlertView show];
        
        };
        
        
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
    
    if (indexPath.row == 0 && indexPath.section == 0) {
        
        [self.view endEditing:YES];
        
        if (!self.feedBackArray.count) {
            
            
            GUAAlertView *al=[GUAAlertView alertViewWithTitle:@"提示" withTitleClor:nil message:@"反馈类型加载失败，请求重新加载" withMessageColor:nil oKButtonTitle:@"确定" withOkButtonColor:nil cancelButtonTitle:@"取消" withOkCancelColor:nil withView:self.view buttonTouchedAction:^{
                // !确定
                [self requestFeedBackType];
                
            } dismissAction:^{
                // !取消

            }];
            
            //2、显示
            [al show];
            
            return;
        }
        
        
//        //进行动画展示
//        [UIView animateWithDuration:Time animations:^{
//            feedbackTypePicker.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT - 150);
//        }];
        
       
        
        
        CSPFeedBackTypeView *feedBackTypeView = [[[NSBundle mainBundle]loadNibNamed:@"CSPFeedBackTypeView" owner:self options:nil]firstObject];
        feedBackTypeView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        
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
