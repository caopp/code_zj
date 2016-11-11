//
//  ZJModifyViewController.m
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/2/29.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "ZJModifyViewController.h"
#import "ZJModifyView.h"
#import "StyleButton.h"
#import "ZJProcessView.h"
#import "ProcessButton.h"
#import "MyUserDefault.h"
#import "UIColor+UIColor.h"
#import "ZJTagAddWithDeleteTableViewCell.h"
#import "SBTagListView.h"
#import "BQProcessView.h"
#import "HttpManager.h"

#import "MyCollectionViewCell.h"
#import "SectionHeaderViewCollectionReusableView.h"
#import "StoreTagLisrtModel.h"
#import "StoreTagModel.h"
#import "UICollectionViewLeftAlignedLayout.h"




@interface ZJModifyViewController ()<ZJModifyViewDelegate,ZJProcessViewDelegate,UITableViewDataSource,UITableViewDelegate,ZJTagAddWithDeleteTableViewCellDelegate,UITextFieldDelegate,SBTagListViewDelegate,BQTagListViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

{
    ZJModifyView *modifyView;
    ZJProcessView *processView;
    //设置全局变量进行标记
    NSInteger lineNum;
    
    NSIndexPath *indexPathRow;
    
    NSMutableArray *array ;
    
    
    NSUInteger indexNum;
    float numFloat;
    
    //uiscrollview
    UIScrollView *scrollView;
    //视图
    UIView *collectionBackgrondView;
    
    UIView *nextCollectionBackgrondView;
    UILabel *descriptionLabel;
    UILabel *hotspotLabel;
    

}
@property (nonatomic,strong)UIButton *SaveButton;
@property (nonatomic,strong)NSArray *styleNameArray;
@property (nonatomic,strong)NSMutableArray *saveTitles;
@property (nonatomic,strong)StyleButton *styleBtn;
@property (nonatomic,strong)ProcessButton *processBtn;
@property (nonatomic,strong)NSArray *processNameArray;
@property (nonatomic,strong)NSMutableArray *processArr;
//设置添加标签
@property (nonatomic,strong)UITableView * tableView;

//设置可变数组
@property (nonatomic,strong)NSMutableArray *textFieldArr;
@property (strong, nonatomic) SBTagListView *list;
@property (strong,nonatomic)BQProcessView *BQList;

//添加ID可变数组
@property (strong,nonatomic)NSMutableArray *arrID;
@property (strong,nonatomic)NSString *arrIDStr;

//设置头部标签
@property(nonatomic, strong)NSMutableArray *ownHobby;//
@property(nonatomic, strong)UICollectionView *collection;
@property(nonatomic, strong)NSMutableArray *dataArr;//
@property (nonatomic,strong)NSMutableArray *listArray;
@property (nonatomic,strong)NSMutableArray *itemArr;





@end

@implementation ZJModifyViewController
//设置cell数组
-(NSMutableArray *)itemArr
{
    if ( _itemArr == nil) {
        _itemArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _itemArr;
}

-(NSMutableArray *)textFieldArr
{
    if (_textFieldArr == nil) {
        _textFieldArr = [NSMutableArray array];
    }
    return  _textFieldArr;
}

-(NSMutableArray *)arrID
{
    if ( _arrID == nil) {
        _arrID = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _arrID;

}



- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"设置店铺标签";
    
    
    //通过上述计算接受过来参数个数，计算，header的高度
    
    //进行数据保存
    _saveTitles = [NSMutableArray arrayWithCapacity:0];
    _processArr = [NSMutableArray arrayWithCapacity:0];
    _listArray = [NSMutableArray arrayWithCapacity:0];

    //设置UI
    [self makeUI];
    //设置返回按钮
    [self customBackBarButton];
   
    //数据请求
    [self getData];
}



#pragma  mark ===============进行数据请求==========
//获取所有店铺接口标签的接口
-(void)getData
{
    [HttpManager sendHttpRequestForUpdateAllStoreTagSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
        //进行初始化
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
            [_collection reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}



#pragma mark ======设置UI=====
-(void)makeUI
{
    //设置浮框
    self.SaveButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.SaveButton.frame = CGRectMake(0, self.view.frame.size.height - 49, self.view.frame.size.width, 49);
    self.SaveButton.backgroundColor = [UIColor yellowColor];
    [self.SaveButton setTitle:@"保存" forState:(UIControlStateNormal)];
    [self.SaveButton setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
    
    [self.view addSubview:self.SaveButton];
    
    [self.SaveButton addTarget:self action:@selector(saveModifyInfo) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.SaveButton setBackgroundColor:[UIColor colorWithHexValue:0x000000 alpha:1]];
    
    [self.SaveButton setTitleColor:[UIColor colorWithHexValue:0xffffff alpha:1] forState:(UIControlStateNormal)];
    [self.SaveButton setFont:[UIFont systemFontOfSize:14]];
    
    
    //scrollView
    
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 49 - 64)];
   
    [self.view addSubview:scrollView];
    scrollView.backgroundColor = [UIColor colorWithHexValue:0xf0f0f0 alpha:1];
    
    
    //上一部视图
    collectionBackgrondView  = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    [scrollView addSubview:collectionBackgrondView];
    collectionBackgrondView.backgroundColor = [UIColor whiteColor];
    
    
    //热门标签
    hotspotLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 20, 100, 15)];
    hotspotLabel.text = @"热门标签";
    hotspotLabel.font = [UIFont systemFontOfSize:15];
    [hotspotLabel setTextColor:[UIColor colorWithHexValue:0x666666 alpha:1]];
    [collectionBackgrondView addSubview:hotspotLabel];
    
    //热门标签简介
    descriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(hotspotLabel.frame.origin.x, hotspotLabel.frame.origin.y + hotspotLabel.frame.size.height + 5, self.view.frame.size.width, 11)];
    descriptionLabel.text = @"这些是热门常用标签,可以直接点选";
    descriptionLabel.font = [UIFont systemFontOfSize:11];
    [descriptionLabel setTextColor:[UIColor colorWithHexValue:0x999999 alpha:1]];
    [collectionBackgrondView addSubview:descriptionLabel];
    

    
    UICollectionViewLeftAlignedLayout *flowLayout = [[UICollectionViewLeftAlignedLayout alloc] init];
    
    _collection = [[UICollectionView alloc]initWithFrame:CGRectMake(15, descriptionLabel.frame.origin.y + descriptionLabel.frame.size.height + 20, self.view.frame.size.width-30 , 200) collectionViewLayout:flowLayout];
    [_collection registerClass:[SectionHeaderViewCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"head"];
    _collection.scrollEnabled = NO;
    _collection.delegate = self;
    _collection.dataSource = self;
    _collection.backgroundColor = [UIColor whiteColor];
    [_collection registerClass:[MyCollectionViewCell class] forCellWithReuseIdentifier:@"identifier"];
    [collectionBackgrondView addSubview:_collection];
    
    
    
    
    
    //下一部分视图
    nextCollectionBackgrondView = [[UIView  alloc]initWithFrame:CGRectMake(0,  collectionBackgrondView.frame.size.height + 20, self.view.frame.size.width, 100)];
    nextCollectionBackgrondView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:nextCollectionBackgrondView];
    
    
    
    
    
    
    //增添更多的标签
    UILabel *moreTagLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 20, 100, 15)];
    moreTagLabel.text = @"增加更多标签";
    moreTagLabel.font = [UIFont systemFontOfSize:15];
    [moreTagLabel setTextColor:[UIColor colorWithHexValue:0x666666 alpha:1]];
    [nextCollectionBackgrondView addSubview:moreTagLabel];
    
    //标签简介
    UILabel *tagDescriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(moreTagLabel.frame.origin.x, moreTagLabel.frame.size.height + moreTagLabel.frame.origin.y + 5, self.view.frame.size.width, 11)];
    tagDescriptionLabel.text = @"上面没有合适的标签,可以自己添加";
    tagDescriptionLabel.font = [UIFont systemFontOfSize:11];
    [tagDescriptionLabel setTextColor:[UIColor colorWithHexValue:0x999999 alpha:1]];
    [nextCollectionBackgrondView addSubview:tagDescriptionLabel];
    
    //自己选择标签
    UILabel *myselfTagLabel = [[UILabel alloc]initWithFrame:CGRectMake(tagDescriptionLabel.frame.origin.x, tagDescriptionLabel.frame.origin.y + tagDescriptionLabel.frame.size.height , self.view.frame.size.width, 11)];
    myselfTagLabel.text = @"每个标签最多10个字";
    myselfTagLabel.font = [UIFont systemFontOfSize:11];
    [myselfTagLabel setTextColor:[UIColor colorWithHexValue:0xeb301f alpha:1]];
    [nextCollectionBackgrondView addSubview:myselfTagLabel];
    

    //设置tableview
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, nextCollectionBackgrondView.frame.size.height) style:(UITableViewStyleGrouped)];
    self.tableView.scrollEnabled = NO;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource  = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [nextCollectionBackgrondView addSubview:self.tableView];
    
}

#pragma mark ====tableView代理方法==

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.textFieldArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ZJTagAddWithDeleteTableViewCell *tagAddWithDeleteTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"ZJTagAddWithDeleteTableViewCell"];
   
    if (!tagAddWithDeleteTableViewCell) {
        [tableView registerNib:[UINib nibWithNibName:@"ZJTagAddWithDeleteTableViewCell" bundle:nil] forCellReuseIdentifier:@"ZJTagAddWithDeleteTableViewCell"];
        tagAddWithDeleteTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"ZJTagAddWithDeleteTableViewCell"];
    }
    
    tagAddWithDeleteTableViewCell.delegate = self;
    
    tagAddWithDeleteTableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    tagAddWithDeleteTableViewCell.index_row = indexPath;
    
    tagAddWithDeleteTableViewCell.tagTextField.text = self.textFieldArr[indexPath.row];
    
    return tagAddWithDeleteTableViewCell;
}


#pragma mark =====tableView中cell进行删除==
//设置tableview footer
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 50;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    StoreTagLisrtModel* getStoreTagListDTO = [[StoreTagLisrtModel alloc] init];
    
    [getStoreTagListDTO setDictFrom:_listArray[section]];
    
    return getStoreTagListDTO.storeTagList.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    MyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"identifier" forIndexPath:indexPath];
    
    StoreTagLisrtModel* getStoreTagListDTO = [[StoreTagLisrtModel alloc] init];
    
    [getStoreTagListDTO setDictFrom:_listArray[indexPath.section]];
    
    StoreTagModel *storeTagModel = [[StoreTagModel alloc]init];
    
    NSMutableArray *arr = getStoreTagListDTO.storeTagList;
    
    storeTagModel = arr[indexPath.row];
    
    cell.label.text = storeTagModel.labelName;
    
    if ([storeTagModel.flag isEqualToString:@"0"]) {
        cell.label.backgroundColor = [UIColor blackColor];
        [cell.label setTextColor:[UIColor colorWithHexValue:0xffffff alpha:1]];
    }
    [cell layoutSubviews];

    //上一部视图
    collectionBackgrondView.frame  = CGRectMake(0, 0, self.view.frame.size.width, collectionView.contentSize.height + 91);
    
    
     _collection.frame = CGRectMake(15,descriptionLabel.frame.origin.y + descriptionLabel.frame.size.height + 20 , self.view.frame.size.width - 30 , collectionBackgrondView.frame.size.height - descriptionLabel.frame.origin.y - descriptionLabel.frame.size.height - 20);


    //下一部分视图
    nextCollectionBackgrondView.frame = CGRectMake(0, collectionBackgrondView.frame.size.height + 5, self.view.frame.size.width, self.view.frame.size.height - 64 - 49 - 5 - collectionBackgrondView.frame.size.height + self.textFieldArr.count * 50);
//    nextCollectionBackgrondView.backgroundColor = [UIColor redColor];
    
    //设置tableview
    self.tableView.frame = CGRectMake(0,76, self.view.frame.size.width, self.view.frame.size.height - 64 - 49 - 5 - collectionBackgrondView.frame.size.height + self.textFieldArr.count * 50);
    self.tableView.backgroundColor = [UIColor clearColor];
    

    return cell;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _listArray.count;
}
#pragma mark 头视图size
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGSize size = {self.view.frame.size.width, 30.0};
    return size;
}
#pragma mark 每个Item大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{

    StoreTagLisrtModel* getStoreTagListDTO = [[StoreTagLisrtModel alloc] init];
    
    [getStoreTagListDTO setDictFrom:_listArray[indexPath.section]];
    
    StoreTagModel *storeTagModel = [[StoreTagModel alloc]init];
    
    NSMutableArray *arr = getStoreTagListDTO.storeTagList;
    
    storeTagModel = arr[indexPath.row];
    
     CGSize contentSize = [storeTagModel.labelName boundingRectWithSize:CGSizeMake(FLT_MAX, 30) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size;

    return CGSizeMake(contentSize.width + 20, 30);
}


-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    SectionHeaderViewCollectionReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"head" forIndexPath:indexPath];    
    StoreTagLisrtModel* getStoreTagListDTO = [[StoreTagLisrtModel alloc] init];
    
    [getStoreTagListDTO setDictFrom:_listArray[indexPath.section]];
    
    headView.titleLabel.text =getStoreTagListDTO.labelCategory;
    
    return headView;
}



-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",indexPath.row);
    MyCollectionViewCell *cell = (MyCollectionViewCell*)[_collection cellForItemAtIndexPath:indexPath];
    cell.isOk = !cell.isOk;
    [self updateCollectionViewCellStatus:cell selected:cell.isOk];
    

    StoreTagLisrtModel* getStoreTagListDTO = [[StoreTagLisrtModel alloc] init];
    
    [getStoreTagListDTO setDictFrom:_listArray[indexPath.section]];
    
    StoreTagModel *storeTagModel = [[StoreTagModel alloc]init];
    
    NSMutableArray *arr = getStoreTagListDTO.storeTagList;
    
    storeTagModel = arr[indexPath.row];

    
    if (cell.isOk) {
        
        [self.arrID addObject:storeTagModel.Id];
        
    }else
    {
     [self.arrID removeObject:storeTagModel.Id];
    }
    
    NSString *string = [self.arrID  componentsJoinedByString:@","];
    _arrIDStr  = [string copy];
    DebugLog(@" string=== %@",string)
    
}

-(void)updateCollectionViewCellStatus:(MyCollectionViewCell *)myCollectionCell selected:(BOOL)selected
{
    if (selected) {
        myCollectionCell.label.backgroundColor = [UIColor blackColor];
        [myCollectionCell.label setTextColor:[UIColor colorWithHexValue:0xffffff alpha:1]];
       
    }else
    {
        myCollectionCell.label.backgroundColor = [UIColor whiteColor];
        [myCollectionCell.label setTextColor:[UIColor colorWithHexValue:0x000000 alpha:1]];
    }
}


-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    view.backgroundColor = [UIColor whiteColor];

    //添加添加标签按钮
    UIButton *addStoreTagButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    addStoreTagButton.frame = CGRectMake(15, 0, 63, 30);
    addStoreTagButton.backgroundColor = [UIColor redColor];
    [addStoreTagButton setTitle:@"添加标签" forState:(UIControlStateNormal)];
    [view addSubview:addStoreTagButton];
    [addStoreTagButton setBackgroundColor:[UIColor colorWithHexValue:0xeb301f alpha:1]];
    [addStoreTagButton setTitleColor:[UIColor colorWithHexValue:0xffffff alpha:1] forState:(UIControlStateNormal)];
    [addStoreTagButton setFont:[UIFont systemFontOfSize:13]];

    //添加观察者
    [addStoreTagButton addTarget:self action:@selector(addStoreTag) forControlEvents:(UIControlEventTouchUpInside)];
    
    return view;
}

#pragma mark 添加删除店铺标签和添加店铺标签
//cell 的代理方法
-(void)deleteTagBtnActionBtnTag:(NSIndexPath *)BtnTag
{
   
    [self.tableView reloadData];
    [self.textFieldArr removeObjectAtIndex:BtnTag.row];
    NSArray *indexArray = [NSArray arrayWithObject:BtnTag];
    [self.tableView deleteRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationFade];
}

//textField输入内容
-(void)textField:(NSIndexPath *)textField
{
    NSLog(@"textField==== %@",textField);

}

//添加标签
-(void)addStoreTag
{
    [self.tableView reloadData];
    [self.textFieldArr addObject:@""];
    
    NSIndexPath *indexPath =  [NSIndexPath indexPathForRow:self.textFieldArr.count - 1 inSection:0];
    NSArray *indexArray=[NSArray arrayWithObject:indexPath];
    
    [self.tableView insertRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationFade];
    
    
    if (self.textFieldArr.count < 10) {
        scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height  + self.textFieldArr.count * 43);
        //下一部分视图
        nextCollectionBackgrondView.frame = CGRectMake(0, collectionBackgrondView.frame.size.height + 5, self.view.frame.size.width, self.view.frame.size.height - 64 - 49 - 5 - collectionBackgrondView.frame.size.height + self.textFieldArr.count * 50);
        
        //设置tableview
        self.tableView.frame = CGRectMake(0,76, self.view.frame.size.width, self.view.frame.size.height - 64 - 49 - 5 - collectionBackgrondView.frame.size.height + self.textFieldArr.count * 50 + 50);

    }else
    {
        return;
    }
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}


#pragma  mark ======对选中的数据进行保存====
//进行页面保存，以及返回上一页面
-(void)saveModifyInfo
{

    //进行店铺修改
    [HttpManager sendHttpRequestForUpdateModifyStoreTagLabelNameStr:@"" labelIdStr:_arrIDStr  Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        DebugLog(@"%@", dict);
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        
    }];
    

    [self.navigationController popViewControllerAnimated:YES];
    
}
#pragma mark =============设置按钮==============
//设置返回按钮
- (void)customBackBarButton{
    
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"04_商家中心_设置_后退"] style:UIBarButtonItemStylePlain target:self action:@selector(backBarButtonClick:)];
    
    self.navigationItem.leftBarButtonItem = backBarButton;
}
//返回按钮执行事件
- (void)backBarButtonClick:(UIBarButtonItem *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    [self.view endEditing:YES];
    
}

@end
