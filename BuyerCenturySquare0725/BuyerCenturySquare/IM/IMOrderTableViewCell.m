//
//  IMOrderTableViewCell.m
//  BuyerCenturySquare
//
//  Created by 王剑粟 on 15/8/31.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "IMOrderTableViewCell.h"

@implementation IMOrderTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setJsonSku:(NSString *)jsonSku {
    self.countView.backgroundColor = [UIColor clearColor];
    if(jsonSku != nil) {
        //删除原来的view
        for (UILabel * label in self.countView.subviews) {
            [label removeFromSuperview];
        }
       
        NSData *jsonData = [jsonSku dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                            options:NSJSONReadingMutableContainers
                                                              error:&err];
        NSArray * keysArray = [dic allKeys];
        int j = 0;
        for (int i = 0; i < keysArray.count; i++) {
            NSString * keyString = [keysArray objectAtIndex:i];
            
            NSString * num = [[[dic objectForKey:keyString] componentsSeparatedByString:@","] objectAtIndex:0];
            if ([num floatValue] > 0) {
                UILabel * label;
                if (j % 2 == 0) {
                    label = [[UILabel alloc] initWithFrame:CGRectMake(0, (j / 2) * 16 + (j / 2 + 1) * 5, 80, 16)];
                }else {
                    label = [[UILabel alloc] initWithFrame:CGRectMake(90, (j / 2) * 16 + (j / 2 + 1) * 5, 80, 16)];
                }
                [label setText:[NSString stringWithFormat:@"%@ × %@", keyString, [[[dic objectForKey:keyString] componentsSeparatedByString:@","] objectAtIndex:0]]];
                [label setTextColor:[UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1]];
                [label setTextAlignment:NSTextAlignmentCenter];
//                [label setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0f]];
                [label setFont:[UIFont systemFontOfSize:12.0]];
                label.layer.borderWidth = 1.0f;
                label.layer.borderColor = [UIColor colorWithRed:0.58 green:0.58 blue:0.58 alpha:1].CGColor;
                label.layer.cornerRadius = 3.0f;
                [self.countView addSubview:label];
                j++;
            }
        }
        if (!j) {
            _orderNumL.hidden = YES;
        }
    }
   
}

@end
