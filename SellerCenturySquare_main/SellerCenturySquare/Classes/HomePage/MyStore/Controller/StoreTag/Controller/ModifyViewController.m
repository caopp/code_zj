//
//  ModifyViewController.m
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/3/22.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "ModifyViewController.h"
#import "Masonry.h"
#import "EqualSpaceFlowLayout.h"
#import "UIColor+HexColor.h"
#import "GoodsTagCollectionViewCell.h"
#import "GoodsLagCollectionReusableView.h"
#import "UICollectionViewLeftAlignedLayout.h"
#import "AddMoreTagTableViewCell.h"
#import "GoodsAlllTagDTO.h"
#import "CSPUtils.h"
#import "ShowGoodsTagViewController.h"
#import "PromptGoodsTagsViewController.h"

#import "StoreTagLisrtModel.h"
#import "StoreTagModel.h"

#define TIME 0.5
@interface ModifyViewController ()<UICollectionViewDataSource ,UICollectionViewDelegate,EqualSpaceFlowLayoutDelegate,UITableViewDataSource ,UITableViewDelegate ,AddMoreTagTableViewDelegate,UITextFieldDelegate>


//顶部View
@property (nonatomic ,strong) UIView *topView;
//底部View
@property (nonatomic ,strong) UIView *bottomView;

@property (nonatomic ,strong) UIScrollView *scrollView;
//默认状态下
@property (nonatomic ,strong) NSMutableArray *normalArrs;
//选中状态下
@property (nonatomic ,strong) NSMutableArray *selectArrs;

//添加其他标签
@property (nonatomic ,strong) UITableView *tableView;

//显示选择标签
@property (nonatomic ,strong) UICollectionView *collectionView;

//数据元
//@property (nonatomic ,strong) NSMutableDictionary *dictData;

//保存更多标签
@property (nonatomic ,strong) NSMutableArray *addMoreTagArr;

//添加标签按钮
@property (nonatomic ,strong) UIButton *addTagBtn;

//提示“每个标签最多10个字”
@property (nonatomic ,strong) UILabel *promptLab;

//请求过来的数据
@property (nonatomic ,strong) GoodsAlllTagDTO *goodsAllDto;

@property (nonatomic ,assign) CGPoint recrodPoint;


@property (nonatomic,strong)NSMutableArray *listArray;

//设置键盘高度
@property (nonatomic ,assign) CGFloat keyboardhight;
//计算cell的高度(cell.orgin.y+cell.size.heigt+bottomView.frame.orgin.y)
@property (nonatomic ,assign) CGFloat cellHeight;


@end

@implementation ModifyViewController


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self registerForKeyboardNotifications];
 }

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self customBackBarButton];
    
    
    self.title = @"设置店铺标签";
    
    _listArray = [NSMutableArray arrayWithCapacity:0];

    [HttpManager sendHttpRequestForUpdateAllStoreTagSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            
            StoreTagLisrtModel* getStoreTagListDTO = [[StoreTagLisrtModel alloc] init];
            
            StoreTagModel* storeTagDTO = [[StoreTagModel alloc] init];
            
            getStoreTagListDTO.storeTagDTOList = [[dic objectForKey:@"data"] objectForKey:@"fixed"];
            getStoreTagListDTO.labelCategory = [[dic objectForKey:@"data"] objectForKey:@"labelCategory"];
            
            //进行可变复制
            _listArray = [getStoreTagListDTO.storeTagDTOList mutableCopy];
            
            for (NSDictionary *dicIofo in _listArray) {
                [getStoreTagListDTO setDictFrom:dicIofo];
                
                for (NSDictionary *dic in dicIofo[@"list"]) {
                    
                    [storeTagDTO  setDictFrom:dic];
                    
                    NSLog(@"%@",storeTagDTO.flag);
                }
                
            }
            [self.collectionView reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    
    self.normalArrs = [NSMutableArray array];
    self.selectArrs = [NSMutableArray array];
    self.addMoreTagArr = [NSMutableArray array];
    
    
    //设置背景颜色
    self.view.backgroundColor = [UIColor whiteColor];
    
    
       
    //1. 滚动视图ScrollView
    self.scrollView = [[UIScrollView alloc] init];
    
    
    
    
    
    //1.1 设置允许不满屏幕时 能滑动
    self.scrollView.alwaysBounceVertical= YES;
    //1.2 添加主视图
    [self.view addSubview:self.scrollView];
    //    self.scrollView.userInteractionEnabled = YES;
    
    
    
    //1.3 设置scrollView的约束布局
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom);
        
    }];
    
    
    //2.  设置scrollView的contentView
    UIView *contentView = [[UIView alloc] init];
    //2.1 添加到scrolView
    [self.scrollView addSubview:contentView];
    
    //2.2 设置contentView的约束布局
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    
    //3.  创建顶部视图
    self.topView = [[UIView alloc] init];
    
    //3.1 设置背景颜色
    self.topView.backgroundColor = [UIColor whiteColor];
    
    //3.2 添加到contentView
    [contentView addSubview:self.topView];
    
    //3.3 设置topView的约束布局
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView.mas_top);
        make.left.equalTo(contentView.mas_left);
        make.right.equalTo(contentView.mas_right);
        make.height.equalTo(@500);
        
        
    }];
    
    //4. 创建说明标签
    UILabel *hotTagLab = [[UILabel alloc] init];
    //4.1  添加到topView中
    [self.topView addSubview:hotTagLab];
    //4.2  给说明标签htoTagLab赋值
    hotTagLab.text = @"选择标签";
    //4.3  设置字体的颜色
    hotTagLab.textColor = [UIColor colorWithHex:0x666666 alpha:1];
    //4.4  设置字体的样式大小
    hotTagLab.font = [UIFont systemFontOfSize:15];
    
    //4.5  设置hotTagLab的约束布局
    [hotTagLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_top).offset(20);
        make.left.equalTo(self.topView.mas_left).offset(15);
        
    }];
    
    //5.  标签说明
    UILabel *togStatusLab = [[UILabel alloc] init];
    
    //5.1 设置字体样式
    togStatusLab.font = [UIFont systemFontOfSize:11];
    //5.2 设置字体的颜色
    togStatusLab.textColor = [UIColor colorWithHex:0x999999 alpha:1];
    //5.3 说明字体的内容
    togStatusLab.text = @"这些是热门常用标签，可以直接点选。";
    //5.4 添加到topView视图
    [self.topView addSubview:togStatusLab];
    //5.5 设置togStatusLab约束布局
    [togStatusLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(hotTagLab.mas_bottom).offset(5);
        make.left.equalTo(hotTagLab.mas_left);
    }];
    
    
    //6.  设置flowLayout
    UICollectionViewLeftAlignedLayout *flowLayout = [[UICollectionViewLeftAlignedLayout alloc] init];
    //6.1 设置head的宽和高
    flowLayout.headerReferenceSize = CGSizeMake(375, 50);
    
    
    //7.  设置collectionView
    UICollectionView*collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 375, 300) collectionViewLayout:flowLayout];
    
    
    //7.1 设置背景颜色
    collectionView.backgroundColor = [UIColor whiteColor];
    //7.2 控制控件不能滚动
    collectionView.scrollEnabled = NO;
    //7.3 赋给全局变量
    self.collectionView = collectionView;
    //7.4 添加到topView中
    [self.topView addSubview:collectionView];
    //7.5 设置代理
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    //7.5 注册collectionViewCell
    [collectionView registerClass:[GoodsTagCollectionViewCell class] forCellWithReuseIdentifier:@"goodsTagCollectionViewCell1"];
    //7.6 注册collectionViewHead
    [collectionView registerNib:[UINib nibWithNibName:@"GoodsLagCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"goodsTagCollectionHeadView"];
    //7.7 布局collectionView
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(togStatusLab.mas_bottom).offset(12);
        make.left.equalTo(self.topView.mas_left);
        make.right.equalTo(self.topView.mas_right);
        make.height.equalTo(@100);
    }];
    
    
    //8.  分割条View
    UIView *lineView = [[UIView alloc] init];
    //8.1 添加到topView
    [self.topView addSubview:lineView];
    //8.2 设置背景颜色
    lineView.backgroundColor = [UIColor colorWithHex:0xf0f0f0];
    //8.3 设置lineView约束布局
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topView.mas_left);
        make.right.equalTo(self.topView.mas_right);
        make.bottom.equalTo(self.topView.mas_bottom);
        make.height.equalTo(@10);
        
    }];
    
    //9.  添加底部视图
    self.bottomView = [[UIView alloc] init];
    //9.1 设置底部视图的背景颜色
    self.bottomView.backgroundColor = [UIColor whiteColor];
    //9.2 添加到scrollView
    [self.scrollView addSubview:self.bottomView];
    //9.3 设置底部的bottomView约束布局
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom);
        make.left.equalTo(self.topView.mas_left);
        make.right.equalTo(self.topView.mas_right);
        make.bottom.equalTo(self.scrollView.mas_bottom);
        make.height.equalTo(@200);
        
        
    }];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTakeBack)];
    [self.bottomView addGestureRecognizer:tap];
    
    
    //10.  添加更多标签
    UILabel *moreTagLab = [[UILabel alloc] init];
    //10.1 添加到底部视图中
    [self.bottomView addSubview:moreTagLab];
    //10.2 设置标签内容
    moreTagLab.text = @"添加更多标签";
    //10.3 设置字体样式
    moreTagLab.font = [UIFont systemFontOfSize:15];
    //10.4 设置字体的颜色
    moreTagLab.textColor = [UIColor colorWithHex:0x666666];
    //10.5 设置moreTagLab
    [moreTagLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomView.mas_top).offset(20);
        make.left.equalTo(self.bottomView.mas_left).offset(15);
        
    }];
    
    //11.  标签说明
    UILabel *tagShowLab = [[UILabel alloc] init];
    //11.1 添加到底部视图
    [self.bottomView addSubview:tagShowLab];
    //11.2 标签说明的内容
    tagShowLab.text = @"上面没有合适的标签，可以自己添加。";
    //11.3 设置字体的样式
    tagShowLab.font = [UIFont systemFontOfSize:11];
    
    //11.4 设置字体的颜色
    tagShowLab.textColor = [UIColor colorWithHex:0x999999];
    //11.5 设置布局
    [tagShowLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(moreTagLab.mas_bottom).offset(5);
        make.left.equalTo(moreTagLab.mas_left);
        
    }];
    
    
    //12.  提示
    UILabel *promptLab = [[UILabel alloc] init];
    
    self.promptLab = promptLab;
    
    //12.1 添加到底部视图
    [self.bottomView addSubview:promptLab];
    //12.2 设置提示的内容
    promptLab.text = @"每个标签最多10个字。";
    //12.3 设置字体的颜色
    promptLab.textColor = [UIColor colorWithHex:0xeb301f];
    //12.4 设置字体样式
    promptLab.font = [UIFont systemFontOfSize:11];
    //12.5 设置提示的约束布局
    [promptLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tagShowLab.mas_bottom).offset(2);
        make.left.equalTo(tagShowLab.mas_left);
    }];
    
    
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
    [self.bottomView addSubview:self.tableView];
    //    self.tableView.scrollEnabled = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.userInteractionEnabled = YES;
    
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(promptLab.mas_bottom).offset(15);
        make.left.equalTo(self.bottomView.mas_left);
        make.right.equalTo(self.bottomView.mas_right);
        make.height.equalTo(@1);
    }];
    
    UIButton *addTagBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.addTagBtn = addTagBtn;
    [self.bottomView addSubview:addTagBtn];
    [addTagBtn setTitle:@"添加标签" forState:UIControlStateNormal];
    [addTagBtn addTarget:self action:@selector(addTagsBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    addTagBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    
    addTagBtn.backgroundColor = [UIColor colorWithHex:0xeb301f];
    [addTagBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView.mas_bottom);
        make.left.equalTo(self.bottomView.mas_left).offset(16);
        make.height.equalTo(@30);
        make.width.equalTo(@63);
        make.top.greaterThanOrEqualTo(promptLab.mas_bottom).offset(14);
    }];
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:saveBtn];
    
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    saveBtn.backgroundColor = [UIColor blackColor];
    [saveBtn addTarget:self action:@selector(saveAllTagBtn:) forControlEvents:UIControlEventTouchUpInside];
    [saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.height.equalTo(@46);
        
    }];

}

- (void)addTagsBtn:(UIButton *)btn
{
    
    if (self.addMoreTagArr.count>=10) {
        return;
        
    }
    if (self.addMoreTagArr.count == 0) {
        [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.promptLab.mas_bottom).offset(15);
            make.left.equalTo(self.bottomView.mas_left);
            make.right.equalTo(self.bottomView.mas_right);
            make.height.equalTo(@10);
        }];
        
        [self.addTagBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.tableView.mas_bottom);
            make.left.equalTo(self.bottomView.mas_left).offset(15);
            make.height.equalTo(@30);
            make.width.equalTo(@63);
            
        }];
        
        
    }
    
    [self.addMoreTagArr addObject:@""];
    [self.tableView reloadData];
    
    
    
    
}

#pragma mark - collectionViewDelegate&&dataSource

//section个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    //    NSArray *keys = self.dictData.allKeys;
    //    NSArray *values = [self.dictData objectForKey:[keys objectAtIndex:section]];
    //    return values.count;
    
    StoreTagLisrtModel* getStoreTagListDTO = [[StoreTagLisrtModel alloc] init];
    
    [getStoreTagListDTO setDictFrom:_listArray[section]];
    
    return getStoreTagListDTO.storeTagList.count;
}

//cell个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    //    NSArray *keys = self.dictData.allKeys;
    //    return keys.count;
    
    return _listArray.count;
}

//显示cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"goodsTagCollectionViewCell1";
    
    
    GoodsTagCollectionViewCell *cell = (GoodsTagCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    
    if (collectionView.contentSize.height > 0) {
        //更改collectionView的高度
        [collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(collectionView.contentSize.height));
            
        }];
        
        //更改topView的高度
        [self.topView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(collectionView.contentSize.height+collectionView.frame.origin.y+20));
        }];
        
        
        //更改bottomView的Y
        [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.topView.mas_bottom);
            
        }];
        
    }
    
    
    
    
    StoreTagLisrtModel* getStoreTagListDTO = [[StoreTagLisrtModel alloc] init];
    
    [getStoreTagListDTO setDictFrom:_listArray[indexPath.section]];
    
    StoreTagModel *storeTagModel = [[StoreTagModel alloc]init];
    
    NSMutableArray *arr = getStoreTagListDTO.storeTagList;
    
    storeTagModel = arr[indexPath.row];
    
    cell.tagNameLabel.text = storeTagModel.labelName;
    
    cell.tagNameLabel.tag = [storeTagModel.Id integerValue];
    if ([storeTagModel.flag isEqualToString:@"0"]) {
        cell.tagNameLabel.backgroundColor = [UIColor blackColor];
        [cell.tagNameLabel setTextColor:[UIColor colorWithHexValue:0xffffff alpha:1]];
    }
    [cell layoutSubviews];
    

        
    
   /*
    FixedTagDTO *fixed = self.goodsAllDto.fixedArr[indexPath.section];
    ListTagDTO *listDto = fixed.listArr[indexPath.row];
    cell.tagNameLabel.text = listDto.labelName;
    cell.tagNameLabel.tag = [listDto.ids integerValue];
    NSLog(@"listDto.ids = %ld",(long)listDto.ids.integerValue);
    
    
    if (listDto.flag.integerValue == 0 ) {
        cell.tagNameLabel.textColor = [UIColor colorWithHex:0xffffff];
        cell.tagNameLabel.layer.backgroundColor = [UIColor colorWithHex:0x000000].CGColor;
        [self.selectArrs addObject:cell];
        
    }

    */
    return cell;
}


//显示headView
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    //设置reusableview
    UICollectionReusableView *reusableview = nil;
    
    //获取headView
    GoodsLagCollectionReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"goodsTagCollectionHeadView" forIndexPath:indexPath];
    
    
    StoreTagLisrtModel* getStoreTagListDTO = [[StoreTagLisrtModel alloc] init];
    
    [getStoreTagListDTO setDictFrom:_listArray[indexPath.section]];
    
    headView.goodsLagCollectionLabel.text = getStoreTagListDTO.labelCategory;
    
    
//    //获取每个headView赋值的值
//    //    NSArray *keys = self.dictData.allKeys;
//    FixedTagDTO *fixDto = self.goodsAllDto.fixedArr[indexPath.section];
//    
    
    //显示的内容
//    headView.goodsLagCollectionLabel.text = fixDto.labelCategory;
    
    reusableview = headView;
    
    return reusableview;
    
}

//返回headView的宽高
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    
    
    return CGSizeMake(375, 20);
    
}

//返回cell的每个宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    StoreTagLisrtModel* getStoreTagListDTO = [[StoreTagLisrtModel alloc] init];
    
    [getStoreTagListDTO setDictFrom:_listArray[indexPath.section]];
    
    StoreTagModel *storeTagModel = [[StoreTagModel alloc]init];
    
    NSMutableArray *arr = getStoreTagListDTO.storeTagList;
    
    storeTagModel = arr[indexPath.row];
    

    
    
//        FixedTagDTO *fixed = self.goodsAllDto.fixedArr[indexPath.section];
//    ListTagDTO *listDto = fixed.listArr[indexPath.row];
//    
//    //    NSString *value = [values objectAtIndex:indexPath.row];
//    NSString *value = listDto.labelName;
    
    //根据内容获取宽高
    CGFloat width =    [self gainFontWidthContent:storeTagModel.labelName];
    return CGSizeMake(width+40, 30);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//设置每个cell的top,left,bottom,right
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0 , 15, 10, 20);
}

//点击每个cell触发的方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL isSelect = NO;
    
    GoodsTagCollectionViewCell *selCell = (GoodsTagCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    
    if (self.selectArrs.count>0) {
        for (GoodsTagCollectionViewCell *OldCell in self.selectArrs) {
            if (selCell == OldCell ) {
                selCell.tagNameLabel.layer.backgroundColor = [UIColor colorWithHex:0xffffff].CGColor;
                selCell.tagNameLabel.textColor = [UIColor colorWithHex:0x000000];
                [self.normalArrs addObject:OldCell];
                isSelect = YES;
                
            }
        }
    }
    
    if (!isSelect)
    {
        isSelect = NO;
        [self.selectArrs addObject:selCell];
        selCell.tagNameLabel.layer.backgroundColor = [UIColor colorWithHex:0x000000].CGColor;
        selCell.tagNameLabel.textColor = [UIColor colorWithHex:0xffffff];
    }
    //如果有
    if (self.normalArrs ) {
        [self.selectArrs removeObjectsInArray:self.normalArrs];
        [self.normalArrs removeAllObjects];
        
        
    }
    
}


/**
 *  计算字体宽度
 *
 *  @param content 输入的内容
 *
 *  @return 返回字体的宽度
 */
- (CGFloat)gainFontWidthContent:(NSString *)content
{
    CGSize size;
    
    size=[content boundingRectWithSize:CGSizeMake(200, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:13]} context:nil].size;
    return size.width;
}


#pragma makr -tableViewDelegae&&dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.addMoreTagArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cell";
    AddMoreTagTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell =   (AddMoreTagTableViewCell *) [[[NSBundle mainBundle]loadNibNamed:@"AddMoreTagTableViewCell" owner:nil options:nil ]lastObject];
        
    }
    cell.delegate = self;
    //
    if (tableView.contentSize.height > 0) {
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(tableView.contentSize.height));
        }];
        //更改topView的高度
        [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(tableView.contentSize.height+tableView.frame.origin.y+86+self.addTagBtn.frame.size.height));
        }];
        
        [self.addTagBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(tableView.mas_bottom);
            
        }];
        
    };
    
    cell.tagNameTF.text =self.addMoreTagArr[indexPath.row];
    cell.tagNameTF.delegate = self;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}

- (void)deleteTheCurrentCell:(AddMoreTagTableViewCell *)cell
{
    NSIndexPath *index = [self.tableView indexPathForCell:cell];
    
    [self.addMoreTagArr removeObjectAtIndex:index.row];
    [self.tableView reloadData];
    
    if (self.addMoreTagArr.count == 0) {
        [self.addTagBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.promptLab.mas_bottom).offset(15);
            make.left.equalTo(self.bottomView.mas_left).offset(15);
            make.height.equalTo(@30);
            make.width.equalTo(@63);
            
        }];
    }
}
- (void)AddMoreTagSendDataStr:(NSString *)dataStr andCurrentCell:(AddMoreTagTableViewCell *)cell
{
    
    if (self.addMoreTagArr.count>0) {
        NSIndexPath *index = [self.tableView indexPathForCell:cell];
        //    [self.addMoreTagArr replaceObjectsAtIndexes:index.row withObjects:dataSt];
        NSLog(@"index.row = %ld",(long)index.row);
        
        
        [self.addMoreTagArr replaceObjectAtIndex:index.row withObject:dataStr];
        [self.tableView endEditing:YES];
        
        
    }
    
    
    
}

//点击保存的时候 请求数据
- (void)saveAllTagBtn:(UIButton *)btn
{
    
    [self.tableView endEditing:YES];
    
    
    //其他标签名字
    NSString *labelNameStr;
    //热门标签
    NSString *labelIdStr;
    
    
    if (self.selectArrs.count>0) {
        for (GoodsTagCollectionViewCell* cellTag in self.selectArrs) {
            if (!labelIdStr) {
                labelIdStr =[NSString stringWithFormat:@"%ld",(long)cellTag.tagNameLabel.tag];
            }else
            {
                labelIdStr = [NSString stringWithFormat:@"%@,%ld",labelIdStr,(long)cellTag.tagNameLabel.tag];
                
            }
        }
    }
    
    if (self.addMoreTagArr.count>0) {
        for (id str in self.addMoreTagArr ) {
            
            NSString *strLenth = (NSString *)str;
            //判断不能超过10个字
            if (strLenth.length>10) {
                DebugLog(@"%@", @"不能超过10个字");
                [self.view makeMessage:@"输入内容不能超过10个字" duration:2 position:@"center"];
                
                return;
                
            }
            
            //判断只能输入，中文，英文，数字
            if ([CSPUtils checkGoodsTagFormat:str]||[str isEqualToString:@""]||!str) {
                if (!labelNameStr) {
                    labelNameStr = [NSString stringWithFormat:@"%@",str];
                }else
                {
                    labelNameStr = [NSString stringWithFormat:@"%@,%@",labelNameStr,str];
                }
            }else
            {
                [self.view makeMessage:@"只能输入，中文，英文，数字" duration:2 position:@"center"];
                
                return;
                
            }
        }
    }
    
    
    
    
    NSString *labelName;

    NSArray *strArrs = [labelNameStr componentsSeparatedByString:@","];
    for (NSString *otherTag in strArrs) {
        if (otherTag &&![otherTag  isEqualToString: @""]&& otherTag != nil) {
            if (!labelName) {
                labelName = otherTag;
            }else
            {
                labelName = [NSString stringWithFormat:@"%@",labelName];
            }
            
        }
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [HttpManager sendHttpRequestForUpdateModifyStoreTagLabelNameStr:labelName labelIdStr:labelIdStr Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        DebugLog(@"dict = %@", dict);
        if ([dict checkLegitimacyForData:@"000"]) {
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    
}


- (void)keyboardJumpCell:(AddMoreTagTableViewCell *)cell
{
    
    [UIView animateWithDuration:0.4 animations:^{
        self.scrollView.contentOffset = self.recrodPoint;
        
    }];
    
    [self.tableView endEditing:YES];
    NSLog(@"%f",cell.frame.origin.y);
    NSLog(@"%f",self.tableView.frame.origin.y);
    
    [UIView animateWithDuration:0.4 animations:^{
        
        CGPoint point =  self.scrollView.contentOffset;
        self.recrodPoint = point;
        point.y = point.y+cell.frame.origin.y;
        
        
        self.scrollView.contentOffset = point;
    } completion:^(BOOL finished) {
        
    }];
    
}

/**
 *  收起键盘
 */
- (void)clickTakeBack
{
    [UIView animateWithDuration:0.4 animations:^{
        self.scrollView.contentOffset = self.recrodPoint;
        
    }];
    
    [self.tableView endEditing: YES];
    
}

//设置左导航
- (void)customBackBarButton{
    
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"04_商家中心_设置_后退"] style:UIBarButtonItemStylePlain target:self action:@selector(backBarButtonClick:)];
    
    self.navigationItem.leftBarButtonItem = backBarButton;
    
}

- (void)backBarButtonClick:(UIBarButtonItem *)sender{
    
    
    
    
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark sel textField
#pragma mark-键盘处理的方法

- (void)registerForKeyboardNotifications
{
    //使用NSNotificationCenter 鍵盤出現時
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWasShown:)
     
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    //使用NSNotificationCenter 鍵盤隐藏時
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillBeHidden:)
     
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    
}


#pragma mark sel 轻拍
//实现当键盘出现的时候计算键盘的高度大小。用于输入框显示位置
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    //kbSize即為鍵盤尺寸 (有width, height)
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//得到鍵盤的高度
    NSLog(@"hight_hitht:%f",kbSize.height);
    
    _keyboardhight = kbSize.height;
    
    
    CGFloat keyboardY = self.view.frame.size.height-kbSize.height;
    
    if (self.cellHeight>keyboardY) {
        
        [UIView animateWithDuration:0.4 animations:^{
            
            self.scrollView.contentOffset = CGPointMake(0, (self.cellHeight-keyboardY+50));
        }];
    }
}

//当键盘隐藏的时候
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    self.scrollView.contentOffset = CGPointMake(0,0);
}



@end
