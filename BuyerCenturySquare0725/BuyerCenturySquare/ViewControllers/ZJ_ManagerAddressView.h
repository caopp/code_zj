//
//  ZJ_ManagerAddressView.h
//  BuyerCenturySquare
//
//  Created by 张晓旭 on 16/3/24.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressTextField.h"

@protocol ZJ_ManagerAddressViewDelegate <NSObject>

-(void)postionBtnAction;

@end

@interface ZJ_ManagerAddressView : UIView
//

@property (weak, nonatomic) IBOutlet UIButton *areaButton;
@property (nonatomic,weak)id<ZJ_ManagerAddressViewDelegate>delegate;
//
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstContraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondContraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thirdContraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fourContraint;

@property (weak, nonatomic) IBOutlet UILabel *roundLabel;

//
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet AddressTextField *nameTextField;
@property (weak, nonatomic) IBOutlet UILabel *firstLabel;

//

@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet AddressTextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;

//
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet AddressTextField *cityTextField;
@property (weak, nonatomic) IBOutlet UIButton *ppositionButton;
@property (weak, nonatomic) IBOutlet UILabel *thridLabel;

//

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *fourLabel;
@property (weak, nonatomic) IBOutlet UITextView *addressTextView;

@end
