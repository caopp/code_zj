//
//  NoStoreTagView.h
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/3/17.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol NoStoreTagViewDelegate <NSObject>

-(void)joinNextPage;

@end

@interface NoStoreTagView : UIView
@property (weak, nonatomic) IBOutlet UILabel *noTagLabel;
@property (weak, nonatomic) IBOutlet UILabel *addTagLabel;
@property (weak, nonatomic) IBOutlet UIButton *addTagButton;
@property (weak, nonatomic) id <NoStoreTagViewDelegate>delegate;
- (IBAction)didClickAddTagButton:(id)sender;

@end
