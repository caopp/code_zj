//
//  ModShopInfoViewController.m
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/8/10.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "ModShopInfoViewController.h"
#import "ModShopInfoNormalTableViewCell.h"
#import "ModShopDetailInfoTableViewCell.h"
#import "ModShopInfoFirstTableViewCell.h"
#import "HttpManager.h"
#import "GetMerchantInfoDTO.h"
#import "GUAAlertView.h"
#import "CSPUtils.h"

typedef void (^FinishBlock)();

@interface ModShopInfoViewController ()
{
    
    GUAAlertView *alertView;
    
    // !是否是身份证验证错误
    BOOL isIdentity;
    
}
@property (nonatomic,copy) FinishBlock requestFinish;
@property (nonatomic,strong) GetMerchantInfoDTO *getMerchantInfoDTO;
@end

@implementation ModShopInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _updateMerchantInfoModel = [[UpdateMerchantInfoModel alloc]init];
    [self customBackBarButton];
    
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [self getDefaultData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - GetData
- (void)getDefaultData{
    
    _getMerchantInfoDTO = [GetMerchantInfoDTO sharedInstance];
     _updateMerchantInfoModel.shopkeeper = _getMerchantInfoDTO.shopkeeper;
    _updateMerchantInfoModel.sex = _getMerchantInfoDTO.sex;
    _updateMerchantInfoModel.mobilePhone = _getMerchantInfoDTO.mobilePhone;
    _updateMerchantInfoModel.telephone = _getMerchantInfoDTO.telephone;
    _updateMerchantInfoModel.identityNo = _getMerchantInfoDTO.identityNo;
    _updateMerchantInfoModel.detailAddress = _getMerchantInfoDTO.detailAddress;
    _updateMerchantInfoModel.contractNo = _getMerchantInfoDTO.contractNo;
    _updateMerchantInfoModel.provinceNo = _getMerchantInfoDTO.provinceNo;
    _updateMerchantInfoModel.cityNo = _getMerchantInfoDTO.cityNo;
    _updateMerchantInfoModel.countyNo = _getMerchantInfoDTO.countyNo;
    _updateMerchantInfoModel.Description = _getMerchantInfoDTO.Description;


}

#pragma mark - 获取商家资料

- (void)getMerchantInfo:(FinishBlock)requestFinishedBlock{
    
    if (self) {
        _requestFinish = [requestFinishedBlock copy];
    }
    
    [HttpManager sendHttpRequestForGetMerchantInfo: ^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            if ([[dic objectForKey:@"data"] isKindOfClass:[NSDictionary class]])
            {
                GetMerchantInfoDTO *getMerchantInfoDTO = [GetMerchantInfoDTO sharedInstance];
                [getMerchantInfoDTO setDictFrom:[dic objectForKey:@"data"]];
            }
            
            if (_requestFinish) {
                
                _requestFinish();
            }
            
        }else{
            
            [self.view makeMessage:dic[@"errorMessage"] duration:2 position:@"center"];
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self.view makeMessage:@"获取商家资料失败" duration:2 position:@"center"];
        
    } ];
    
}


#pragma mark - 保存
- (IBAction)saveButtonClicked:(id)sender {

    [self.view endEditing:YES];
    
    NSString * lackStr = [self isLack];
    
    if (![lackStr isEqualToString:@""]) {
    
        
        alertView = [GUAAlertView alertViewWithTitle:nil withTitleClor:nil message:lackStr withMessageColor:nil oKButtonTitle:@"确定" withOkButtonColor:nil cancelButtonTitle:nil withOkCancelColor:nil withView:self.view buttonTouchedAction:nil dismissAction:nil];
        [alertView show];
    
        return ;
        
        
    }
    
    
    [self modShopInfoRequest];

    
}
-(NSString *)isLack{


    NSString *identify = _updateMerchantInfoModel.identityNo;//!身份证
    
    if ([self isNull:_updateMerchantInfoModel.shopkeeper]) {
        
        return  @"请输入店铺负责人";
        
    }else if ([self isNull:_updateMerchantInfoModel.sex]){
    
        return @"请选择店铺负责人性别";
    
    }else if ([self isNull:_updateMerchantInfoModel.mobilePhone]){
    
        return @"请输入联系手机";
    
    }else if (![CSPUtils checkMobileNumber:_updateMerchantInfoModel.mobilePhone]){
    
        return @"输入的手机号有误";
    
    }else if ([self isNull:_updateMerchantInfoModel.identityNo]){
    
        return @"请输入身份证";
        
    }else if (![CSPUtils validateIDCardNumber:identify]){
    
        return @"输入的身份证信息有误";

    
    }else if ([self isNull:_updateMerchantInfoModel.provinceNo] || [self isNull:_updateMerchantInfoModel.cityNo] || [self isNull:_updateMerchantInfoModel.countyNo]){
    
        return @"请选择省市区";
    
    }else if ([self isNull:_updateMerchantInfoModel.detailAddress]){
    
        return @"请输入详细地址";
    
    }else if ([self isNull:_updateMerchantInfoModel.contractNo]){
    
        return @"请输入合同编号";
        
    }else if ([self isNull:_updateMerchantInfoModel.Description]){
    
        return @"请输入商家简介";
    }
    
    // !座机号不是必填项 如果座机号不为空再判断是否正确
//    if (![self isNull:_updateMerchantInfoModel.telephone]) {
//        
//        if (![CSPUtils checkFixedLineNumber:_updateMerchantInfoModel.telephone]) {// !座机的判断方法不对 所以不采取
//            
//            return @"输入的座机号不正确";
//            
//        }
//        
//    }
    
    
    
    
    return @"";

}


-(BOOL)isNull:(NSObject *)obj{
    
    if (obj == nil) {
        
        return YES;
    }
    if ([obj isKindOfClass:[NSNull class]]) {
        
        return YES;
    }
    
    if ([obj isKindOfClass:[NSString class]]) {
        
        if ([obj isEqual:@""]) {
            
            return YES;
        }
    }
    
    return NO;
    
}
- (void)modShopInfoRequest{
    
    [self progressHUDShowWithString:@"修改中"];
    
    [HttpManager sendHttpRequestForGetUpdateMerchantInfo:_updateMerchantInfoModel success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            [self progressHUDHiddenWidthString:@"修改成功"];
            
            [self getMerchantInfo:^{
                
                
                [self.navigationController popViewControllerAnimated:YES];
                
                
            }];
            
            
            
        }else{
            
            [self progressHUDHiddenWidthString:dic[@"errorMessage"]];
            
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self progressHUDHiddenWidthString:@"修改失败"];
        
        
    } ];
}

#pragma mark - TableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *firstCellIdentifier = @"ModShopInfoFirstCell";
    
    NSString *normalCellIdentifier = @"ModShopInfoNormalCell";
    
    NSString *introduceCellIdentifier = @"ShopIntroduceCell";
    
    ModShopInfoFirstTableViewCell *firstCell = [tableView dequeueReusableCellWithIdentifier:firstCellIdentifier];
    
    ModShopInfoNormalTableViewCell *normalCell = [tableView dequeueReusableCellWithIdentifier:normalCellIdentifier];
    
    ModShopDetailInfoTableViewCell *introduceCell = [tableView dequeueReusableCellWithIdentifier:introduceCellIdentifier];
    
    if (firstCell == nil)
    {
        firstCell =[[ModShopInfoFirstTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:firstCellIdentifier];
    }
    
    if (normalCell == nil)
    {
        normalCell =[[ModShopInfoNormalTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:normalCellIdentifier];
    }
    
    if (introduceCell == nil)
    {
        introduceCell =[[ModShopDetailInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:introduceCellIdentifier];
    }
    
    firstCell.updateMerchantInfoModel = _updateMerchantInfoModel;
    introduceCell.updateMerchantInfoModel = _updateMerchantInfoModel;
    
    [normalCell setAccessoryType:UITableViewCellAccessoryNone];
    [normalCell setPicker:NO];
    normalCell.updateMerchantInfoModel = _updateMerchantInfoModel;
    normalCell.index = indexPath.row;
    
    switch (indexPath.row) {
        case 0:
            
            firstCell.nameL.text = _getMerchantInfoDTO.shopkeeper;
            firstCell.isMan = [_getMerchantInfoDTO.sex integerValue]==1?YES:NO;
            return firstCell;
            break;
            
        case 1:
            normalCell.contentT.placeholder = @"手机号";
            normalCell.contentT.text = _getMerchantInfoDTO.mobilePhone;
            return normalCell;
            break;
        case 2:
            normalCell.contentT.placeholder = @"座机电话";
            normalCell.contentT.text = _getMerchantInfoDTO.telephone;
            return normalCell;
            break;
        case 3:
            {
                normalCell.contentT.placeholder = @"身份证";
                normalCell.contentT.text = _getMerchantInfoDTO.identityNo;
                
                return normalCell;
                break;
            
            }
        case 4:
            normalCell.contentT.placeholder = @"省市区";
//            [normalCell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            normalCell.contentT.text = [NSString stringWithFormat:@"%@%@%@",_getMerchantInfoDTO.provinceName,_getMerchantInfoDTO.cityName,_getMerchantInfoDTO.countyName];
            [normalCell setPicker:YES];
            return normalCell;
            break;
        case 5:
            normalCell.contentT.placeholder = @"详细地址";
            normalCell.contentT.text = _getMerchantInfoDTO.detailAddress;
            return normalCell;
            break;
        case 6:
            normalCell.contentT.placeholder = @"合同编号";
            normalCell.contentT.text = _getMerchantInfoDTO.contractNo;
            return normalCell;
            break;
        case 7:
            introduceCell.defaultText = _getMerchantInfoDTO.Description;
            return introduceCell;
            break;
        default:
            break;
    }
    
    return nil;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    
    [self.view endEditing:YES];
    
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
