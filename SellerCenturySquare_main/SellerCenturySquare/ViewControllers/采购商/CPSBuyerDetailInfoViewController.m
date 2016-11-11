//
//  CPSBuyerDetailInfoViewController.m
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/9/6.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CPSBuyerDetailInfoViewController.h"
#import "GetMemberApplyInfoDTO.h"
#import "UIImageView+WebCache.h"
#import "ConversationWindowViewController.h"

@interface CPSBuyerDetailInfoViewController ()

@end

@implementation CPSBuyerDetailInfoViewController{
    
    GetMemberApplyInfoDTO *getMemberApplyInfoDTO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customBackBarButton];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    
    [self getHttpData];
}

#pragma mark - HttpRequest
- (void)getHttpData{
    
    if (!_memberNo) {
        return;
    }
    
    [HttpManager sendHttpRequestForGetMemberApplyInfo:_memberNo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            NSLog(@"采购商-资料接口（申请资料）  返回正常编码");
            if ([[dic objectForKey:@"data"] isKindOfClass:[NSDictionary class]])
            {
                
                getMemberApplyInfoDTO = [[GetMemberApplyInfoDTO alloc] init];
                
                [getMemberApplyInfoDTO setDictFrom:[dic objectForKey:@"data"]];
                
                [self.tableView reloadData];
            }
            
        }else{
            
            NSLog(@" 采购商-资料接口（申请资料） 返回异常编码 errorMessage = %@",[dic objectForKey:@"errorMessage"]);
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"testGetMemberApplyInfo 失败");
        NSLog(@"The error description is %@\n",[error localizedDescription]);
        
    } ];

}

#pragma mark - Private Functions

- (IBAction)callAction:(id)sender {
    
    NSString *tel = [NSString stringWithFormat:@"确定拨打电话%@",getMemberApplyInfoDTO.mobilePhone];
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:tel delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex != [alertView cancelButtonIndex]) {
        
        NSString *num = [NSString stringWithFormat:@"tel://%@",getMemberApplyInfoDTO.mobilePhone];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]]; //拨号
    }
}

- (IBAction)IMAction:(id)sender {
    
//    ConversationWindowViewController *IMVC = [[ConversationWindowViewController alloc]initWithNameWithYOffsent:_nickName withJID:_chatAccount];
//    
//    [self.navigationController pushViewController:IMVC animated:YES];
    
    
//    ConversationWindowViewController *IMVC = [[ConversationWindowViewController alloc] initWithNameWithYOffsent:name withJID:JID withMemberNO:data[@"memberNo"]];
//    [self.navigationController pushViewController:IMVC animated:YES];
    
}

#pragma mark - TableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat fontHeight = 15;
    CGFloat fontSize = 13;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"normalCell"];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"normalCell"];
        
        UILabel *titleL = [[UILabel alloc]initWithFrame:CGRectMake(15, 14, 70, fontHeight)];
        UILabel *detailInfoL = [[UILabel alloc]initWithFrame:CGRectMake(100, 14, self.view.frame.size.width-100, fontHeight)];
        
        [titleL setFont:[UIFont systemFontOfSize:fontSize]];
        titleL.textColor = [UIColor lightGrayColor];
        
        [detailInfoL setFont:[UIFont systemFontOfSize:fontSize]];
        
        titleL.tag = 10;
        detailInfoL.tag = 11;
        
        [cell addSubview:titleL];
        [cell addSubview:detailInfoL];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    UITableViewCell *lastCell = [tableView dequeueReusableCellWithIdentifier:@"lastCell"];
    if (lastCell == nil)
    {
        lastCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"lastCell"];
        
        UILabel *titleL = [[UILabel alloc]initWithFrame:CGRectMake(15, 14, 70, fontHeight)];
        UILabel *detailInfoL = [[UILabel alloc]initWithFrame:CGRectMake(100, 14, 200, fontHeight)];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(100, 40, 110, 77)];
        
        [titleL setFont:[UIFont systemFontOfSize:fontSize]];
        titleL.textColor = [UIColor lightGrayColor];
        
        [detailInfoL setFont:[UIFont systemFontOfSize:fontSize]];

        
        titleL.tag = 20;
        detailInfoL.tag = 21;
        imageView.tag = 22;
        
        [lastCell addSubview:titleL];
        [lastCell addSubview:detailInfoL];
        [lastCell addSubview:imageView];
        
        CGRect frame = lastCell.frame;
        frame.size.height = 300;
        [lastCell setFrame:frame];
        [lastCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    UILabel *titleL = (UILabel *)[cell viewWithTag:10];
    UILabel *detailInfoL = (UILabel *)[cell viewWithTag:11];
    
    UILabel *last_TitleL = (UILabel *)[lastCell viewWithTag:20];
    UILabel *last_DetailInfoL = (UILabel *)[lastCell viewWithTag:21];
    UIImageView *last_imageView = (UIImageView *)[lastCell viewWithTag:22];
    
    switch (indexPath.row) {
        case 0:
            titleL.text = @"姓名";
            detailInfoL.text = [NSString stringWithFormat:@"%@     %@",getMemberApplyInfoDTO.memberName,getMemberApplyInfoDTO.sex];
            break;
        case 1:
            titleL.text = @"手机号";
            detailInfoL.text = getMemberApplyInfoDTO.mobilePhone;
            break;
        case 2:
            titleL.text = @"座机电话";
            detailInfoL.text = getMemberApplyInfoDTO.memberTel;
            break;
        case 3:
            titleL.text = @"身份证";
            detailInfoL.text = getMemberApplyInfoDTO.identityNo;
            break;
        case 4:
            titleL.text = @"所在地区";
            detailInfoL.text = [NSString stringWithFormat:@"%@%@%@",getMemberApplyInfoDTO.provinceName,getMemberApplyInfoDTO.cityName,getMemberApplyInfoDTO.countyName];
            break;
        case 5:
            titleL.text = @"详细地址";
            detailInfoL.text = getMemberApplyInfoDTO.detailAddress;
            break;
        case 6:
            last_TitleL.text = @"营业执照";
            last_DetailInfoL.text = getMemberApplyInfoDTO.businessLicenseNo;
            [last_imageView sd_setImageWithURL:[NSURL URLWithString:getMemberApplyInfoDTO.businessLicenseUrl]];
            return lastCell;
            break;
        default:
            break;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    CGFloat height =cell.frame.size.height;
    
    return height;
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
