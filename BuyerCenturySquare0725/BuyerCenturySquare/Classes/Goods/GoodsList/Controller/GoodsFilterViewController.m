//
//  GoodsResultViewController.m
//  BuyerCenturySquare
//
//  Created by 左键视觉 on 16/3/23.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "GoodsFilterViewController.h"

@interface GoodsFilterViewController ()
{

    //!----搜索、筛选的导航
    UIButton *selectTempBtn;
    //!搜索view
    SearchView * otherSearchView;

}
//!------搜索、筛选的导航
//商家 商品选择框
@property(nonatomic,assign)MerchantAndGoodSelectView * headerSelectView;

@property(nonatomic,assign)BOOL isSearchMerchant;//!搜索的是否是商家（用于商家 商品选择框、点击搜索时候判断是搜 商家 还是 商品）


@end

@implementation GoodsFilterViewController

#pragma mark 重写父类的方法
- (void)viewDidLoad {
    
   [super viewDidLoad];//!需要走父类的 创建UI

}
-(void)viewWillAppear:(BOOL)animated{

    //!记录搜索的是商品还是商家（当前界面是 搜索、筛选 结果页面的时候需要）
    self.isSearchMerchant = NO;
    
    //!创建导航 需要在这里创建，不然界面消失的时候会把导航上的控件删除
    [self createNav];

    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];

    //!调用父类的方法
    [self addAllNotification];
    
}

-(void)viewDidDisappear:(BOOL)animated{
    
    
    //!移除导航上的控件
    if (_headerSelectView) {
        
        [_headerSelectView removeFromSuperview];
        [otherSearchView removeFromSuperview];
        
    }
    //!调用父类的方法
    [self removeAllNotification];
    [self removeFilterView];
    
    
}

#pragma mark 创建导航
-(void)createNav{

    
    [self createFilterAndSearchNavWithText];
    
    NSString *leftImageName = @"public_nav_back";//!筛选过来的左导航为返回按钮
    CGRect  leftFrame = CGRectMake(0, 0, 10, 18);

    //!左按钮
    UIButton *leftNavBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftNavBtn.frame =leftFrame;
    
    [leftNavBtn setImage:[UIImage imageNamed:leftImageName] forState:UIControlStateNormal];
    [leftNavBtn addTarget:self action:@selector(leftNavClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftNavBtn];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];

}

//!筛选、搜索界面过来的导航
-(void)createFilterAndSearchNavWithText{

    
    __weak GoodsFilterViewController * vc = self;
    
    //!商家、商品分类切换view
    _headerSelectView = [[[NSBundle mainBundle]loadNibNamed:@"MerchantAndGoodSelectView" owner:self options:nil]lastObject];
    _headerSelectView.frame = CGRectMake(15+10 + 27, (self.navigationController.navigationBar.frame.size.height - _headerSelectView.frame.size.height/2)/2, _headerSelectView.frame.size.width, _headerSelectView.frame.size.height/2);//!先只显示一半
    
    [_headerSelectView setDataisFromMerchant:self.isSearchMerchant];//!设置按钮上面的数据，如果是从搜索商家传入yes
    [_headerSelectView setBackgroundColor:[UIColor clearColor]];
    
    _headerSelectView.changHightBlock = ^(BOOL isSelectBtn){//!参数：是否点击了按钮（如果点击按钮就调到搜索界面）

        
        CGFloat hight;
        if (_headerSelectView.frame.size.height >= 60) {//!展开的时候，现在要收起
            
            hight = _headerSelectView.frame.size.height/2;
            
            selectTempBtn.hidden = YES;
            
            
        }else{
            
            hight = _headerSelectView.frame.size.height*2;
            //!对这样的写法深深的致歉，现在实在没有找到办法如何解决 这个选中框第二个按钮不在nav 部分无法点中的问题 ，只好在展开的时候，显示一个透明的按钮在 下面
            
            if (!selectTempBtn) {
                
                selectTempBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                selectTempBtn.frame = CGRectMake(_headerSelectView.frame.origin.x, 0, _headerSelectView.firstBtn.frame.size.width, 30);
                [selectTempBtn setBackgroundColor:[UIColor clearColor]];
                [selectTempBtn addTarget:self action:@selector(tempBtnClick) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:selectTempBtn];
                
            }
            
            selectTempBtn.hidden = NO;
            
            
        }
        
        _headerSelectView.frame =CGRectMake(15+10 + 27, _headerSelectView.frame.origin.y, _headerSelectView.frame.size.width,hight);
        
        //!获取到第一个按钮的数据，判断是商家还是商品
        if ([_headerSelectView.firstBtn.titleLabel.text isEqualToString:@"商家"]) {
            
            self.isSearchMerchant = YES;
            
        }else{
            
            self.isSearchMerchant = NO;
        }
        
        
        if (isSelectBtn) {//!参数：是否点击了按钮（如果点击按钮就调到搜索界面）
            
            [vc intoSearchVC];
            
            
        }
        
        
    };
    [self.navigationController.navigationBar addSubview:_headerSelectView];
    
    
    
    //!假搜索view
    otherSearchView = [[[NSBundle mainBundle]loadNibNamed:@"SearchView" owner:self options:nil]lastObject];
    
    otherSearchView.searchViewTapBlock = ^(){//!点击搜索框的时候调用的方法
        
        [vc intoSearchVC];
        
    };
    otherSearchView.leftLabel.text = self.structName;//!假搜索view 显示的内容
    
    otherSearchView.frame = CGRectMake(CGRectGetMaxX(_headerSelectView.frame)+6, _headerSelectView.frame.origin.y, self.navigationController.navigationBar.frame.size.width - CGRectGetMaxX(_headerSelectView.frame)-6 -7, 30);
    
    [self.navigationController.navigationBar addSubview:otherSearchView];
    
}


//!进入搜索界面
-(void)intoSearchVC{
    
    SearchMerhcantAndGoodController * searchVC = [[SearchMerhcantAndGoodController alloc]init];
    searchVC.isSearchMerchant = self.isSearchMerchant;//!搜索的是商家传入 yes，搜索的是商品 传入no
    [self.navigationController pushViewController:searchVC animated:NO];
    
    
}

-(void)tempBtnClick{
    
    [_headerSelectView secondBtnClick];
    
}

-(void)leftNavClick{

    [self.navigationController popViewControllerAnimated:YES];

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
