//
//  HZAreaPickerView.m
//  areapicker
//
//  Created by Cloud Dai on 12-9-9.
//  Copyright (c) 2012年 clouddai.com. All rights reserved.
//

#import "HZAreaPickerView.h"
#import <QuartzCore/QuartzCore.h>

#define kDuration 0.3

@interface HZAreaPickerView ()
{
    NSMutableArray *provinces, *cities, *areas;
    NSMutableArray *allObjects;
}
@property (weak, nonatomic) IBOutlet UILabel *lineLabel;
@property (weak, nonatomic) IBOutlet UIView *groundView;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@end

@implementation HZAreaPickerView

@synthesize delegate=_delegate;
@synthesize locate=_locate;
@synthesize locatePicker = _locatePicker;

-(void)awakeFromNib
{
    self.lineLabel.backgroundColor = [UIColor colorWithHexValue:0xc8c7cc alpha:1];
    self.groundView.backgroundColor = [UIColor colorWithHexValue:0xf0f0f0 alpha:1];
    self.pickerView.backgroundColor = [UIColor colorWithHexValue:0xefeff4 alpha:1];
    
    self.lineLabel.hidden = YES;
    self.groundView.hidden = YES;
    self.editorButton.hidden = YES;
}

-(HZLocation *)locate
{
    if (_locate == nil) {
        _locate = [[HZLocation alloc] init];
    }
    
    return _locate;
}

- (id)init
{
  
    self = [[[NSBundle mainBundle] loadNibNamed:@"HZAreaPickerView" owner:self options:nil] objectAtIndex:0];
    
    if (self) {
        self.locatePicker.dataSource = self;
        self.locatePicker.delegate = self;
    
//        //加载数据
//        NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"GetAreaAllList.plist" ofType:nil]];
//        provinces = [dic[@"list"] copy];
//        self.backgroundColor = [UIColor redColor];
    
        //加载数据（获取沙盒存储路径）
        NSString * titlePath = [NSString stringWithFormat:@"%@/Documents/allCity.plist",NSHomeDirectory()];
        provinces = [NSMutableArray arrayWithContentsOfFile:titlePath];
        
        //数组中添加一个字典
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
        
        [provinces addObject:dic];
        
        
        //字典中添加一个数组
        NSDictionary *provDic = [NSDictionary dictionaryWithObject:@"" forKey:@"name"];
        
        [dic addEntriesFromDictionary:provDic];
        
        NSMutableArray *cityArr = [NSMutableArray array];
        
        [dic setObject:cityArr forKey:@"subData"];
        
    

        //数组中在添加一个字典
        NSMutableDictionary *areDic = [NSMutableDictionary dictionaryWithCapacity:0];
        
        [cityArr addObject:areDic];
        
         NSDictionary *cityDic = [NSDictionary dictionaryWithObject:@"请选择" forKey:@"name"];
        
        [areDic addEntriesFromDictionary:cityDic];
        
         NSMutableArray *areaArr = [NSMutableArray array];
        
        [areDic setObject:areaArr forKey:@"subData"];
        
        //字典中在插入一个数组
        NSDictionary *arDic = [NSDictionary dictionaryWithObject:@"" forKey:@"name"];
        
        [areaArr addObject:arDic];

        //取出最后一个可变字典
        NSMutableDictionary *lastDic = [provinces lastObject];
        
        //添加一个可变的数组
         allObjects = [NSMutableArray array];
        
        //可变数组中添加对象
        [allObjects addObject:lastDic];
        
    
        
        
        //重新进行遍历
        for (int i = 0; i < provinces.count; i++) {
            
            if (![provinces[i][@"name"] isEqualToString:@""]) {
                
                [allObjects addObject:provinces[i]];
                
            }
        }
        
        cities = [[allObjects objectAtIndex:0] objectForKey:@"subData"];
 
        self.locate.state = [[allObjects objectAtIndex:0] objectForKey:@"name"];
        
        self.locate.stateId = [[allObjects objectAtIndex:0] objectForKey:@"id"];
        
        self.locate.city = [[cities objectAtIndex:0] objectForKey:@"name"];
        
        self.locate.cityId = [[cities objectAtIndex:0] objectForKey:@"id"];
        
        areas = [[cities objectAtIndex:0] objectForKey:@"subData"];
        
        if (areas.count > 0) {
            self.locate.district = [[areas objectAtIndex:0] objectForKey:@"name"];
            self.locate.districtId = [[areas objectAtIndex:0] objectForKey:@"id"];
        } else{
            self.locate.district = @"";
            self.locate.districtId = nil;
        }
        
    }
    return self;
}


#pragma mark - PickerView lifecycle

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return [allObjects count];
            break;
        case 1:
            return [cities count];
            break;
        case 2:
            return [areas count];
            break;
        default:
            return 0;
            break;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            
            return [[allObjects objectAtIndex:row] objectForKey:@"name"];
            
            break;
        case 1:
            
            return [[cities objectAtIndex:row] objectForKey:@"name"];
            
            break;
        case 2:
            if ([areas count] > 0) {
                return [[areas objectAtIndex:row] objectForKey:@"name"];
                break;
            }
        default:
            return  @"";
            break;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            
            cities = [[allObjects objectAtIndex:row] objectForKey:@"subData"];
            [self.locatePicker selectRow:0 inComponent:1 animated:YES];
            [self.locatePicker reloadComponent:1];
            
            areas = [[cities objectAtIndex:0] objectForKey:@"subData"];
            [self.locatePicker selectRow:0 inComponent:2 animated:YES];
            [self.locatePicker reloadComponent:2];
            
            self.locate.state = [[allObjects objectAtIndex:row] objectForKey:@"name"];
            self.locate.stateId = [[allObjects objectAtIndex:row] objectForKey:@"id"];
            self.locate.city = [[cities objectAtIndex:0] objectForKey:@"name"];
            self.locate.cityId = [[cities objectAtIndex:0] objectForKey:@"id"];
            if ([areas count] > 0) {
                self.locate.district = [[areas objectAtIndex:0] objectForKey:@"name"];
                self.locate.districtId = [[areas objectAtIndex:0] objectForKey:@"id"];
            } else{
                self.locate.district = @"";
                self.locate.districtId = nil;
            }
            
            break;
        case 1:
            areas = [[cities objectAtIndex:row] objectForKey:@"subData"];
            [self.locatePicker selectRow:0 inComponent:2 animated:YES];
            [self.locatePicker reloadComponent:2];
            
            self.locate.city = [[cities objectAtIndex:row] objectForKey:@"name"];
            self.locate.cityId = [[cities objectAtIndex:row] objectForKey:@"id"];
            if ([areas count] > 0) {
                self.locate.district = [[areas objectAtIndex:0] objectForKey:@"name"];
                self.locate.districtId = [[areas objectAtIndex:0] objectForKey:@"id"];
            } else{
                self.locate.district = @"";
                self.locate.districtId = nil;
            }
            break;
        case 2:
            if ([areas count] > 0) {
                self.locate.district = [[areas objectAtIndex:row] objectForKey:@"name"];
                
                self.locate.districtId = [[areas objectAtIndex:row] objectForKey:@"id"];
            } else{
                self.locate.district = @"";
                self.locate.districtId = nil;
            }
            break;
        default:
            break;
    }
    
    if([self.delegate respondsToSelector:@selector(pickerDidChaneStatus:)]) {
        [self.delegate pickerDidChaneStatus:self];
    }
    
}


#pragma mark - animation

- (void)showInView:(UIView *) view
{
    self.frame = CGRectMake(0, view.frame.size.height, view.frame.size.width, self.frame.size.height);
    [view addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, view.frame.size.height - self.frame.size.height, self.frame.size.width, self.frame.size.height);
    }];
    
}

- (void)cancelPicker
{
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.frame = CGRectMake(0, self.frame.origin.y+self.frame.size.height, self.frame.size.width, self.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         [self removeFromSuperview];
                         
                     }];
    
}

- (IBAction)overEditor:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(viewEditorOver)]) {
        [self.delegate performSelector:@selector(viewEditorOver)];
    }
    
}
@end
