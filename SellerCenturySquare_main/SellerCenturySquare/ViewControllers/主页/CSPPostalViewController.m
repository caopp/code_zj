//
//  CSPPostalViewController.m
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/9/18.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CSPPostalViewController.h"
#import "GetGoodsFeeInfoDTO.h"
#import "UIImageView+WebCache.h"

@interface CSPPostalViewController ()
{
    GetGoodsFeeInfoDTO *getGoodsFeeInfoDTO;
    
}
@end

@implementation CSPPostalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getPostalData];

    self.title = @"邮费专拍";
    [self customBackBarButton];
    
    GetMerchantInfoDTO *getMerchantInfoDTO = [GetMerchantInfoDTO sharedInstance];
    NSString *name = [NSString stringWithFormat:@"邮费专拍-%@",getMerchantInfoDTO.merchantName];
    
    _nameL.text = name;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    
    [self tabbarHidden:YES];
}

- (void)getPostalData{
    
  

    
    [HttpManager sendHttpRequestForGetGoodsFeeInfo:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        NSLog(@"dic = %@",dic);
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            //参数需要保存
            if ([[dic objectForKey:@"data"] isKindOfClass:[NSDictionary class]])
            {
                GetGoodsFeeInfoDTO *getGoodsFeeInfoDTO = [[GetGoodsFeeInfoDTO alloc] init];
                
                [getGoodsFeeInfoDTO setDictFrom:[dic objectForKey:@"data"]];
                
                NSString *urlStr = getGoodsFeeInfoDTO.detailUrl;
                
                NSURL *url = [NSURL URLWithString:urlStr];
                
                [_imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"post_placeholder"]];
            }
            
            
            
        }else{
            
            NSLog(@"大B商品修改接口  返回异常编码 errorMessage = %@",[dic objectForKey:@"errorMessage"]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",[NSString stringWithFormat:@"%@",error]);
    }];
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
