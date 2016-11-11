//
//  CSPRecommendDetailViewController.m
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/9/20.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CSPRecommendDetailViewController.h"
#import "UIColor+HexColor.h"
#import "GetRecommendRecordDetailsListDTO.h"
#import "GoodsPicDTO.h"
#import "RecommendRecordDetailsDTO.h"
#import "CSPUtils.h"
#import "MyLayout.h"
#import "NSDate+Utils.h"
//static const NSString *host = @"http://183.61.244.243:81";

@interface CSPRecommendDetailViewController ()
{
    float yOffset;
    UIScrollView *scrollView;
    MyFlowLayout *flowLayout;
    BOOL isShowAll;//显示全部
    UIView *bottomLineView;
    UILabel *timeL ;
}
@end

@implementation CSPRecommendDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customBackBarButton];
    [self detailInfoRequestWithID:_recommendRecordDTO.Id];
    
    self.title = @"推荐商品";
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - HttpRequest
- (void)detailInfoRequestWithID:(NSNumber*)identify{
    
    [HttpManager sendHttpRequestForGetRecommendRecordDetailsList:identify success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            NSLog(@"推荐商品记录详情接口  返回正常编码");
            if ([[dic objectForKey:@"data"] isKindOfClass:[NSDictionary class]])
            {
                _getRecommendRecordDetailsListDTO = [[GetRecommendRecordDetailsListDTO alloc ]init];
                
                [_getRecommendRecordDetailsListDTO setDictFrom:[dic objectForKey:@"data"]];
                
                [self UIInit];
            }
            
        }else{
            
            NSLog(@" 推荐商品记录详情接口 返回异常编码 errorMessage = %@",[dic objectForKey:@"errorMessage"]);
        }
        
        NSLog(@"dic = %@",dic);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"testGetRecommendRecordDetailsList 失败");
        NSLog(@"The error description is %@\n",[error localizedDescription]);
        
    } ];
}

- (void)delHistoryRequest:(NSNumber*)identify{
    
    [HttpManager sendHttpRequestForDeleteRecommendRecord:[identify stringValue] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            NSLog(@" 推荐商品记录删除接口  返回正常编码");
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            
            NSLog(@" 推荐商品记录删除接口 返回异常编码 errorMessage = %@",[dic objectForKey:@"errorMessage"]);
        }
        
        NSLog(@"dic = %@",dic);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"testGetDeleteRecommendRecord 失败");
        NSLog(@"The error description is %@\n",[error localizedDescription]);
        
    } ];

}


#pragma mark - Private Functions

- (void)UIInit{
    
    CGRect rect = self.view.frame;
    rect.size.height -= 49;
    scrollView =[[UIScrollView alloc]initWithFrame:rect];
    [self.view addSubview:scrollView];
    
    yOffset = 0;
    
    yOffset += 15;
    
    UILabel *recL = [[UILabel alloc]initWithFrame:CGRectMake(15,yOffset, 150, 30)];
    recL.font = [UIFont systemFontOfSize:15];
    recL.text = [NSString stringWithFormat:@"推荐商品：%@款",_getRecommendRecordDetailsListDTO.goodsNum];
    [scrollView addSubview:recL];
    
    yOffset += 40;
    
    [self addImagesArr:_getRecommendRecordDetailsListDTO.goodsPicDTOList];
    
    UILabel *psL = [[UILabel alloc]initWithFrame:CGRectMake(15, yOffset, 150, 25)];
    psL.font = [UIFont systemFontOfSize:11];
    psL.textColor = [UIColor colorWithHex:0x666666];
    psL.text = [NSString stringWithFormat:@"附言:"];
    [scrollView addSubview:psL];
    
    yOffset +=25;
    
    UILabel *contentL = [[UILabel alloc]init];
    contentL.font = [UIFont systemFontOfSize:10];
    contentL.textColor = [UIColor colorWithHex:0x999999];
    contentL.text = [NSString stringWithFormat:@"%@",_getRecommendRecordDetailsListDTO.content];
    UIFont *fnt = [UIFont systemFontOfSize:10];
    CGRect tmpRect = [CSPUtils labelFitStringContentSizeWith:contentL font:fnt boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-30, 1000)];
    tmpRect.origin.x = 15;
    tmpRect.origin.y = yOffset;
    [contentL setFrame:tmpRect];
    
    [scrollView addSubview:contentL];
    
    yOffset +=tmpRect.size.height+10;
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(15, yOffset, self.view.frame.size.width-30, 1)];
    [lineView setBackgroundColor:[UIColor colorWithHex:0x999999 alpha:0.3]];
    [scrollView addSubview:lineView];
    
    yOffset +=0;
    
    UILabel *receiveL = [[UILabel alloc]initWithFrame:CGRectMake(15, yOffset, 150, 30)];
    receiveL.font = [UIFont systemFontOfSize:11];
    receiveL.textColor = [UIColor colorWithHex:0x666666];
    receiveL.text = [NSString stringWithFormat:@"收件人:%@人",_getRecommendRecordDetailsListDTO.memberNum];
    
    [scrollView addSubview:receiveL];
    
    yOffset +=30;
    
    flowLayout = [[MyFlowLayout alloc] initWithFrame:CGRectMake(15, yOffset, self.view.frame.size.width-30, _getRecommendRecordDetailsListDTO.recommendMemberDTOList.count *20)];
      flowLayout.wrapContentHeight = YES;
    [scrollView addSubview:flowLayout];
    [self addNamesArr:_getRecommendRecordDetailsListDTO.recommendMemberDTOList withFlowLayout:flowLayout];

    yOffset += 10;
    
    bottomLineView = [[UIView alloc]initWithFrame:CGRectMake(15, yOffset, self.view.frame.size.width-30, 1)];
    [bottomLineView setBackgroundColor:[UIColor colorWithHex:0x999999 alpha:0.3]];
    [scrollView addSubview:bottomLineView];
    
    yOffset +=5;
    
    timeL = [[UILabel alloc]initWithFrame:CGRectMake(15, yOffset, 150, 15)];
    timeL.font = [UIFont systemFontOfSize:8];
    timeL.textColor = [UIColor colorWithHex:0x999999];
    
//    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[_getRecommendRecordDetailsListDTO.createDate integerValue]/1000];
//    NSDateFormatter *dateFormatter  = [[NSDateFormatter alloc]init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//    NSString *time = [dateFormatter stringFromDate:date];
    NSString *dateStr= @"";
    
//    if (_getRecommendRecordDetailsListDTO.createDate.length>10) {
//        
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        
//        [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
//        
//        NSDate *destDate= [dateFormatter dateFromString:_getRecommendRecordDetailsListDTO.createDate];
//        dateStr = [destDate stringToday];
//        //dateStr = [_getRecommendRecordDetailsListDTO.createDate substringToIndex:10];
//    }
    timeL.text = _getRecommendRecordDetailsListDTO.createDate;
    [scrollView addSubview:timeL];
    
    yOffset += 40;
    
    
    [scrollView setContentSize:CGSizeMake(self.view.frame.size.width, yOffset)];
}

- (void)addImagesArr:(NSMutableArray *)imagesArr{
    
    if (!imagesArr) {
        return;
    }
    
    //删除
    for (id obj in self.view.subviews) {
        
        if ([obj isKindOfClass:[UIImageView class]]) {
            
            [obj removeFromSuperview];
        }
    }
    
    NSInteger rowCount = imagesArr.count/5;
    if (imagesArr.count%5>0) {
        rowCount++;
    }
    
    for (int i = 0; i<rowCount; i++) {
        
        for (int j = 0; j<5; j++) {
            
            if (j>0&&i==rowCount-1&&imagesArr.count%5==j) {
                
                break;
            }
            
            GoodsPicDTO *goodsPicDTO = imagesArr[i*5+j];
            
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(15+j*55, yOffset+i*55, 50, 50)];
            
            NSString *urlStr = [NSString stringWithFormat:@"%@",goodsPicDTO.picUrl];
            
            NSURL *url = [NSURL URLWithString:urlStr];
            
            [imageView sd_setImageWithURL:url];
            
            [scrollView addSubview:imageView];
            
        }
    }
    
    yOffset += 55*rowCount+10;
    
}

- (void)addNamesArr:(NSMutableArray *)nameList withFlowLayout:(MyFlowLayout *)_flowLayout{
    
    
    
    NSLog(@"nameList==%@",nameList);
    
    if (!nameList) {
        return;
    }
    
    for (id obj in _flowLayout.subviews) {
        [obj  removeFromSuperview ];
    }
    
    for (int i = 0;i <nameList.count;i++) {
        if (i >9&&!isShowAll) {
            break;
        }
        RecommendMemberDTO *recMemberDTO = nameList[i];
        UILabel *nameT = [[UILabel alloc]init];
        
        nameT.textColor = [UIColor colorWithHex:0x999999];
        
        nameT.font = [UIFont systemFontOfSize:12];
        
        nameT.heightDime.equalTo(@(12));
        nameT.leftPos.equalTo(@(5));
        nameT.topPos.equalTo(@(5));
        nameT.widthDime.min(30);
        nameT.text = recMemberDTO.memberName;
        [nameT sizeToFit];
        nameT.enabled = NO;
        
        [_flowLayout addSubview:nameT];
        
     

    }
    if (nameList.count >10) {
        UIButton *btnShow = [[UIButton alloc] init];
        btnShow.heightDime.equalTo(@(12));
        btnShow.leftPos.equalTo(@(5));
        btnShow.topPos.equalTo(@(5));
        btnShow.widthDime.min(40);
        NSString *str = isShowAll?@"收回":@"显示更多";
        [btnShow addTarget:self action:@selector(showMore) forControlEvents:UIControlEventTouchUpInside];
        NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:str];
        NSRange contentRange = {0,[content length]};
        [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
        [btnShow setAttributedTitle:content forState:UIControlStateNormal];
        [btnShow.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [btnShow sizeToFit];
        [flowLayout addSubview:btnShow];
    }
   
    
    CGRect rect = [flowLayout estimateLayoutRect:CGSizeMake(flowLayout.frame.size.width-30, 0)];
    yOffset = _flowLayout.frame.origin.y +rect.size.height ;
}


- (IBAction)delButtonClicked:(id)sender {
    
    [self delHistoryRequest:_recommendRecordDTO.Id];
}
-(void)showMore{
    
    isShowAll = !isShowAll;
     [self addNamesArr:_getRecommendRecordDetailsListDTO.recommendMemberDTOList withFlowLayout:flowLayout];
    yOffset += 10;
    
    bottomLineView.frame = CGRectMake(15, yOffset, self.view.frame.size.width-30, 1);
    yOffset +=5;
    
    timeL.frame = CGRectMake(15, yOffset, 150, 15);

    yOffset += 40;
    
    [scrollView setContentSize:CGSizeMake(self.view.frame.size.width, yOffset)];

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
