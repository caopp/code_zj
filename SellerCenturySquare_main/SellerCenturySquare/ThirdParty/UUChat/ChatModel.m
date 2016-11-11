//
//  ChatModel.m
//  UUChatTableView
//
//  Created by shake on 15/1/6.
//  Copyright (c) 2015年 uyiuyao. All rights reserved.
//

#import "ChatModel.h"
#import "UUMessage.h"
#import "UUMessageFrame.h"
#import "NSDate+Utils.h"
#import "CSPUtils.h"
@implementation ChatModel

- (void)populateRandomDataSource {
    
    self.dataSource = [NSMutableArray array];
}

- (UITableViewCell *)addOrderItem:(ECMessage *)message withIsHistory:(BOOL)isHistory {
    message .showTime = YES;
    message.showTime  =  [self minuteOffSetStart:self.previousTime end:[CSPUtils getTime:message.dateTime]];
    if (message.showTime) {
        self.previousTime = [CSPUtils getTime:message.dateTime];
    }
    if (isHistory) {
        [self.dataSource insertObject:message atIndex:0];
         //[self.dataSource addObject:message];
    }else {
        [self.dataSource addObject:message];
    }
    
    return nil;
}

// 添加自己的item
- (UUMessageFrame *)addSpecifiedItem:(NSDictionary *)dic withIsHistory:(BOOL)isHistory {
    UUMessageFrame *messageFrame = [[UUMessageFrame alloc]init];
    UUMessage *message = [[UUMessage alloc] init];
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    
    [dataDic setObject:@(UUMessageFromMe) forKey:@"from"];
    [dataDic setObject:@"" forKey:@"strName"];
    [dataDic setObject:@"" forKey:@"strIcon"];
    
    [message setWithDict:dataDic withStaus:UUMessageStatusOn];
    [message minuteOffSetStart:self.previousTime end:dataDic[@"strTime"]];
    if ([[dataDic[@"strTime"] substringWithRange:NSMakeRange(0, 4)] isEqualToString:@"1970"]) {
        message.showDateLabel = NO;
    }
    messageFrame.showTime = message.showDateLabel;
   // messageFrame.showTime = YES;
 
    [messageFrame setMessage:message];
    if (message.showDateLabel) {
        self.previousTime = dataDic[@"strTime"];
    }
    if (isHistory) {

        [self.dataSource insertObject:messageFrame atIndex:0];
    }else {
        [self.dataSource addObject:messageFrame];
    }
    
    return messageFrame;
}

// 添加其他发送过来的item
- (UUMessageFrame *)addOtherItem:(NSDictionary *)dic withIsHistory:(BOOL)isHistory {
    UUMessageFrame *messageFrame = [[UUMessageFrame alloc]init];
    UUMessage *message = [[UUMessage alloc] init];
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    
    [dataDic setObject:@(UUMessageFromOther) forKey:@"from"];
    [dataDic setObject:@"" forKey:@"strName"];
    [dataDic setObject:dic[@"strIcon"] forKey:@"strIcon"];

    if ([[dic objectForKey:@"type"]  isEqual: @(UUMessageTypePicture)]) {
        [message setWithDict:dataDic withStaus:UUMessageStatusOn];
    }else
        [message setWithDict:dataDic withStaus:UUMessageStatusSuccess];
    
    [message minuteOffSetStart:self.previousTime end:dataDic[@"strTime"]];
    if ([[dataDic[@"strTime"] substringWithRange:NSMakeRange(0, 4)] isEqualToString:@"1970"]) {
        message.showDateLabel = NO;
    }
    messageFrame.showTime = message.showDateLabel;
  
    [messageFrame setMessage:message];
    
    if (message.showDateLabel) {
        self.previousTime = dataDic[@"strTime"];
    }
    
    if (isHistory) {
        [self.dataSource insertObject:messageFrame atIndex:0];
       // [self.dataSource addObject:messageFrame];
    }else {
        [self.dataSource addObject:messageFrame];
    }
    
    return messageFrame;
}

// 添加聊天item（一个cell内容）
//static NSString *previousTime = nil;
- (NSArray *)additems:(NSInteger)number
{
    NSMutableArray *result = [NSMutableArray array];
    
    for (int i=0; i<number; i++) {
        
        NSDictionary *dataDic = [self getDic];
        UUMessageFrame *messageFrame = [[UUMessageFrame alloc]init];
        UUMessage *message = [[UUMessage alloc] init];
        [message setWithDict:dataDic withStaus:UUMessageStatusSuccess];
        [message minuteOffSetStart:self.previousTime end:dataDic[@"strTime"]];
//        messageFrame.showTime = message.showDateLabel;
        [messageFrame setMessage:message];
        
        if (message.showDateLabel) {
            self.previousTime = dataDic[@"strTime"];
        }
        [result addObject:messageFrame];
    }
    return result;
}

// 如下:群聊（groupChat）
static int dateNum = 10;
- (NSDictionary *)getDic
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    int randomNum = arc4random()%5;
    if (randomNum == UUMessageTypePicture) {
        [dictionary setObject:[UIImage imageNamed:[NSString stringWithFormat:@"%zd.jpeg",arc4random()%2]] forKey:@"picture"];
    }else{
        // 文字出现概率4倍于图片（暂不出现Voice类型）
        randomNum = UUMessageTypeText;
        [dictionary setObject:[self getRandomString] forKey:@"strContent"];
    }
    NSDate *date = [[NSDate date]dateByAddingTimeInterval:arc4random()%1000*(dateNum++) ];
    [dictionary setObject:@(UUMessageFromOther) forKey:@"from"];
    [dictionary setObject:@(randomNum) forKey:@"type"];
    [dictionary setObject:[date description] forKey:@"strTime"];
    // 这里判断是否是私人会话、群会话
    int index = _isGroupChat ? arc4random()%6 : 0;
    [dictionary setObject:[self getName:index] forKey:@"strName"];
    [dictionary setObject:[self getImageStr:index] forKey:@"strIcon"];
    
    return dictionary;
}

- (NSString *)getRandomString {
    
    NSString *lorumIpsum = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent non quam ac massa viverra semper. Maecenas mattis justo ac augue volutpat congue. Maecenas laoreet, nulla eu faucibus gravida, felis orci dictum risus, sed sodales sem eros eget risus. Morbi imperdiet sed diam et sodales.";
    
    NSArray *lorumIpsumArray = [lorumIpsum componentsSeparatedByString:@" "];
    
    int r = arc4random() % [lorumIpsumArray count];
    r = MAX(6, r); // no less than 6 words
    NSArray *lorumIpsumRandom = [lorumIpsumArray objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, r)]];
    
    return [NSString stringWithFormat:@"%@!!", [lorumIpsumRandom componentsJoinedByString:@" "]];
}

- (NSString *)getImageStr:(NSInteger)index{
    NSArray *array = @[@"http://www.120ask.com/static/upload/clinic/article/org/201311/201311061651418413.jpg",
                       @"http://p1.qqyou.com/touxiang/uploadpic/2011-3/20113212244659712.jpg",
                       @"http://www.qqzhi.com/uploadpic/2014-09-14/004638238.jpg",
                       @"http://e.hiphotos.baidu.com/image/pic/item/5ab5c9ea15ce36d3b104443639f33a87e950b1b0.jpg",
                       @"http://ts1.mm.bing.net/th?&id=JN.C21iqVw9uSuD2ZyxElpacA&w=300&h=300&c=0&pid=1.9&rs=0&p=0",
                       @"http://ts1.mm.bing.net/th?&id=JN.7g7SEYKd2MTNono6zVirpA&w=300&h=300&c=0&pid=1.9&rs=0&p=0"];
    return array[index];
}

- (NSString *)getName:(NSInteger)index{
    NSArray *array = @[@"Hi,Daniel",@"Hi,Juey",@"Hey,Jobs",@"Hey,Bob",@"Hah,Dane",@"Wow,Boss"];
    return array[index];
}


- (BOOL)minuteOffSetStart:(NSString *)start end:(NSString *)end
{
    if (!start) {
        return YES;
    }
    
    NSString *subStart = [start substringWithRange:NSMakeRange(0, 19)];
    NSDate *startDate = [NSDate dateFromString:subStart withFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *subEnd = [end substringWithRange:NSMakeRange(0, 19)];
    NSDate *endDate = [NSDate dateFromString:subEnd withFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    //这个是相隔的秒数
    NSTimeInterval timeInterval = [startDate timeIntervalSinceDate:endDate];
    
    //相距5分钟显示时间Label
    if (fabs (timeInterval) > 60) {
        return YES;
    }else{
        return NO;
    }
    
}
@end
