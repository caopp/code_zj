//
//  TestCases.m
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-7-28.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "TestCases.h"
#import "HttpManager.h"
#import "LoginDTO.h"
#import "SetPasswordDTO.h"
#import "ForgetPwdCheckDTO.h"
#import "GetMerchantMainDTO.h"
#import "GetMerchantInfoDTO.h"
#import "GetGoodsCategoryListDTO.h"
#import "GoodsCategoryDTO.h"
#import "GetShopGoodsListDTO.h"
#import "ShopGoodsDTO.h"
#import "GetEditGoodsListDTO.h"
#import "EditGoodsDTO.h"
#import "GetGoodsInfoListDTO.h"
#import "GoodsInfoDTO.h"
#import "UpdateGoodsInfoModel.h"
#import "GetNoticeStationListDTO.h"
#import "NoticeStationDTO.h"
#import "GetImgDownloadListDTO.h"
#import "ImgDownloadDTO.h"
#import "GetImageHistoryListDTO.h"
#import "ImageHistoryDTO.h"
#import "GetPayMerchantOnsaleDTO.h"
#import "GetPayMerchantDownloadDTO.h"
#import "GetMerchantNotAuthTipDTO.h"
#import "getRecommendRecordListDTO.h"
#import "RecommendRecordDTO.h"
#import "GoodsPicDTO.h"
#import "GetMerchantPermissionListDTO.h"
#import "GetRecommendRecordDetailsListDTO.h"
#import "RecommendRecordDetailsDTO.h"
#import "GetRecommendReceiverListDTO.h"
#import "RecommendReceiverDTO.h"
#import "SaveGoodsRecommendModel.h"
#import "GetMemberTradeListDTO.h"
#import "MemberTradeDTO.h"
#import "GetMemberInviteListDTO.h"
#import "MemberInviteDTO.h"
#import "GetMemberBlackListDTO.h"
#import "MemberBlackDTO.h"
#import "GetMemberInfoDTO.h"
#import "ChatHistoryModel.h"
#import "GetMerchantCloseLogDTO.h"
#import "MerchantCloseLogDTO.h"
#import "GetMemberApplyInfoDTO.h"
#import "MerchantPermissionDTO.h"
#import "GetOrderListDTO.h"
#import "GetOrderDTO.h"
#import "GetOrderDetailListDTO.h"
#import "GetOrderDetailDTO.h"
#import "orderGoodsItemDTO.h"
#import "UserListDTOModel.h"
#import "GetGoodsFeeInfoDTO.h"
#import "SkuListDTO.h"
#import "GetImageReferImageHistoryListDTO.h"
#import "GetInvMobileListDTO.h"
#import "GetInvMobileDTO.h"
#import "GetPayPayDTO.h"
#import "WeChatMobilePayDTO.h"
#import "GetMerchantIntegralByMonthDTO.h"
#import  "GetMerchantIntegralLogDTO.h"
#import "GetPortalStatisticsDTO.h"
#import "MemberDTO.h"
#import "GoodsSellDTO.h"
#import "GetOrderSalesPerDaysDTO.h"
#import "GetPurchaserStatisticsPerDaysDTO.h"
#import "GetProductStatisticPerSaleDTO.h"
#import "SaveGoodsRecommendDTO.h"

BOOL Islogin = FALSE;
@implementation TestCases

-(void) testStart
{
    Islogin = FALSE;
    testLogin();                           //3.1	登陆接口(已测试,成功)
    
   
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        sleep(4);
        if (Islogin) {
            NSLog(@"The Login is successful,you can go on testing .....\n");
        }
        else
        {
            NSLog(@"The Login is failure................................\n");
            return ;
        }
        
        //testSetPassword();                //3.2  设置登录密码(已测试,成功)
        //testForgetPwdCheck();             //3.3  忘记密码校验接口(已测试,成功)
        //testUpdatePassword();             //3.4  用户修改密码接口(已测试,成功)
        //testMerchantMain();               //3.5  大B商家中心主页接口(已测试,成功)
        //testUpdateGoodsReadStatus();      //3.6  大B商家中心主页商品阅读状态修改接口(暂时搁置)

        //testGetMerchantInfo();            //3.7   大B商家信息接口(已测试,成功)
        //testGetUpdateMerchantBusiness();  //3.8   更改营业状态（包括歇业时间）(已测试,成功)
        //testGetMerchantCloseLog();        //3.9 	歇业记录查询接口(已测试,成功)
        //testGetUpdateMerchantBatchlimit();//3.10  修改全店混批条件(已测试,成功)
        //testGetGetUpdateMerchantInfo();   //3.11  修改商家资料(已测试,成功)
        
        //testGetGoodsCategoryList();        //3.12	大B获取商品分类接口(已测试,成功)
        //testGetShopGoodsList();	         //3.13 商品列表（店铺展示）接口(已测试,成功.)
       // testGetEditGoodsList();            //3.14 商品列表（可编辑）接口(已测试,成功)
        //testGetGoodsInfoList();           //3.15	大B商品详情接口 接口(已测试,成功)
        //testGetUpdateGoodsInfo();         //3.16	大B商品修改接口(已测试,成功)
        
        //testGetGoodsFeeInfo();             //3.17	邮费专拍详情接口(已测试,成功)
        //testGetUpdateGoodsStatus();        //3.17 大B商品修改接口(已测试,成功)
        //testGetNoticeStationList();        //3.18	大B站内信列表 (已测试,成功)
        //testGetUpdateNoticeStatus();       //3.19	大B站内信阅读状态修改接口 (已测试,成功)
        //testGetImgDownloadSetting();       //3.20	大B商品图片下载权限设置接口(已测试,成功)
        
        //testGetImgDownloadList();          //3.21	大B商品下载图片列表接口(已测试,成功.)
        //testGetImgDownCallback();          //3.22	大B图片下载完成回调接口(已测试,成功)
        //testGetImgHistoryCallback();       //3.23	大B商品图片下载历史查询接口(已测试,成功)
        //testGetMerchantPermissionList();   //3.24	商家等级权限说明接口(已测试,成功)
        
        //testGetPayMerchantOnsale();         //3.25 付费上架(已测试,成功)
        //testGetPayMerchantDownload();       //3.26 付费下载(已测试,成功)
        //testGetMerchantNotAuthTip();        //3.27 无权限提示接口(已测试,成功)
        //testGetSalesStatisticsList();         //3.28 大B销售统计接口(已测试,暂时搁置)
        
        //testGetSalesStatisticsByDateList(); //3.29 大B按照销售时间统计接口(已测试,暂时搁置)
        //testGetMemberTradeList();           //3.30 大B按照时间统计采购商接口(已测试,暂时搁置)
        //testGetGoodsStatisticsList();       //3.31 大B按照时间统计采购商接口(已测试,暂时搁置)
        //testGetRecommendRecordList();       //3.32 推荐商品记录列表接口(已测试,成功)
        //testGetRecommendRecordDetailsList();//3.33 推荐商品记录详情接口(已测试,成功)
        //testGetDeleteRecommendRecord();     //3.34 推荐商品记录删除接口(已测试,成功)
         //testGetRecommendReceiverList();     //3.35 推荐商品收件人列表接口(已测试,成功)
        
         testSaveGoodsRecommend();           //3.36  推荐商品记录发送接口(已测试,成功)
        //testSecondGetMemberTradeList();       //3.37  采购商-有交易的会员的列表接口(已测试,成功)
        //testSecondGetMemberInviteList();    //3.38  采购商-我邀请的会员的列表接口(已测试,成功)
        //testGetMemberBlackList();           //3.39  采购商-黑名单列表接口(已测试,成功)
        //testGetUpdateMemberBlackList();     //3.40  采购商-黑名单设置接口(已测试,成功)
        
        //testGetMemberInfo();                 //3.41   采购商-详情接口(已测试,成功)
        //testGetMemberApplyInfo();            //3.42	采购商-资料接口（申请资料）(已测试,成功)
        //testGetMemberLevelSet();             //3.43	采购商-店铺等级设置接口(已测试,成功)
        //testGetMemberInvite();               //3.44	采购商-邀请接口(已测试,成功，文档未定义返回数据)
        //testGetMemberInvite();               //3.44	采购商-邀请接口(已测试,成功，文档未定义返回数据)

        //testGetOrderList();                  //3.45	采购单列表(已测试,成功)
        //testGetOrderDetail();                //3.46	采购单详情(已测试,成功)
        //testModifyOrderAmount();             //3.47	修改采购单总金额(已测试,成功)
        //testOrderCancel();                   //3.48	取消交易(已测试,成功)
        //testGetChatPusher()();               //3.49	消息推送（openfire）
        //testGetChatHistory();                //3.50	获取历史聊天信息(已测试,失败)
        
        //testImageUpload();
        //testSetOrderDelivery();
        //testGetMerchantAddFeedback();
        // testCreatOrderAddVirtualOrder();
        //testGetOrderByMemberNo();
        //testGetImageReferImageHistoryListWithGoodsNo();
        
       // testPayPay();
         //testGetInvMobileList();              //3.57	验证手机联系号码能否接受邀请接口
        //testSendSms();
        //testVerifySms();
       // testChatPusher();
        //testGetMerchantIntegralByMonth();
        //testGetMerchantIntegralLogList();
        //[self testFunction];
        //testValidateMemberInvite();
    });
}

//3.1 登陆测试
void testLogin()
{
    //NSString *account = @"15889631996";
    NSString *account = @"13800010001";
    NSString *passwd = @"123456";
    
    [HttpManager sendHttpRequestForLoginWithMemberAccount:account password:passwd success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
             NSLog(@"登陆成功");
            
            if ([[dic objectForKey:@"data"] isKindOfClass:[NSDictionary class]])
            {
                
                LoginDTO *loginDTO = [LoginDTO sharedInstance];
                
                [loginDTO setDictFrom:[dic objectForKey:@"data"]];
                
                if ([loginDTO loginParameterIsLack] == YES) {
                    NSLog(@"The login parameter is Lack,please attention\n");
                }
                
                Islogin = TRUE;
            }
            
        }else{
            
            NSLog(@"登陆失败errorMessage = %@",[dic objectForKey:@"errorMessage"]);
        }
        
        NSLog(@"dic = %@",dic);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"登陆失败");
        NSLog(@"The error description is %@\n",[error localizedDescription]);
        
    } ];
    
    return;
    
}

//3.2	设置登录密码
void testSetPassword()
{
    NSString *account = @"15889631996";
    NSString *passwd = @"1234";
    
    [HttpManager sendHttpRequestForSetPassword:account passwd:passwd success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            NSLog(@"设置登录密码  返回正常编码");
            
            SetPasswordDTO *setPassword = [SetPasswordDTO sharedInstance];
            
            [setPassword setDictFrom:[dic objectForKey:@"data"]];
            
        }else{
            
            NSLog(@"设置登录密码  返回异常编码 errorMessage = %@",[dic objectForKey:@"errorMessage"]);
        }
        
        NSLog(@"dic = %@",dic);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"testSetPassword 失败");
        
    } ];
    
    return;
    
}

//3.3	忘记密码校验接口
void testForgetPwdCheck()
{
    NSString *mobilePhone = @"15889631996";
    
    [HttpManager sendHttpRequestForForgetPwdCheckWithMobilePhone:mobilePhone success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            NSLog(@"忘记密码校验接口  返回正常编码");
            
        }else{
            
            NSLog(@"忘记密码校验接口  返回异常编码 errorMessage = %@",[dic objectForKey:@"errorMessage"]);
        }
        
        NSLog(@"dic = %@",dic);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"testForgetPwdCheck 失败");
        
    } ];
    
    return;
    
}

//3.4	用户修改密码接口
void testUpdatePassword()
{
   
    NSString *account = @"15889631996";
    NSString *passwd = @"1234";;
    NSString *oldpwd = @"5678";

    [HttpManager sendHttpRequestForUpdatePassword:account passwd:passwd oldpwd:oldpwd success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            NSLog(@"用户修改密码接口  返回正常编码");
            
        }else{
            
            NSLog(@"用户修改密码接口  返回异常编码 errorMessage = %@",[dic objectForKey:@"errorMessage"]);
        }
        
        NSLog(@"dic = %@",dic);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"testUpdatePassword 失败");
        
    } ];
    
    return;
}

//3.5	大B商家中心主页接口
void testMerchantMain()
{
    [HttpManager sendHttpRequestForGetMerchantMain:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            NSLog(@"大B商家中心主页接口  返回正常编码");
            if ([[dic objectForKey:@"data"] isKindOfClass:[NSDictionary class]])
            {
                GetMerchantMainDTO *getMerchantMainDTO = [GetMerchantMainDTO sharedInstance];
                [getMerchantMainDTO setDictFrom:[dic objectForKey:@"data"]];
                NSLog(@"The unshippedNum is %d\n",[getMerchantMainDTO.unshippedNum intValue]);
                NSLog(@"The untakeOrderNum is %d\n",[getMerchantMainDTO.untakeOrderNum intValue]);
                
            }
            
        }else{
            
            NSLog(@"大B商家中心主页接口  返回异常编码 errorMessage = %@",[dic objectForKey:@"errorMessage"]);
        }
        
        NSLog(@"dic = %@",dic);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"testMerchantMain 失败");
        
    } ];
    
    return;
    
}

//3.6 大B商家中心主页商品阅读状态修改接口
void testUpdateGoodsReadStatus()
{
    [HttpManager sendHttpRequestForUpdateGoodsReadStatus: ^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            NSLog(@"大B商家中心主页商品阅读状态修改接口  返回正常编码");
            
            //GetMerchantMainDTO *getMerchantMainDTO = [GetMerchantMainDTO sharedInstance];
            //[getMerchantMainDTO setDictFrom:[dic objectForKey:@"data"]];
            
        }else{
            
            NSLog(@"大B商家中心主页商品阅读状态修改接口  返回异常编码 errorMessage = %@",[dic objectForKey:@"errorMessage"]);
        }
        
        NSLog(@"dic = %@",dic);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"testUpdateGoodsReadStatus 失败");
        NSLog(@"The error description is %@\n",[error localizedDescription]);
        
    } ];
     
    return;
    
}

//3.7 大B商家信息接口
void testGetMerchantInfo()
{
    
    [HttpManager sendHttpRequestForGetMerchantInfo: ^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            NSLog(@"大B商家信息接口  返回正常编码");
            if ([[dic objectForKey:@"data"] isKindOfClass:[NSDictionary class]])
            {
                GetMerchantInfoDTO *getMerchantInfoDTO = [GetMerchantInfoDTO sharedInstance];
                [getMerchantInfoDTO setDictFrom:[dic objectForKey:@"data"]];
            }
            
        }else{
            
            NSLog(@"大B商家信息接口  返回异常编码 errorMessage = %@",[dic objectForKey:@"errorMessage"]);
        }
        
        NSLog(@"dic = %@",dic);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"testGetMerchantInfo 失败");
        NSLog(@"The error description is %@\n",[error localizedDescription]);
        
    } ];
    
    return;
    
}

//3.8	更改营业状态（包括歇业时间）
void testGetUpdateMerchantBusiness()
{
    NSString* operateStatus = @"1";
    NSString* closeStartTime = @"2015-10-13 16:00:00";
    NSString* closeEndTime = @"2015-10-13 17:00:00";
    
    [HttpManager sendHttpRequestForGetUpdateMerchantBusiness: operateStatus closeStartTime:closeStartTime closeEndTime:closeEndTime success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            NSLog(@"更改营业状态（包括歇业时间）  返回正常编码");
            
            //更该营业状态（包括歇业时间） 返回正常编码。
//            GetMerchantInfoDTO *getMerchantInfoDTO = [GetMerchantInfoDTO sharedInstance];
//            [getMerchantInfoDTO setDictFrom:[dic objectForKey:@"data"]];
            
        }else{
            
            NSLog(@"更改营业状态（包括歇业时间）  返回异常编码 errorMessage = %@",[dic objectForKey:@"errorMessage"]);
        }
        
        NSLog(@"dic = %@",dic);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"testGetMerchantInfo 失败");
        NSLog(@"The error description is %@\n",[error localizedDescription]);
        
    } ];
    
    return;
    
}

//3.9	歇业记录查询接口
void testGetMerchantCloseLog()
{
    [HttpManager sendHttpRequestForGetMerchantCloseLog:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            NSLog(@"歇业记录查询接口  返回正常编码");
            if ([[dic objectForKey:@"data"] isKindOfClass:[NSDictionary class]])
            {
                GetMerchantCloseLogDTO *getMerchantCloseLogDTO = [[GetMerchantCloseLogDTO alloc] init];
                MerchantCloseLogDTO *merchantCloseLogDTO = [[MerchantCloseLogDTO alloc] init];
                
                [getMerchantCloseLogDTO setDictFrom:[dic objectForKey:@"data"]];
            
                long count = [getMerchantCloseLogDTO.MerchantCloseLogDTOList count];
                
                NSLog(@"The List count is %ld\n",count);
                
                for( int index =0; index <count; index ++){
                    NSDictionary *Dictionary = [getMerchantCloseLogDTO.MerchantCloseLogDTOList objectAtIndex:index];
                    [merchantCloseLogDTO setDictFrom:Dictionary];
                    NSLog(@"The closeStartTime is %@\n",merchantCloseLogDTO.closeStartTime);
                    
                }
            }
            
            
        }else{
            
             NSLog(@"歇业记录查询接口  返回异常编码 errorMessage = %@",[dic objectForKey:@"errorMessage"]);
        }
        
        NSLog(@"dic = %@",dic);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"testGetMerchantCloseLog 失败");
        NSLog(@"The error description is %@\n",[error localizedDescription]);
        
    } ];
    
    return;
    
}

//3.10	修改全店混批条件
void testGetUpdateMerchantBatchlimit()
{
    NSString * batchAmountFlag = @"0";
    NSString *batchNumFlag = @"0";
    NSNumber* batchAmountLimit = [[NSNumber alloc ]initWithDouble:300.0];
    NSNumber* batchNumLimit = [[NSNumber alloc ]initWithInt:5];
    
    [HttpManager sendHttpRequestForGetUpdateMerchantBatchlimit: batchAmountFlag batchNumFlag:batchNumFlag batchAmountLimit:batchAmountLimit batchNumLimit:batchNumLimit success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            NSLog(@"修改全店混批条件  返回正常编码");
            
            //            GetMerchantInfoDTO *getMerchantInfoDTO = [GetMerchantInfoDTO sharedInstance];
            //            [getMerchantInfoDTO setDictFrom:[dic objectForKey:@"data"]];
            
        }else{
            
            NSLog(@"修改全店混批条件  返回异常编码 errorMessage = %@",[dic objectForKey:@"errorMessage"]);
        }
        
        NSLog(@"dic = %@",dic);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"testGetUpdateMerchantBatchlimit 失败");
        NSLog(@"The error description is %@\n",[error localizedDescription]);
        
    } ];
    
    return;
    
}

//	3.11  修改商家资料
void testGetGetUpdateMerchantInfo()
{
    UpdateMerchantInfoModel *updateMerchantInfoModel = [[UpdateMerchantInfoModel alloc] init];
    
    updateMerchantInfoModel.shopkeeper = @"Tom";
    updateMerchantInfoModel.identityNo = @"Tom";
    updateMerchantInfoModel.provinceNo = [[NSNumber alloc] initWithInt:1];
    updateMerchantInfoModel.cityNo = [[NSNumber alloc] initWithInt:1];
    updateMerchantInfoModel.countyNo = [[NSNumber alloc] initWithInt:1];
    updateMerchantInfoModel.detailAddress = @"Tom";
    updateMerchantInfoModel.contractNo = @"Tom";
    updateMerchantInfoModel.sex = @"1";
    updateMerchantInfoModel.mobilePhone = @"Tom";
    updateMerchantInfoModel.telephone = @"Tom";
    updateMerchantInfoModel.Description = @"Tom";
    
    [HttpManager sendHttpRequestForGetUpdateMerchantInfo:updateMerchantInfoModel success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            NSLog(@" 修改商家资料  返回正常编码");
            
            //GetMerchantInfoDTO *getMerchantInfoDTO = [GetMerchantInfoDTO sharedInstance];
            //[getMerchantInfoDTO setDictFrom:[dic objectForKey:@"data"]];
            
        }else{
            
            NSLog(@"修改商家资料  返回异常编码 errorMessage = %@",[dic objectForKey:@"errorMessage"]);
        }
        
        NSLog(@"dic = %@",dic);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"testGetGetUpdateMerchantInfo 失败");
        NSLog(@"The error description is %@\n",[error localizedDescription]);
        
    } ];
    
    return;
    
}

//	3.12	大B获取商品分类接口
void testGetGoodsCategoryList()
{
    
    [HttpManager sendHttpRequestForGetGoodsCategoryList:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            NSLog(@" 大B获取商品分类接口  返回正常编码");
            
            GetGoodsCategoryListDTO *getGoodsCategoryListDTO = [GetGoodsCategoryListDTO init];
            GoodsCategoryDTO *goodsCategoryDTO = [[GoodsCategoryDTO alloc] init];
            getGoodsCategoryListDTO.goodsCategoryDTOList = [dic objectForKey:@"data"];
            
            long count = [getGoodsCategoryListDTO.goodsCategoryDTOList count];
            NSLog(@"The count is %ld\n",count);
            
            for( int index =0; index <count; index ++){
                NSDictionary *Dictionary = [getGoodsCategoryListDTO.goodsCategoryDTOList objectAtIndex:index];
                [goodsCategoryDTO setDictFrom:Dictionary];
                NSLog(@"The categoryNo is %@\n",goodsCategoryDTO.categoryNo);
                NSLog(@"The categoryName is %@\n",goodsCategoryDTO.categoryName);
                NSLog(@"The structureNo is %@\n",goodsCategoryDTO.structureNo);
            }
            
        }else{
            
            NSLog(@"大B获取商品分类接口  返回异常编码 errorMessage = %@",[dic objectForKey:@"errorMessage"]);
        }
        
        NSLog(@"dic = %@",dic);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"testGetGoodsCategoryList 失败");
        NSLog(@"The error description is %@\n",[error localizedDescription]);
        
    } ];
    
    return;
    
}


//	3.13  商品列表（店铺展示）接口
void testGetShopGoodsList()
{
    NSNumber *pageNo = [[NSNumber alloc] initWithInt:1];
    NSNumber *pageSize = [[NSNumber alloc] initWithInt:20];
    NSString *structureNo = @"";
    NSString *queryTime = @"7";
    NSString *goodsType = @"0";
    
    [HttpManager sendHttpRequestForGetShopGoodsList:pageNo pageSize:pageSize structureNo:structureNo queryTime:queryTime goodsType:goodsType success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            NSLog(@" 商品列表（店铺展示）接口  返回正常编码");
            NSLog(@"dic = %@",dic);

            if ([[dic objectForKey:@"data"] isKindOfClass:[NSDictionary class]])
            {
                GetShopGoodsListDTO *getShopGoodsListDTO = [[GetShopGoodsListDTO alloc ]init];
                [getShopGoodsListDTO setDictFrom:[dic objectForKey:@"data"]];
//                ShopGoodsDTO *shopGoodsDTO = [[ShopGoodsDTO alloc ]init];
                
//                NSLog(@"The operateStatus is %@\n",getShopGoodsListDTO.operateStatus);
//                NSLog(@"The totalCount is %d\n",getShopGoodsListDTO.totalCount.intValue);
//                
//                long count = [getShopGoodsListDTO.ShopGoodsDTOList count];
//                
//                NSLog(@"The count is %ld\n",count);
//                for( int index =0; index <count; index ++){
//                    NSDictionary *Dictionary = [getShopGoodsListDTO.ShopGoodsDTOList objectAtIndex:index];
//                    [shopGoodsDTO setDictFrom:Dictionary];
//                    NSLog(@"The goodsNo is %@\n",shopGoodsDTO.goodsNo);
//                    NSLog(@"The goodsName is %@\n",shopGoodsDTO.goodsName);
//                    NSLog(@"The goodsType is %@\n",shopGoodsDTO.goodsType);
//                }
            }
        }else{
            
            NSLog(@"商品列表（店铺展示）接口  返回异常编码 errorMessage = %@",[dic objectForKey:@"errorMessage"]);
        }
        
        NSLog(@"dic = %@",dic);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"testGetShopGoodsList 失败");
        NSLog(@"The error description is %@\n",[error localizedDescription]);
        
    } ];
    
    return;
    
}

//	3.14  商品列表（可编辑）接口
void testGetEditGoodsList()
{
    EditGoodsModel* editGoodsModel = [[EditGoodsModel alloc] init];
    editGoodsModel.goodsStatus = @"2";
    editGoodsModel.pageNo = [[NSNumber alloc] initWithInt:1];
    editGoodsModel.pageSize = [[NSNumber alloc] initWithInt:20];
    //测试条件一
//    editGoodsModel.queryType = @"0";
//    editGoodsModel.param = @"32432";
    
    //测试条件二
    editGoodsModel.queryType = @"";
    editGoodsModel.param = @"";
    
    [HttpManager sendHttpRequestForGetEditGoodsList:editGoodsModel success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
          NSLog(@"dic = %@",dic);
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            NSLog(@" 商品列表（可编辑）接口  返回正常编码");
            if ([[dic objectForKey:@"data"] isKindOfClass:[NSDictionary class]])
            {
                GetEditGoodsListDTO *getEditGoodsListDTO = [[GetEditGoodsListDTO alloc ]init];
                [getEditGoodsListDTO setDictFrom:[dic objectForKey:@"data"]];
                EditGoodsDTO *editGoodsDTO = [[EditGoodsDTO alloc ]init];
                
                NSLog(@"The totalCount is %d\n",getEditGoodsListDTO.totalCount.intValue);
                
                long count = [getEditGoodsListDTO.EditGoodsDTOList count];
                
                NSLog(@"The count is %ld\n",count);
                for( int index =0; index <count; index ++){
                    NSDictionary *Dictionary = [getEditGoodsListDTO.EditGoodsDTOList objectAtIndex:index];
                    [editGoodsDTO setDictFrom:Dictionary];
                    NSLog(@"The goodsWillNo is %@\n",editGoodsDTO.goodsWillNo);
                    NSLog(@"The goodsNo is %@\n",editGoodsDTO.goodsNo);
                    NSLog(@"The goodsName is %@\n",editGoodsDTO.goodsName);
                   // NSLog(@"The goodsType is %@\n",editGoodsDTO.goodsType);
                }
            }
            
        }else{
            
            NSLog(@"商品列表（可编辑）接口  返回异常编码 errorMessage = %@",[dic objectForKey:@"errorMessage"]);
        }
        
      
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"testGetEditGoodsList 失败");
        NSLog(@"The error description is %@\n",[error localizedDescription]);
        
    } ];
    
    return;
    
}

//	3.15	大B商品详情接口
void testGetGoodsInfoList()
{
    //NSString* goodsNo =  @"00000005";
    //NSString* goodsNo =  @"00000004";
    NSString* goodsNo =  @"00000050";
    
    [HttpManager sendHttpRequestForGetGoodsInfoList:goodsNo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
         NSLog(@"dic = %@",dic);
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            NSLog(@" 大B商品详情接口  返回正常编码");
            if ([[dic objectForKey:@"data"] isKindOfClass:[NSDictionary class]])
            {
                GetGoodsInfoListDTO *getGoodsInfoListDTO = [[GetGoodsInfoListDTO alloc ]init];
                [getGoodsInfoListDTO setDictFrom:[dic objectForKey:@"data"]];
                StepDTO *stepDTO = [[StepDTO alloc ]init];
                PicDTO *picDTO = [[PicDTO alloc ]init];
                SkuDTO *skuDTO = [[SkuDTO alloc ]init];
                
                long stepListCount = [getGoodsInfoListDTO.stepDTOList count];
                long skuListCount = [getGoodsInfoListDTO.skuDTOList count];
                
                NSLog(@"The goodsName is %@\n",getGoodsInfoListDTO.goodsName);
                NSLog(@"The stepListCount is %ld\n",stepListCount);
                NSLog(@"The skuListCount is %ld\n",skuListCount);
                
                for( int index =0; index <stepListCount; index ++){
                    NSDictionary *Dictionary = [getGoodsInfoListDTO.stepDTOList objectAtIndex:index];
                    [stepDTO setDictFrom:Dictionary];
                    NSLog(@"The goodsNo is %@\n",stepDTO.goodsNo);
                    NSLog(@"The minNum is %ld\n",(long)[stepDTO.minNum integerValue]);
                    NSLog(@"The maxNum is %ld\n",(long)[stepDTO.maxNum integerValue]);
                }
                //referImageList
                
                long referImageCount = [getGoodsInfoListDTO.referImageList count];
                NSLog(@"The referImageList count is %ld\n",referImageCount);
                
                for( int index =0; index <referImageCount; index ++){
                    NSDictionary *Dictionary = [getGoodsInfoListDTO.referImageList objectAtIndex:index];
                    [picDTO setDictFrom:Dictionary];
                    NSLog(@"The picName is %@\n",picDTO.picName);
                }
                
                //objectiveImageList
                long objectiveImageCount = [getGoodsInfoListDTO.objectiveImageList count];
                NSLog(@"The objectiveImageList count is %ld\n",objectiveImageCount);
                
                for( int index =0; index <objectiveImageCount; index ++){
                    NSDictionary *Dictionary = [getGoodsInfoListDTO.objectiveImageList objectAtIndex:index];
                    [picDTO setDictFrom:Dictionary];
                    NSLog(@"The picName is %@\n",picDTO.picName);
                }
                
                //windowImageList
                long windowImageCount = [getGoodsInfoListDTO.windowImageList count];
                NSLog(@"The windowImageList count is %ld\n",windowImageCount);
                
                for( int index =0; index <windowImageCount; index ++){
                    NSDictionary *Dictionary = [getGoodsInfoListDTO.windowImageList objectAtIndex:index];
                    [picDTO setDictFrom:Dictionary];
                    NSLog(@"The picName is %@\n",picDTO.picName);
                }

                for( int index =0; index <skuListCount; index ++){
                    NSDictionary *Dictionary = [getGoodsInfoListDTO.skuDTOList objectAtIndex:index];
                    [skuDTO setDictFrom:Dictionary];
                    NSLog(@"The goodsNo is %@\n",skuDTO.skuNo);
                    NSLog(@"The skuName is %@\n",skuDTO.skuName);
                    NSLog(@"The sort is %@\n",skuDTO.sort);
                    NSLog(@"The showStockFlag is %@\n",skuDTO.showStockFlag);
                }
                
                
                /****************************修改商品信息************************/
                
                getGoodsInfoListDTO.goodsName = @"最大衣服,最好看";
                getGoodsInfoListDTO.sampleFlag = @"1";
                getGoodsInfoListDTO.samplePrice = [[NSNumber alloc] initWithDouble:607.0f];
                
                NSMutableArray  *skuDTOArray = getGoodsInfoListDTO.skuDTOList;
                NSMutableArray  *newSkuDTOArray = [[NSMutableArray alloc]init];
                
                for (int index = 0; index < [skuDTOArray count]; index ++ ) {
                    NSDictionary *skuDictionary = [skuDTOArray objectAtIndex:index];
                    [skuDTO setDictFrom:skuDictionary];
                    
                    skuDTO.showStockFlag = @"0";
                    
                    [newSkuDTOArray addObject:[skuDTO getDictFrom:skuDTO]];
                    getGoodsInfoListDTO.skuDTOList = newSkuDTOArray;
                }

                
                NSMutableArray  *stepDTOArray = getGoodsInfoListDTO.stepDTOList;
                NSMutableArray  *newStepDTOArray = [[NSMutableArray alloc]init];
                
                for (int index = 0; index < [stepDTOArray count]; index ++ ) {
                    NSDictionary *stepDictionary = [stepDTOArray objectAtIndex:index];
                    [stepDTO setDictFrom:stepDictionary];

                    if (index == 0) {
                        stepDTO.price = [[NSNumber alloc] initWithDouble:40.0f];
                        stepDTO.minNum = [[NSNumber alloc] initWithInt:100];
                        stepDTO.maxNum = [[NSNumber alloc] initWithInt:1000];
                        stepDTO.sort = [[NSNumber alloc] initWithInt:1];
                    }
                    if (index == 1) {
                        stepDTO.price = [[NSNumber alloc] initWithDouble:50.0f];
                        stepDTO.minNum = [[NSNumber alloc] initWithInt:1001];
                        stepDTO.maxNum = [[NSNumber alloc] initWithInt:1501];
                        stepDTO.sort = [[NSNumber alloc] initWithInt:2];
                    }
                    [newStepDTOArray addObject:[stepDTO getDictFrom:stepDTO]];
                     getGoodsInfoListDTO.stepDTOList = newStepDTOArray;
                }
                
                [HttpManager sendHttpRequestForGetUpdateGoodsInfo:getGoodsInfoListDTO success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    
                    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                    
                    if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
                        
                        NSLog(@" 大B商品修改接口  返回正常编码");
                        
                    }else{
                        
                        NSLog(@"大B商品修改接口  返回异常编码 errorMessage = %@",[dic objectForKey:@"errorMessage"]);
                    }
                    
                    NSLog(@"dic = %@",dic);
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    
                    NSLog(@"testGetUpdateGoodsInfo 失败");
                    NSLog(@"The error description is %@\n",[error localizedDescription]);
                    
                } ];
                

            }
        }else{
            
            NSLog(@"大B商品详情接口  返回异常编码 errorMessage = %@",[dic objectForKey:@"errorMessage"]);
        }
        
       
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"testGetGoodsInfoList 失败");
        NSLog(@"The error description is %@\n",[error localizedDescription]);
        
    } ];
    
    return;
    
}

//3.16	大B商品修改接口
void testGetUpdateGoodsInfo()
{
    UpdateGoodsInfoModel *updateGoodsInfoModel = [[UpdateGoodsInfoModel alloc] init];
    GoodsInfoSkuDTOModel* firstSkuDTOModel = [[GoodsInfoSkuDTOModel alloc] init];
    GoodsInfoSkuDTOModel* secondSkuDTOModel = [[GoodsInfoSkuDTOModel alloc] init];
    GoodsInfoStepDTOModel* firstStepDTOModel = [[GoodsInfoStepDTOModel alloc] init];
    GoodsInfoStepDTOModel* secondStepDTOModel = [[GoodsInfoStepDTOModel alloc] init];
    
    NSMutableArray* SkuDTOModelArray = [[NSMutableArray alloc] init];
    NSMutableArray* StepDTOModelArray = [[NSMutableArray alloc] init];
    
    updateGoodsInfoModel.goodsNo = @"00000006";
    updateGoodsInfoModel.goodsStatus = @"0";
    updateGoodsInfoModel.goodsName = @"大包子外套";
    updateGoodsInfoModel.price = [[NSNumber alloc] initWithDouble:200.0];
    updateGoodsInfoModel.sampleFlag = @"1";
    updateGoodsInfoModel.samplePrice = [[NSNumber alloc] initWithDouble:300.0];
    
    firstSkuDTOModel.skuNo = @"1";
    firstSkuDTOModel.showStockFlag = @"1";
    
    secondSkuDTOModel.skuNo = @"2";
    secondSkuDTOModel.showStockFlag = @"2";
    
    firstStepDTOModel.Id = [[NSNumber alloc] initWithInt:1];
    firstStepDTOModel.price = [[NSNumber alloc] initWithDouble:10.0];
    firstStepDTOModel.minNum = [[NSNumber alloc] initWithInt:1];
    firstStepDTOModel.maxNum = [[NSNumber alloc] initWithInt:10];
    
    secondStepDTOModel.Id = [[NSNumber alloc] initWithInt:2];
    secondStepDTOModel.price = [[NSNumber alloc] initWithDouble:20.0];
    secondStepDTOModel.minNum = [[NSNumber alloc] initWithInt:11];
    secondStepDTOModel.maxNum = [[NSNumber alloc] initWithInt:20];
    
    NSDictionary *currentDictionary;
    
    currentDictionary = [firstSkuDTOModel getDictFrom:firstSkuDTOModel];
    [SkuDTOModelArray addObject:currentDictionary];
    
    currentDictionary = [secondSkuDTOModel getDictFrom:secondSkuDTOModel];
    [SkuDTOModelArray addObject:currentDictionary];
    
    currentDictionary = [firstStepDTOModel getDictFrom:firstStepDTOModel];
    [StepDTOModelArray addObject:currentDictionary];
    currentDictionary = [secondStepDTOModel getDictFrom:secondStepDTOModel];
    [StepDTOModelArray addObject:currentDictionary];
    
    updateGoodsInfoModel.updateGoodsInfoSkuDTOModelList = SkuDTOModelArray;
    updateGoodsInfoModel.updateGoodsInfoStepDTOModelList = StepDTOModelArray;
    
    [HttpManager sendHttpRequestForGetUpdateGoodsInfo:updateGoodsInfoModel success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            NSLog(@" 大B商品修改接口  返回正常编码");
            
        }else{
            
            NSLog(@"大B商品修改接口  返回异常编码 errorMessage = %@",[dic objectForKey:@"errorMessage"]);
        }
        
        NSLog(@"dic = %@",dic);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"testGetUpdateGoodsInfo 失败");
        NSLog(@"The error description is %@\n",[error localizedDescription]);
        
    } ];
    
    return;
    
}

//3.17	邮费专拍详情接口
void testGetGoodsFeeInfo()
{
    
    [HttpManager sendHttpRequestForGetGoodsFeeInfo:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        NSLog(@"dic = %@",dic);
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请求成功" message:[dic objectForKey:@"errorMessage"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            
            [alert show];
            //参数需要保存
            if ([[dic objectForKey:@"data"] isKindOfClass:[NSDictionary class]])
            {
                GetGoodsFeeInfoDTO *getGoodsFeeInfoDTO = [[GetGoodsFeeInfoDTO alloc] init];
                [getGoodsFeeInfoDTO setDictFrom:[dic objectForKey:@"data"]];
                NSLog(@"@the goodsName is %@\n",getGoodsFeeInfoDTO.goodsName);
                NSLog(@"@the goodsNo is %@\n",getGoodsFeeInfoDTO.goodsNo);
                
                //skuList
                SkuListDTO *skuListDTO = [[SkuListDTO alloc] init];
                long skuListCount = [getGoodsFeeInfoDTO.skuList count];
                NSLog(@"The skuListCount is %ld\n",skuListCount);
                
                for( int index =0; index <skuListCount; index ++){
                    NSDictionary *Dictionary = [getGoodsFeeInfoDTO.skuList objectAtIndex:index];
                    [skuListDTO setDictFrom:Dictionary];
                    NSLog(@"The showStockFlag is %@\n",skuListDTO.showStockFlag);
                }
                
            }
            
            
        }else{
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请求失败" message:[dic objectForKey:@"errorMessage"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            
            [alert show];
             NSLog(@"大B商品修改接口  返回异常编码 errorMessage = %@",[dic objectForKey:@"errorMessage"]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",[NSString stringWithFormat:@"%@",error]);
    }];

}
//3.17	大B商品上下架操作接口
void testGetUpdateGoodsStatus()
{
    UpdateGoodsStatusModel *updateGoodsStatusModel = [[UpdateGoodsStatusModel alloc] init];
    
    updateGoodsStatusModel.goodsStatus = @"3";
    updateGoodsStatusModel.goodsNo = @"00000004,00000005";
    
    [HttpManager sendHttpRequestForGetUpdateGoodsStatus:updateGoodsStatusModel success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        NSLog(@"dic = %@",dic);
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            NSLog(@" 大B商品上下架操作接口  返回正常编码");
            
        }else{
            
            //大 B 商品上下架操作接口 返回异常编码 失败 返回正常编码 进一步促进产业结构调整 蛋蛋
            NSLog(@" 大B商品上下架操作接口  返回异常编码 errorMessage = %@",[dic objectForKey:@"errorMessage"]);
        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"testGetUpdateGoodsStatus 失败");
        NSLog(@"The error description is %@\n",[error localizedDescription]);
        
    } ];
    
    return;
}

//3.18	大B站内信列表
void testGetNoticeStationList()
{
        NSNumber* pageNo =  [[NSNumber alloc] initWithInt:1];
        NSNumber* pageSize =  [[NSNumber alloc] initWithInt:20];
    
        [HttpManager sendHttpRequestForGetNoticeStationList:pageNo pageSize:pageSize success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            NSLog(@" 大B站内信列表  返回正常编码");
            NSLog(@"dic = %@",dic);
            if ([[dic objectForKey:@"data"] isKindOfClass:[NSDictionary class]])
            {
                GetNoticeStationListDTO *getNoticeStationListDTO = [[GetNoticeStationListDTO alloc ]init];
                [getNoticeStationListDTO setDictFrom:[dic objectForKey:@"data"]];
                NoticeStationDTO *noticeStationDTO = [[NoticeStationDTO alloc ]init];
                
                NSLog(@"The totalCount is %@\n",getNoticeStationListDTO.totalCount);
                
                long count = [getNoticeStationListDTO.noticeStationDTOList count];
                NSLog(@"The count is %ld\n",count);
                
                for( int index =0; index <count; index ++){
                    NSDictionary *Dictionary = [getNoticeStationListDTO.noticeStationDTOList objectAtIndex:index];
                    [noticeStationDTO setDictFrom:Dictionary];
                    NSLog(@"The infoTitle is %@\n",noticeStationDTO.infoTitle);
                    
                }
            }
            
        }else{
            
            NSLog(@"大B站内信列表  返回异常编码 errorMessage = %@",[dic objectForKey:@"errorMessage"]);
        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"testGetNoticeStationList 失败");
        NSLog(@"The error description is %@\n",[error localizedDescription]);
        
    } ];
    
    return;
    
}


//3.19	大B站内信阅读状态修改接口
void testGetUpdateNoticeStatus()
{
    NSString * Id = @"1";
    
    [HttpManager sendHttpRequestForGetUpdateNoticeStatus:Id success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            NSLog(@" 大B站内信阅读状态修改接口  返回正常编码");
            
        }else{
            
            NSLog(@"大B站内信阅读状态修改接口 返回异常编码 errorMessage = %@",[dic objectForKey:@"errorMessage"]);
        }
        
        NSLog(@"dic = %@",dic);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"testGetUpdateNoticeStatus 失败");
        NSLog(@"The error description is %@\n",[error localizedDescription]);
        
    } ];
    
    return;
    
}

//3.20	大B图片七日内下载限制设置接口
void testGetImgDownloadSetting()
{
    NSString * downloadLimit7 = @"1";
    
    [HttpManager sendHttpRequestForGetImgDownloadSetting:downloadLimit7 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            NSLog(@"大B图片七日内下载限制设置接口  返回正常编码");
            
        }else{
            
            NSLog(@"大B图片七日内下载限制设置接口 返回异常编码 errorMessage = %@",[dic objectForKey:@"errorMessage"]);
        }
        
        NSLog(@"dic = %@",dic);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"testGetImgDownloadSetting 失败");
        NSLog(@"The error description is %@\n",[error localizedDescription]);
        
    } ];
    
    return;
    
}

//3.21	大B商品下载图片列表接口
void testGetImgDownloadList()
{
    NSString *goodsNo = @"00000005";
    NSString *downLoadType =@"3";
    
//    [HttpManager sendHttpRequestForGetImgDownloadList:goodsNo downLoadType:downLoadType success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
//        
//        
//        NSLog(@" 大B商品下载图片列表接口  返回正常编码");
//        if ([[dic objectForKey:@"data"] isKindOfClass:[NSDictionary class]])
//        {
//            GetImgDownloadListDTO *getImgDownloadListDTO = [[GetImgDownloadListDTO alloc ]init];
//            ImgDownloadDTO *imgDownloadDTO = [[ImgDownloadDTO alloc ]init];
//            PictureDTO *pictureDTO = [[PictureDTO alloc] init];
//            
//            getImgDownloadListDTO.imgDownloadListDTOList = [dic objectForKey:@"data"];
//            long count = [getImgDownloadListDTO.imgDownloadListDTOList count];
//            NSLog(@"The count is %ld\n",count);
//            
//            for( int index =0; index <count; index ++){
//                NSDictionary *Dictionary = [getImgDownloadListDTO.imgDownloadListDTOList objectAtIndex:index];
//                [imgDownloadDTO setDictFrom:Dictionary];
//                NSLog(@"The goodsNo is %@\n",imgDownloadDTO.goodsNo);
//                NSLog(@"The picSize is %@\n",imgDownloadDTO.picSize);
//                
//                 long picCount = [imgDownloadDTO.pictureDTOList count];
//                for(int index = 0;index < picCount;index ++)
//                {
//                    NSDictionary *Dictionary = [imgDownloadDTO.pictureDTOList objectAtIndex:index];
//                    [pictureDTO setDictFrom:Dictionary];
//                    NSLog(@"The picSize is %@\n",pictureDTO.picSize);
//                }
//            }
//            
//
//            
//            
//        }else{
//            
//            NSLog(@"大B商品下载图片列表接口 返回异常编码 errorMessage = %@",[dic objectForKey:@"errorMessage"]);
//        }
//        
//        NSLog(@"dic = %@",dic);
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//        NSLog(@"testGetImgDownloadList 失败");
//        NSLog(@"The error description is %@\n",[error localizedDescription]);
//        
//    } ];
//    
//    return;
    
}

//3.22	大B图片下载完成回调接口
//void testGetImgDownCallback()
//{
//    
//    ImageDownloadCallbackModel *imageDownloadCallbackModel = [[ImageDownloadCallbackModel alloc] init];
//    
//    imageDownloadCallbackModel.goodsNo = @"1";
//    imageDownloadCallbackModel.picType = @"0";
//
//    
//    [HttpManager sendHttpRequestForGetImageDownloadCallBackList:imageDownloadCallbackModel  success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
//        
//        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
//            
//            NSLog(@" 大B图片下载完成回调接口  返回正常编码");
//            
//            
//        }else{
//            
//            NSLog(@" 大B图片下载完成回调接口 返回异常编码 errorMessage = %@",[dic objectForKey:@"errorMessage"]);
//        }
//        
//        NSLog(@"dic = %@",dic);
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//        NSLog(@"testGetImgDownCallback 失败");
//        NSLog(@"The error description is %@\n",[error localizedDescription]);
//        
//    } ];
//    
//    return;
//    
//}

//3.23	大B商品图片下载历史查询接口
void testGetImgHistoryCallback()
{
   
    NSNumber* pageNo  = [[NSNumber alloc]initWithInt:2];
    NSNumber *pageSize = [[NSNumber alloc]initWithInt:20];
    
    [HttpManager sendHttpRequestForGetImageHistoryList:pageNo pageSize:pageSize success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            NSLog(@" 大B商品图片下载历史查询接口  返回正常编码");
            
            if ([[dic objectForKey:@"data"] isKindOfClass:[NSDictionary class]])
            {
                GetImageHistoryListDTO *getImageHistoryListDTO = [[GetImageHistoryListDTO alloc ]init];
                ImageHistoryDTO *imageHistoryDTO = [[ImageHistoryDTO alloc ]init];
                HistoryPictureDTO *historyPictureDTO = [[HistoryPictureDTO alloc] init];
                
                [getImageHistoryListDTO setDictFrom:[dic objectForKey:@"data"]];
                long count = [getImageHistoryListDTO.imageHistoryDTOList count];
                NSLog(@"The count is %ld\n",count);
                
                for( int index =0; index <count; index ++){
                    NSDictionary *Dictionary = [getImageHistoryListDTO.imageHistoryDTOList objectAtIndex:index];
                    [imageHistoryDTO setDictFrom:Dictionary];
                    NSLog(@"The goodsNo is %@\n",imageHistoryDTO.goodsNo);
                    
                    long picCount = [imageHistoryDTO.historyPictureDTOList count];
                    for(int index = 0;index < picCount;index ++)
                    {
                        NSDictionary *Dictionary = [imageHistoryDTO.historyPictureDTOList objectAtIndex:index];
                        [historyPictureDTO setDictFrom:Dictionary];
                        NSLog(@"The picSize is %@\n",historyPictureDTO.picSize);
                    }

                }
            }
            
            
        }else{
            
            NSLog(@" 大B商品图片下载历史查询接口 返回异常编码 errorMessage = %@",[dic objectForKey:@"errorMessage"]);
        }
        
        NSLog(@"dic = %@",dic);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"testGetImgHistoryCallback 失败");
        NSLog(@"The error description is %@\n",[error localizedDescription]);
        
    } ];
    
    return;
    
}

//3.24	商家等级权限说明接口
void testGetMerchantPermissionList()
{
    
    [HttpManager sendHttpRequestForGetMerchantPermissionList:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            NSLog(@" 商家等级权限说明接口  返回正常编码");
            
            GetMerchantPermissionListDTO *getMerchantPermissionListDTO = [[GetMerchantPermissionListDTO alloc ]init];
            MerchantPermissionDTO *merchantPermissionDTO = [[MerchantPermissionDTO alloc ]init];

            getMerchantPermissionListDTO.merchantPermissionDTOList = [dic objectForKey:@"data"];
            
            long count = [getMerchantPermissionListDTO.merchantPermissionDTOList count];
            NSLog(@"The count is %ld\n",count);

            for( int index =0; index <count; index ++){
                NSDictionary *Dictionary = [getMerchantPermissionListDTO.merchantPermissionDTOList objectAtIndex:index];
                [merchantPermissionDTO setDictFrom:Dictionary];
                NSLog(@"The downloadAuthXb is %@\n",merchantPermissionDTO.downloadAuthXb);

            }
            
            
            
        }else{
            
            NSLog(@" 商家等级权限说明接口 返回异常编码 errorMessage = %@",[dic objectForKey:@"errorMessage"]);
            
        }
        
        NSLog(@"dic = %@",dic);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"testGetMerchantPermissionList 失败");
        NSLog(@"The error description is %@\n",[error localizedDescription]);
        
    } ];
    
    return;
    
}

//3.25	付费上架
void testGetPayMerchantOnsale()
{
    
    [HttpManager sendHttpRequestForGetPayMerchantOnsale:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            NSLog(@" 付费上架  返回正常编码");
            if ([[dic objectForKey:@"data"] isKindOfClass:[NSDictionary class]])
            {
                GetPayMerchantOnsaleDTO *getPayMerchantOnsaleDTO = [[GetPayMerchantOnsaleDTO alloc ]init];
                [getPayMerchantOnsaleDTO setDictFrom:[dic objectForKey:@"data"]];
                NSLog(@"The paySalePrice is %lf\n",[getPayMerchantOnsaleDTO.paySalePrice doubleValue]);
            }
            
        }else{
            
            NSLog(@" 付费上架 返回异常编码 errorMessage = %@",[dic objectForKey:@"errorMessage"]);
        }
        
        NSLog(@"dic = %@",dic);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"testGetPayMerchantOnsale 失败");
        NSLog(@"The error description is %@\n",[error localizedDescription]);
        
    } ];
    
    return;
    
}

//3.26	付费下载
void testGetPayMerchantDownload()
{
    
    [HttpManager sendHttpRequestForGetPayMerchantDownload:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            NSLog(@" 付费下载  返回正常编码");
            
            if ([[dic objectForKey:@"data"] isKindOfClass:[NSDictionary class]])
            {
                GetPayMerchantDownloadDTO *getPayMerchantDownloadDTO = [[GetPayMerchantDownloadDTO alloc ]init];
                [getPayMerchantDownloadDTO setDictFrom:[dic objectForKey:@"data"]];
                NSLog(@"The buyDownloadPrice is %lf\n",[getPayMerchantDownloadDTO.buyDownloadPrice doubleValue]);
            }
            
        }else{
            
            NSLog(@" 付费下载 返回异常编码 errorMessage = %@",[dic objectForKey:@"errorMessage"]);
        }
        
        NSLog(@"dic = %@",dic);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"testGetPayMerchantDownload 失败");
        NSLog(@"The error description is %@\n",[error localizedDescription]);
        NSString *errorMesg = [error localizedDescription];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"error " message:errorMesg delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
        [alert show];
        
    } ];
    
    return;
    
}

//3.27	无权限提示接口
void testGetMerchantNotAuthTip()
{
    
    NSString * authType = @"1";
    [HttpManager sendHttpRequestForGetMerchantNotAuthTip:authType success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            NSLog(@" 无权限提示接口  返回正常编码");
            if ([[dic objectForKey:@"data"] isKindOfClass:[NSDictionary class]])
            {
                GetMerchantNotAuthTipDTO *getMerchantNotAuthTipDTO = [[GetMerchantNotAuthTipDTO alloc ]init];
                [getMerchantNotAuthTipDTO setDictFrom:[dic objectForKey:@"data"]];
                NSLog(@"The integralNum is %lf\n",[getMerchantNotAuthTipDTO.integralNum doubleValue]);
            }
            
        }else{
            
            NSLog(@" 无权限提示接口 返回异常编码 errorMessage = %@",[dic objectForKey:@"errorMessage"]);
        }
        
        NSLog(@"dic = %@",dic);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"testGetMerchantNotAuthTip 失败");
        NSLog(@"The error description is %@\n",[error localizedDescription]);
        
    } ];
    
    return;
    
}

//3.28	大B销售统计接口
void testGetSalesStatisticsList()
{
    [HttpManager sendHttpRequestForGetPortalStatistics:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            NSLog(@" 大B销售统计接口  返回正常编码");
           if ([[dic objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
               
               GetPortalStatisticsDTO *getPortalStatisticsDTO = [[GetPortalStatisticsDTO alloc] init];
               MemberDTO* memberDTO = [[MemberDTO alloc] init];
               GoodsSellDTO *goodsSellDTO = [[GoodsSellDTO alloc] init];
               
               [getPortalStatisticsDTO setDictFrom:[dic objectForKey:@"data"]];
               NSUInteger memberCount = [getPortalStatisticsDTO.memberDTOList count];
               for (int index = 0; index < memberCount; index++) {
                   NSDictionary *dictionary = [getPortalStatisticsDTO.memberDTOList objectAtIndex:index];
                   [memberDTO setDictFrom:dictionary];
                   
               }
               NSUInteger goodsSellCount = [getPortalStatisticsDTO.memberDTOList count];
               for (int index = 0; index < goodsSellCount; index++) {
                   NSDictionary *dictionary = [getPortalStatisticsDTO.memberDTOList objectAtIndex:index];
                   [goodsSellDTO setDictFrom:dictionary];
                   
               }
            }
            
        }else{
            
            NSLog(@" 大B销售统计接口 返回异常编码 errorMessage = %@",[dic objectForKey:@"errorMessage"]);
        }
        
        NSLog(@"dic = %@",dic);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"testGetSalesStatisticsList 失败");
        NSLog(@"The error description is %@\n",[error localizedDescription]);
        
    } ];
    
    return;
    
}

//3.30	大B按照销售时间统计接口
void testGetSalesStatisticsByDateList()
{
    NSNumber *pastDays = [[NSNumber alloc] initWithInt:1];
    NSString* startDate = @"20150723163255";
    NSString* endDate = @"20150723163249";
   
    [HttpManager sendHttpRequestForGetOrderSalesPerDays:pastDays startDate:startDate endDate:endDate success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            NSLog(@" 大B销售统计接口  返回正常编码");
            if ([[dic objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                GetOrderSalesPerDaysDTO *getOrderSalesPerDaysDTO = [[GetOrderSalesPerDaysDTO alloc] init];
                SalesDTO *salesDTO = [[SalesDTO alloc] init];
                
                [getOrderSalesPerDaysDTO setDictFrom:[dic objectForKey:@"data"]];
                NSInteger salesCount = [getOrderSalesPerDaysDTO.salesDTOList count];
                for (int index = 0; index < salesCount; index ++) {
                    
                    [salesDTO setDictFrom:[getOrderSalesPerDaysDTO.salesDTOList objectAtIndex:index]];
                    
                }
                
            }
            
        }else{
            
            NSLog(@" 大B销售统计接口 返回异常编码 errorMessage = %@",[dic objectForKey:@"errorMessage"]);
        }
        
        NSLog(@"dic = %@",dic);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"testGetSalesStatisticsList 失败");
        NSLog(@"The error description is %@\n",[error localizedDescription]);
        
    } ];
    
    return;
    
}

//3.31	大B统计采购商接口
void testGetMemberTradeList()
{
    NSNumber *pastDays = [[NSNumber alloc] initWithInt:0];
    
    [HttpManager sendHttpRequestForGetPurchaserStatisticsPerDays:pastDays success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            NSLog(@" 大B按照时间统计采购商接口  返回正常编码");
            if ([[dic objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                GetPurchaserStatisticsPerDaysDTO *getPurchaserStatisticsPerDaysDTO = [[GetPurchaserStatisticsPerDaysDTO alloc] init];
                SalesStatisticsDTO *salesStatisticsDTO = [[SalesStatisticsDTO alloc] init];
                
                [getPurchaserStatisticsPerDaysDTO setDictFrom:[dic objectForKey:@"data"]];
                NSInteger salesCount = [getPurchaserStatisticsPerDaysDTO.salesStatisticsDTOList count];
                for (int index = 0; index < salesCount; index ++) {
                    
                    [salesStatisticsDTO setDictFrom:[getPurchaserStatisticsPerDaysDTO.salesStatisticsDTOList objectAtIndex:index]];
                    
                }
                
            }

            
        }else{
            
            NSLog(@" 大B按照时间统计采购商接口 返回异常编码 errorMessage = %@",[dic objectForKey:@"errorMessage"]);
        }
        
        NSLog(@"dic = %@",dic);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"testGetMemberTradeListList 失败");
        NSLog(@"The error description is %@\n",[error localizedDescription]);
        
    } ];
    
    return;
    
}

//3.32	大B单品统计接口
void testGetGoodsStatisticsList()
{
    NSNumber *queryType = [[NSNumber alloc]initWithInt:1];
    NSString *orderBy = @"1";
    
    [HttpManager sendHttpRequestForGetProductStatisticPerSale:queryType orderBy:orderBy success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            NSLog(@" 大B按照时间统计采购商接口  返回正常编码");
            GetProductStatisticPerSaleDTO *getProductStatisticPerSaleDTO = [[GetProductStatisticPerSaleDTO alloc] init];
            if ([[dic objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                [getProductStatisticPerSaleDTO setDictFrom:[dic objectForKey:@"data"]];
            }
            
        }else{
            
            NSLog(@" 大B按照时间统计采购商接口 返回异常编码 errorMessage = %@",[dic objectForKey:@"errorMessage"]);
        }
        
        NSLog(@"dic = %@",dic);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"testGetGoodsStatisticsListList 失败");
        NSLog(@"The error description is %@\n",[error localizedDescription]);
        
    } ];
    
    return;
    
}

//3.32	推荐商品记录列表接口
void testGetRecommendRecordList()
{
    NSNumber* pageNo = [[NSNumber alloc] initWithInt:1];
    NSNumber* pageSize = [[NSNumber alloc] initWithInt:20];;
    
    [HttpManager sendHttpRequestForGetRecommendRecordList:pageNo pageSize:pageSize  success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            NSLog(@"dic = %@",dic);
            NSLog(@" 推荐商品记录列表接口  返回正常编码");
            if ([[dic objectForKey:@"data"] isKindOfClass:[NSDictionary class]])
            {
                GetRecommendRecordListDTO *getRecommendRecordListDTO = [[GetRecommendRecordListDTO alloc ]init];
                RecommendRecordDTO *recommendRecordDTO = [[RecommendRecordDTO alloc ]init];
                GoodsPicDTO *goodsPicDTO = [[GoodsPicDTO alloc ]init];
                
                [getRecommendRecordListDTO setDictFrom:[dic objectForKey:@"data"]];
                long  count = [getRecommendRecordListDTO.recommendRecordDTOList count];
                
                NSLog(@"The count is %ld\n",count);
                
                for( int index =0; index <count; index ++){
                    NSDictionary *Dictionary = [getRecommendRecordListDTO.recommendRecordDTOList objectAtIndex:index];
                    [recommendRecordDTO setDictFrom:Dictionary];
                    NSLog(@"The createDate is %@\n",recommendRecordDTO.createDate);
                    
                    long GoodsPicCount = [recommendRecordDTO.GoodsPicDTOList count];
                    NSLog(@"The currentCount is %ld\n",GoodsPicCount);
                    for (int i =0; i <GoodsPicCount; i ++) {
                        NSDictionary *GoodsPicDictionary = [recommendRecordDTO.GoodsPicDTOList objectAtIndex:i];
                        [goodsPicDTO setDictFrom:GoodsPicDictionary];
                        NSLog(@"The goodsNo is %@\n",goodsPicDTO.goodsNo);
                        
                    }
                    
                    
                    
                }
            }
        }else{
            
            NSLog(@" 推荐商品记录列表接口 返回异常编码 errorMessage = %@",[dic objectForKey:@"errorMessage"]);
        }
        
        NSLog(@"dic = %@",dic);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"testGetRecommendRecordList 失败");
        NSLog(@"The error description is %@\n",[error localizedDescription]);
        
    } ];
    
    return;
    
}

//3.33	推荐商品记录详情接口
void testGetRecommendRecordDetailsList()
{
    NSNumber* Id = [[NSNumber alloc] initWithInt:35];
    
    [HttpManager sendHttpRequestForGetRecommendRecordDetailsList:Id success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            NSLog(@"dic = %@",dic);
            NSLog(@"推荐商品记录详情接口  返回正常编码");
            if ([[dic objectForKey:@"data"] isKindOfClass:[NSDictionary class]])
            {
                GetRecommendRecordDetailsListDTO *getRecommendRecordDetailsListDTO = [[GetRecommendRecordDetailsListDTO alloc ]init];
                GoodsPicDTO *goodsPicDTO = [[GoodsPicDTO alloc ]init];
//                RecommendMemberDTO *recommendMemberDTO = [[RecommendMemberDTO alloc ]init];
//                
//                [getRecommendRecordDetailsListDTO setDictFrom:[dic objectForKey:@"data"]];
//                
//                long goodsPicCount = [getRecommendRecordDetailsListDTO.goodsPicDTOList count];
//                long recommendMemberCount = [getRecommendRecordDetailsListDTO.recommendMemberDTOList count];
//                
//                NSLog(@"The goodsPicCount is %ld\n",goodsPicCount);
//                NSLog(@"The recommendMemberCount is %ld\n",recommendMemberCount);
//                
//                for (int i =0; i <goodsPicCount; i ++)
//                {
//                    NSDictionary *Dictionary = [getRecommendRecordDetailsListDTO.goodsPicDTOList objectAtIndex:i];
//                    [goodsPicDTO setDictFrom:Dictionary];
//                    NSLog(@"The goodsNo is %@\n",goodsPicDTO.goodsNo);
//                }
//                for (int i =0; i <recommendMemberCount; i ++)
//                {
//                    NSDictionary *Dictionary = [getRecommendRecordDetailsListDTO.recommendMemberDTOList objectAtIndex:i];
//                    [recommendMemberDTO setDictFrom:Dictionary];
//                    NSLog(@"The memberName is %@\n",recommendMemberDTO.memberName);
//                }
                
            }
            
        }else{
            
            NSLog(@" 推荐商品记录详情接口 返回异常编码 errorMessage = %@",[dic objectForKey:@"errorMessage"]);
        }
        
        NSLog(@"dic = %@",dic);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"testGetRecommendRecordDetailsList 失败");
        NSLog(@"The error description is %@\n",[error localizedDescription]);
        
    } ];
    
    return;
    
}

//3.34	推荐商品记录删除接口
void testGetDeleteRecommendRecord()
{
    NSString *ids = @"29";
    
    [HttpManager sendHttpRequestForDeleteRecommendRecord:ids success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            NSLog(@" 推荐商品记录删除接口  返回正常编码");
            
            
        }else{
            
            NSLog(@" 推荐商品记录删除接口 返回异常编码 errorMessage = %@",[dic objectForKey:@"errorMessage"]);
        }
        
        NSLog(@"dic = %@",dic);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"testGetDeleteRecommendRecord 失败");
        NSLog(@"The error description is %@\n",[error localizedDescription]);
        
    } ];
    
    return;
    
}

//3.35	推荐商品收件人列表接口
void testGetRecommendReceiverList()
{
    NSNumber *pageNo = [[NSNumber alloc] initWithInt:1];
    NSNumber *pageSize = [[NSNumber alloc] initWithInt:20];
    NSString *dayNum = @"10";
    

    [HttpManager sendHttpRequestForGetRecommendReceiverList:pageNo pageSize:pageSize dayNum:dayNum success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            NSLog(@"dic = %@",dic);
            NSLog(@"推荐商品收件人列表接口  返回正常编码");
            if ([[dic objectForKey:@"data"] isKindOfClass:[NSDictionary class]])
            {
                GetRecommendReceiverListDTO *getRecommendReceiverListDTO = [[GetRecommendReceiverListDTO alloc ]init];

                RecommendReceiverDTO *recommendReceiverDTO = [[RecommendReceiverDTO alloc ]init];
                [getRecommendReceiverListDTO setDictFrom:[dic objectForKey:@"data"]];
                
                long count = [getRecommendReceiverListDTO.recommendReceiverDTOList count];
                NSLog(@"The count is %ld\n",count);
                
                for( int index =0; index <count; index ++){
                    NSDictionary *Dictionary = [getRecommendReceiverListDTO.recommendReceiverDTOList objectAtIndex:index];
                    [recommendReceiverDTO setDictFrom:Dictionary];
                    NSLog(@"The memberNo is %@\n",recommendReceiverDTO.memberNo);
                }
            }
            
        }else{

            NSLog(@" 推荐商品收件人列表接口 返回异常编码 errorMessage = %@",[dic objectForKey:@"errorMessage"]);
        }
        
        NSLog(@"dic = %@",dic);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"testGetRecommendRecordDetailsList 失败");
        NSLog(@"The error description is %@\n",[error localizedDescription]);
        
    } ];
    
    return;
    
}

//3.36	推荐商品记录发送接口
void testSaveGoodsRecommend()
{
    SaveGoodsRecommendModel *saveGoodsRecommendModel = [[SaveGoodsRecommendModel alloc] init];
    saveGoodsRecommendModel.goodsNum = [[NSNumber alloc] initWithInt:1];
    
    saveGoodsRecommendModel.content = @"aaaaaaaaaaaaaaaa";
    saveGoodsRecommendModel.goodsNos = @"10000056,00000004,10000047";
    saveGoodsRecommendModel.memberNos = @"M000000053,M000000002";
    
    [HttpManager sendHttpRequestForGetSaveGoodsRecommend:saveGoodsRecommendModel success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            NSLog(@"推荐商品记录发送接口  返回正常编码");
            SaveGoodsRecommendDTO *saveGoodsRecommendDTO = [[SaveGoodsRecommendDTO alloc] init];
            [saveGoodsRecommendDTO setDictFrom:[dic objectForKey:@"data"]];
            
            MemberChatDTO *memberChatDTO = [[MemberChatDTO alloc] init];
            GoodsDTO *goodsDTO = [[GoodsDTO alloc]init];
            
            NSInteger memberChatListCount = [saveGoodsRecommendDTO.memberChatList count];
            NSInteger goodsListCount = [memberChatDTO.goodsList count];
            
            for (int index = 0; index < memberChatListCount; index++) {
                [memberChatDTO setDictFrom:[saveGoodsRecommendDTO.memberChatList objectAtIndex:index]];
                
            }
            
            for (int index = 0; index < goodsListCount; index++) {
                [goodsDTO setDictFrom:[memberChatDTO.goodsList objectAtIndex:index]];
                
            }
            
        }else{
            
            NSLog(@" 推荐商品记录发送接口 返回异常编码 errorMessage = %@",[dic objectForKey:@"errorMessage"]);
        }
        
        NSLog(@"dic = %@",dic);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"testSaveGoodsRecommend 失败");
        NSLog(@"The error description is %@\n",[error localizedDescription]);
        
    } ];
    
    return;
    
}

//3.37	采购商-有交易的会员的列表接口
void testSecondGetMemberTradeList()
{
    NSString *orderBy = @"1";
    NSNumber*pageNo = [[NSNumber alloc] initWithInt:1];
    NSNumber*pageSize = [[NSNumber alloc] initWithInt:20];
    
    
    [HttpManager sendHttpRequestForGetMemberTradeList:orderBy pageNo: pageNo  pageSize: pageSize success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"dic = %@",dic);
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            NSLog(@"采购商-有交易的会员的列表接口  返回正常编码");
            
            if ([[dic objectForKey:@"data"] isKindOfClass:[NSDictionary class]])
            {
                GetMemberTradeListDTO *getMemberTradeListDTO = [[GetMemberTradeListDTO alloc] init];
                
                [getMemberTradeListDTO setDictFrom:[dic objectForKey:@"data"]];
                MemberTradeDTO *memberTradeDTO = [[MemberTradeDTO alloc ]init];
                
                long count = [getMemberTradeListDTO.memberTradeDTOList count];
                NSLog(@"The count is %ld\n",count);
                
                for( int index =0; index <count; index ++){
                    NSDictionary *Dictionary = [getMemberTradeListDTO.memberTradeDTOList objectAtIndex:index];
                    [memberTradeDTO setDictFrom:Dictionary];
                    NSLog(@"The mobilePhone is %@\n",memberTradeDTO.mobilePhone);
                }
            }
            
        }else{
            
            NSLog(@" 采购商-有交易的会员的列表接口 返回异常编码 errorMessage = %@",[dic objectForKey:@"errorMessage"]);
        }
        
        NSLog(@"dic = %@",dic);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"testSecondGetMemberTradeList 失败");
        NSLog(@"The error description is %@\n",[error localizedDescription]);
        
    } ];
    
    return;
    
}

//3.38	采购商-我邀请的会员的列表接口
void testSecondGetMemberInviteList()
{
    NSString *orderBy = @"3";
    NSNumber*pageNo = [[NSNumber alloc] initWithInt:1];
    NSNumber*pageSize = [[NSNumber alloc] initWithInt:20];
    
    
    [HttpManager sendHttpRequestForGetMemberInviteList:orderBy pageNo: pageNo  pageSize: pageSize success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"dic = %@",dic);
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            NSLog(@"采购商-我邀请的会员的列表接口  返回正常编码");
            if ([[dic objectForKey:@"data"] isKindOfClass:[NSDictionary class]])
            {
                GetMemberInviteListDTO *getMemberInviteListDTO = [[GetMemberInviteListDTO alloc] init];
                
                [getMemberInviteListDTO setDictFrom:[dic objectForKey:@"data"]];
                long count = [getMemberInviteListDTO.memberInviteDTOList count];
                NSLog(@"The count is %ld\n",count);
            }
        }else{
            
            NSLog(@" 采购商-我邀请的会员的列表接口 返回异常编码 errorMessage = %@",[dic objectForKey:@"errorMessage"]);
        }
        
        NSLog(@"dic = %@",dic);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"testSecondGetMemberInviteList 失败");
        NSLog(@"The error description is %@\n",[error localizedDescription]);
        
    } ];
    
    return;
    
}
//3.39	采购商-黑名单列表接口
void testGetMemberBlackList()
{

    [HttpManager sendHttpRequestForGetMemberBlackList:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            NSLog(@"采购商-黑名单列表接口  返回正常编码");
            if ([[dic objectForKey:@"data"] isKindOfClass:[NSDictionary class]])
            {
                GetMemberBlackListDTO *getMemberBlackListDTO = [[GetMemberBlackListDTO alloc] init];
                
                [getMemberBlackListDTO setDictFrom:[dic objectForKey:@"data"]];
                MemberBlackDTO *memberBlackDTO = [[MemberBlackDTO alloc ]init];
                
                long count = [getMemberBlackListDTO.memberBlackDTOList count];
                NSLog(@"The count is %ld\n",count);
                
                for( int index =0; index <count; index ++){
                    NSDictionary *Dictionary = [getMemberBlackListDTO.memberBlackDTOList objectAtIndex:index];
                    [memberBlackDTO setDictFrom:Dictionary];
                    NSLog(@"The memberName is %@\n",memberBlackDTO.memberName);
                }
            }
            
        }else{
            
            NSLog(@" 采购商-黑名单列表接口 返回异常编码 errorMessage = %@",[dic objectForKey:@"errorMessage"]);
        }
        
        NSLog(@"dic = %@",dic);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"testSecondGetMemberInviteList 失败");
        NSLog(@"The error description is %@\n",[error localizedDescription]);
        
    } ];
    
    return;
    
}

//3.40	采购商-黑名单设置接口
void testGetUpdateMemberBlackList()
{
    
    NSString*  memberNo =@"M000000053";
    NSString*  blackListFlag = @"1";
    
    [HttpManager sendHttpRequestForGetUpdateMemberBlackList: memberNo  blackListFlag:blackListFlag success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            NSLog(@"采购商-黑名单设置接口  返回正常编码");
            
        }else{
            
            NSLog(@" 采购商-黑名单设置接口 返回异常编码 errorMessage = %@",[dic objectForKey:@"errorMessage"]);
        }
        
        NSLog(@"dic = %@",dic);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"testSecondGetMemberInviteList 失败");
        NSLog(@"The error description is %@\n",[error localizedDescription]);
        
    } ];
    
    return;
    
}

//3.41	采购商-详情接口
void testGetMemberInfo()
{
   
    
    
    NSString*  memberNo =@"M000000053";
    
    [HttpManager sendHttpRequestForGetMemberInfo:memberNo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            NSLog(@"采购商-详情接口  返回正常编码");
            if ([[dic objectForKey:@"data"] isKindOfClass:[NSDictionary class]])
            {
                GetMemberInfoDTO *getMemberInfoDTO = [[GetMemberInfoDTO alloc] init];
                
                [getMemberInfoDTO setDictFrom:[dic objectForKey:@"data"]];
                
                NSLog(@"The memberName is %@\n",getMemberInfoDTO.memberName);
            
            }
            
        }else{
            
            NSLog(@" 采购商-详情接口 返回异常编码 errorMessage = %@",[dic objectForKey:@"errorMessage"]);
        }
        
        NSLog(@"dic = %@",dic);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"testGetMemberInfo 失败");
        NSLog(@"The error description is %@\n",[error localizedDescription]);
        
    } ];

    return;
    
}

//3.42	采购商-资料接口（申请资料）
void testGetMemberApplyInfo()
{
    NSString* memberNo = @"M000000004";
    
    [HttpManager sendHttpRequestForGetMemberApplyInfo: memberNo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            NSLog(@"采购商-资料接口（申请资料）  返回正常编码");
            if ([[dic objectForKey:@"data"] isKindOfClass:[NSDictionary class]])
            {
                GetMemberApplyInfoDTO *getMemberApplyInfoDTO = [[GetMemberApplyInfoDTO alloc] init];
                
                [getMemberApplyInfoDTO setDictFrom:[dic objectForKey:@"data"]];
                
                NSLog(@"The memberTel is %@\n",getMemberApplyInfoDTO.memberTel);
            }
            
        }else{
            
            NSLog(@" 采购商-资料接口（申请资料） 返回异常编码 errorMessage = %@",[dic objectForKey:@"errorMessage"]);
        }
        
        NSLog(@"dic = %@",dic);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"testGetMemberApplyInfo 失败");
        NSLog(@"The error description is %@\n",[error localizedDescription]);
        
    } ];
    
    return;
    
}

//3.43	采购商-店铺等级设置接口

void testGetMemberLevelSet()
{
    NSString*  memberNo =@"M000000053";
    NSNumber*  level = [[NSNumber alloc] initWithInt:6];;
    
    
    [HttpManager sendHttpRequestForGetMemberLevelSet:memberNo level:level success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            NSLog(@"采购商-店铺等级设置接口  返回正常编码");
            
        }else{
            
            NSLog(@" 采购商-店铺等级设置接口 返回异常编码 errorMessage = %@",[dic objectForKey:@"errorMessage"]);
        }
        
        NSLog(@"dic = %@",dic);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"testGetMemberLevelSet 失败");
        NSLog(@"The error description is %@\n",[error localizedDescription]);
        
    } ];
    
    return;
    
}


//3.44	采购商-邀请接口
void testGetMemberInvite()
{
   
    NSString* mobileList = @"18661071018,3";
    
    NSLog(@"The mobileList is %@\n",mobileList);
    [HttpManager sendHttpRequestForMemberInvite:mobileList success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            NSLog(@"采购商-邀请接口  返回正常编码");
            
        }else{
            
            NSLog(@"采购商-邀请接口 返回异常编码 errorMessage = %@",[dic objectForKey:@"errorMessage"]);
        }
        
        NSLog(@"dic = %@",dic);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"testGetMemberInvite 失败");
        NSLog(@"The error description is %@\n",[error localizedDescription]);
        
    } ];
    
    return;

}

//3.45	采购单列表print
void testGetOrderList()
{
    NSString*  orderStatus =@"";
    NSNumber*  pageNo = [[NSNumber alloc] initWithInt:1];;
    NSNumber*  pageSize = [[NSNumber alloc] initWithInt:60];;
    
    [HttpManager sendHttpRequestForGetOrderList: orderStatus pageNo:pageNo pageSize:pageSize channelType:[NSNumber numberWithInteger:1] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            NSLog(@"dic = %@",dic);
            
            NSLog(@"采购单列表  返回正常编码");
            GetOrderListDTO *getOrderListDTO = [[GetOrderListDTO alloc] init];
            GetOrderDTO *getOrderDTO = [[GetOrderDTO alloc] init];
            orderGoodsItemDTO *orderItemDTO = [[orderGoodsItemDTO alloc] init];
            
            getOrderListDTO.getOrderDTOList = [dic objectForKey:@"data"];
            
            long count = [getOrderListDTO.getOrderDTOList count];
            //NSLog(@"The getOrderDTOList count is %ld\n",count);
            
            for( int index =0; index <count; index ++){
                NSDictionary *Dictionary = [getOrderListDTO.getOrderDTOList objectAtIndex:index];
                [getOrderDTO setDictFrom:Dictionary];
                
                NSLog(@"The status is %@\n",getOrderDTO.status);
                //NSLog(@"The orderCode is %@\n",getOrderDTO.orderCode);
                //NSLog(@"The memberPhone is %@\n",getOrderDTO.memberPhone);
                
                long count = [getOrderDTO.goodsList count];
                //NSLog(@"The orderGoodsItemsList count is %ld\n",count);
                
                for( int index =0; index <count; index ++){
                    NSDictionary *Dictionary = [getOrderDTO.goodsList objectAtIndex:index];
                    [orderItemDTO setDictFrom:Dictionary];
                    NSLog(@"The goodsNo is %@\n",orderItemDTO.goodsNo);
            
                    
                }
            }
            
        }else{
            
            NSLog(@"采购单列表 返回异常编码 errorMessage = %@",[dic objectForKey:@"errorMessage"]);
        }
        
        NSLog(@"dic = %@",dic);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"testGetOrderList 失败");
        NSLog(@"The error description is %@\n",[error localizedDescription]);
        
    } ];
    
    return;
    
}

//3.46	采购单详情
void testGetOrderDetail()
{
    NSString*  orderCode = @"1439822868150";

    [HttpManager sendHttpRequestForGetOrderDetail:orderCode  success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            NSLog(@"采购单详情  返回正常编码");
            if ([[dic objectForKey:@"data"] isKindOfClass:[NSDictionary class]])
            {
                GetOrderDetailDTO *getOrderDetailDTO = [[GetOrderDetailDTO alloc] init];
                OrderDeliveryDTO*orderDeliveryDTO = [[OrderDeliveryDTO alloc] init];
                orderGoodsItemDTO *orderItemDTO = [[orderGoodsItemDTO alloc] init];
                
                [getOrderDetailDTO setDictFrom:[dic objectForKey:@"data"]];
                
                NSLog(@"The status is %@\n",getOrderDetailDTO.status);
                NSLog(@"The addressId is %@\n",getOrderDetailDTO.addressId);
                NSLog(@"The createTime is %@\n",getOrderDetailDTO.createTime);
                
                long imagesCount = [getOrderDetailDTO.orderDeliveryDTOList count];
                NSLog(@"The imagesCount count is %ld\n",imagesCount);
                
                for( int index =0; index <imagesCount; index ++){
                    NSDictionary *Dictionary = [getOrderDetailDTO.orderDeliveryDTOList objectAtIndex:index];
                    [orderDeliveryDTO setDictFrom:Dictionary];
                    
                    
                    NSLog(@"The deliveryReceiptImage is %@\n",orderDeliveryDTO.deliveryReceiptImage);
                    
                }
                
                long count = [getOrderDetailDTO.goodsList count];
                NSLog(@"The orderItems count is %ld\n",count);
                
                for( int index =0; index <count; index ++){
                    NSDictionary *Dictionary = [getOrderDetailDTO.goodsList objectAtIndex:index];
                    [orderItemDTO setDictFrom:Dictionary];
                    
                  
                    NSLog(@"The price is %@\n",orderItemDTO.price);
                    
                }
            }
       
        }else{
            
            NSLog(@"采购单详情 返回异常编码 errorMessage = %@",[dic objectForKey:@"errorMessage"]);
        }
        
        NSLog(@"dic = %@",dic);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"testGetOrderDetail 失败");
        NSLog(@"The error description is %@\n",[error localizedDescription]);
        
    } ];
    
    return;
    
}


//3.47	修改采购单总金额
void testModifyOrderAmount()
{
    NSString*  orderCode = @"1438614839936";
    NSNumber*  newAmount = [[NSNumber alloc] initWithDouble:210.0];
    
    [HttpManager sendHttpRequestForGetModifyOrderAmount:orderCode newAmount: newAmount  success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            NSLog(@"修改采购单总金额  返回正常编码");
            
        }else{
            
            NSLog(@"修改采购单总金额 返回异常编码 errorMessage = %@",[dic objectForKey:@"errorMessage"]);
        }
        
        NSLog(@"dic = %@",dic);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"testModifyOrderAmount 失败");
        NSLog(@"The error description is %@\n",[error localizedDescription]);
        
    } ];
    
    return;
    
}

//3.48	取消交易
void testOrderCancel()
{
    
    NSString*  orderCode = @"1438614839936";
    
    [HttpManager sendHttpRequestForGetCancelOrder:orderCode  success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            NSLog(@"取消交易  返回正常编码");
            
        }else{
            
            NSLog(@"取消交易 返回异常编码 errorMessage = %@",[dic objectForKey:@"errorMessage"]);
        }
        
        NSLog(@"dic = %@",dic);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"testOrderCancel 失败");
        NSLog(@"The error description is %@\n",[error localizedDescription]);
        
    } ];
    
    return;
    
}

//3.49	消息推送（openfire）
void testGetChatPusher()
{
    
//    NSString *subject = @"lilei";
//    NSString *content =@"lilei";
//    NSMutableArray *toUsers = [[NSMutableArray alloc] init];
//    
//    [toUsers addObject:@"hanmeimei"];
//    
//    [HttpManager sendHttpRequestForGetChatPusher:(NSString *)subject content:content toUsers:toUsers  success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
//        
//        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
//            
//            NSLog(@"消息推送（openfire）");
//            
//        }else{
//            
//            NSLog(@"消息推送（openfire）errorMessage = %@",[dic objectForKey:@"errorMessage"]);
//        }
//        
//        NSLog(@"dic = %@",dic);
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//        NSLog(@"testGetChatPusher 失败");
//        NSLog(@"The error description is %@\n",[error localizedDescription]);
//        
//    } ];
    
    return;
    
}

//3.51	获取历史聊天信息（openfire）
void testGetChatHistory()
{
    
    ChatHistory *chatHistory = [[ChatHistory alloc] init];
    chatHistory.from = @"zhangsan";
    chatHistory.to= @"llisi";
    chatHistory.time  = @"2015-9-17";
    
    if (chatHistory.pageNo == nil) {
        
        chatHistory.pageNo = [NSNumber numberWithInteger:1];
        
    }
    
    if (chatHistory.pageSize == nil) {
        chatHistory.pageSize = [NSNumber numberWithInteger:20];
    }

    [HttpManager sendHttpRequestForGetChatHistory:chatHistory  success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            NSLog(@"获取历史聊天信息  返回正常编码");
            
        }else{
            
            NSLog(@"获取历史聊天信息 返回异常编码 errorMessage = %@",[dic objectForKey:@"errorMessage"]);
        }
        
        NSLog(@"dic = %@",dic);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"testOrderCancel 失败");
        NSLog(@"The error description is %@\n",[error localizedDescription]);
        
    } ];
    
    return;
    
}

 //3.51 图片上传
void testImageUpload(){
    
    NSString *appType = @"1";
    NSString *type = @"5";
    UIImage *image= [UIImage imageNamed:@"goodsDefalut"];
    NSString *orderCode =@"1440641317";
    
    NSString *goodsNo = @"";
    //[self imageUpload:image];
    
    NSData* file = UIImageJPEGRepresentation(image,1);
    
    [HttpManager sendHttpRequestForImgaeUploadWithAppType:appType type:type orderCode:orderCode goodsNo:goodsNo file:file success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        NSLog(@"dic = %@",dic);
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请求成功" message:[dic objectForKey:@"errorMessage"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            
            [alert show];
            //参数需要保存
            NSLog(@"Response = %@", operation);
            
        }else{
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请求失败" message:[dic objectForKey:@"errorMessage"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            
            [alert show];
            NSLog(@"error = %@",[NSString stringWithFormat:@"%@",[dic objectForKey:@"errorMessage"]]);
            NSLog(@"Response = %@", operation);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",[NSString stringWithFormat:@"%@",[error localizedDescription]]);
        NSLog(@"Response = %@", operation);
    }];
}

//3.52	设置已发货状态接口
void testSetOrderDelivery(){
    
    NSString *orderCode =@"1439970582532";
    
    [HttpManager sendHttpRequestForSetOrderDelivery:orderCode success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        NSLog(@"dic = %@",dic);
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请求成功" message:[dic objectForKey:@"errorMessage"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            
            [alert show];
            //参数需要保存
            NSLog(@"Response = %@", operation);
            
        }else{
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请求失败" message:[dic objectForKey:@"errorMessage"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            
            [alert show];
            NSLog(@"error = %@",[NSString stringWithFormat:@"%@",[dic objectForKey:@"errorMessage"]]);
            NSLog(@"Response = %@", operation);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",[NSString stringWithFormat:@"%@",[error localizedDescription]]);
        NSLog(@"Response = %@", operation);
    }];
}

//3.52	大B意见反馈
void testGetMerchantAddFeedback(){
    
    NSString *content =@"hello, thih is test!";
    NSString *type =@"7";
    
    [HttpManager sendHttpRequestForGetMerchantAddFeedback:type content:content success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        NSLog(@"dic = %@",dic);
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请求成功" message:[dic objectForKey:@"errorMessage"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            
            [alert show];
            //参数需要保存
            NSLog(@"Response = %@", operation);
            
        }else{
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请求失败" message:[dic objectForKey:@"errorMessage"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            
            [alert show];
            NSLog(@"error = %@",[NSString stringWithFormat:@"%@",[dic objectForKey:@"errorMessage"]]);
            NSLog(@"Response = %@", operation);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",[NSString stringWithFormat:@"%@",[error localizedDescription]]);
        NSLog(@"Response = %@", operation);
    }];
}

//3.53 创建虚拟商品采购单接口
void testCreatOrderAddVirtualOrder() {
    
    NSNumber *piece =[[NSNumber alloc] initWithInt:1];
    NSString *goodsNo =@"00000039";
    NSString *skuNo  = @"0000003902";
    NSNumber *serviceType  =  [[NSNumber alloc] initWithInt:3];
    
    [HttpManager sendHttpRequestForaddVirtualOrder:piece goodsNo:goodsNo skuNo:skuNo serviceType:serviceType success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        NSLog(@"dic = %@",dic);
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请求成功" message:[dic objectForKey:@"errorMessage"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            
            [alert show];
            //参数需要保存
            
        }else{
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请求失败" message:[dic objectForKey:@"errorMessage"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            
            [alert show];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error = %@",[NSString stringWithFormat:@"%@",error]);
        NSLog(@"The error description is %@\n",[error localizedDescription]);
        
    }];
    

}
//3.54	采购单记录接口（按会员查询）
void testGetOrderByMemberNo()
{
    NSString *memberNo = @"M000000053";
    NSNumber *pageSize = [[NSNumber alloc] initWithInt:15];
    NSNumber *pageNo = [[NSNumber alloc] initWithInteger:1];
    [HttpManager sendHttpRequestForGetOrderByMemberNo:memberNo pageNo:pageNo pageSize:pageSize  success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        NSLog(@"dic = %@",dic);
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请求成功" message:[dic objectForKey:@"errorMessage"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            
            [alert show];
            
            //参数需要保存
            GetOrderListDTO *getOrderListDTO = [[GetOrderListDTO alloc] init];
            GetOrderDTO *getOrderDTO = [[GetOrderDTO alloc] init];
            orderGoodsItemDTO *OrderItemDTO = [[orderGoodsItemDTO alloc] init];
            
            getOrderListDTO.getOrderDTOList = [dic objectForKey:@"data"];
            
            long count = [getOrderListDTO.getOrderDTOList count];
            NSLog(@"The getOrderDTOList count is %ld\n",count);
            
            for( int index =0; index <count; index ++){
                NSDictionary *Dictionary = [getOrderListDTO.getOrderDTOList objectAtIndex:index];
                [getOrderDTO setDictFrom:Dictionary];
                
                NSLog(@"The type is %@\n",getOrderDTO.type);
                NSLog(@"The orderCode is %@\n",getOrderDTO.orderCode);
                NSLog(@"The status is %d\n",getOrderDTO.status.intValue);
                NSLog(@"The totalAmount is %lf\n",getOrderDTO.totalAmount.doubleValue);
                
                long count = [getOrderDTO.goodsList count];
                NSLog(@"The orderGoodsItemsList count is %ld\n",count);
                
                for( int index =0; index <count; index ++){
                    NSDictionary *Dictionary = [getOrderDTO.goodsList objectAtIndex:index];
                    [OrderItemDTO setDictFrom:Dictionary];
                    
                    NSLog(@"The goodsNo is %@\n",OrderItemDTO.goodsNo);
                    NSLog(@"The picUrl is %@\n",OrderItemDTO.picUrl);
                    
                    NSLog(@"The price is %lf\n",OrderItemDTO.price.doubleValue);
                    NSLog(@"The quantity is %d\n",OrderItemDTO.quantity.intValue);
                    
                    
                }
            }
            
        }else{
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请求失败" message:[dic objectForKey:@"errorMessage"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            
            [alert show];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error = %@",[NSString stringWithFormat:@"%@",error]);
        NSLog(@"The error description is %@\n",[error localizedDescription]);
        
    }];
}
//3.55	查询参考图上传记录接口
void testGetImageReferImageHistoryListWithGoodsNo(){
    
    NSString *goodsNo = @"00000006";
    
    [HttpManager sendHttpRequestForGetImageReferImageHistoryListWithGoodsNo:goodsNo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        NSLog(@"dic = %@",dic);
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请求成功" message:[dic objectForKey:@"errorMessage"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            
            [alert show];
            //参数需要保存
            GetImageReferImageHistoryListDTO *getImageReferImageHistoryListDTO = [[GetImageReferImageHistoryListDTO alloc] init];
            NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
            
            mutableArray = [dic objectForKey:@"data"];
            long count = [mutableArray count];
            
            for (int index = 0; index < count; index ++) {
                NSDictionary *dictionary = [mutableArray objectAtIndex:index];
                [getImageReferImageHistoryListDTO setDictFrom:dictionary];
//                NSLog(@"The uploadDate is %@\n",getImageReferImageHistoryListDTO.uploadDate);
                NSLog(@"The auditStatus is %@\n",getImageReferImageHistoryListDTO.auditStatus);
                
                long imageUrlsCount = [getImageReferImageHistoryListDTO.imageUrlsList count];
                for (int index = 0; index < imageUrlsCount; index ++)
                {
                    NSLog(@"The current %d url is %@\n",index,[getImageReferImageHistoryListDTO.imageUrlsList objectAtIndex:index]);
                }
            }

            
        }else{
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请求失败" message:[dic objectForKey:@"errorMessage"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            
            [alert show];
            NSLog(@"error = %@",[NSString stringWithFormat:@"%@",[dic objectForKey:@"errorMessage"]]);
            NSLog(@"Response = %@", operation);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",[NSString stringWithFormat:@"%@",[error localizedDescription]]);
        NSLog(@"Response = %@", operation);
    }];
}


//3.56	商家支付接口
void testPayPay()
{
    PayPayDTO *payPayDTO = [[PayPayDTO alloc] init];
    
    payPayDTO.tradeNo = @"sSP00000046-1442883604677";
    payPayDTO.useBalance = @"1";
    payPayDTO.balanceAmount = nil;
    payPayDTO.password = nil;
    payPayDTO.payMethod = @"AlipayQuick";
    //payPayDTO.payAmount = nil;
    payPayDTO.payAmount =[[NSNumber alloc] initWithDouble:201.0];
    
    
    if( BCSHttpRequestParameterIsLack == [HttpManager sendHttpRequestForGetPayPay:payPayDTO success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        NSLog(@"dic = %@",dic);
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请求成功" message:[dic objectForKey:@"errorMessage"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            
            [alert show];
            //参数需要保存
            if ([[dic objectForKey:@"data"] isKindOfClass:[NSDictionary class]])
            {
                GetPayPayDTO* getPayPayDTO = [[GetPayPayDTO alloc] init];
                
                [getPayPayDTO setDictFrom:[dic objectForKey:@"data"]];
                

                NSLog(@"the payMethod is %@",getPayPayDTO.payMethod);
                WeChatMobilePayDTO * weChatMobilePayDTO = [[WeChatMobilePayDTO alloc] init];

                if ([getPayPayDTO.payMethod isEqualToString:@"WeChatMobile"])
                {
                    [weChatMobilePayDTO setDictFrom:getPayPayDTO.WeChatMobileSignData];
                    NSLog(@"The partnerId is %@\n",weChatMobilePayDTO.partnerId);
                }
                else {
                    NSLog(@"The AlipayQuickSignData is %@\n",getPayPayDTO.AlipayQuickSignData);
                    
                }
            }
            
            
        }else{
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请求失败" message:[dic objectForKey:@"errorMessage"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            NSLog(@"errorMessage = %@",[dic objectForKey:@"errorMessage"]);
            [alert show];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",[NSString stringWithFormat:@"%@",error]);
    }])
    {
        NSLog(@"Parameter is lack\n");
    }
    

}

//3.57 验证手机号码能否接受邀请接口
void testGetInvMobileList()
{
    NSString* mobileList = @"18661071018,15152213855";
    
    NSLog(@"The mobileList is %@\n",mobileList);
    [HttpManager sendHttpRequestForGetMemberInviteList:mobileList success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            NSLog(@"采购商-邀请接口  返回正常编码");
             NSLog(@"dic = %@",dic);
            
        }else{
            
            NSLog(@"采购商-邀请接口 返回异常编码 errorMessage = %@",[dic objectForKey:@"errorMessage"]);
        }
        
        GetInvMobileListDTO *getInvMobileListDTO = [[GetInvMobileListDTO alloc] init];
        getInvMobileListDTO.getInvMobileDTOList = [dic objectForKey:@"data"];
        
//        long count = [getInvMobileListDTO.getInvMobileDTOList count];
//        
//        for (int index = 0 ; index < count; index ++) {
        
//            GetInvMobileDTO *getInvMobileDTO = [[GetInvMobileDTO alloc] init];
//            NSDictionary *dictionary = [getInvMobileListDTO.getInvMobileDTOList objectAtIndex:index];
//            [getInvMobileDTO setDictFrom:dictionary];
//            
//            NSLog(@"the inVOpt is %@\n",getInvMobileDTO.invOpt);
//            NSLog(@"the memberAccount is %@\n",getInvMobileDTO.memberAccount);
        
//        }
      
     
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"testGetMemberInvite 失败");
        NSLog(@"The error description is %@\n",[error localizedDescription]);
        
    } ];
    
    return;

}

void testSendSms()
{
    
    NSString *phone = @"18661071018";
    NSString *type = @"3";
    
    [HttpManager sendHttpRequestForSendSmsWithPhone:phone type:type success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        NSLog(@"dic = %@",dic);
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请求成功" message:[dic objectForKey:@"errorMessage"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            
            [alert show];
            //参数需要保存
            
        }else{
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请求失败" message:[dic objectForKey:@"errorMessage"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            
            [alert show];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",[NSString stringWithFormat:@"%@",error]);
    }];

}

//3.12 短信校验接口
void testVerifySms(){
    
    NSString *phone = @"18661071018";
    NSString *type = @"3";
    NSString *smsCode = @"494126";
    
    [HttpManager sendHttpRequestForVerifySmsCodeWithPhone:phone type:type smsCode:smsCode success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        NSLog(@"dic = %@",dic);
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请求成功" message:[dic objectForKey:@"errorMessage"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            
            [alert show];
            //参数需要保存
            
        }else{
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请求失败" message:[dic objectForKey:@"errorMessage"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            
            [alert show];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",[NSString stringWithFormat:@"%@",error]);
    }];
    
}


//IOS 消息推送
void testChatPusher()
{
    NSNumber *type = [[NSNumber alloc] initWithInt:1];
    NSString *title = @"good idea";
    NSString *acountType = @"2";
    NSString *acounts = @"18661071018";
    NSString *targets = @"00000020";
    
    [HttpManager sendHttpRequestForGetChatPusher:type title:title acountType:acountType acounts:acounts targets:targets success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        NSLog(@"dic = %@",dic);
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请求成功" message:[dic objectForKey:@"errorMessage"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            
            [alert show];
            //参数需要保存
            
        }else{
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请求失败" message:[dic objectForKey:@"errorMessage"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            
            [alert show];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",[NSString stringWithFormat:@"%@",[error localizedDescription]]);
    }];
    

}

//3.60	大B积分记录按月统计接口
void testGetMerchantIntegralByMonth()
{

    NSString *time = @"2015-08";
    NSNumber *pageNo = [[NSNumber alloc] initWithInt:1];
    NSNumber *pageSize = [[NSNumber alloc] initWithInt:20];
    
    [HttpManager sendHttpRequestForGetMerchantIntegralByMonth:time pageNo:pageNo pageSize:pageSize success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        NSLog(@"dic = %@",dic);
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            NSDictionary *dictionary = [[NSDictionary alloc] init];
            NSArray *array = [[NSArray alloc] init];
            
            dictionary = [dic objectForKey:@"data"];
            array = [dictionary objectForKey:@"list"];
            
            GetMerchantIntegralByMonthDTO *getMerchantIntegralByMonthDTO = [[GetMerchantIntegralByMonthDTO alloc] init];
            
            for (int index =0; index < [array count]; index ++) {
             
                dictionary = [array objectAtIndex:index];
                [getMerchantIntegralByMonthDTO setDictFrom:dictionary];
                
            }
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请求成功" message:[dic objectForKey:@"errorMessage"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            
            [alert show];
            //参数需要保存
            
        }else{
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请求失败" message:[dic objectForKey:@"errorMessage"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            
            [alert show];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",[NSString stringWithFormat:@"%@",[error localizedDescription]]);
    }];
    
    
}

//3.61	大B积分记录查询接口
void testGetMerchantIntegralLogList()
{
    
    [HttpManager sendHttpRequestForGetMerchantIntegralLogList:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        NSLog(@"dic = %@",dic);
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            NSDictionary *dictionary = [[NSDictionary alloc] init];
            NSArray *array = [[NSArray alloc] init];
            
            
            array = [dic objectForKey:@"data"];
            
            GetMerchantIntegralLogDTO *getMerchantIntegralLogDTO = [[GetMerchantIntegralLogDTO alloc] init];
            
            for (int index =0; index < [array count]; index ++) {
                
                dictionary = [array objectAtIndex:index];
                [getMerchantIntegralLogDTO setDictFrom:dictionary];
                
            }

            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请求成功" message:[dic objectForKey:@"errorMessage"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            
            [alert show];
            //参数需要保存
            
        }else{
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请求失败" message:[dic objectForKey:@"errorMessage"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            
            [alert show];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",[NSString stringWithFormat:@"%@",[error localizedDescription]]);
    }];
    
    
}

//3.62	采购商邀请号码验证接口
void testValidateMemberInvite()
{
    NSString* mobilePhone =@"18661071018";
    
    [HttpManager sendHttpRequestForValidateMemberInvite:mobilePhone success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        NSLog(@"dic = %@",dic);
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请求成功" message:[dic objectForKey:@"errorMessage"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            
            [alert show];
            //参数需要保存
            
        }else{
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请求失败" message:[dic objectForKey:@"errorMessage"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            
            [alert show];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",[NSString stringWithFormat:@"%@",[error localizedDescription]]);
    }];
    
    
}

@end
