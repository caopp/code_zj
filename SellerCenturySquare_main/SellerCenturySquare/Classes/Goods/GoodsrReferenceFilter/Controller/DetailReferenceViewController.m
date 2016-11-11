//
//  DetailReferenceViewController.m
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/7/11.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "DetailReferenceViewController.h"
#import "SlidePageManager.h"
#import "SlidePageView.h"
//顶部
#import "GoodHeaderTableViewCell.h"
#import "CSPMoreShopViewController.h"
//窗口图和详情图cell
#import "WindowWithDetailTableViewCell.h"
#import "HttpManager.h"
#import "GoodImageDTO.h"
#import "WindowXibView.h"
#import "DetailXibView.h"
#import "DetailPicTableViewCell.h"
#import "SDRefresh.h"
#import "EnlargeImageModel.h"
#import "TitleZoneGoodsTableViewCell.h"

@interface DetailReferenceViewController ()<SlidePageSquareViewDelegate,UIScrollViewDelegate,WindowWithDetailTableViewCellDelegate,DetailXibViewDelegate,DetailPicTableViewCellDelagate>
{
    //窗口图心事设置
    NSString *windowSetStr;
    //详情图显示设置
    NSString  *detailSetStr;
    NSMutableArray *windOWArr;
    NSMutableArray *detailArr;
    //参看图选中后进行展示
    NSMutableArray *selectedArr;
    //参看图选中展示个数
    NSMutableArray *selectedArrCount;
    //全局isdefualt 判断
    NSNumber  *isdefualt;
    //设置开关进行全部和部分展示
    BOOL  isEye;
    //参考图header展示
    DetailXibView *detailXibView;
    //窗口图header展示
    WindowXibView *windowXibView;
    
    NSInteger pageNO;
    NSInteger pageSize;
    NSInteger detailpageNO;
    NSInteger detailpageSize;
    //根据index进行判断上拉，下拉
    NSInteger indexRefresh;
    //选中数组
    NSMutableArray *arrSelected;
    UILabel *showSelectedLabel;
    NSNumber *isDefaultNum;
    NSInteger addSetRNum;
    NSNumber *isSelectdDefault;
    
}

@property (weak, nonatomic) IBOutlet UIScrollView *segmentScroll;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (nonatomic,strong) SlidePageManager *manager ;
//顶部
@property (weak, nonatomic) IBOutlet UITableView *headerTableView;
//窗口图
@property (weak, nonatomic) IBOutlet UITableView *WindowFigureTableView;
//详情图
@property (weak, nonatomic) IBOutlet UITableView *DetailTableView;

@property (strong, nonatomic)UIScrollView *showScrollView;
@property (nonatomic, weak) SDRefreshHeaderView *refreshHeader;
@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;


@property (nonatomic, weak) SDRefreshHeaderView *detailRefreshHeader;
@property (nonatomic, weak) SDRefreshFooterView *detailRrefreshFooter;


@property (weak, nonatomic) IBOutlet UIView *backgroundView;

@end

@implementation DetailReferenceViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
}

//窗口图数组
- (void)viewDidLoad {
    [super viewDidLoad];
    [self customBackBarButton];

    //标题
    self.title = @"零售_商品默认参考图筛选";
    self.view.backgroundColor = [UIColor whiteColor];
    
    //顶部
    self.headerTableView.delegate = self;
    self.headerTableView.dataSource = self;
    self.headerTableView.scrollEnabled = NO;
    self.headerTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //窗口图
    self.WindowFigureTableView.delegate = self;
    self.WindowFigureTableView.dataSource = self;
    self.WindowFigureTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //详情图
    self.DetailTableView.delegate = self;
    self.DetailTableView.dataSource = self;
    self.DetailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;    
    [self createUI];
    
    //创建窗口图数组
    windOWArr = [NSMutableArray arrayWithCapacity:0];
    detailArr = [NSMutableArray arrayWithCapacity:0];
    selectedArr = [NSMutableArray arrayWithCapacity:0];
    selectedArrCount = [NSMutableArray arrayWithCapacity:0];
    //添加选中数组
    arrSelected = [NSMutableArray arrayWithCapacity:0];
    
    //眼睛处于关闭状态
    isEye = NO;
    
    if (![self.goodReference.wQty isEqualToNumber:[NSNumber numberWithInt:0]]) {
        
        NSNotification *notification = [[NSNotification alloc]initWithName:@"windowPicNum" object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter]postNotification:notification];
        
    }else
    {
        NSNotification *notification = [[NSNotification alloc]initWithName:@"windowPicNumRed" object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter]postNotification:notification];
    }
    
    if (![self.goodReference.rQty isEqualToNumber:[NSNumber numberWithInt:0]]) {
        
        NSNotification *notification = [[NSNotification alloc]initWithName:@"detailPicNum" object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter]postNotification:notification];
        
    }else
    {
        NSNotification *notification = [[NSNotification alloc]initWithName:@"detailPicNumRed" object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter]postNotification:notification];
    }
    
    //进行刷新
    [self createRefresh];
    [self.refreshHeader beginRefreshing];
    [self createRefreshDetail];
    isDefaultNum = [NSNumber numberWithInt:1];
    addSetRNum = [self.goodReference.setRNum integerValue];
}

#pragma mark 创建界面
-(void)createUI{
    
    //窗口图显示设置情况
    if ([self.goodReference.isSetWPic isEqualToNumber:[NSNumber numberWithInt:0]]) {
        
        windowSetStr = @"窗口参考图:未设置";
        
    }else
    {
        windowSetStr = @"窗口参考图:已设置";
    }
    
    //详情图显示设置情况
    if ([self.goodReference.isSetRPic isEqualToNumber:[NSNumber numberWithInt:0]]) {
        
        detailSetStr = @"详情参考图:未设置";
    }else
    {
        detailSetStr = @"详情参考图:已设置";
    }
    
    self.segmentScroll.delegate = self;
    
    //!顶部的滑动
    self.manager = [[SlidePageManager alloc]init];
    
    SlidePageSquareView * scView1 = (SlidePageSquareView*)[self.manager createBydataArr:@[windowSetStr,detailSetStr] slidePageType:SlidePageTypeSquare  bgColor:[UIColor colorWithHex:0x333333] squareViewColor:[UIColor colorWithHex:0xffffff] unSelectTitleColor:[UIColor colorWithHex:0x999999] selectTitleColor:[UIColor blackColor] witTitleFont:[UIFont systemFontOfSize:14]];
    scView1.frame = CGRectMake(0, 0,SCREEN_WIDTH, 32);
    scView1.contentSize = CGSizeMake(SCREEN_WIDTH, 0);
    scView1.delegateForSlidePage = self;
    [self.headerView addSubview:scView1];
    
}


#pragma mark - event touch
- (void)slidePageSquareView:(SlidePageSquareView*)view andBtnClickIndex:(NSInteger)index{
    
    [_segmentScroll  setContentOffset:CGPointMake(SCREEN_WIDTH*index,0 ) animated:YES];
    NSLog(@"%ld",index);
    
    indexRefresh = index;
    
    if (index == 0) {
        
         [self.refreshHeader beginRefreshing];

    }else if(index == 1){
        
        [self.detailRefreshHeader beginRefreshing];
    }
}

#pragma mark scrollerViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

    if (scrollView == self.DetailTableView) {
        return;
    }
    //!改变顶部的偏移
    self.manager.contentOffsetX = scrollView.contentOffset.x;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    //先进行x轴
    static float oldX = 0;
    if (scrollView.contentOffset.x != oldX) {
        NSInteger i = (targetContentOffset->x - 0)/_segmentScroll.frame.size.width;
        if (i == 0) {
            
            NSNotification *notification = [[NSNotification alloc]initWithName:@"windowPicNumRed" object:nil userInfo:nil];
            [[NSNotificationCenter defaultCenter]postNotification:notification];

            [self.refreshHeader beginRefreshing];
            
        }else if (i == 1)
        {
            NSNotification *notification = [[NSNotification alloc]initWithName:@"detailPicNumRed" object:nil userInfo:nil];
            [[NSNotificationCenter defaultCenter]postNotification:notification];
            
            [self.detailRefreshHeader beginRefreshing];
        }
    }
    
    //在进行y轴
    //进行y轴上判断
    static float newY = 0;
    static float oldY = 0;
    newY = scrollView.contentOffset.y ;
    if (newY != oldY ) {
    }
}

#pragma mark tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.headerTableView == tableView) {
       return 1;
    }else if (self.WindowFigureTableView == tableView)
    {
       return  windOWArr.count;
        
    }else if (self.DetailTableView == tableView)
    {
        if (YES == isEye)
        {
            if (selectedArrCount.count == 0) {
                showSelectedLabel.hidden = NO;
            }else
            {
                showSelectedLabel.hidden = YES;
            }
            return selectedArrCount.count;
            
        }else
        {
            showSelectedLabel.hidden = YES;
            return detailArr.count;
        }
    }
    return 0;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.headerTableView == tableView) {
        return 0.01;
    }
    
    return 40;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.DetailTableView == tableView) {
    
        if (!detailXibView) {
            detailXibView = [[[NSBundle mainBundle]loadNibNamed:@"DetailXibView" owner:self options:nil]lastObject];
            
            detailXibView.delegate = self;
            
            detailXibView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
            
            detailXibView.backgroundColor = [UIColor whiteColor];
            detailXibView.setOkLabel.text = [NSString stringWithFormat:@"已经设置%ld张",addSetRNum];

        }
        
        return detailXibView;

    }else if (self.WindowFigureTableView == tableView)
    {
        if (!windowXibView) {
            windowXibView = [[[NSBundle mainBundle]loadNibNamed:@"WindowXibView" owner:self options:nil]lastObject];
            windowXibView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
            windowXibView.backgroundColor = [UIColor whiteColor];
        }

        return windowXibView;
    }
    return nil;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (self.headerTableView == tableView) {
        GoodHeaderTableViewCell *cell;
        cell = [self createGoodsShareTableViewCell:indexPath withTable:tableView];
        
        return cell;
        
    }else if (self.WindowFigureTableView == tableView)
    {
        WindowWithDetailTableViewCell *cell;
        cell = [self createWindowWithDetailTableViewCell:indexPath withTable:tableView arr:windOWArr];
        
        cell.delegate = self;
        
        return cell;

    }else if (self.DetailTableView == tableView)
    {
        DetailPicTableViewCell *cell;
        
        NSMutableArray *arr;
        
        if (isEye) {
            
            arr = selectedArrCount;

        }else{
            
            arr = detailArr;
        }
        
        cell = [self createWindowWithTableViewCell:indexPath withTable:tableView arr:arr];
        
        cell.delegate = self;
        
        return cell;
    }
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell =  [self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    if (self.headerTableView == tableView) {
        
        return 120;
    }else{
      
        return cell.frame.size.height;
    }
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.headerTableView == tableView) {
        
        CSPMoreShopViewController*goodsDetailsVC = [[CSPMoreShopViewController alloc]init];
        goodsDetailsVC.goodsNo = self.goodReference.goodsNo;
        
        [self.navigationController pushViewController:goodsDetailsVC animated:YES];
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

#pragma  mark create TableViewCell
-(GoodHeaderTableViewCell *)createGoodsShareTableViewCell:(NSIndexPath *)index withTable:(UITableView *)tableView{
    GoodHeaderTableViewCell *headeCell = [tableView dequeueReusableCellWithIdentifier:@"GoodHeaderTableViewCell"];
    if (!headeCell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"GoodHeaderTableViewCell" bundle:nil] forCellReuseIdentifier:@"GoodHeaderTableViewCell"];
        headeCell = [tableView dequeueReusableCellWithIdentifier:@"GoodHeaderTableViewCell"];
    }
    
    headeCell.backgroundColor = [UIColor colorWithHex:0xefeff4 alpha:1];
    
    headeCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //进行数据传递
    //名称
    headeCell.goodsNameLabel.text = self.goodReference.goodsName;

    //零售价
    if ([self.goodReference.retailPrice  floatValue] == 0) {
        
        headeCell.priceLabel.text = [NSString stringWithFormat:@"¥ %@",@"0"];
        
    }else
    {
        headeCell.priceLabel.text = [NSString stringWithFormat:@"¥ %@",self.goodReference.retailPrice];
    }
    
    //默认图
    [headeCell.imgUrlLabel sd_setImageWithURL:[NSURL URLWithString:self.goodReference.imgUrl] ];

   //商品货号
    headeCell.goodsWillNoLabel.text = [NSString stringWithFormat:@"货号: %@", self.goodReference.goodsWillNo];
    
    //货物颜色
    headeCell.colorLabel.text = [NSString stringWithFormat:@"颜色: %@", self.goodReference.color];

   //货物状态
    if ([self.goodReference.goodsStatus isEqualToString:@"2"]) {
        headeCell.goodsStatusLabel.text = @"状态:已上架";
    }else if ([self.goodReference.goodsStatus isEqualToString:@"3"])
    {
        headeCell.goodsStatusLabel.text = @"状态:已下架";
    }
    
    return headeCell;
}


-(WindowWithDetailTableViewCell *)createWindowWithDetailTableViewCell:(NSIndexPath *)index withTable:(UITableView *)tableView  arr:(NSMutableArray *)arr{
    
    WindowWithDetailTableViewCell *headeCell = [tableView dequeueReusableCellWithIdentifier:@"WindowWithDetailTableViewCell"];
    if (!headeCell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"WindowWithDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"WindowWithDetailTableViewCell"];
        headeCell = [tableView dequeueReusableCellWithIdentifier:@"WindowWithDetailTableViewCell"];
    }
    
    headeCell.backgroundColor = [UIColor colorWithHex:0xefeff4 alpha:1];
    
    headeCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    GoodImageDTO *goodImage = [[GoodImageDTO alloc]init];
    
    [goodImage setDictFrom:arr[index.row]];
    
    [headeCell acceptImageDTO:goodImage];
    
    headeCell.selectedButton.tag = index.row;
    
    headeCell.WindowWithDetail.tag = index.row;

    // 展示名字
    headeCell.nameLabel.text = goodImage.userName;
    //分享时间
    headeCell.timeLabel.text = [NSString stringWithFormat:@"分享时间:%@", goodImage.createDate];
    //设置窗口图的名字
    headeCell.selectedButton.tag = index.row;
    
    //给图片设置tag
    headeCell.WindowWithDetail.tag = index.row;
    
    if ([goodImage.isDefault isEqualToNumber:[NSNumber numberWithInt:1]]) {
        
        headeCell.selectedButton.selected = NO;
        
    }else if ([goodImage.isDefault isEqualToNumber:[NSNumber numberWithInt:2]])
    {
        headeCell.selectedButton.selected = YES;
    }
    
    return headeCell;
}

-(DetailPicTableViewCell *)createWindowWithTableViewCell:(NSIndexPath *)index withTable:(UITableView *)tableView  arr:(NSMutableArray *)arr{
    DetailPicTableViewCell *headeCell = [tableView dequeueReusableCellWithIdentifier:@"DetailPicTableViewCell"];
    if (!headeCell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"DetailPicTableViewCell" bundle:nil] forCellReuseIdentifier:@"DetailPicTableViewCell"];
        headeCell = [tableView dequeueReusableCellWithIdentifier:@"DetailPicTableViewCell"];
    }
    
    headeCell.selectedButton.tag = index.row;
    
    headeCell.WindowWithDetail.tag = index.row;
    
    headeCell.backgroundColor = [UIColor whiteColor];
    
    headeCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    GoodImageDTO *goodImage = [[GoodImageDTO alloc]init];
    
    [goodImage setDictFrom:arr[index.row]];
    
    [headeCell acceptGoodImageDTO:goodImage];
  
    // 展示名字
    headeCell.nameLabel.text = goodImage.userName;
    
    //分享时间
    headeCell.timeLabel.text = [NSString stringWithFormat:@"分享时间: %@",goodImage.createDate];
    
    if ([goodImage.isDefault isEqualToNumber:[NSNumber numberWithInt:1]]) {
        
        headeCell.selectedButton.selected = NO;
        
    }else if ([goodImage.isDefault isEqualToNumber:[NSNumber numberWithInt:2]])
    {
        
        headeCell.selectedButton.selected = YES;
    }
    
    return headeCell;
}


//进行数据请求
-(void)getImageDataListImageType:(NSNumber *)imageType isDefault:(NSNumber *)isDefault goodsNo:(NSString *)goodsNo showNum:(NSInteger )showNum pageNo:(NSInteger )pageNoNu pageSize:(NSInteger)pageSizeNu  downloadImage:(SDRefreshView *)refresh
{
    [HttpManager sendHttpRequestFordefaultShareImagesImageType:imageType goodsNo:goodsNo isDefault:isDefault pageNo:[NSNumber numberWithInteger:pageNoNu] pageSize:[NSNumber numberWithInteger:pageSizeNu] Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSArray *arr;
        NSArray *detarr;
        if ([responseDic[@"code"] isEqualToString:@"000"]) {
            //根据所给的isDefault 的值，进行判断。
            if ([imageType isEqualToNumber:[NSNumber numberWithInt:1]]) {
               arr = responseDic[@"data"][@"list"];
                if (refresh == _refreshHeader) {
                    windOWArr = [NSMutableArray arrayWithArray:arr];
                }else{
                    [windOWArr addObjectsFromArray:arr];
                }
                
                [self.WindowFigureTableView  reloadData];
                
            }else if ([imageType isEqualToNumber:[NSNumber numberWithInt:2]])
            {
                detarr = responseDic[@"data"][@"list"];
                if (refresh == _detailRefreshHeader) {
                    if ([isDefault isEqualToNumber:[NSNumber numberWithInt:2]]) {
                        selectedArrCount = [NSMutableArray arrayWithArray:detarr];
                    }else
                    {
                        detailArr = [NSMutableArray arrayWithArray:detarr];
                    }
                }else{
                    [detailArr addObjectsFromArray:detarr];
                }

                [self.DetailTableView reloadData];
            }
    
        }
        [self.refreshHeader endRefreshing];
        [self.refreshFooter endRefreshing];
        [self.detailRefreshHeader endRefreshing];
        [self.detailRrefreshFooter endRefreshing];
        //!看如果到底了，就修改底部提示文字
        if (arr.count < 20) {
            [self.refreshFooter noDataRefresh];
        }
        if (detarr.count < 20) {
            [self.detailRrefreshFooter noDataRefresh];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.refreshHeader endRefreshing];
        [self.refreshFooter endRefreshing];
        [self.detailRefreshHeader endRefreshing];
        [self.detailRrefreshFooter endRefreshing];
    }];
}

#pragma mark ========选中按钮代理方法=======
-(void)setButton:(UIButton *)button image:(UIImageView *)image;
{
    //@1首先进行判断(按钮当前的状态)
    if (button.selected) {
        GoodImageDTO *goodImage = [[GoodImageDTO alloc]init];
        [goodImage setDictFrom:windOWArr[button.tag]];
        if ([goodImage.isDefault isEqualToNumber:[NSNumber numberWithInt:2]]) {
            return;
        }
    }else//@2对没有选中状态按钮的处理数据
    {
        //@3对数组中选中的状态的数据进行设置取消状态，获取所有的数组
        GoodImageDTO *goodImageDTO = [[GoodImageDTO alloc]init];
        int defaultIndex = 0;
        NSDictionary *dictionary;
        for (int i = 0; i < windOWArr.count ; i ++) {
            NSDictionary *defaultDic = windOWArr[i];
            [goodImageDTO setDictFrom:defaultDic];
            //@4对默认选中数组进行处理
            if ([goodImageDTO.isDefault isEqualToNumber:[NSNumber numberWithInt:2]]) {
                goodImageDTO.isDefault = [NSNumber numberWithInt:1];
                defaultIndex = i;
                NSMutableDictionary *mutabelDic = [defaultDic mutableCopy];
                [mutabelDic setObject:goodImageDTO.isDefault forKey:@"isDefault"];
                dictionary = [mutabelDic copy];
                
                [self  setDefaltPic:goodImageDTO.Id isDefault:goodImageDTO.isDefault button:button image:image imageType:1];
            }
        }
        //!修改要设置为默认的数据 并修改为默认
        GoodImageDTO *selectedDTO = [[GoodImageDTO alloc]init];
        NSDictionary *selectedDic = windOWArr[button.tag];
        [selectedDTO setDictFrom:selectedDic];
        selectedDTO.isDefault = [NSNumber numberWithInt:2];
        NSMutableDictionary *selectedMutabelDic = [selectedDic mutableCopy];
        [selectedMutabelDic setObject:selectedDTO.isDefault forKey:@"isDefault"];
        selectedDic = [selectedMutabelDic copy];
        [windOWArr replaceObjectAtIndex:button.tag withObject:selectedDic];
        [self  setDefaltPic:selectedDTO.Id isDefault:selectedDTO.isDefault button:button image:image imageType:1];
        [self.manager changeLabelValue:0 withTitle:@"窗口参考图:已设置"];
    }
    
    /*
    GoodImageDTO *goodImage = [[GoodImageDTO alloc]init];
    
    int defaultindex = 0;
    
    NSDictionary *dictionary;
    
    for (int i = 0; i < windOWArr.count; i ++) {
        
         NSDictionary*  defaultDictionary = windOWArr[i];
        
         [goodImage setDictFrom:defaultDictionary];
        
        if ([goodImage.isDefault isEqualToNumber:[NSNumber numberWithInt:2]]) {
            
            goodImage.isDefault = [NSNumber numberWithInt:1];
            
            defaultindex = i;
            
            NSMutableDictionary *mutabelDic = [defaultDictionary mutableCopy];
            
            [mutabelDic setObject:goodImage.isDefault forKey:@"isDefault"];
            
            dictionary = [mutabelDic copy];
            
            [self  setDefaltPic:goodImage.Id isDefault:goodImage.isDefault button:button image:image imageType:1];
    
        }
            dictionary = [defaultDictionary mutableCopy];

         [windOWArr replaceObjectAtIndex:defaultindex withObject:dictionary];
    
    }
    
    //!修改要设置为默认的数据 并修改为默认
    GoodImageDTO *selectedDTO = [[GoodImageDTO alloc]init];
    
    NSDictionary *selectedDic = windOWArr[button.tag];

    [selectedDTO setDictFrom:selectedDic];
    
    selectedDTO.isDefault = [NSNumber numberWithInt:2];

    NSMutableDictionary *selectedMutabelDic = [selectedDic mutableCopy];

    [selectedMutabelDic setObject:selectedDTO.isDefault forKey:@"isDefault"];

    selectedDic = [selectedMutabelDic copy];
    
    [windOWArr replaceObjectAtIndex:button.tag withObject:selectedDic];

    [self  setDefaltPic:selectedDTO.Id isDefault:selectedDTO.isDefault button:button image:image imageType:1];
    
    [self.manager changeLabelValue:0 withTitle:@"窗口参考图:已设置"];
    
    [self.WindowFigureTableView reloadData];
    */
    
}


//放大图片
-(void)amplificationImage:(UIImageView *)imageView
{
    [EnlargeImageModel showImage:imageView];
}


//设置默认
-(void)setDefaltPic:(NSNumber *)picId isDefault:(NSNumber *)isDefault button:(UIButton *)button image:(UIImageView *)image  imageType:(int )imageType
{
    
    [HttpManager sendHttpRequestFordefaultShareImagespicId:picId isDefault:isDefault Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *responseDic =  [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([responseDic[@"code"] isEqualToString:@"000"]) {
           
//            button.selected = !button.selected;
            
            if (imageType == 1) {
                
                [self.refreshHeader beginRefreshing];
                
            }else
            {
//                [self.detailRefreshHeader beginRefreshing];
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
            [self.refreshHeader endRefreshing];
            
//            [self.detailRefreshHeader endRefreshing];

    }];
}

//点击详情参考图显示
-(void)setDetailButton:(UIButton *)detailButton image:(UIImageView *)image
{
    detailButton.selected = !detailButton.selected;
    if (detailButton.selected) {
        if (addSetRNum >= 10) {
            detailButton.selected = NO;
            [self.view makeMessage:@"最多仅可设置10张图片" duration:2.0f position:@"center"];
            return;
        }
    }
    /*
    GoodImageDTO *goodImage = [[GoodImageDTO alloc]init];
    if (isEye == YES) {
        
        [goodImage setDictFrom: selectedArrCount[detailButton.tag]];
        [selectedArrCount removeObjectAtIndex:detailButton.tag];
        
    }else
    {
        [goodImage setDictFrom: detailArr[detailButton.tag]];
    }
    
    if (detailButton.selected) {
        goodImage.isDefault = [NSNumber numberWithInt:2];
        addSetRNum++;
    }else
    {
        goodImage.isDefault = [NSNumber numberWithInt:1];
        addSetRNum--;
    }
    
    [self  setDefaltPic:goodImage.Id isDefault:goodImage.isDefault button:detailButton image:image imageType:2];
     */
    
    //进行眼睛设置问题
    NSMutableArray *arr;
    if (isEye) {
        arr = selectedArrCount;
    }else
    {
        arr = detailArr;
    }
    //数字进行展示（显示数字问题）
    NSNumber *isDefault;
    if (detailButton.selected) {
        addSetRNum++;
        isDefault = [NSNumber numberWithInt:2];
    }else
    {
        addSetRNum--;
        isDefault = [NSNumber numberWithInt:1];
    }
    
    //!修改要设置为默认的数据 并修改为默认
    GoodImageDTO *selectedDTO = [[GoodImageDTO alloc]init];
    NSDictionary *selectedDic = arr[detailButton.tag];
    [selectedDTO setDictFrom:selectedDic];
    selectedDTO.isDefault = isDefault;
    NSMutableDictionary *selectedMutabelDic = [selectedDic mutableCopy];
    [selectedMutabelDic setObject:selectedDTO.isDefault forKey:@"isDefault"];
    selectedDic = [selectedMutabelDic copy];
    [arr replaceObjectAtIndex:detailButton.tag withObject:selectedDic];
    [self  setDefaltPic:selectedDTO.Id isDefault:selectedDTO.isDefault button:detailButton image:image imageType:2];
    
    detailXibView.setOkLabel.text = [NSString stringWithFormat:@"已经设置%ld张",addSetRNum];
    
    if (addSetRNum == 0) {
        [self.manager changeLabelValue:1 withTitle:@"详情参考图:未设置"];
    }else
    {
        [self.manager changeLabelValue:1 withTitle:@"详情参考图:已设置"];
    }

    [self.DetailTableView reloadData];
    
}


#pragma mark ======设置眼睛按钮====
-(void)setEyeButtonAction:(UIButton *)eyeButton;
{
    eyeButton.selected = !eyeButton.selected;
    
    if (eyeButton.selected) {
        
         isDefaultNum = [NSNumber numberWithInt:2];
         isEye = YES;
    }else
    {
         isDefaultNum = [NSNumber numberWithInt:1];
         isEye = NO;
    }
  
    [self.detailRefreshHeader beginRefreshing];
    
    
    /*
    [selectedArr removeAllObjects];
    
    eyeButton.selected = !eyeButton.selected;
    
    //对所获取的数据进行便利
    if (YES == eyeButton.selected) {

        for (int i = 0; i < detailArr.count; i ++) {
        
            GoodImageDTO * goodImage = [[GoodImageDTO alloc]init];
            
            [goodImage setDictFrom:detailArr[i]];
            
            if ([goodImage.isDefault isEqualToNumber:[NSNumber numberWithInt:2]]) {
                
                [selectedArr addObject:detailArr[i]];
            }
        }
        
        detailXibView.setOkLabel.text = [NSString stringWithFormat:@"已经设置%ld张",selectedArr.count];
        
        isEye = YES;
        
    }else
    {
      
        isEye = NO;
    }
    
    //进行列表刷新
    [self.DetailTableView reloadData];
     */
    
}


//!创建刷新
-(void)createRefresh{
    //!头部
    SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshViewWithStyle:SDRefreshViewStyleCustom];
    
    [refreshHeader addToScrollView:self.WindowFigureTableView];

    self.refreshHeader = refreshHeader;
    
    __weak DetailReferenceViewController * vc = self;
    
    self.refreshHeader.beginRefreshingOperation = ^{
        
        [vc requestHistoryDownloadImage:self.refreshHeader];
        
    };
    
    //!底部
    SDRefreshFooterView *refreshFooter = [SDRefreshFooterView refreshViewWithStyle:SDRefreshViewStyleClassical];

    [refreshFooter addToScrollView:self.WindowFigureTableView];
        
    self.refreshFooter = refreshFooter;
    
    self.refreshFooter.beginRefreshingOperation = ^{
        
        [vc requestHistoryDownloadImage:self.refreshFooter];
        
    };
}


- (void)requestHistoryDownloadImage:(SDRefreshView *)refresh{
    
    if (refresh == self.refreshHeader) {
    
        pageNO = 1;
        pageSize = 20;
    }else{
        pageNO = pageNO +1;
    }
    
    [self getImageDataListImageType:[NSNumber numberWithInt:1] isDefault:[NSNumber numberWithInt:0] goodsNo:self.goodReference.goodsNo showNum:0 pageNo:pageNO pageSize:20   downloadImage:refresh];

}



//!创建刷新
-(void)createRefreshDetail{
    //!头部
    SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshViewWithStyle:SDRefreshViewStyleCustom];
    
    [refreshHeader addToScrollView:self.DetailTableView];
    
    self.detailRefreshHeader = refreshHeader;
    
    __weak DetailReferenceViewController * vc = self;
    
    self.detailRefreshHeader.beginRefreshingOperation = ^{
        
        [vc requestHistoryDownload:self.detailRefreshHeader];
    };
    
    //!底部
    SDRefreshFooterView *refreshFooter = [SDRefreshFooterView refreshViewWithStyle:SDRefreshViewStyleClassical];
    
    [refreshFooter addToScrollView:self.DetailTableView];
    
    self.detailRrefreshFooter = refreshFooter;
    
    self.detailRrefreshFooter.beginRefreshingOperation = ^{
        
        [vc requestHistoryDownload:self.detailRrefreshFooter];
        
    };
}


- (void)requestHistoryDownload:(SDRefreshView *)refresh{

    if (refresh==self.detailRefreshHeader) {
        
        detailpageNO = 1;
        
    }else{
        
        detailpageNO = detailpageNO +1;
    }
    
    
    [self getImageDataListImageType:[NSNumber numberWithInt:2] isDefault:isDefaultNum goodsNo:self.goodReference.goodsNo showNum:0 pageNo:detailpageNO pageSize:20   downloadImage:refresh];
}


-(void)viewDidAppear:(BOOL)animated
{
    showSelectedLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 100,self.DetailTableView.frame.size.height/2 - 10, 200, 20)];
//    showSelectedLabel.backgroundColor = [UIColor redColor];
    showSelectedLabel.text = @"暂未设置默认详情参考图片";
    showSelectedLabel.hidden = YES;
    showSelectedLabel.textColor = [UIColor colorWithRed:187/255.0 green:187/255.0 blue:187/255.0 alpha:1];
    showSelectedLabel.font = [UIFont systemFontOfSize:15];
    showSelectedLabel.textAlignment = NSTextAlignmentCenter;
    [self.DetailTableView addSubview:showSelectedLabel];
}


//返回按钮执行事件
- (void)backBarButtonClick:(UIBarButtonItem *)sender{
    
    NSNotification *notification = [[NSNotification alloc]initWithName:@"windowPicNumRed" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter]postNotification:notification];
    NSNotification *notification1 = [[NSNotification alloc]initWithName:@"detailPicNumRed" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter]postNotification:notification1];
    [self.navigationController popViewControllerAnimated:YES];
}


@end
