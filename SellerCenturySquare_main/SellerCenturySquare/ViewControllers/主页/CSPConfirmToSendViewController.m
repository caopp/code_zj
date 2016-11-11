//
//  CSPConfirmToSendViewController.m
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/9/18.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CSPConfirmToSendViewController.h"
#import "RecommendPostScriptTableViewCell.h"
#import "RecommendReceiveTableViewCell.h"
#import "RecommendSendFirstTableViewCell.h"
#import "SaveGoodsRecommendModel.h"
#import "ShopGoodsDTO.h"
#import "SaveGoodsRecommendDTO.h"
#import "ChatManager.h"
#import "IMMsgDBAccess.h"

@interface CSPConfirmToSendViewController ()
@property (strong, nonatomic) IBOutlet UITableView *confirmTableView;

@end

@implementation CSPConfirmToSendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _saveGoodsRecommendModel = [[SaveGoodsRecommendModel alloc] init];
    [self customBackBarButton];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(modifyGoods) name:kModifyRecommendNumberNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(modifyContacts) name:kModifyReceivePersonNotification object:nil];
    
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changesKeyboard) name:@"EditeRecommend" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Functions
-(void)changesKeyboard{
    if (_confirmTableView.contentOffset.y>100) {
        _confirmTableView.contentOffset = CGPointMake(0, 0);
    }else
        _confirmTableView.contentOffset = CGPointMake(0, 150);
}
//修改推荐商品
- (void)modifyGoods{
    
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
}

//修改推荐联系人
- (void)modifyContacts{
    
     [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:3] animated:YES];
}

- (NSString*)getGoodsNos{
    
    NSString *goodsNosStr = [[NSString alloc]init];
    
    if (_goodsInfoDic.allKeys.count==0) {
        
        return nil;
    }
    
    for (NSString *tmpStr in _goodsInfoDic.allKeys) {
        
        goodsNosStr = [goodsNosStr stringByAppendingFormat:@"%@,",tmpStr];
    }
    
    goodsNosStr = [goodsNosStr substringToIndex:goodsNosStr.length-1];
    
    return goodsNosStr;
}

- (NSString *)getMemeberNos{

    NSString *memberNosStr = [[NSString alloc]init];
    
    if (_memberInfoDic.allKeys.count==0) {
        
        return nil;
    }
    
    for (NSString *tmpStr in _memberInfoDic.allKeys) {
        
        memberNosStr = [memberNosStr stringByAppendingFormat:@"%@,",tmpStr];
    }
    
     
    memberNosStr = [memberNosStr substringToIndex:memberNosStr.length-1];
    
    return memberNosStr;
}

- (NSMutableArray *)getImageList{
    
    if (!_goodsInfoDic) {
        return nil;
    }
    
    NSMutableArray *imageList = [[NSMutableArray alloc]init];
    
    for (ShopGoodsDTO *tmpGoodsDTO in _goodsInfoDic.allValues) {
        
        [imageList addObject:tmpGoodsDTO.imgUrl];
    }
    
    return imageList;
}

- (IBAction)sendButtonClicked:(id)sender {
    UIButton *btn = sender;
    btn.enabled = NO;
    [self.view endEditing:YES];
    
    [self sendRecommendRequest:btn];
}

#pragma mark - HttpRequest
- (void)sendRecommendRequest:(UIButton*)btn{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _saveGoodsRecommendModel.goodsNum = [[NSNumber alloc] initWithInteger:_goodsInfoDic.allKeys.count];
    _saveGoodsRecommendModel.goodsNos = [self getGoodsNos];
    _saveGoodsRecommendModel.memberNos = [self getMemeberNos];
    _saveGoodsRecommendModel.memberNum = [[NSNumber alloc] initWithInteger:_memberInfoDic.allKeys.count];
    
    if (_saveGoodsRecommendModel.content==nil) {
        _saveGoodsRecommendModel.content= @"";
    }
    
    if (_saveGoodsRecommendModel.IsLackParameter) {
        return;
    }
    [HttpManager sendHttpRequestForGetSaveGoodsRecommend:_saveGoodsRecommendModel success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"dic==%@",dic);
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            NSLog(@"推荐商品记录发送接口  返回正常编码");
            NSArray *arr = [dic objectForKey:@"data"];
          
            for (NSDictionary *dicM in arr) {
                MemberChatDTO * memberDTO  = [[MemberChatDTO alloc] init];
                [memberDTO setDictFrom:dicM];
                [ChatManager shareInstance].memberNo = memberDTO.memberNo;
                ECSession * session = [[IMMsgDBAccess sharedInstance] querySession:memberDTO.memberChatAccount];
                
                for (GoodsDTO * goodsDTO in memberDTO.goodsList) {
                    
                    ShopGoodsDTO * shopGoodsDTO = [[ShopGoodsDTO alloc] init];
                    
                    shopGoodsDTO.goodsNo = goodsDTO.goodsNo;
                    shopGoodsDTO.goodsColor = goodsDTO.color;
                    shopGoodsDTO.price = [NSNumber numberWithFloat:[goodsDTO.price floatValue]];
                    shopGoodsDTO.searchGoodNo = memberDTO.memberChatAccount;
                    shopGoodsDTO.merchantNo = memberDTO.memberChatAccount;
                    shopGoodsDTO.imgUrl = goodsDTO.smallPicUrl;
                    shopGoodsDTO.goodsWillNo = goodsDTO.goodsWillNo;
                    NSLog(@"memberChantName===%@",memberDTO.memberChatAccount);
                    [[ChatManager shareInstance] SendGoodMessage:shopGoodsDTO toUserID:memberDTO.memberChatAccount withIMtype:@"0" withMerchantname:memberDTO.memberChantName withECSession:session];
                }
                
                
                //发送文本信息
                if (![_saveGoodsRecommendModel.content isEqualToString:@""] && !_saveGoodsRecommendModel.content.length == 0) {
                    [[ChatManager shareInstance] SendTextMessage:_saveGoodsRecommendModel.content toUserID:memberDTO.memberChatAccount withECSession:session withMerchantname:memberDTO.memberChantName];
                }

            }
//            SaveGoodsRecommendDTO *saveGoodsRecommendDTO = [[SaveGoodsRecommendDTO alloc] init];
//            [saveGoodsRecommendDTO setDictFrom:[dic objectForKey:@"data"]];
//            
//            for (MemberChatDTO * memberDTO in saveGoodsRecommendDTO.memberChatList) {
//                
//                            }

            
            [self performSegueWithIdentifier:@"recommendSuccess" sender:nil];
            
        }else{
            
            NSLog(@" 推荐商品记录发送接口 返回异常编码 errorMessage = %@",[dic objectForKey:@"errorMessage"]);
        }
        
        NSLog(@"dic = %@",dic);
        btn.enabled = YES;
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"testSaveGoodsRecommend 失败");
        NSLog(@"The error description is %@\n",[error localizedDescription]);
        btn.enabled = YES;
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];


    } ];
}

#pragma mark - TableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RecommendSendFirstTableViewCell *recommendCell = [tableView dequeueReusableCellWithIdentifier:@"RecommendSendFirstTableViewCell"];
    
    RecommendReceiveTableViewCell *receiveCell = [tableView dequeueReusableCellWithIdentifier:@"RecommendReceiveTableViewCell"];
    
    RecommendPostScriptTableViewCell *psCell = [tableView dequeueReusableCellWithIdentifier:@"RecommendPostScriptTableViewCell"];
    
    if (!recommendCell) {
        
        [tableView registerNib:[UINib nibWithNibName:@"RecommendSendFirstTableViewCell" bundle:nil] forCellReuseIdentifier:@"RecommendSendFirstTableViewCell"];
        recommendCell = [tableView dequeueReusableCellWithIdentifier:@"RecommendSendFirstTableViewCell"];
    }
    
    if (!receiveCell) {
        
        [tableView registerNib:[UINib nibWithNibName:@"RecommendReceiveTableViewCell" bundle:nil] forCellReuseIdentifier:@"RecommendReceiveTableViewCell"];
        recommendCell = [tableView dequeueReusableCellWithIdentifier:@"RecommendReceiveTableViewCell"];
    }
    
    if (!psCell) {
        
        [tableView registerNib:[UINib nibWithNibName:@"RecommendPostScriptTableViewCell" bundle:nil] forCellReuseIdentifier:@"RecommendPostScriptTableViewCell"];
        recommendCell = [tableView dequeueReusableCellWithIdentifier:@"RecommendPostScriptTableViewCell"];
    }
    
    // Configure the cell...
    switch (indexPath.section) {
        case 0:
            recommendCell.imagesArr = [self getImageList];
            return recommendCell;
            break;
        case 1:
            receiveCell.num = _memberInfoDic.allKeys.count;
            return receiveCell;
            break;
        case 2:
            psCell.saveGoodsRecommendModel = _saveGoodsRecommendModel;
            return psCell;
            break;
        default:
            return nil;
            break;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    CGFloat height =cell.frame.size.height;
    
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section==0) {
        return 0.1;
    }
    return 10;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
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
