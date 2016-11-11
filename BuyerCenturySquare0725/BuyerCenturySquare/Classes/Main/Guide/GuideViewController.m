//
//  GuideViewController.m
//  SellerCenturySquare
//
//  Created by 左键视觉 on 15/12/21.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import "GuideViewController.h"

@interface GuideViewController ()

@end

@implementation GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self createSC];


}

-(void)createSC{
    
    //!更新app进行的查看
    /*
    NSString * guideNum = @"4";
    if (SCREEN_HEIGHT<=480) {
        
        guideNum = @"4";
        
    }else if (SCREEN_HEIGHT<= 568 && SCREEN_HEIGHT>480){
        
        guideNum = @"5";
        
        
    }else if (SCREEN_WIDTH == 375){
        
        guideNum = @"6";
        
    }else{
        
        guideNum = @"6p";
    }
    
    imagesArray = [[NSMutableArray alloc]initWithObjects:[UIImage imageNamed:[NSString stringWithFormat:@"guide%@_1",guideNum]],[UIImage imageNamed:[NSString stringWithFormat:@"guide%@_2",guideNum]],[UIImage imageNamed:[NSString stringWithFormat:@"guide%@_3",guideNum]],[UIImage imageNamed:[NSString stringWithFormat:@"guide%@_4",guideNum]],[UIImage imageNamed:[NSString stringWithFormat:@"guide%@_5",guideNum]], nil];
    */
    imagesArray = [[NSMutableArray alloc]initWithObjects:
                   [UIImage imageNamed:@"guide_1.jpg"],
                   [UIImage imageNamed:@"guide_2.jpg"],
                   [UIImage imageNamed:@"guide_3.jpg"],
                   [UIImage imageNamed:@"guide_4.jpg"],
                   [UIImage imageNamed:@"guide_5.jpg"],
                   [UIImage imageNamed:@"guide_6.jpg"], nil];

    guideScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    guideScrollView.contentSize = CGSizeMake(SCREEN_WIDTH*imagesArray.count, self.view.frame.size.height - 100);
    
    guideScrollView.pagingEnabled = YES;
    
    guideScrollView.bounces = NO;
    
    guideScrollView.showsHorizontalScrollIndicator = NO;
    
    guideScrollView.showsVerticalScrollIndicator = NO;
    
    guideScrollView.delegate = self;
    
    [self.view addSubview:guideScrollView];
    
    
    // !如果是从关于进去
    if (self.isFromAbout) {
        
        guideScrollView.contentOffset = CGPointMake(0, 0);
        
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backBtn setImage:[UIImage imageNamed:@"guideBack"] forState:UIControlStateNormal];
        [backBtn setImage:[UIImage imageNamed:@"guideBack"] forState:UIControlStateSelected];

        backBtn.frame = CGRectMake(15, 30, 26, 26);
        [backBtn addTarget:self action:@selector(backBtnClcik) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:backBtn];
        
    }
    
    
    
    for (int i = 0; i < imagesArray.count; i++) {
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i*SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        
        imageView.image = [imagesArray objectAtIndex:i];
        
        [guideScrollView addSubview:imageView];
        
        if (i == imagesArray.count-1) {
            //添加立即体验按钮
            UIButton *enterButton = [UIButton buttonWithType:UIButtonTypeCustom];
            enterButton.frame = CGRectMake(20, SCREEN_HEIGHT - 150, SCREEN_WIDTH - 40, 80);
//            enterButton.alpha = 0.5;
            
            [enterButton addTarget:self action:@selector(enterButton) forControlEvents:UIControlEventTouchUpInside];
            
            [imageView addSubview:enterButton];
            
            imageView.userInteractionEnabled = YES;
        }
        
    }
    
    pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(20, SCREEN_HEIGHT-50, SCREEN_WIDTH-40, 30)];
    pageControl.numberOfPages = imagesArray.count;
    pageControl.currentPage = 0;
    pageControl.pageIndicatorTintColor = [UIColor grayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    
    [self.view addSubview:pageControl];
    
    
}
#pragma mark-立即体验
- (void)enterButton{
    
    [guideScrollView removeFromSuperview];
    guideScrollView = nil;
    
    [pageControl removeFromSuperview];
    pageControl = nil;
    
    //!从关于进入的
    if (self.isFromAbout) {
        
//        [self.navigationController popToRootViewControllerAnimated:YES];
        [self dismissViewControllerAnimated:YES completion:^{
           
            
            if (self.changeVCBlcok) {
                
                self.changeVCBlcok();
                
            }
        
            
        }];
        
        
    }else{
    
    
        if (self.changeVCBlcok) {
            
            self.changeVCBlcok();
            
        }
    }
    
    
  
    
    
}

#pragma mark 返回按钮
-(void)backBtnClcik{


//    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;

    
    if (scrollView.contentOffset.y < 0 || scrollView.contentOffset.y >20) {
        
        scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, 0);
        
    }
    
}




#pragma mark 处理导航
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;

}

-(void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.hidden = NO;

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
