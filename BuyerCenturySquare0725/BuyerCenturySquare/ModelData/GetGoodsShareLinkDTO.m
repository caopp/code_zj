//
//  GetGoodsShareLinkDTO.m
//  BuyerCenturySquare
//
//  Created by jian.zhou on 15-9-6.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "GetGoodsShareLinkDTO.h"
#import "SDWebImageDownloader.h"

@implementation GetGoodsShareLinkDTO

-(void)setDictFrom:(NSDictionary *)dictInfo{
    @try {
        if (self && dictInfo) {
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"title"]]) {
                
                self.title = [dictInfo objectForKey:@"title"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"shareUrl"]]) {
                
                self.shareUrl = [dictInfo objectForKey:@"shareUrl"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"imgUrl"]]) {
                
                self.imgUrl = [dictInfo objectForKey:@"imgUrl"];
                [[SDWebImageDownloader sharedDownloader]downloadImageWithURL:[NSURL URLWithString:self.imgUrl] options:SDWebImageDownloaderLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                    
                } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                    self.shareImage = image;
                }];
                
            }
            
            
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
}
@end
