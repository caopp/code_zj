//
//  PhotoPreviewController.m
//  SellerCenturySquare
//
//  Created by 左键视觉 on 15/12/31.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import "PhotoPreviewController.h"

@interface PhotoPreviewController ()<UIActionSheetDelegate,UIScrollViewDelegate>
{

    UIScrollView *_sc;

}
@end

@implementation PhotoPreviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customBackBarButton];


    //!创建导航
    [self createNav];
    
    //!创建scrollerView
    [self createSC];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];


}
-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = NO;

}
-(void)viewDidDisappear:(BOOL)animated{

    
    [super viewDidDisappear:animated];
    
    self.navigationController.navigationBar.translucent = YES;

    
}
#pragma mark 创建导航
-(void)createNav{

    
    //!导航左按钮
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"04_商家中心_设置_后退"] style:UIBarButtonItemStylePlain target:self action:@selector(backBarButtonClick)];
    
    self.navigationItem.leftBarButtonItem = backBarButton;
    
    //!导航右按钮
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"zoomDelete"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnClick)];
    
    self.navigationItem.rightBarButtonItem = rightBarButton;

    

}
-(void)backBarButtonClick{

    [self.navigationController popViewControllerAnimated:YES];

}
#pragma mark createSC
-(void)createSC{

    _sc = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH , self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height -20)];
        
    _sc.contentSize = CGSizeMake(SCREEN_WIDTH * self.dataArray.count, _sc.frame.size.height);
    _sc.delegate = self;
    _sc.pagingEnabled = YES;
    _sc.bounces = YES;
    _sc.showsHorizontalScrollIndicator = NO;
    
    [self.view addSubview:_sc];

    for (int i=0; i<self.dataArray.count; i++) {
        
        //!获取图片的宽高
        NSDictionary *imgaeDic = self.dataArray[i];
        UIImage * nowImage = imgaeDic[@"UIImagePickerControllerOriginalImage"];
        
        //!计算图片显示的高度
        CGFloat hight = SCREEN_WIDTH/(nowImage.size.width/nowImage.size.height);
        CGFloat y = (_sc.frame.size.height - hight)/2;
        
        if (hight>_sc.frame.size.height) {
            
            hight =_sc.frame.size.height;
            y = 0;
        }
        CGFloat x = self.view.frame.size.width *i;
    
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(x, y, _sc.frame.size.width, hight)];
        
        imageView.image = nowImage;

        imageView.tag = 100+i;
        [_sc addSubview:imageView];

        
    }
    
    _sc.contentOffset = CGPointMake(SCREEN_WIDTH*(self.intoNum-1), 0);
    

    self.title = [NSString stringWithFormat:@"%ld/%lu",(long)self.intoNum , (unsigned long)self.dataArray.count];


    
}
#pragma mark 删除事件
-(void)rightBtnClick{


    UIActionSheet *actionTitle = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定删除图片？" otherButtonTitles:@"拍照", nil];
    [actionTitle showInView:self.view];

    

}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{

    //!选中删除
    if (!buttonIndex) {
        
        //!读取删除的是第几个
        CGPoint nowPoint = _sc.contentOffset;
        int selectInteger = nowPoint.x/SCREEN_WIDTH;
        
        //!删除对应的view，并从数据数组中删除 改变contentsize
        UIImageView *selectImageView = (UIImageView *)[_sc viewWithTag:(100+selectInteger)];
        [selectImageView removeFromSuperview];
        
        
        //!改变位置
        //!最后一个，并且前面是有数据的 则contentoffset调到显示倒数第二个 即可
        if (selectInteger == self.dataArray.count - 1 && self.dataArray.count !=1 ) {
            
            _sc.contentOffset = CGPointMake(_sc.contentOffset.x - SCREEN_WIDTH, 0);
            
        }else if (selectInteger == 0 && self.dataArray.count == 1){ //!如果删除的是第一个，并且最后只剩下这个了
        
            
            [self.dataArray removeObjectAtIndex:0];
            //!调用代理方法
            if (self.delegateBlock) {
                
                self.delegateBlock();//!刷新界面
            }
            
            [self.navigationController popViewControllerAnimated:YES];
        
            
            return;
            
        }else{//!不是最后一个，改变所有的位置

        
            for (int i= selectInteger+1; i<self.dataArray.count; i++) {
                
                //!获取图片的宽高
                NSDictionary *imgaeDic = self.dataArray[i];
                UIImage * nowImage = imgaeDic[@"UIImagePickerControllerOriginalImage"];
                
                //!计算图片显示的高度
                CGFloat hight = SCREEN_WIDTH/(nowImage.size.width/nowImage.size.height);
                CGFloat y = (_sc.frame.size.height - hight)/2;
                if (hight>_sc.frame.size.height) {
                    
                    hight =_sc.frame.size.height;
                    y = 0;
                }
                
                CGFloat x = self.view.frame.size.width *(i-1);
                
                UIImageView *selectImageView = (UIImageView *)[_sc viewWithTag:(100+i)];
                selectImageView.frame = CGRectMake(x, y, _sc.frame.size.width, hight);
                
                //!改变tag
                selectImageView.tag = 100+(i-1);
                
            }
        
        
        }
        
        
        [self.dataArray removeObjectAtIndex:selectInteger];
        _sc.contentSize = CGSizeMake(SCREEN_WIDTH*self.dataArray.count, _sc.frame.size.height);
        //!调用代理方法
        if (self.delegateBlock) {
            
            self.delegateBlock();//!刷新界面
        }
        
        float x = _sc.contentOffset.x;
        int page = x/SCREEN_WIDTH;
        
        self.title = [NSString stringWithFormat:@"%d/%lu",page + 1 , (unsigned long)self.dataArray.count];
        
        
    }


}






-(void)scrollViewDidScroll:(UIScrollView *)scrollView{


    float x = scrollView.contentOffset.x;
    int page = x/SCREEN_WIDTH;
    
    self.title = [NSString stringWithFormat:@"%d/%lu",page + 1 , (unsigned long)self.dataArray.count];

    

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
