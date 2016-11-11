//
//  CSPPicDownloadingTableViewCell.m
//  BuyerCenturySquare
//
//  Created by GuChenlong on 7/14/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPPicDownloadingTableViewCell.h"




@implementation CSPPicDownloadingTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (IBAction)windowSelectedButtonClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(windowSelected2Clicked:)]) {
        [self.delegate windowSelected2Clicked:sender];
    }
}
- (IBAction)windowPauseButtonClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(windowPauseClicked:)]) {
        [self.delegate windowPauseClicked:sender];
    }
}
- (IBAction)impersonalityPauseButtonClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(impersonalityPauseClicked:)]) {
        [self.delegate impersonalityPauseClicked:sender];
    }
}
- (IBAction)impersonalitySelectedButtonCliced:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(impersonalitySelectedCliced:)]) {
        [self.delegate impersonalitySelectedCliced:sender];
    }
}


//- (void)downloadZipWith:(PictureDTO *)picDTO
//{
//    self.pictureDTO = picDTO;
//
//    [IADownloadManager downloadItemWithURL:[NSURL URLWithString:picDTO.zipUrl] useCache:YES];
//    [IADownloadManager attachListener:self toURL:[NSURL URLWithString:picDTO.zipUrl]];
//}
//
//- (void) downloadManagerDidProgress:(float)progress
//{
//    if ([self.pictureDTO.picType isEqualToString:@"0"]) {
//        [self.windowProgressView setProgress:progress animated:YES];
//        self.windowProgressLabel.text = [NSString stringWithFormat:@"%.1fMB/%.1fMB",self.pictureDTO.picSize.doubleValue/1024 *progress,self.pictureDTO.picSize.doubleValue/1024];
//
//    }
//    else{
//        [self.impersonalityProgressView setProgress:progress animated:YES];
//            self.impersonalityProgressLabel.text = [NSString stringWithFormat:@"%.1fMB/%.1fMB",self.pictureDTO.picSize.doubleValue/1024 *progress,self.pictureDTO.picSize.doubleValue/1024];
//    }
//}
//- (void) downloadManagerDidFinish:(BOOL)success response:(id)response
//{
//    if (success) {
//        
//    }
//}
//
//-(void)downloadZipsWith:(DownloadImageDTO *)downloadImageDTO;
//{
//    
//    self.pictureDTO1 = [[PictureDTO alloc] init];
//    self.pictureDTO2 = [[PictureDTO alloc] init];
//
//    NSDictionary *Dictionary1 = [downloadImageDTO.pictureDTOList objectAtIndex:0];
//    NSDictionary *Dictionary2 = [downloadImageDTO.pictureDTOList objectAtIndex:1];
//    [self.pictureDTO1 setDictFrom:Dictionary1];
//    [self.pictureDTO2 setDictFrom:Dictionary2];
//    
//    NSMutableArray *array = [[NSMutableArray alloc]initWithObjects:[NSURL URLWithString:self.pictureDTO1.zipUrl],[NSURL URLWithString:self.pictureDTO2.zipUrl], nil];
//
//    [IASequentialDownloadManager downloadItemWithURLs:array useCache:YES];
//    [IASequentialDownloadManager attachListener:self toURLs:array];
//}
//
//- (void) sequentialManagerProgress:(float)progress atIndex:(int)index
//{
//    if (index == 0) {
//        [self.windowProgressView setProgress:progress animated:YES];
//        self.windowProgressLabel.text = [NSString stringWithFormat:@"%.1fMB/%.1fMB",self.pictureDTO1.picSize.doubleValue/1024 *progress,self.pictureDTO1.picSize.doubleValue/1024];
//    }else
//    {
//        [self.impersonalityProgressView setProgress:progress animated:YES];
//        self.impersonalityProgressLabel.text = [NSString stringWithFormat:@"%.1fMB/%.1fMB",self.pictureDTO2.picSize.doubleValue/1024 *progress,self.pictureDTO2.picSize.doubleValue/1024];
//    }
//}
//- (void) sequentialManagerDidFinish:(BOOL)success response:(id)response atIndex:(int)index
//{
//    
//}

@end
