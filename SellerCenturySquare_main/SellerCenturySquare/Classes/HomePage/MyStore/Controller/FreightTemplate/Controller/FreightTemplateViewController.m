//
//  FreightTemplateViewController.m
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/3/1.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "FreightTemplateViewController.h"
#import "HttpManager.h"
//新建模版控制器
#import "NewTemplateViewController.h"
#import "FreightTemplateCell.h"
//#import "MailView.h"

#import "FreightplateMailView.h"
#import "FreightTempModel.h"
#import "FreightTempListModel.h"
#import "GUAAlertView.h"
//查看运费模版详情页面
#import "LookFreightTemplateViewController.h"

#import "CourierViewController.h"


#import "ZJ_TemplateiewController.h"

@interface FreightTemplateViewController ()<UITableViewDataSource,UITableViewDelegate,FreightTemplateCellDelegate,FreightplateMailViewDelegate>
{
//设置全局变量
    NSInteger lineNum;
    NSInteger section;
    
    FreightplateMailView *maiLView;
    
    NSString *isDefaultStr;
}

//可变数组进行接受
@property (nonatomic,strong)NSMutableArray *infoListArr;

//新建模版按钮
@property(nonatomic,strong)UIButton *templateButton;
//建立table
@property(nonatomic,strong)UITableView *tableView;

@end

@implementation FreightTemplateViewController


//收货地址信息
-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    //获取数据列表接口
    [self getData];
    
}

//获取数据列表接口
-(void)getData
{
    [HttpManager sendHttpRequestForUpdateGetFreightTemplateListPageNo:nil pageSize:nil Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        _infoListArr = [[NSMutableArray alloc]initWithCapacity:0];
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            FreightTempListModel * freightTempListModel  = [[FreightTempListModel alloc]init];
            
            freightTempListModel.freightTempDTOList = [dic objectForKey:@"data"];
            
            _infoListArr = [freightTempListModel.freightTempDTOList mutableCopy];
            
            FreightTempModel *freightTempModel = [[FreightTempModel alloc]init];
            
            for (NSDictionary *dic in freightTempListModel.freightTempDTOList) {
                
                [freightTempModel setDictFrom:dic];
                
                if ([freightTempModel.isDefault isEqualToString:@"0"]) {

                    isDefaultStr = freightTempModel.templateName;
                    
                }
                
                if ([freightTempModel.isDefault isEqualToString:@"2"]) {
                    
                    if ([freightTempModel.sysDefault isEqualToString:@"0"]) {
                        
                    isDefaultStr = freightTempModel.templateName;
                        
                    }
                }
                
            }
            NSLog(@"数据请求成功");
        }
        
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       
        NSLog(@"error==== %@",error);
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"运费模版";
    
    //设置返回按钮
    [self customBackBarButton];
    //设置UI
    [self makeUI];
    
}

//设置UI
-(void)makeUI
{
    
    //创建tableView
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64 - 49) style:(UITableViewStyleGrouped)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    
    //创建模版按钮
    self.templateButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.templateButton.frame = CGRectMake(0, self.view.frame.size.height - 49 - 64, self.view.frame.size.width, 49);
    self.templateButton.backgroundColor = [UIColor colorWithHexValue:0x000000 alpha:1];
    [self.templateButton setTitle:@"新建模版" forState:(UIControlStateNormal)];

    [self.templateButton setTitleColor:[UIColor colorWithHexValue:0xffffff alpha:1] forState:(UIControlStateNormal)];
    [self.view addSubview:self.templateButton];
    
    //添加观察者
    [self.templateButton addTarget:self action:@selector(setNewTemplateButtonAction) forControlEvents:(UIControlEventTouchUpInside)];
}
#pragma mark =============设置tableView代理方法===============

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _infoListArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellID = @"FreightTemplateCell";
    
    FreightTemplateCell * cell = (FreightTemplateCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == NULL) {
        
        NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"FreightTemplateCell" owner:self options:nil] ;
        cell = [nib objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    FreightTempModel *freightTempModel = [[FreightTempModel alloc]init];
    
    [freightTempModel setDictFrom:_infoListArr[indexPath.row]];

    cell.templateName.text = freightTempModel.templateName;
    
    cell.delegate = self;

    if ([freightTempModel.isDefault isEqualToString:@"0"]) {
        
        cell.patientiaButton.selected = YES;
    }
    else if([freightTempModel.isDefault isEqualToString:@"1"])
    {
        cell.patientiaButton.selected = NO;
        
    }else if ([freightTempModel.isDefault isEqualToString:@"2"])
    {
        if ( [freightTempModel.sysDefault isEqualToString:@"0"]) {
            
            cell.patientiaButton.selected = YES;
            
        }else if ([freightTempModel.sysDefault isEqualToString:@"1"])
        {
            cell.patientiaButton.selected = NO;
        }
    }
    
    
    if (indexPath.row == (_infoListArr.count - 1)) {
        
        cell.lookButton.hidden = YES;
        cell.deleteButton.hidden = YES;
        cell.noDeletedLabel.hidden = NO;
        
    }else{
        cell.lookButton.hidden = NO;
        cell.deleteButton.hidden = NO;
        cell.noDeletedLabel.hidden = YES;
    }

    cell.deleteButton.tag = indexPath.row;
    cell.lookButton.tag = indexPath.row;
    cell.patientiaButton.tag = indexPath.row;
    //选中
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 92;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 110;
//}

//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    if (!maiLView) {
//       
//        maiLView = [[[NSBundle mainBundle]loadNibNamed:@"FreightplateMailView" owner:nil options:nil]lastObject];
//        maiLView.delegate = self;
//        
//        
//        FreightTempModel *freightTempModel = [[FreightTempModel alloc]init];
//        
//        [freightTempModel setDictFrom:_infoListArr[section]];
//        
//        maiLView.frame = CGRectMake(0, 0, self.view.frame.size.width, 60);
//    
//    }
//    return maiLView;
//}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    FreightTempModel *freightTempModel = [[FreightTempModel alloc]init];
    NSDictionary *dictionary = _infoListArr[indexPath.row];
    [freightTempModel setDictFrom:dictionary];
    
    LookFreightTemplateViewController *lookFreightTemplateVC = [[LookFreightTemplateViewController alloc]init];
    
    lookFreightTemplateVC.Id = freightTempModel.Id;
    lookFreightTemplateVC.isDefault = freightTempModel.isDefault;
    
    lookFreightTemplateVC.lookTitle = freightTempModel.templateName;
    [self.navigationController pushViewController: lookFreightTemplateVC animated:YES];
    
}

#pragma mark ======cell中代理方法=======
-(void)selectedBtn:(UIButton *)btn
{
    [self setDefaultBtn:btn];
}
//设置默认按钮行为
-(void)setDefaultBtn:(UIButton *)defaluBtn
{
    
    NSLog(@" defaluBtn== %ld",(long)defaluBtn.tag);
    
    section = defaluBtn.tag;
    
    FreightTempModel *freightTempModel = [[FreightTempModel alloc]init];
    
    NSDictionary *dictionary = _infoListArr[section];
    
    [freightTempModel setDictFrom:dictionary];
    
    NSString *replaceStr = [NSString stringWithFormat:@"更改后,原使用“%@”运费模板商品,将全部改为使用“%@”运费模板。",isDefaultStr,freightTempModel.templateName];
    
    if (![freightTempModel.isDefault isEqualToString:@"0"] && ![freightTempModel.isDefault isEqualToString:@"2"]) {
    
        [self setDefaultBtnID:freightTempModel.Id str:replaceStr button:defaluBtn];
    }
    
    if ([freightTempModel.isDefault isEqualToString:@"2"]) {
        if (![freightTempModel.sysDefault isEqualToString:@"0"]) {
            
            [self setDefaultBtnID:freightTempModel.Id str:replaceStr button:defaluBtn];
        }

    }
    
}

//设置默认按钮
-(void)setDefaultBtnID:(NSNumber *)defaultID  str:(NSString *)str  button:(UIButton *)button
{
    GUAAlertView *alert = [GUAAlertView alertViewWithTitle:@"确定更改默认模板?" withTitleClor:nil message:str withMessageColor:nil oKButtonTitle:@"确定" withOkButtonColor:nil cancelButtonTitle:@"取消" withOkCancelColor:nil withView:self.view buttonTouchedAction:^{
        
        [HttpManager  sendHttpRequestForDefultID:defaultID success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            
            if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
                
                //获取数据列表接口
                [self getData];
                
                button.selected = !button.selected;
                
                [self.view makeMessage:@"更改完成" duration:2.0f position:@"center"];
                
                
                NSLog(@"请求数据成功");
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
        
        
    } dismissAction:^{
        
    }];
    [alert show];

}




//查看设置好的运费模版
-(void)lookSettingPatientiaTemplateAction:(UIButton *)button
{

    section = button.tag;
    FreightTempModel *freightTempModel = [[FreightTempModel alloc]init];
    NSDictionary *dictionary = _infoListArr[section];
    [freightTempModel setDictFrom:dictionary];
    
    LookFreightTemplateViewController *lookFreightTemplateVC = [[LookFreightTemplateViewController alloc]init];
    lookFreightTemplateVC.Id = freightTempModel.Id;
    lookFreightTemplateVC.lookTitle = freightTempModel.templateName;
    [self.navigationController pushViewController: lookFreightTemplateVC animated:YES];

}

//删除运费模版
-(void)deletePatientiaTemplateAction:(UIButton *)button templateCell:(FreightTemplateCell *)templateCell
{

    FreightTempModel *freightTempModel = [[FreightTempModel alloc]init];
    NSDictionary *dictionary = _infoListArr[button.tag];
    [freightTempModel setDictFrom:dictionary];

    
    if ([freightTempModel.isDefault isEqualToString: @"0"]) {
        
        [self.view makeMessage:@"暂不可删除!请先勾选其他模板为默认模板。" duration:2.0f position:@"center"];
        
    }else
    {
        GUAAlertView *alert = [GUAAlertView alertViewWithTitle:nil withTitleClor:nil message:@"确定删除运费模版?" withMessageColor:nil oKButtonTitle:@"确定" withOkButtonColor:nil cancelButtonTitle:@"取消" withOkCancelColor:nil withView:self.view buttonTouchedAction:^{
            
            //删除运费模版
            [self deleteRequestForFreightTemplateDataID:freightTempModel.Id];
            
        } dismissAction:^{
            
        }];
        [alert show];
    }
}
#pragma marK ======删除运费模版=========

-(void)deleteRequestForFreightTemplateDataID:(NSNumber *)templateDataID
{
    
//    FreightTempModel *freightTempModel = [[FreightTempModel alloc]init];
//    NSDictionary *dictionary = _infoListArr[section];    
//    [freightTempModel setDictFrom:dictionary];
    
    [HttpManager sendHttpRequestForFreightTemplateID:templateDataID success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            [_infoListArr removeObjectAtIndex:section];
//            [self.tableView rmreloadData];
            //获取数据列表接口
            [self getData];
            
        }
    
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       
        NSLog(@"error ===  %@",error);
        
    }];
    
}




#pragma mark ================新建观察者
-(void)setNewTemplateButtonAction
{
    
    ZJ_TemplateiewController  *templateiewC = [[ZJ_TemplateiewController alloc]init];
    templateiewC.templatemanage = 1;
    [self.navigationController pushViewController:templateiewC animated:YES];

//    CourierViewController * courierVC = [[CourierViewController alloc]init];
//    [self.navigationController pushViewController:courierVC animated:YES];
    
}

#pragma mark =============设置按钮==============
//设置返回按钮
- (void)customBackBarButton{
    
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"04_商家中心_设置_后退"] style:UIBarButtonItemStylePlain target:self action:@selector(backBarButtonClick:)];
    
    self.navigationItem.leftBarButtonItem = backBarButton;
}
//返回按钮执行事件
- (void)backBarButtonClick:(UIBarButtonItem *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
