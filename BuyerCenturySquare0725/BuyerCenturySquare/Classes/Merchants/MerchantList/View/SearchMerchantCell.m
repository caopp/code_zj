//
//  SearchMerchantCell.m
//  BuyerCenturySquare
//
//  Created by 左键视觉 on 16/3/22.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "SearchMerchantCell.h"
#import "InMerchantGoodsView.h"

#import "UIImageView+WebCache.h"
@implementation SearchMerchantCell

-(void)drawRect:(CGRect)rect{

    self.showImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.showImageView.clipsToBounds = YES;

    //!商家收藏按钮不同状态的图片显示
    [self.collectBtn setImage:[UIImage imageNamed:@"merchant_collect"] forState:UIControlStateNormal];
    [self.collectBtn setImage:[UIImage imageNamed:@"merchant_collectSelected"] forState:UIControlStateSelected];
    
    [self.tagsView setBackgroundColor:[UIColor clearColor]];
    
    //!让cell上面的回到顶部权限关闭，不影响所在的collectionview回到顶部的功能
    self.goodsSC.scrollsToTop = NO;
    

}

-(void)configData:(SearchMerhantDTO *)merhantDTO{

    merchantDTOs = merhantDTO;
    
    //!背景图片
    [self.showImageView sd_setImageWithURL:[NSURL URLWithString:merhantDTO.pictureUrl] placeholderImage:[UIImage imageNamed:@"big_placeHolder"]];
    
    //!名字
    self.merchantNameLabel.text = merhantDTO.merchantName;
    
    //!标签
    
    //!档口号
    self.addressLabel.text = merhantDTO.stallNo;
    
    //!件数
    self.goodNumLabel.text = [NSString stringWithFormat:@"%@",merhantDTO.goodsNum];
    
    //!是否喜欢
    if ([merchantDTOs.isFavorite isEqualToString:@"0"]) {
        
        self.collectBtn.selected = YES;

    }else{
    
        self.collectBtn.selected = NO;

    }
    //!创建标签
    [self createTags:merhantDTO];

    
    
    
    //!创建sc
    [self createSc:merhantDTO];


    
}
#pragma mark 创建分类、标签
-(void)createTags:(SearchMerhantDTO * )merhantDTO{

    for (UIView * childView in self.tagsView.subviews) {
        
        [childView removeFromSuperview];
    }
    
    
    //!分类的label
    NSString * showStr = merhantDTO.categoryName;
    CGSize showSize = [self showSize:showStr];
   
    UILabel * categoryLabel = [self tagsLabel];
    categoryLabel.frame = CGRectMake(0, 0, showSize.width + 15, 13);
    categoryLabel.text = showStr;
    [categoryLabel setBackgroundColor:[UIColor whiteColor]];
    [categoryLabel setTextColor:[UIColor blackColor]];
    [self.tagsView addSubview:categoryLabel];
    
    //!分割标签
    
    //!规定：类别 和 标签 所在的view 距离两边的距离最小是55

    //!还原 先让 tagsView距离两边的距离变为55
    self.tagsViewLeft.constant = 55;
    self.tagsViewRight.constant = 55;
    
    //!计算tagsView的宽度
    float tagViewWidth = self.frame.size.width - self.tagsViewLeft.constant - self.tagsViewRight.constant;
    
    UILabel * tempLabel = categoryLabel;//!类别label记录下来
    
    if (![merhantDTO.labelName isEqualToString:@""]) {//!如果没有标签，就不进行分割 和创建 标签label
        
        NSArray * tagsArray = [merhantDTO.labelName componentsSeparatedByString:@",,"];
        
        for (int i = 0; i< tagsArray.count; i++) {
            
            UILabel * tagsLabel = [self tagsLabel];
            
            tagsLabel.text = tagsArray[i];
            
            CGSize tagsShowSize = [self showSize: tagsArray[i]];
            
            [tagsLabel setTextColor:[UIColor whiteColor]];
            
            tagsLabel.layer.borderColor = [UIColor whiteColor].CGColor;
            
            tagsLabel.layer.borderWidth = 1;
            
            tagsLabel.frame = CGRectMake(CGRectGetMaxX(tempLabel.frame) +6, 0, tagsShowSize.width + 15 , 13);
             //!如果label已经超出了 tagsView的宽度，就不显示了
            if (CGRectGetMaxX(tagsLabel.frame) > tagViewWidth) {
                
                break ;
            }
            
            [self.tagsView addSubview:tagsLabel];
            
            tempLabel = tagsLabel;
            
        }

        
    }
    //!计算最后一个label在 tagsView上面的位置，得到tagsView的最新宽度，修改tagsView距离两边的大小
    float realTagsViewWidth = CGRectGetMaxX(tempLabel.frame);
    float leftAndRightConst = (self.frame.size.width - realTagsViewWidth)/2.0;
    self.tagsViewLeft.constant = leftAndRightConst;
    self.tagsViewRight.constant = leftAndRightConst;
    
    
}

-(UILabel *)tagsLabel{

    UILabel * categoryLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 34 , 13)];
    [categoryLabel setFont:[UIFont systemFontOfSize:10]];
    categoryLabel.textAlignment = NSTextAlignmentCenter;
    categoryLabel.layer.masksToBounds = YES;
    categoryLabel.layer.cornerRadius = 2;
    
    return categoryLabel;

}

-(CGSize )showSize:(NSString *)price{
    
    //!cell.vipPriceView.frame.size.width =200
    CGSize showSize = [price boundingRectWithSize:CGSizeMake(200, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:10]} context:nil].size;
    
    
    return showSize;
    
    
}

#pragma mark 创建sc
-(void)createSc:(SearchMerhantDTO * )merhantDTO{

    
    if (!self.goodsSC) {
        
        self.goodsSC = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.grayView.frame), self.frame.size.width , self.frame.size.height - CGRectGetMaxY(self.grayView.frame))];//25是收藏按钮距离底部的距离，100是sc的高度
    
        [self.goodsSC setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.95]];
        
       
        [self.contentView addSubview:self.goodsSC];
        
        
    }
    
    for (UIView * views in [self.goodsSC subviews]) {
        
        [views removeFromSuperview];
        
    }
    

    float goodsWidth = self.goodsSC.frame.size.height  * (2.0/3.0);

    int num = 0;
    __weak SearchMerchantCell * cell = self;
    
    for (int i = 0 ; i < 11; i ++) {
        
        
        InMerchantGoodsView * goodsView ;
        
        if (i == 10) {//!如果是最后一个，变成“进入店铺”
            
            goodsView = [self lastGoodsViewWithNum:i withWidth:goodsWidth];
            
            goodsView.selectBlock = ^(){
            
                
                [cell selectLastBtnClick];
                
            };
            
        }else if(i < merhantDTO.tenNumGoodsArray.count){//!商品
            
            goodsView = [self goodsViewWithNum:i withWidth:goodsWidth];
            TenNumGoodsDTO * goodsDTO = (TenNumGoodsDTO *)merhantDTO.tenNumGoodsArray[i];
            
            [goodsView.goodsImageView sd_setImageWithURL:[NSURL URLWithString:goodsDTO.imgUrl] placeholderImage:[UIImage imageNamed:@"middle_placeHolder"]];
            
            
            goodsView.goodsPriceLabel.text = [NSString stringWithFormat:@"￥%@",goodsDTO.memberPirce];
            
            if ([goodsDTO.authFlag isEqualToString:@"0"]) {//!0 无、1 有
                
                goodsView.blueView.hidden = NO;
                
                goodsView.readLevelLabel.text = [NSString stringWithFormat:@"V%@",goodsDTO.readLevel];
                
            }else{
                
                goodsView.blueView.hidden = YES;
            }
            
            [goodsView.selectBtn setTitle:@"" forState:UIControlStateNormal];
            [goodsView.selectBtn setTitle:@"" forState:UIControlStateSelected];
            
            goodsView.selectBlock = ^(){
            
              
                [cell selectGoods:goodsDTO];//!传进点击的dto
            
            };
            
        }else{//!默认图
        
            goodsView = [self goodsViewWithNum:i withWidth:goodsWidth];
            
            [goodsView.goodsImageView setImage:[UIImage imageNamed:@"placeholder"]];
            
            goodsView.goodsPriceLabel.text = @"";
            goodsView.blueView.hidden = YES;
            
            [goodsView.selectBtn setTitle:@"" forState:UIControlStateNormal];
            [goodsView.selectBtn setTitle:@"" forState:UIControlStateSelected];
        
        }
        

        
        //!设置背景颜色
        goodsView.backgroundColor =  [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.95];

        
        [self.goodsSC addSubview:goodsView];
        
        num = i;
        
        
    }
    /*
    //!如果num == 0，说明没有商品,放空的到上面
    if (num == 0) {
        
        for (int i = 0 ; i < 11 ; i ++ ) {
            
            InMerchantGoodsView * goodsView ;
            
            if (i == 10) {
                
                goodsView = [self lastGoodsViewWithNum:i withWidth:goodsWidth];
                
                goodsView.selectBlock = ^(){
                    
                    [cell selectLastBtnClick];//!点击最后一个按钮
                    
                };
                
            }else{
                
                goodsView = [self goodsViewWithNum:i withWidth:goodsWidth];
                
                [goodsView.goodsImageView setImage:[UIImage imageNamed:@"placeholder"]];
                
                goodsView.goodsPriceLabel.text = @"";
                goodsView.blueView.hidden = YES;
                
                [goodsView.selectBtn setTitle:@"" forState:UIControlStateNormal];
                [goodsView.selectBtn setTitle:@"" forState:UIControlStateSelected];
                
            }
            
            [self.goodsSC addSubview:goodsView];
            
            
            num = i;
        }
        
        
    }
     */
    
    self.goodsSC.contentSize = CGSizeMake(goodsWidth*(num +1 ) + 6*num + 15,self.goodsSC.frame.size.height);

    
    self.goodsSC.contentOffset = CGPointMake(0, 0);
    
}

-(InMerchantGoodsView *)goodsViewWithNum:(int)i withWidth:(float)goodsWidth{

    InMerchantGoodsView * goodsView = [[[NSBundle mainBundle]loadNibNamed:@"InMerchantGoodsView" owner:nil options:nil]lastObject];
    goodsView.frame = CGRectMake(15 + goodsWidth * i + 6* i, 15 , goodsWidth, self.goodsSC.frame.size.height - 15);
    
    return goodsView;

}
//!最后一个点击“进入店铺”
-(InMerchantGoodsView *)lastGoodsViewWithNum:(int)i withWidth:(float)goodsWidth{
    
    InMerchantGoodsView * goodsView = [[[NSBundle mainBundle]loadNibNamed:@"InMerchantGoodsView" owner:nil options:nil]lastObject];
    goodsView.frame = CGRectMake(15 + goodsWidth * i + 6* i, 15 , goodsWidth, self.goodsSC.frame.size.height - 15);
    
    goodsView.goodsImageView.hidden = YES;
    goodsView.goodsPriceLabel.hidden = YES;
    goodsView.blueView.hidden = YES;
    
    return goodsView;
    
}
//!点击事件
//!点击最后一个的事件
-(void)selectLastBtnClick{


    if (self.selectGoodsBlock) {
        
        self.selectGoodsBlock(nil,YES,merchantDTOs.merchantNo);
    }
    

}
//!点击前面几个的事件
-(void)selectGoods:(TenNumGoodsDTO *)goodDTO{

    
    if (self.selectGoodsBlock) {
        
        self.selectGoodsBlock(goodDTO,NO,merchantDTOs.merchantNo);
        
    }

    
}


- (IBAction)collectBtnClick:(id)sender {
    
    if (self.collectBtnClock) {
        
        self.collectBtnClock();
        
    }

    

    
}


@end
