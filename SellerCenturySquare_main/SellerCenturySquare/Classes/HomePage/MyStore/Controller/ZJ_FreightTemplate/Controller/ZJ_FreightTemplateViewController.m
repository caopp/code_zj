//
//  ZJ_FreightTemplateViewController.m
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/6/11.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "ZJ_FreightTemplateViewController.h"
#import "YcSegmentView.h"

//全部模板
#import "AllFreightTemplateView.h"
#import "WholesaleView.h"
#import "RetailView.h"

#import "FreightTempModel.h"
#import "FreightTempListModel.h"

#import "SlidePageManager.h"
#import "SlidePageSquareView.h"

//全部模板
#import "AllFreightTemplateView.h"
#import "WholesaleView.h"
#import "RetailView.h"

@interface ZJ_FreightTemplateViewController ()<YcSegmentViewDelegate,SlidePageSquareViewDelegate>

{
    UIScrollView * _goodsSc;
    
    //全部模板
    AllFreightTemplateView *allFreightView;
    WholesaleView *wholesaleView;
    RetailView *retailView;
}
//可变数组进行接受
@property (nonatomic,strong)NSMutableArray *infoListArr;

@property (nonatomic,strong)NSMutableDictionary *dataDic;
@property (nonatomic,strong) SlidePageManager *manager ;
@end

@implementation ZJ_FreightTemplateViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super  viewWillAppear:animated];
    
    //返回进行数据刷新
    NSNotification *notification = [[NSNotification alloc]initWithName:@"DataRefreshNotification" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter]postNotification:notification];

}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"运费模板";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createUI];
    
    [self  customBackBarButton];
    
    //进行展示通知显示选中模板个数
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showFreightConut) name:@"showThreeFreight" object:nil];
    //批发模板进行弹框通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showWholesaleTemplate) name:@"WholesaleTemplateName" object:nil];
    //零售模板进行弹框通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showRetailTemplate) name:@"RetailTemplateName" object:nil];
    //全部模板加载现实
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showHUDForView) name:@"ShowAllFreightName" object:nil];
    //全部模板加载隐藏
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hideHUDForView) name:@"HideAllFreightName" object:nil];
    //删除模板加载现实
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showHUDForView) name:@"showDeleteFreightName" object:nil];
    //删除模板加载隐藏
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hideHUDForView) name:@"hideDeleteFreightName" object:nil];
    
    //批发模板加载现实
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showHUDForView) name:@"showWholesaleTemplateName" object:nil];
    //批发模板加载隐藏
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hideHUDForView) name:@"hideWholesaleTemplateName" object:nil];
    
    //批发模板加载现实
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showHUDForView) name:@"showRetailNotification" object:nil];
    //批发模板加载隐藏
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hideHUDForView) name:@"hideRetailNotification" object:nil];
    
    
    //批发模板保存
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showHUDForView) name:@"SaveFreightTemplateType" object:nil];
    //批发模板保存
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hideHUDForView) name:@"EndSaveFreightTemplateType" object:nil];
    
    
    //零售模板保存加载显示
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showHUDForView) name:@"SaveFreightTemplate" object:nil];
    //零售模板保存加载隐藏
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hideHUDForView) name:@"EndSaveFreightTemplate" object:nil];
    
    
    
   }
-(void)showHUDForView
{
 [MBProgressHUD showHUDAddedTo:self.view   animated:YES];
}
-(void)hideHUDForView
{
 [MBProgressHUD hideHUDForView:self.view  animated:YES];
}

        
        

-(void)showWholesaleTemplate
    {
        [self.view makeMessage:@"暂不可删除！此模板现在是批发端的默认模板。为批发端更换默认模板后才可删除。" duration:2.0f position:@"center"];
    }
-(void)showRetailTemplate
    {
        [self.view makeMessage:@"暂不可删除！此模板现在是零售端的默认模板。为零售端更换默认模板后才可删除。" duration:2.0f position:@"center"];
    }

//显示模板个数方法
-(void)showFreightConut
{
  [self.view makeMessage:@"最多可同时选择3个计费模板(非包邮模板)。" duration:2.0f position:@"center"];
}


//创建UI
-(void)createUI
{
    self.manager = [[SlidePageManager alloc]init];
    SlidePageSquareView * scView1 = (SlidePageSquareView*)[self.manager createBydataArr:@[@"全部模板",@"批发端可选模板",@"零售端可选模板"] slidePageType:SlidePageTypeSquare  bgColor:[UIColor colorWithHex:0x333333] squareViewColor:[UIColor colorWithHex:0xffffff] unSelectTitleColor:[UIColor colorWithHex:0x999999] selectTitleColor:[UIColor blackColor] witTitleFont:[UIFont systemFontOfSize:14]];
    
    scView1.frame = CGRectMake(0, 0,SCREEN_WIDTH, 32);
    scView1.contentSize = CGSizeMake(SCREEN_WIDTH, 0);
    scView1.delegateForSlidePage = self;
    [self.view addSubview:scView1];
    
    
    _goodsSc = [[UIScrollView alloc]initWithFrame:CGRectMake(0,32, self.view.frame.size.width, self.view.frame.size.height - 32)];
    _goodsSc.contentSize = CGSizeMake(self.view.frame.size.width * 3, _goodsSc.frame.size.height);
    _goodsSc.pagingEnabled = YES;
    _goodsSc.scrollsToTop = NO;
    _goodsSc.delegate = self;
    [self.view addSubview:_goodsSc];
    
    
    //!在售
    allFreightView = [[AllFreightTemplateView alloc]initWithFrame:CGRectMake(0, 0, _goodsSc.frame.size.width, _goodsSc.frame.size.height) nav:self.navigationController];
    allFreightView.backgroundColor = [UIColor redColor];
    
    
    //!新发布
    wholesaleView = [[WholesaleView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(allFreightView.frame), allFreightView.frame.origin.y,_goodsSc.frame.size.width, _goodsSc.frame.size.height) nav:self.navigationController];
    wholesaleView.backgroundColor = [UIColor yellowColor];
    
    
    //!已下架
    retailView = [[RetailView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(wholesaleView.frame), wholesaleView.frame.origin.y,_goodsSc.frame.size.width, _goodsSc.frame.size.height) nav:self.navigationController];
    retailView.backgroundColor = [UIColor purpleColor];
    
    
    //!添加到view
    [_goodsSc addSubview:allFreightView];
    [_goodsSc addSubview:wholesaleView];
    [_goodsSc addSubview:retailView];
    
}

/**
 *  按钮点击回调
 *  @param view  滑块视图
 *  @param index 点击按钮 Index
 */
#pragma mark SlidePageSquareViewDelegate
//!点击顶部按钮，进行滑动
- (void)slidePageSquareView:(SlidePageSquareView*)view andBtnClickIndex:(NSInteger)index{
    
    CGFloat screenWith = [UIScreen mainScreen].bounds.size.width;
    [_goodsSc  setContentOffset:CGPointMake(screenWith*index,0 ) animated:YES];
    
    if (index == 0) {
     
        
        //返回进行数据刷新
        NSNotification *notification = [[NSNotification alloc]initWithName:@"DataRefreshNotification" object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter]postNotification:notification];
        
    }else if (index == 1)
    {
        //返回进行数据刷新
        NSNotification *notification = [[NSNotification alloc]initWithName:@"WholesaleNotification" object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter]postNotification:notification];
    
    }else if (index == 2)
    {
        NSNotification *notification = [[NSNotification alloc]initWithName:@"RetailNotification" object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter]postNotification:notification];
    }
}
#pragma mark scrollerViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //!改变顶部的偏移
    self.manager.contentOffsetX = scrollView.contentOffset.x;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{

    //先进行x轴
    static float oldX = 0;
    if (scrollView.contentOffset.x != oldX) {
        NSInteger i = (targetContentOffset->x - 0)/SCREENW;
        if (i == 0) {
           
        //返回进行数据刷新
        NSNotification *notification = [[NSNotification alloc]initWithName:@"DataRefreshNotification" object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter]postNotification:notification];
            
        }
        else if (i == 1)
        {
            
        //返回进行数据刷新
        NSNotification *notification = [[NSNotification alloc]initWithName:@"WholesaleNotification" object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter]postNotification:notification];
            
        }else if (i == 2)
        {
         NSNotification *notification = [[NSNotification alloc]initWithName:@"RetailNotification" object:nil userInfo:nil];
         [[NSNotificationCenter defaultCenter]postNotification:notification];
            
        }
    }
    
    //在进行y轴
    //进行y轴上判断
    static float newY = 0;
    static float oldY = 0;
    newY = scrollView.contentOffset.y ;
    if (newY != oldY ) {
        NSLog(@"不进行数据请求");
    }
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"showThreeFreight" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"WholesaleTemplateName" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"RetailTemplateName" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"ShowAllFreightName" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"HideAllFreightName" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"showDeleteFreightName" object:nil];
      [[NSNotificationCenter defaultCenter]removeObserver:self name:@"hideDeleteFreightName" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"showWholesaleTemplateName" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"hideWholesaleTemplateName" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"showRetailNotification" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"hideRetailNotification" object:nil];
}


@end
