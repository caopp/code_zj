//
//  FeedBackViewController.m
//  BuyerCenturySquare
//
//  Created by 张晓旭 on 16/8/25.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "FeedBackViewController.h"
#import "CSPFeedBackTableViewCell.h"
#import "FeedbackTypePickerView.h"
#import "CSPFeedBackTypeDTO.h"
@interface FeedBackViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    FeedbackTypePickerView *typePickerView;
     NSString *type;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation FeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.title = @"意见反馈";
    [self addCustombackButtonItem];
    self.view.backgroundColor = [UIColor colorWithHexValue:0xefeff4 alpha:1];

    self.tableView.backgroundColor = [UIColor colorWithHexValue:0xefeff4 alpha:1];
    //选择反馈类型加载
    typePickerView = [[[NSBundle mainBundle]loadNibNamed:@"FeedbackTypePickerView" owner:nil options:nil]lastObject];
    typePickerView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 300);
    typePickerView.backgroundColor = [UIColor colorWithHexValue:0xc8c7cc alpha:1];
    [self.view addSubview:typePickerView];
    
    //!添加 点击其他地方收起键盘事件
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    //不加会屏蔽到TableView的点击事件等
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
    
    //设置通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notification:) name:@"FeedType" object:nil];
    self.submitButton.layer.cornerRadius = 2;
    self.submitButton.layer.masksToBounds = YES;
    
    type = @"2";
    
}

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
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
         cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    }else if (indexPath.section == 1){
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"CSPFeedBackViewControllerCellID1"];
        cell.backgroundColor = [UIColor colorWithHexValue:0xefeff4 alpha:1];
        
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
        return 0.01f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        [UIView animateWithDuration:0.5 animations:^{
            typePickerView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT - 150);
        }];
    }
}

-(void)hideKeyboard
{
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.5 animations:^{
        typePickerView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT + 150);
    }];
}

-(void)notification:(NSNotification *)notification
{
    CSPFeedBackTableViewCell *cell = (CSPFeedBackTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        
    CSPFeedBackTypeDTO *feedBackTypeDTO = notification.userInfo[@"name"];
    
    type = feedBackTypeDTO.type;
    
    cell.feedBackTypeLabel.text = feedBackTypeDTO.typeName;
}



- (IBAction)didClickSubmitAction:(id)sender {
    
    [self progressHUDShowWithString:@"提交中"];
    
    CSPFeedBackTableViewCell *cell = (CSPFeedBackTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    
    NSString *content = cell.feedBackTextView.text;
    
    NSString *alertStr = NSLocalizedString(@"feedAlert", @"您遇到什么问题，或者哪些功能建议，欢迎在此提出！我们将持续跟进优化。");
    
    if (content.length<1 || [content isEqualToString:alertStr]) {
        
        [self progressHUDHiddenWidthString:NSLocalizedString(@"contentNil", @"反馈内容不能为空")];
        
        return;
        
    }
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    [HttpManager sendHttpRequestForaddFeedback:type content:content success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *responseDic = [self conversionWithData:responseObject];
        
        if ([self isRequestSuccessWithCode:[responseDic objectForKey:@"code"]]) {
            
            
            [self progressHUDHiddenTipSuccessWithString:NSLocalizedString(@"feedSucceed", @"反馈成功")];
            [self.navigationController popViewControllerAnimated:YES];
            
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
@end
