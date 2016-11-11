//
//  IMCollectOrderTableViewCell.m
//  BuyerCenturySquare
//
//  Created by caopenpen on 16/3/21.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "IMCollectOrderTableViewCell.h"
#import "OrderLabel.h"
#import "IMGoodsInfoDTO.h"
#import "DoubleSku.h"

@implementation IMCollectOrderTableViewCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)awakeFromNib{
   
    
//        UIView *viewSize = [UIView new] ;
//       
//        viewSize.backgroundColor = [UIColor whiteColor];
//        labelNo.heightDime.equalTo(@((random() % 40) + 40));
//        labelNo.widthDime.min(40);
//        
//         [self.layOutView addSubview:viewSize];
    self.layOutView.wrapContentHeight = YES;

   
}

-(void)loadMessage:(ECMessage *)message{
   
    
    self.timeLabel.text =message.showTime?  [CSPUtils changeTheDateString:[CSPUtils getTime:message.dateTime]]:@"";
    NSArray *arrGoodNo = [message.goodNo componentsSeparatedByString:@";"];
    NSArray *arrColor =  [message.goodColor componentsSeparatedByString:@";"];
    NSArray *arrGoodsWillNo =  [message.goodsWillNo componentsSeparatedByString:@";"];
    NSArray *arrPrice =  [message.goodPrice componentsSeparatedByString:@";"];
    
    NSData *jsonData = [message.goodSku dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    
    NSMutableArray *skuList = [dic objectForKey:@"skuList"];
    
    NSString *messageType = [dic objectForKey:@"msgType"];
    NSArray *arrType = [messageType componentsSeparatedByString:@";"];
 
    for (UIView *view in [self.layOutView subviews]) {
        [view removeFromSuperview];
    }
     BOOL isCount = NO;//总采购单量
    for (int i =0 ;i< arrColor.count;i++) {
        
        NSString *modeType = [arrType objectAtIndex:i];
        NSDictionary *dic = [skuList objectAtIndex:i];
       
        for (NSString * skuName in dic.allKeys) {
            NSString *value = [[[dic objectForKey:skuName] componentsSeparatedByString:@","] objectAtIndex:0];
            if ([value intValue]>0||[modeType isEqualToString:@"3"]) {
                isCount = YES;
            }
        }
    }
    for (int i =0 ;i< arrColor.count;i++) {
        
        NSString *goodNo = [arrGoodNo objectAtIndex:i];
        NSString *color = [arrColor objectAtIndex:i];
        NSString *goodsWillNo =[arrGoodsWillNo objectAtIndex:i];
        NSString *price = [arrPrice objectAtIndex:i];
        NSString *modeType = [arrType objectAtIndex:i];
        NSDictionary *dic = [skuList objectAtIndex:i];
        BOOL isExcited = NO;
        for (NSString * skuName in dic.allKeys) {
            NSString *value = [[[dic objectForKey:skuName] componentsSeparatedByString:@","] objectAtIndex:0];
            if ([value intValue]>0||[modeType isEqualToString:@"3"]) {
                isExcited = YES;
            }
        }
        if (!isExcited&&isCount) {
            continue;
        }
        NSInteger count = [modeType isEqualToString:@"3"]?1:(dic.allKeys.count);
        for (int i = 0; i<count +2; i++) {
            OrderLabel *labelNo = [OrderLabel new];// initWithFrame:CGRectMake(80, 15 +50*i, self.frame.size.width - 100, 20)];
            labelNo.font = [UIFont systemFontOfSize:13.0];
            labelNo.textColor = [UIColor colorWithHexValue:0x666666 alpha:1];
            
            
            if (i==0) {
                NSString *colorStr;
                if ([modeType isEqualToString:@"2"]) {
                    colorStr = color;
                }else{
                    colorStr = [NSString stringWithFormat:@"%@样板",color];
                }
                
                //添加颜色
                
                NSString *goodnoStr = [NSString stringWithFormat:@"%@  %@  ￥%@",goodsWillNo?goodsWillNo:@"",colorStr,price];
                
                CGSize titleSize = [goodnoStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 120, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
                
                labelNo.numberOfLines = 0;
                labelNo.textAlignment = NSTextAlignmentLeft;
                labelNo.heightDime.min(titleSize.height);
                labelNo.leftPos.equalTo(@(0));
                labelNo.topPos.equalTo(@(10));
                labelNo.widthDime.equalTo(@(self.layOutView.frame.size.width));
               
                
                NSMutableAttributedString * str = [[NSMutableAttributedString alloc]initWithString:goodnoStr attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13.0f], NSForegroundColorAttributeName: [UIColor colorWithHexValue:0x666666 alpha:1]}];
                [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexValue:0x3e00aa alpha:1] range:NSMakeRange([goodnoStr length]-[price length]-1, [price length]+1)];
                
                
//                labelNo.text = [NSString stringWithFormat:@"%@  %@  ￥%@",goodsWillNo,colorStr,price];
                labelNo.attributedText = str;
                
                
            }else if(i==1){
                if (!isExcited) {
                    continue;
                }
                labelNo.textAlignment = NSTextAlignmentLeft;
                labelNo.heightDime.equalTo(@(15));
                labelNo.widthDime.min(40);
                labelNo.topPos.equalTo(@(10));
                labelNo.leftPos.equalTo(@(0));
              
                labelNo.text = color;
                [labelNo sizeToFit];
            }else{
               
                labelNo.textAlignment = NSTextAlignmentCenter;
                labelNo.layer.masksToBounds = YES;
                labelNo.layer.cornerRadius = 4.0f;
                labelNo.layer.borderColor = [UIColor blackColor].CGColor;
                labelNo.layer.borderWidth = 0.4f;
               
                if ([modeType isEqualToString:@"2"]) {
                    NSString * skuName = [dic.allKeys objectAtIndex:i-2];
                    NSString *value = [[[dic objectForKey:skuName] componentsSeparatedByString:@","] objectAtIndex:0];
                    if ([value intValue]==0&&[modeType isEqualToString:@"2"]) {
                        continue;
                    }
                    
                    labelNo.text =[NSString stringWithFormat:@" %@ × %@  ",skuName,value] ;
                }else{
                    labelNo.text =[NSString stringWithFormat:@" 样板 × 1  "] ;
                }
             
                
                labelNo.heightDime.equalTo(@(15));
                labelNo.leftPos.equalTo(@(10));
                labelNo.topPos.equalTo(@(10));
                labelNo.widthDime.min(60);
                [labelNo sizeToFit];
                
                
            }
            [self.layOutView addSubview:labelNo];
            
        }

    }

        
    
}
//    CGRect rectM = [self.layOutView estimateLayoutRect:CGSizeMake(320, 0)];
//    NSLog(@"myHeight===%f",rectM.size.height);
//    CGRect rect = self.frame;
//    rect.size.height = rectM.size.height+20;
//    [self setFrame:rect];


@end
