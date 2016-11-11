//
//  CPSPostageViewController.m
//  SellerCenturySquare
//
//  Created by 左键视觉 on 15/12/3.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import "CPSPostageViewController.h"
#import "GetGoodsFeeInfoDTO.h"

#import "CPSGoodsDetailsPreviewTableViewCell.h"


@interface CPSPostageViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>{

    NSString *name;

    NSURL *url;
}

@property(nonatomic,strong)UIScrollView *scrollView;

@property(nonatomic,strong)UITableView *goodsInfoTableView;




@end

@implementation CPSPostageViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"补差价";
    
    [self customBackBarButton];
    
    [self initScrollView];
    
    [self initTableView];
    
    [self.view bringSubviewToFront:self.progressHUD];
    
    
    //!名称
    GetMerchantInfoDTO *getMerchantInfoDTO = [GetMerchantInfoDTO sharedInstance];
    name = [NSString stringWithFormat:@"补差价-%@",getMerchantInfoDTO.merchantName];
    
    [self getPostalData];
    
    
    
}
- (void)getPostalData{
    
    [HttpManager sendHttpRequestForGetGoodsFeeInfo:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            //参数需要保存
            if ([[dic objectForKey:@"data"] isKindOfClass:[NSDictionary class]])
            {
                GetGoodsFeeInfoDTO *getGoodsFeeInfoDTO = [[GetGoodsFeeInfoDTO alloc] init];
                
                [getGoodsFeeInfoDTO setDictFrom:[dic objectForKey:@"data"]];
                
                NSString *urlStr = getGoodsFeeInfoDTO.detailUrl;
                
                url = [NSURL URLWithString:urlStr];
                
                
                
            }
            
            
            
        }
        
        [self.goodsInfoTableView reloadData];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
    }];
}


- (void)initScrollView{
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    self.scrollView.delegate = self;
    
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height*2);
    
    self.scrollView.pagingEnabled = YES;
    
    self.scrollView.scrollEnabled = NO;
    
    [self.view addSubview:self.scrollView];
}

- (void)initTableView{
    
    self.goodsInfoTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
    
    self.goodsInfoTableView.delegate = self;
    
    self.goodsInfoTableView.dataSource = self;
    
    self.goodsInfoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.scrollView addSubview:self.goodsInfoTableView];
    
    
}


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
    
    [self tabbarHidden:YES];
}

- (void)viewWillLayoutSubviews{
    
    [super viewWillLayoutSubviews];
    
    self.scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height*2);
    
    self.goodsInfoTableView.frame = CGRectMake(0, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    

}

#pragma mark-UITableViewDataSource,UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return 1;
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CPSGoodsDetailsPreviewTableViewCell *cell;
    
    if (self.goodsInfoTableView == tableView) {
        
        cell = [[[NSBundle mainBundle]loadNibNamed:@"CPSGoodsDetailsPreviewTableViewCell" owner:self options:nil]objectAtIndex:11];
        
        if (indexPath.row == 0) {
            
            
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width)];
            
            
            [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"post_placeholder"]];
            
            
            [cell.goodsScrollView addSubview:imageView];
            

            cell.goodsNameLabel.text = name;
            
            
            
            cell.goodsPageControl.numberOfPages = 0;
            


        }
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.goodsInfoTableView == tableView) {
        
        if (indexPath.row == 0) {
            
            return  self.view.frame.size.width + 52  + [self goodNameSize];
        
            
        }
        
        
    }
    
       
    return 0;

    
}
-(CGFloat)goodNameSize{
    

    CGSize size = [name boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    
    return size.height;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    
    return 0;
        
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0;

    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
