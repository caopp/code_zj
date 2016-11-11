//
//  CSPGoodsInfoTopInfoTableViewCell.m
//  BuyerCenturySquare
//
//  Created by 李春晓 on 15/7/14.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CSPGoodsInfoTopInfoTableViewCell.h"
#import "StepListDTO.h"
#import "UIColor+Extend.h"

@implementation CSPGoodsInfoTopInfoTableViewCell{
    
    NSInteger stepListCount;
    NSInteger lineCount;
}

- (void)awakeFromNib {
    // Initialization code
    _TopBar.tag = 999;
    _memberLevel.layer.masksToBounds = YES;
    _memberLevel.layer.cornerRadius = 4.0f;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeBG) name:@"test" object:nil];
}
//-(void)layoutSubviews{
//    
//    _TopBar.tag = 999;
//    CGRect tmpRect = [self.goodName.text boundingRectWithSize:CGSizeMake(self.frame.size.width-30,1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:19.0],NSFontAttributeName, nil] context:nil];
//    CGRect from = self.goodName.frame;
//    from.size.height = tmpRect.size.height;
//    self.goodName.frame = from;
//    CGRect fromP = self.price.frame;
//    fromP.origin.y = from.origin.y +from.size.height +20;
//    self.price.frame = fromP;
//    CGRect fromM = self.moneyLogoL.frame;
//    fromM.origin.y =from.origin.y +from.size.height +33;
//    self.moneyLogoL.frame = fromM;
//}
- (void)changeBG{
    
    [_navBarView setBackgroundColor:[UIColor blackColor]];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//- (void)setStepList:(NSMutableArray *)stepList{
//    
//    if (stepList==nil) {
//        return;
//    }
//    CGRect tmpRect = [self.goodName.text boundingRectWithSize:CGSizeMake(self.frame.size.width-30,1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:18.0],NSFontAttributeName, nil] context:nil];
//
//
//    CGFloat yOffset = tmpRect.size.height + 24;
//    _moneyLogoL.hidden = NO;
//    
//    stepListCount = [stepList count] ;
//    
//    NSMutableDictionary *stepListDic = [[NSMutableDictionary alloc]init];
//    
//    for (StepListDTO *tmpDTO in stepList) {
//        NSNumber *sort = tmpDTO.sort;
//        [stepListDic setObject:tmpDTO forKey:sort];
//    }
//   
//    NSInteger lineCountA = stepListCount/3;
//    NSInteger lineCountB = stepListCount%3;
//    if (lineCountB>0) {
//        lineCount = lineCountA+1;
//    }else{
//        lineCount = lineCountA;
//    }
//    CGFloat width = (self.frame.size.width-34)/3;
//    CGFloat plusX = 125;
//    
//    if ([UIScreen mainScreen].bounds.size.width==320) {
//        width = 85;
//        plusX = 110;
//    }
//
//    for (int i = 0; i<lineCount; i++) {
//        
//        StepListDTO *presentStepListDTO;
//        
//        UIFont *font = [UIFont systemFontOfSize:14];
//        
//        UILabel *stepLabel_1 = [[UILabel alloc]initWithFrame:CGRectMake(15,yOffset+30+i*16,width,14)];
//        UILabel *stepLabel_2 = [[UILabel alloc]initWithFrame:CGRectMake(plusX,yOffset+30+i*16,width,14)];
//        UILabel *stepLabel_3 = [[UILabel alloc]initWithFrame:CGRectMake(plusX*2,yOffset+30+i*16,width,14)];
//        
//        [stepLabel_1 setTextColor:[UIColor colorWithHexColorString:@"666666"]];
//        [stepLabel_2 setTextColor:[UIColor colorWithHexColorString:@"666666"]];
//        [stepLabel_3 setTextColor:[UIColor colorWithHexColorString:@"666666"]];
//        
//        [stepLabel_1 setFont:font];
//        [stepLabel_2 setFont:font];
//        [stepLabel_3 setFont:font];
//        
//        UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(plusX-5,yOffset+31+i*18, 1, 12)];
//        UIView *lineV2 = [[UIView alloc]initWithFrame:CGRectMake(plusX*2-5,yOffset+31+i*18, 1, 12)];
//        [lineV setBackgroundColor:[UIColor lightGrayColor]];
//        [lineV2 setBackgroundColor:[UIColor lightGrayColor]];
//        
//        NSNumber *count =[NSNumber numberWithInteger:i*3+1];
//        presentStepListDTO = stepListDic[count];
//        stepLabel_1.text = [NSString stringWithFormat:@"%@件 :￥%.2lf",presentStepListDTO.minNum,[presentStepListDTO.price floatValue]];
//        [self insertSubview:stepLabel_1 atIndex:0];
//        
//        if ((lineCount-1==i&&lineCountB>=2)||(lineCount-1==i&&lineCountB==0)||lineCount-1>i) {
//            
//            NSNumber *count2 =[NSNumber numberWithInteger:i*3+2];
//            presentStepListDTO = stepListDic[count2];
//            NSString *minNum2 = [presentStepListDTO.minNum stringValue];
//            NSString *price2 = [presentStepListDTO.price stringValue];
//            
//            stepLabel_2.text = [NSString stringWithFormat:@"%@件 :￥%.2lf",minNum2,[price2 floatValue]];
//            stepLabel_2.textAlignment = NSTextAlignmentCenter;
//            [self insertSubview:stepLabel_2 atIndex:0];
//            [self insertSubview:lineV atIndex:0];
//            
//        }
//        
//        if ((lineCount-1==i&&lineCountB==0)||lineCount-1>i) {
//
//            NSNumber *count3 =[NSNumber numberWithInteger:i*3+3];
//            presentStepListDTO = stepListDic[count3];
//            NSString *minNum3 = [presentStepListDTO.minNum stringValue];
//            NSString *price3 = [presentStepListDTO.price stringValue];
//            stepLabel_3.text = [NSString stringWithFormat:@"%@件 :￥%.2lf",minNum3,[price3 floatValue]];
//            stepLabel_3.textAlignment = NSTextAlignmentRight;
//            [self insertSubview:stepLabel_3 atIndex:0];
//            [self insertSubview:lineV2 atIndex:0];
//        }
//         yOffset += 5;
//    }
//    
//    CGFloat height = 0;
//    
//    int borderNum = 1;
//    if (lineCount>borderNum) {
//        
//        height += 18*(lineCount-borderNum);
//    }
//    
//    height += 45+yOffset;
//    
//    CGRect cellFrame = self.frame;
//    cellFrame.size.height =height;
//    
//    [self setFrame:cellFrame];
//}
-(void)removeView{
    for (UIView *view in self.subviews) {
        if (view.tag == 100) {
             [view removeFromSuperview];
        }
       
    }
}
- (void)setStepList:(NSMutableArray *)stepList{
    
    if (stepList==nil) {
        return;
    }
    [self removeView];
    CGRect tmpRect = [self.goodName.text boundingRectWithSize:CGSizeMake(self.frame.size.width-30,1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:17.0],NSFontAttributeName, nil] context:nil];
    
    CGFloat yOffset = tmpRect.size.height-30+5;
    _moneyLogoL.hidden = NO;
    
    stepListCount = [stepList count] ;
    
    NSMutableDictionary *stepListDic = [[NSMutableDictionary alloc]init];
    
    for (StepListDTO *tmpDTO in stepList) {
        NSNumber *sort = tmpDTO.sort;
        [stepListDic setObject:tmpDTO forKey:sort];
    }
    
    NSInteger lineCountA = stepListCount/3;
    NSInteger lineCountB = stepListCount%3;
    if (lineCountB>0) {
        lineCount = lineCountA+1;
    }else{
        lineCount = lineCountA;
    }
    CGFloat width = (self.frame.size.width-24)/3;
    CGFloat plusX = 125;
    
    if ([UIScreen mainScreen].bounds.size.width==320) {
        width = 85;
        plusX = 110;
    }
    
    for (int i = 0; i<lineCount; i++) {
        
        StepListDTO *presentStepListDTO;
        
//        UIFont *font = [UIFont systemFontOfSize:14];
        UIFont *font = [UIFont systemFontOfSize:14];
        UILabel *stepLabel_1 = [[UILabel alloc]initWithFrame:CGRectMake(15,yOffset+105+i*16,width,14)];
        UILabel *stepLabel_2 = [[UILabel alloc]initWithFrame:CGRectMake(plusX,yOffset+105+i*16,width,14)];
        UILabel *stepLabel_3 = [[UILabel alloc]initWithFrame:CGRectMake(plusX*2,yOffset+105+i*16,width,14)];
        stepLabel_1.tag = 100;
        stepLabel_2.tag = 100;
        stepLabel_3.tag = 100;
        
        [stepLabel_1 setTextColor:[UIColor colorWithHexColorString:@"666666"]];
        [stepLabel_2 setTextColor:[UIColor colorWithHexColorString:@"666666"]];
        [stepLabel_3 setTextColor:[UIColor colorWithHexColorString:@"666666"]];
        
        [stepLabel_1 setFont:font];
        [stepLabel_2 setFont:font];
        [stepLabel_3 setFont:font];
        
        UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(plusX-5,yOffset+106+i*18, 1, 12)];
        UIView *lineV2 = [[UIView alloc]initWithFrame:CGRectMake(plusX*2-5,yOffset+106+i*18, 1, 12)];
        [lineV setBackgroundColor:[UIColor lightGrayColor]];
        [lineV2 setBackgroundColor:[UIColor lightGrayColor]];
        lineV.tag = 100;
        lineV2.tag = 100;
        NSNumber *count =[NSNumber numberWithInteger:i*3+1];
        presentStepListDTO = stepListDic[count];
        stepLabel_1.text = [NSString stringWithFormat:@"%@件 :￥%.2lf",presentStepListDTO.minNum,[presentStepListDTO.price floatValue]];
        [self insertSubview:stepLabel_1 atIndex:0];
        
        if ((lineCount-1==i&&lineCountB>=2)||(lineCount-1==i&&lineCountB==0)||lineCount-1>i) {
            
            NSNumber *count2 =[NSNumber numberWithInteger:i*3+2];
            presentStepListDTO = stepListDic[count2];
            NSString *minNum2 = [presentStepListDTO.minNum stringValue];
            NSString *price2 = [presentStepListDTO.price stringValue];
            
            stepLabel_2.text = [NSString stringWithFormat:@"%@件 :￥%.2lf",minNum2,[price2 floatValue]];
            stepLabel_2.textAlignment = NSTextAlignmentCenter;
            [self insertSubview:stepLabel_2 atIndex:0];
            [self insertSubview:lineV atIndex:0];
            
        }
        
        if ((lineCount-1==i&&lineCountB==0)||lineCount-1>i) {
            
            NSNumber *count3 =[NSNumber numberWithInteger:i*3+3];
            presentStepListDTO = stepListDic[count3];
            NSString *minNum3 = [presentStepListDTO.minNum stringValue];
            NSString *price3 = [presentStepListDTO.price stringValue];
            stepLabel_3.text = [NSString stringWithFormat:@"%@件 :￥%.2lf",minNum3,[price3 floatValue]];
            stepLabel_3.textAlignment = NSTextAlignmentCenter;
            [self insertSubview:stepLabel_3 atIndex:0];
            [self insertSubview:lineV2 atIndex:0];
        }
        yOffset += 5;
    }
    
    CGFloat height = 0;
    
    int borderNum = 1;
    if (lineCount>borderNum) {
        
        height += 18*(lineCount-borderNum);
    }
    
    height += 122+yOffset;
    
    CGRect cellFrame = self.frame;
    cellFrame.size.height =height;
    
    [self setFrame:cellFrame];
}
//- (IBAction)downClick:(id)sender {
//    [[NSNotificationCenter defaultCenter]postNotificationName:kDownloadButtonClickedNotification object:nil];
//
//}
//- (IBAction)saveClick:(id)sender {
//    [[NSNotificationCenter defaultCenter]postNotificationName:kCollectButtonClickedNotification object:nil];
//   
//}
//- (IBAction)shareClick:(id)sender {
//     [[NSNotificationCenter defaultCenter]postNotificationName:kShareButtonClickedNotification object:nil];
//}

- (void)setModeState:(BOOL)modeState{
    
    _alphaView.hidden = !modeState;
}


@end
