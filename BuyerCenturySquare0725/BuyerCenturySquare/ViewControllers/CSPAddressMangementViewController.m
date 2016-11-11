//
//  CSPAdressMangementViewController.m
//  BuyerCenturySquare
//
//  Created by GuChenlong on 7/13/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPAddressMangementViewController.h"
#import "CSPAddressMagementTableViewCell.h"
#import "CSPMangeAddressViewController.h"
#import "ConsigneeDTO.h"
#import "GetConsigneeListDTO.h"

#import "AddressDetailViewController.h"

#import "ZJ_ManagerAddressViewController.h"

@interface CSPAddressMangementViewController ()<CSPAddressMagementCellDelegate, UITableViewDelegate,AddressDetailViewControllerDelegate>
{
    NSMutableArray *listArray_;
    NSInteger row;
    ConsigneeDTO *deselectedDefault_;
    ConsigneeDTO *selectedDefault_;
    BOOL isneedModify;
    
    UIButton *deleteButton;
}
@property (nonatomic,strong)NSMutableArray *listArray;
@property (nonatomic,strong)ConsigneeDTO *deselectedDefault;
@property (nonatomic,strong)ConsigneeDTO *selectedDefault;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *AddressButton;
- (IBAction)newAddressButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
- (IBAction)backButtonClicked:(id)sender;

@end

@implementation CSPAddressMangementViewController
@synthesize listArray = listArray_,deselectedDefault = deselectedDefault_,selectedDefault = selectedDefault_;

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"地址管理";
    [self.navigationItem setHidesBackButton:YES];
    [self addCustombackButtonItem];
    //地址默认按钮
    isneedModify = NO;
    
    [self setExtraCellLineHidden:self.tableView];
    //线顶头
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getData];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
}


-(void)getData
{
        [HttpManager sendHttpRequestForConsigneeGetListSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            
            if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
                
                //#初始化地址管理信息
                GetConsigneeListDTO* getConsigneeListDTO = [[GetConsigneeListDTO alloc] init];
                
                //#
                ConsigneeDTO* consigneeDTO = [[ConsigneeDTO alloc] init];
                
                getConsigneeListDTO.consigneeDTOList = [dic objectForKey:@"data"];
                //进行可变复制
                self.listArray = [getConsigneeListDTO.consigneeDTOList mutableCopy];
                
                NSDictionary *dictionary;
                
                //对数组中的
                for (NSDictionary *dic in self.listArray) {
                    [consigneeDTO setDictFrom:dic];
                    if ([consigneeDTO.defaultFlag isEqualToString:@"0"]) {
                        dictionary = [dic copy];
                    }
                }
                if(dictionary != nil){
                    [self.listArray removeObject:dictionary];
                    //插入一个字典
                    [self.listArray insertObject:dictionary atIndex:0];
                    
                    self.deselectedDefault = [[ConsigneeDTO alloc]init];
                    [self.deselectedDefault setDictFrom:dictionary];
                    self.deselectedDefault.defaultFlag = @"1";
                    
                }
                
                //!如果当前只有一个地址，并且不是默认地址，就把该地址设置为默认地址
                if (self.listArray.count == 1 ) {
                    
                    ConsigneeDTO * onlyConsigeeDTO = [[ConsigneeDTO alloc]initWithDictionary:self.listArray[0]];
                    if (![onlyConsigeeDTO.defaultFlag isEqualToString:@"0"]) {//!如果不是默认地址，则调用 设置默认地址请求，把该地址设置为默认地址
                        [self changeDeafault:0];
                    }
                }
                //进行刷新
                [self.tableView reloadData];
                
            }else{
                
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请求失败" message:[dic objectForKey:@"errorMessage"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alert show];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error = %@",[NSString stringWithFormat:@"%@",error]);
            
        }];
  
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
    
    [super viewWillDisappear:animated];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.listArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //#进行cell的设置
    CSPAddressMagementTableViewCell *adressMagementCell = [tableView dequeueReusableCellWithIdentifier:@"CSPAddressMagementTableViewCell"];

    //#进行设置
    if (!adressMagementCell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"CSPAddressMagementTableViewCell" bundle:nil] forCellReuseIdentifier:@"CSPAddressMagementTableViewCell"];
        
        adressMagementCell = [tableView dequeueReusableCellWithIdentifier:@"CSPAddressMagementTableViewCell"];
    }
    
    //#xib代理方法
    adressMagementCell.delegate = self;
    
    //#初始化数据模型
    ConsigneeDTO* consigneeDTO = [[ConsigneeDTO alloc] init];
    
    NSMutableDictionary *Dictionary = self.listArray[indexPath.section];
    //数据模型进行赋值
    [consigneeDTO setDictFrom:Dictionary];
 
    [adressMagementCell getAddressMagementTableViewCellConsigneeDTO:consigneeDTO];
    
    //#进行标记（section中的tag值）
    adressMagementCell.defuaultButton.tag = indexPath.section;
    adressMagementCell.editButton.tag = indexPath.section;
    adressMagementCell.deleteButton.tag = indexPath.section;
    
    return adressMagementCell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //#初始化数据模型
//    ConsigneeDTO* consigneeDTO = [[ConsigneeDTO alloc] init];
//    NSMutableDictionary *Dictionary = self.listArray[indexPath.section];
//    [consigneeDTO setDictFrom:Dictionary];
//    
//    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
//    CGSize size = [consigneeDTO.detailAddress boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    UITableViewCell *cell =  [self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    return cell.frame.size.height;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 9;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
    
    ConsigneeDTO* consigneeDTO = [[ConsigneeDTO alloc] init];
    
    NSDictionary *Dictionary = self.listArray[indexPath.section];
    [consigneeDTO setDictFrom:Dictionary];
    
    if (self.isFromSureOrder) {//!从确认订单界面进入，点击cell需要返回上一个界面
        
        [self.delegate updateConsignee:consigneeDTO];
        [self.navigationController popViewControllerAnimated:YES];
        
    }else{//!其他情况，点击cell进入地址详情界面
    
        AddressDetailViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AddressDetailViewController"];
        
        nextVC.delegate = self;
        
        nextVC.consigneeDTO = consigneeDTO;
        
        [self.navigationController pushViewController:nextVC animated:YES];

    
    }
}



-(void)implementProxyMethodID:(NSNumber *)ID button:(UIButton *)button
{
    
//    if ([self.deselectedDefault.Id isEqualToNumber:ID]) {
//        self.deselectedDefault = nil;
//    }

    //小B删除收货地址
    
//     [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HttpManager sendHttpRequestForConsigneeDelWithConsigneeID:ID success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            button.enabled = YES;
            
//            [self.listArray removeObjectAtIndex:row];
//            [self.tableView reloadData];
            [self getData];
            
        }else{
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请求失败" message:[dic objectForKey:@"errorMessage"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            
            [alert show];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
//        NSLog(@"error = %@",[NSString stringWithFormat:@"%@",error]);
        
    }];
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


#pragma mark--
#pragma CSPAddressMagementCellDelegate
//#默认按钮代理方法
- (void)defaultButtonTaped:(UIButton *)sender{
    
    if (sender.selected == YES) {
        return;
    }
    
    //!修改数据源 并上传给服务器（传入的是：要设置为默认的按钮的tag）
    [self changeDeafault:sender.tag];
}

-(void)changeDeafault:(NSInteger)selectInt{

    isneedModify = YES;
    
    ConsigneeDTO* consigneeDTO = [[ConsigneeDTO alloc] init];
    
    int defaultindex = 0;
    
    NSDictionary *dictionary;
    
    //!把原来的默认 设置 为默认，放到数据源里面
    for (int i= 0; i<self.listArray.count; i++) {
        
        NSDictionary*  defaultDictionary = self.listArray[i];
        
        [consigneeDTO setDictFrom:defaultDictionary];
        
        if ([consigneeDTO.defaultFlag isEqualToString:@"0"]) {
            
            consigneeDTO.defaultFlag = @"1";
            
            defaultindex = i;
            
            NSMutableDictionary *mutabelDic = [defaultDictionary mutableCopy];
            
            [mutabelDic setObject:consigneeDTO.defaultFlag forKey:@"defaultFlag"];
            
            dictionary = [mutabelDic copy];
            
        }
    }
    if (dictionary != nil) {
        
        [self.listArray replaceObjectAtIndex:defaultindex withObject:dictionary];
        
    }
    
    //!修改要设置为默认的数据 并修改为默认
    ConsigneeDTO *selectedDTO = [[ConsigneeDTO alloc]init];
    
    NSDictionary *selectedDic = self.listArray[selectInt];
    
    [selectedDTO setDictFrom:selectedDic];
    
    selectedDTO.defaultFlag = @"0";
    
    NSMutableDictionary *selectedMutabelDic = [selectedDic mutableCopy];
    
    [selectedMutabelDic setObject:selectedDTO.defaultFlag forKey:@"defaultFlag"];
    
    selectedDic = [selectedMutabelDic copy];
    
    self.selectedDefault = [[ConsigneeDTO alloc]init];
    
    [self.selectedDefault setDictFrom:selectedDic];
    
    [self.listArray replaceObjectAtIndex:selectInt withObject:selectedDic];
    
    //!上传给服务器 并刷新数据
    [self changeDefaultAddress];

    [self.tableView reloadData];
    
}


//#编辑按钮代理方法
- (void)editButtonTaped:(UIButton *)sender{
    
    [self changeDefaultAddress];
    
    ConsigneeDTO* consigneeDTO = [[ConsigneeDTO alloc] init];
    
    NSDictionary *Dictionary = self.listArray[sender.tag];
    [consigneeDTO setDictFrom:Dictionary];
    
    
    ZJ_ManagerAddressViewController *managerVC = [[ZJ_ManagerAddressViewController alloc]init];
    managerVC.manageAddress = CSPModifyAddress;
    
    managerVC.consigneeDTO = consigneeDTO;
    
    [self.navigationController pushViewController:managerVC animated:YES];

}



- (void)deleteButtonTaped:(UIButton *)sender cell:(CSPAddressMagementTableViewCell *)cell{
    
    
    deleteButton = (UIButton *)[self.view viewWithTag:100];
    
    
    cell.deleteButton.enabled = NO;
    
    
    if (cell.defuaultButton.selected) {
        [self.view makeMessage:@"默认收货地址不可删除" duration:2 position:@"center"];
        return;
    }
    
    [self changeDefaultAddress];

    row = sender.tag;
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"确定删除收货地址?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    
    
}


- (IBAction)newAddressButtonClicked:(id)sender {
    
    [self changeDefaultAddress];

    ZJ_ManagerAddressViewController * destViewController = [[ZJ_ManagerAddressViewController alloc]init];
        destViewController.manageAddress = CSPAddNewAddress;
    [self.navigationController pushViewController:destViewController animated:YES];
    
}


#pragma mark --
#pragma UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        
        ConsigneeDTO* consigneeDTO = [[ConsigneeDTO alloc] init];
        
        NSDictionary *Dictionary = self.listArray[row];
        
        [consigneeDTO setDictFrom:Dictionary];
        
        if ([self.deselectedDefault.Id isEqualToNumber:consigneeDTO.Id]) {
            
            self.deselectedDefault = nil;
        }
        
//        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        //小B删除收货地址
        [HttpManager sendHttpRequestForConsigneeDelWithConsigneeID:consigneeDTO.Id success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            
            
            if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {

                deleteButton.enabled = YES;
                
                if (self.isFromSureOrder) {//!是从确认订单进入的
                    
                    if ((self.orderSelectID && [consigneeDTO.Id isEqualToNumber:self.orderSelectID])|| !self.orderSelectID) {//!如果删除的是确认订单界面选择的地址，就把默认地址传给 确认订单界面(传入订单号就判断删除的订单号是否 == 传入订单号；没有传入订单号（没有填写收货地址直接进入的用户）)
                        
                        //!找到默认模板
                        for (int i= 0; i<self.listArray.count; i++) {
                            
                            NSDictionary*  defaultDictionary = self.listArray[i];
                            
                            [consigneeDTO setDictFrom:defaultDictionary];
                            
                            if ([consigneeDTO.defaultFlag isEqualToString:@"0"]) {
                                
                                [self.delegate updateConsignee:consigneeDTO];
                                
                                break ;
                                
                            }
                        }
                    }
                }
                
                [self.listArray removeObjectAtIndex:row];
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];

                [self.tableView reloadData];
                
            }
//            else{
//                
//                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请求失败" message:[dic objectForKey:@"errorMessage"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//                
//                [alert show];
//                [MBProgressHUD hideHUDForView:self.view animated:YES];
//
//            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"error = %@",[NSString stringWithFormat:@"%@",error]);
            [MBProgressHUD hideHUDForView:self.view animated:YES];

        }];
    }
    
}


- (void)backButtonClicked:(id)sender {
    
    [self changeDefaultAddress];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)changeDefaultAddress{
    
    if ([self.deselectedDefault.Id.stringValue isEqualToString:self.selectedDefault.Id.stringValue]) {
        return;
    }
    
    //!把原来的默认设置为 非默认
    if (self.deselectedDefault != nil && isneedModify == YES) {
        
        [HttpManager sendHttpRequestForConsigneeUpdateWithConsigneeDTO:self.deselectedDefault success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            
            if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
                
                [self getData];

            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"error = %@",[NSString stringWithFormat:@"%@",error]);
        }];
    }
    
    //!把当前选中要设置为默认的对象 传给服务器
    if (self.selectedDefault != nil) {

        [HttpManager sendHttpRequestForConsigneeUpdateWithConsigneeDTO:self.selectedDefault success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            
            NSLog(@"dic = %@",dic[@"errorMessage"]);
         
            if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
                
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"error = %@",[NSString stringWithFormat:@"%@",error]);

        }];
    }
    
}




@end
