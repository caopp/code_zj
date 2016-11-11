//
//  CSPRecommendViewController.m
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/9/16.   待修改
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CSPRecommendViewController.h"
#import "RecommendCollectionViewCell.h"
#import "UIColor+HexColor.h"
#import "HttpManager.h"
#import "GetShopGoodsListDTO.h"
#import "ShopGoodsDTO.h"
#import "CSPRecommendContactsViewController.h"
#import "ACMacros.h"
@interface CSPRecommendViewController ()
@property (nonatomic,strong) NSMutableDictionary *selectedGoodsDic;
@property (nonatomic,copy) NSString *dayNum;

@end

@implementation CSPRecommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton *button = (UIButton *)[self.view viewWithTag:1];
    [button setBackgroundColor:[UIColor whiteColor]];
    button.selected = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    _selectedGoodsDic = [[NSMutableDictionary alloc]init];
    _dayNum = @"30";
    [self getRecommendGoodsList:@"6"];
    
    [self customBackBarButton];
   
}

- (void)viewWillAppear:(BOOL)animated{
 
    [self tabbarHidden:YES];
}

- (void)viewDidAppear:(BOOL)animated{
    
  _recommendScrollview.contentSize = CGSizeMake(Main_Screen_Width *4, 0);
    
}

-(void)createCollectionView{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - HttpRequest
- (void)getRecommendGoodsList:(NSString*)type{
 
    NSNumber *pageNo = [[NSNumber alloc] initWithInt:1];
    NSNumber *pageSize = [[NSNumber alloc] initWithInt:50];
    NSString *structureNo = @"";
    NSString *queryTime = type;
    
    [HttpManager sendHttpRequestForGetShopGoodsList:pageNo pageSize:pageSize structureNo:structureNo queryTime:queryTime goodsType:@"0" success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            NSLog(@" 商品列表（店铺展示）接口  返回正常编码");
            if ([[dic objectForKey:@"data"] isKindOfClass:[NSDictionary class]])
            {
                _getShopGoodsListDTO = [[GetShopGoodsListDTO alloc ]init];
                [_getShopGoodsListDTO setDictFrom:[dic objectForKey:@"data"]];
                NSLog(@"ShopGoodsDTOList===%ld",_getShopGoodsListDTO.ShopGoodsDTOList.count);
               // [self.collectionView reloadData];
                UICollectionView *collectionView = [_recommendArray objectAtIndex:[type integerValue]-6];
                [collectionView reloadData];
            }
        }else{
            
            NSLog(@"商品列表（店铺展示）接口  返回异常编码 errorMessage = %@",[dic objectForKey:@"errorMessage"]);
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"testGetShopGoodsList 失败");
        NSLog(@"The error description is %@\n",[error localizedDescription]);
        
    } ];
    
}


#pragma mark - Private Functions
- (IBAction)optionButtonClicked:(id)sender {
    
    UIButton *currentButton = (UIButton *)sender;
    
    for (int i = 1;i<5;i++) {
        
        UIButton *button = (UIButton *)[self.view viewWithTag:i];
    
        [button setBackgroundColor:[UIColor colorWithHex:0x999999]];
        
        button.selected = NO;
    
        if (currentButton.tag==i) {
            
            [button setBackgroundColor:[UIColor whiteColor]];
            button.selected = YES;
        }
    }
    NSString *queryTime;
    switch (currentButton.tag) {
        case 1:
            queryTime = @"6";
            _dayNum = @"30";
            break;
        case 2:
            queryTime = @"7";
            _dayNum = @"20";
            break;
        case 3:
            queryTime = @"8";
            _dayNum = @"15";
            break;
        case 4:
            queryTime = @"9";
            _dayNum = @"0";
            break;
       ;
        default:
            break;
    }
    _recommendScrollview.contentOffset = CGPointMake((currentButton.tag-1)*Main_Screen_Width, 0);
    [self getRecommendGoodsList:queryTime];
    
    _selectedGoodsDic = [[NSMutableDictionary alloc]init];
}

- (NSArray *)getSelectedGoodsList{
    
    return _selectedGoodsDic.allValues;
}


#pragma mark - Collection DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return _getShopGoodsListDTO.ShopGoodsDTOList.count;
}
// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    RecommendCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RecommendCollectionViewCell" forIndexPath:indexPath];
    
    // Configure the cell
    cell.shopGoodsDTO = _getShopGoodsListDTO.ShopGoodsDTOList[indexPath.row];
    
    cell.selectedGoodsDic = _selectedGoodsDic;
    
    return cell;
    
}
-(void)collectionView:(UICollectionView *)cv didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{

    [((RecommendCollectionViewCell *)cell).imageView setImage:nil];
    [((RecommendCollectionViewCell *)cell).levelL setText:nil];
    [((RecommendCollectionViewCell *)cell).tipsL setText:nil];
    [((RecommendCollectionViewCell *)cell).priceL setText:nil];
    
}


#pragma mark - Navigation
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(nullable id)sender {
    if (_selectedGoodsDic.allKeys.count) {
        
        return YES;
    }else{
        [self.view makeMessage:@"请选择推荐的商品" duration:2.0f position:@"center"];
        return NO;
    }
}
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    CSPRecommendContactsViewController *recoContactsVC = segue.destinationViewController;
    
    recoContactsVC.goodsInfoDic = _selectedGoodsDic;
    recoContactsVC.dayNum = _dayNum;
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
  
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.recommendScrollview == scrollView) {
        NSLog(@"contentOffset.x = %f", self.recommendScrollview.contentOffset.x);
        NSInteger index = self.recommendScrollview.contentOffset.x/self.view.frame.size.width;
        NSLog(@"index = %lu",(long)index);
        UIButton *btn =(UIButton *)[self.view viewWithTag:index+1];
        [self optionButtonClicked:btn];
    }
}



@end
