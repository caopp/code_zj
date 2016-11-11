//
//  CSPBackgroundView.m
//  SellerCenturySquare
//
//  Created by GuChenlong on 15/7/1.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CSPBackgroundView.h"
#import <Accelerate/Accelerate.h>

CGFloat const  ImageDefaultBlurRadius = 5;

@implementation CSPBackgroundView

- (void)awakeFromNib
{
    if (self.backgroundImageView == nil) {
        self.backgroundImageView = [[UIImageView alloc]init];
        
          
        self.backgroundImageView.image = [UIImage imageNamed:@"background"];
        
        //        UIView *view = [[UIView alloc]init];
        //        view.frame = self.frame;
        //        view.alpha = 0.7f;
        //        view.backgroundColor = [UIColor blackColor];
        
        [self insertSubview:self.backgroundImageView  atIndex:0];
        //        [self insertSubview:view atIndex:1];
    }
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.backgroundImageView .frame = self.frame;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self awakeFromNib];
    }
    return self;
}

//- (UIImage *)setImageToBlur: (UIImage *)image
//            blurRadius: (CGFloat)blurRadius
//
//{
//    CIContext *context   = [CIContext contextWithOptions:nil];
//    CIImage *sourceImage = [CIImage imageWithCGImage:image.CGImage];
//    
//    // Apply clamp filter:
//    // this is needed because the CIGaussianBlur when applied makes
//    // a trasparent border around the image
//    
//    NSString *clampFilterName = @"CIAffineClamp";
//    CIFilter *clamp = [CIFilter filterWithName:clampFilterName];
//    
//    
//    [clamp setValue:sourceImage
//             forKey:kCIInputImageKey];
//    
//    CIImage *clampResult = [clamp valueForKey:kCIOutputImageKey];
//    
//    // Apply Gaussian Blur filter
//    
//    NSString *gaussianBlurFilterName = @"CIGaussianBlur";
//    CIFilter *gaussianBlur           = [CIFilter filterWithName:gaussianBlurFilterName];
//    
//    
//    
//    [gaussianBlur setValue:clampResult
//                    forKey:kCIInputImageKey];
//    [gaussianBlur setValue:[NSNumber numberWithFloat:blurRadius]
//                    forKey:@"inputRadius"];
//    
//    CIImage *gaussianBlurResult = [gaussianBlur valueForKey:kCIOutputImageKey];
//    
//
//    
//    
//    
//    CGImageRef cgImage = [context createCGImage:gaussianBlurResult
//                                       fromRect:[sourceImage extent]];
//    
//    UIImage *blurredImage = [UIImage imageWithCGImage:cgImage];
//
//    
//    
//    return blurredImage;
//    
//    
//}

- (UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur {
    if (blur < 0.f || blur > 1.f) {
        blur = 0.5f;
    }
    int boxSize = (int)(blur * 100);
    boxSize = boxSize - (boxSize % 2) + 1;
    
    CGImageRef img = image.CGImage;
    
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    
    void *pixelBuffer;
    
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) *
                         CGImageGetHeight(img));
    
    if(pixelBuffer == NULL)
        NSLog(@"No pixelbuffer");
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    error = vImageBoxConvolve_ARGB8888(&inBuffer,
                                       &outBuffer,
                                       NULL,
                                       0,
                                       0,
                                       boxSize,
                                       boxSize,
                                       NULL,
                                       kvImageEdgeExtend);
    
    
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(
                                             outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    CFRelease(inBitmapData);
    
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);
    
    return returnImage;
}




@end
