//
//  UIImage+Save.m
//  BuyerCenturySquare
//
//  Created by longminghong on 15/8/17.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "UIImage+Save.h"

@implementation UIImage (Save)

- (void)writeToSystemPhotosAlbum{
    
    UIImageWriteToSavedPhotosAlbum(self, nil,  nil , nil );
}

-(void)saveImageToAlbum:(NSString*)albumName withCompletionBlock:(SaveImageCompletion)completionBlock
{
    //write the image data to the assets library (camera roll)
    
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc]init];
    
    [assetsLibrary writeImageToSavedPhotosAlbum:self.CGImage
                                    orientation:(ALAssetOrientation)self.imageOrientation
                                completionBlock:^(NSURL* assetURL, NSError* error) {
                                    
                                    //error handling
                                    if (error!=nil) {
                                        completionBlock(error);
                                        return;
                                    }
                                    
                                    //add the asset to the custom photo album
                                    [self addAssetURL: assetURL
                                              toAlbum:albumName
                                  withCompletionBlock:completionBlock];
                                    
                                }];
}

-(void)addAssetURL:(NSURL*)assetURL toAlbum:(NSString*)albumName withCompletionBlock:(SaveImageCompletion)completionBlock
{
    __block BOOL albumWasFound = NO;
    
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc]init];
    
    //search all photo albums in the library
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAlbum
                                 usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                                     
                                     //compare the names of the albums
                                     if ([albumName compare: [group valueForProperty:ALAssetsGroupPropertyName]]==NSOrderedSame) {
                                         
                                         //target album is found
                                         albumWasFound = YES;
                                         
                                         //get a hold of the photo's asset instance
                                         [assetsLibrary assetForURL: assetURL
                                                        resultBlock:^(ALAsset *asset) {
                                                            
                                                            //add photo to the target album
                                                            [group addAsset: asset];
                                                            
                                                            //run the completion block
                                                            completionBlock(nil);
                                                            
                                                        } failureBlock: completionBlock];
                                         
                                         //album was found, bail out of the method
                                         return;
                                     }
                                     
                                     if (group==nil && albumWasFound==NO) {
                                         //photo albums are over, target album does not exist, thus create it
                                         
                                         __weak ALAssetsLibrary* weakSelf = assetsLibrary;
                                         
                                         //create new assets album
                                         [assetsLibrary addAssetsGroupAlbumWithName:albumName
                                                                        resultBlock:^(ALAssetsGroup *group) {
                                                                            
                                                                            //get the photo's instance
                                                                            [weakSelf assetForURL: assetURL
                                                                                      resultBlock:^(ALAsset *asset) {
                                                                                          
                                                                                          //add photo to the newly created album
                                                                                          [group addAsset: asset];
                                                                                          
                                                                                          //call the completion block
                                                                                          completionBlock(nil);
                                                                                          
                                                                                      } failureBlock: completionBlock];
                                                                            
                                                                        } failureBlock: completionBlock];
                                         
                                         //should be the last iteration anyway, but just in case
                                         return;
                                     }
                                     
                                 } failureBlock: completionBlock];
    
}

@end
