//
//  CSPMoreShopViewController.m
//  CustomerCenturySquare
//
//  Created by caopenpen on 16/6/20.
//  Copyright © 2016年 zuojian. All rights reserved.
//

#import "CSPMoreShopViewController.h"
#import "RefreshControl.h"
#import "CSPScrollTableViewCell.h"
#import "CSPInfoTableViewCell.h"
#import "CSPColorTableViewCell.h"
#import "CSPContentTableViewCell.h"
#import "CSPGoodsInfoSubPicsTableViewCell.h"
#import "ArrartTableViewCell.h"
#import "NoContentTableViewCell.h"
#import "AppDelegate.h"
#import "ImgDTO.h"
#import "PhotoBrowserVM.h"
#import "CSPMerchantClosedView.h"
#import "ManageGoodsViewController.h"
@interface CSPMoreShopViewController ()<UITableViewDataSource,UITableViewDelegate,RefreshControlDelegate,MJPhotoBrowserDelegate,CSPMerchantClosedViewDelegate>{
    UISegmentedControl *_imgSelectView;
    float textH;
}
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property(nonatomic,strong)UITableView *goodsInfoTableView;
//@property(nonatomic,strong)UITableView *imageTableView;
@property(nonatomic,strong)RefreshControl *bottomRefreshControl;
@property(nonatomic,strong)RefreshControl *topRefreshControl;
@property(nonatomic,assign)ObjectStyle objectattStyle;//按钮选择
@property (nonatomic,strong)NSMutableArray *goodsMoreArray;
@property (nonatomic,strong)GoodsMoreDTO *goodsMoreDTO;
@end

@implementation CSPMoreShopViewController

-(void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updataImageTable) name:@"ReloadPhoto" object:nil];

}
-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"ReloadPhoto" object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = NSLocalizedString(@"预览", @"预览");
 
    [self customBackBarButton];

    [self initTableView];
    

    [self getData];
   
}



- (void)initTableView{
    self.scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HIGHT-65);
    self.goodsInfoTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HIGHT-65)];
    //self.goodsInfoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.goodsInfoTableView.delegate = self;
    
    self.goodsInfoTableView.showsVerticalScrollIndicator = NO;
    self.goodsInfoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.goodsInfoTableView.tag = 99;
    self.goodsInfoTableView.dataSource = self;
    self.goodsInfoTableView.contentSize = CGSizeMake(0, self.view.frame.size.height+self.view.frame.size.width);
    [self.scrollView addSubview:self.goodsInfoTableView];
    

    
   // scroolH = self.goodsInfoTableView.frame.size.height;
    //添加上拉
    self.bottomRefreshControl = [[RefreshControl alloc] initWithScrollView:self.goodsInfoTableView delegate:self];
    [self.bottomRefreshControl setBottomEnabled:YES];
    
    [self.bottomRefreshControl setTopEnabled:NO];


}
-(void)createImgTableWithHasReference:(BOOL)bo{
    for (UIView *view  in [_scrollView subviews]) {
        if (view.tag != 99) {
            [view removeFromSuperview];

        }
    }
    NSArray *arrayItems;
    if (bo) {
        arrayItems= [[NSArray alloc] initWithObjects:NSLocalizedString(@"参考图", @"参考图"),NSLocalizedString(@"客观图", @"客观图"),NSLocalizedString(@"规格参数", @"规格参数"), nil];
    }else{
        arrayItems= [[NSArray alloc] initWithObjects:NSLocalizedString(@"客观图", @"客观图"),NSLocalizedString(@"规格参数", @"规格参数"), nil];
    }
    
    _imgSelectView= [[UISegmentedControl alloc] initWithItems:arrayItems ];
    _imgSelectView.frame = CGRectMake(15, SCREEN_HIGHT-65+5, SCREEN_WIDTH-30, 30);
    [_imgSelectView addTarget:self action:@selector(changeObjectStyle:) forControlEvents:UIControlEventValueChanged];
    _imgSelectView.tintColor = [UIColor blackColor];
    _imgSelectView.backgroundColor = [UIColor whiteColor];
    //_imgSelectView.delegate = self;
    _imgSelectView.selectedSegmentIndex = 0;
    [self.scrollView addSubview:_imgSelectView];
    
    UIScrollView *scrollTap = [[UIScrollView alloc] initWithFrame:CGRectMake(0, SCREEN_HIGHT-65 +40, SCREEN_WIDTH, SCREEN_HIGHT-65-40)];
    scrollTap.contentSize = CGSizeMake(SCREEN_WIDTH *(bo?3:2), 0);
    scrollTap.tag = 98;
    scrollTap.delegate = self;
    scrollTap.pagingEnabled = YES;
    [self.scrollView addSubview:scrollTap];
    
    for (int i = bo?0:1; i<3; i++) {
        UITableView *imageTableViewMsat = [[UITableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*(i-(bo?0:1)), 0, SCREEN_WIDTH, SCREEN_HIGHT-65-40) style:UITableViewStylePlain];
        imageTableViewMsat.tag = 100000+i;
        imageTableViewMsat.delegate = self;
        imageTableViewMsat.dataSource = self;
        
        imageTableViewMsat.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [scrollTap addSubview:imageTableViewMsat];
    }
    
    UITableView *tapTable =[self.scrollView viewWithTag:100000+(bo?0:1)];
    self.topRefreshControl = [[RefreshControl alloc] initWithScrollView:tapTable delegate:self];
    
    [self.topRefreshControl setTopEnabled:YES];
    [tapTable reloadData];
}


#pragma mark - getData
-(void)getData{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
   


    [HttpManager sendHttpRequestForGetCDetailsByGoodsNo:self.goodsNo  success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSDictionary *responseDic = [self conversionWithData:responseObject];
        
        
        
        if ([self isRequestSuccessWithCode:[responseDic objectForKey:CODE]]) {
            
            id data = [responseDic objectForKey:@"data"];
            
            //判断数据的合法
            if ([self checkData:data class:[NSArray class]]) {
                _goodsMoreArray = [[NSMutableArray alloc] initWithCapacity:0];
                for (NSDictionary *dic in data) {
                    GoodsMoreDTO *goodsDto = [[GoodsMoreDTO alloc]init];
                    [goodsDto  setDictFrom:dic];
                    if(goodsDto.goodsStatus.intValue !=3){
                        [_goodsMoreArray addObject:goodsDto];
                    }
                }
                if (_goodsMoreArray.count == 0) {
                    self.scrollView.hidden = YES;
                    self.title = @"提示";
                    
                    CSPMerchantClosedView *merchantCloseView = [self instanceMerchantClosedView];
                    //        merchantCloseView.type = MerchantClosedViewTypeGoodsInvalid;
                    CGRect rect = self.view.frame;
                    rect.origin.y -= 60;
                    merchantCloseView.frame = self.view.frame;
                    
                    [merchantCloseView setType:MerchantClosedViewTypeGoodsInvalid];
                    
                    merchantCloseView.delegate = self;
                    
                    [self.view addSubview:merchantCloseView];
                    //                    UIAlertView *alertViewlog = [[UIAlertView alloc] initWithTitle:@"商品已下架" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                    //                    alertViewlog.tag = 101;
                    //                    [alertViewlog show];
                    return ;
                }
                self.goodsMoreDTO = nil;
                
                self.goodsMoreDTO = [[GoodsMoreDTO alloc]init];
                self.goodsMoreDTO = [_goodsMoreArray objectAtIndex:0];
                
            }else if([self checkData:data class:[NSDictionary class]]){
                _goodsMoreArray = [[NSMutableArray alloc] initWithCapacity:0];
                GoodsMoreDTO *goodsDto = [[GoodsMoreDTO alloc]init];
                [goodsDto  setDictFrom:data];
                if(goodsDto.goodsStatus.intValue !=3){
                    [_goodsMoreArray addObject:goodsDto];
                }
                if (_goodsMoreArray.count == 0) {
                    self.scrollView.hidden = YES;
                    self.title = @"提示";
                    
                    CSPMerchantClosedView *merchantCloseView = [self instanceMerchantClosedView];
                    //        merchantCloseView.type = MerchantClosedViewTypeGoodsInvalid;
                    CGRect rect = self.view.frame;
                    rect.origin.y -= 60;
                    merchantCloseView.frame = self.view.frame;
                    
                    [merchantCloseView setType:MerchantClosedViewTypeGoodsInvalid];
                    
                    merchantCloseView.delegate = self;
                    
                    [self.view addSubview:merchantCloseView];
                    return ;
                }
                self.goodsMoreDTO = nil;
                
                self.goodsMoreDTO = [[GoodsMoreDTO alloc]init];
                self.goodsMoreDTO = [_goodsMoreArray objectAtIndex:0];
            }
            
            
        }else{
            
            [self alertViewWithTitle:@"商品详情加载失败" message:[responseDic objectForKey:ERRORMESSAGE]];
            
        }
        
        if ([_goodsMoreArray count]) {
            _goodsMoreDTO = [_goodsMoreArray objectAtIndex:0];
            [self createImgTableWithHasReference:_goodsMoreDTO.referImageList.count?YES:NO];
            [self changeTextChangeHasText:[_goodsMoreDTO.details length]];

            [_goodsInfoTableView reloadData];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self tipRequestFailureWithErrorCode:error.code];

    }];
   
}


-(void)changeTextChangeHasText:(BOOL)hasText{
    if (hasText) {
        textH = 0;
    }else{
        textH= SCREEN_HIGHT - 65 - SCREEN_WIDTH -80;
    }
    self.goodsInfoTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HIGHT-65 - textH);
    _imgSelectView.frame = CGRectMake(15, SCREEN_HIGHT-65+5-textH, SCREEN_WIDTH-30, 30);
    UIScrollView *scrollTap = [self.view viewWithTag:98];
    scrollTap.frame = CGRectMake(0, SCREEN_HIGHT-65 +40-textH, SCREEN_WIDTH, SCREEN_HIGHT-65-40+textH);
    for (int i =_goodsMoreDTO.referImageList.count?0:1; i<3; i++) {
        UITableView *imageTableViewMsat = [self.scrollView viewWithTag:100000+i];
        imageTableViewMsat.frame = CGRectMake(SCREEN_WIDTH*(i-(_goodsMoreDTO.referImageList.count?0:1)),textH==0?0: -65, SCREEN_WIDTH, SCREEN_HIGHT-65-40+textH);
     
    }

}





-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _goodsInfoTableView) {
        return 3;
    }else if(tableView.tag == 100000){//参考图
        return _goodsMoreDTO.referImageList.count?_goodsMoreDTO.referImageList.count:1;
    }else if(tableView.tag == 100001){//客观图
        return _goodsMoreDTO.objectiveImageList.count?_goodsMoreDTO.objectiveImageList.count:1;
    }else if(tableView.tag == 100002){//规格参数
        return _goodsMoreDTO.attrList.count?_goodsMoreDTO.attrList.count:1;
    }
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0&&tableView == _goodsInfoTableView) {
        return SCREEN_WIDTH;
    }
    
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    return cell.frame.size.height;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CSPBaseTableViewCell *cell;// = [UITableViewCell alloc];
    if (tableView == _goodsInfoTableView) {
        switch (indexPath.row) {
            case 0:
                cell = [self createCSPScrollTableViewCell:indexPath withTable:tableView];

                break;
            case 1:
                 cell = [self createCSPInfoTableViewCell:indexPath withTable:tableView];
                break;
            case 2:
                cell = [self createCSPContentTableViewCell:indexPath withTable:tableView];
                break;
//            case 3:
//                 cell = [self createCSPColorTableViewCell:indexPath withTable:tableView];
//                break;
            default:
                break;
        }
    }else{
        NSArray *arrData;
        switch (tableView.tag) {
            case 100000:
                arrData = _goodsMoreDTO.referImageList;
                break;
            case 100001:
                arrData = _goodsMoreDTO.objectiveImageList;
                break;
            case 100002:
                arrData = _goodsMoreDTO.attrList;
                break;
            default:
                break;
        }
        if (!arrData.count||!arrData) {
            cell = [self createNoContentTableViewCell:indexPath withTable:tableView];
        }else if(tableView.tag ==100002){
            cell = [self createArrartTableViewCell:indexPath withTable:tableView];
        }else{
            cell = [self createCSPGoodsInfoSubPicsTableViewCell:indexPath withTable:tableView];

        }
        
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _goodsInfoTableView&&indexPath.row == 3) {

    }else{
        if (tableView.tag !=100003&&tableView != _goodsInfoTableView) {
            if (_objectattStyle == ObjectStyleAttr) {
                return;
            }
           
            CSPGoodsInfoSubPicsTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            
            PhotoBrowserVM *browserVM = [[PhotoBrowserVM alloc] init];
            [browserVM tapImage:cell.imgView withTag:indexPath.row withArrayImg:(tableView.tag==100000)?_goodsMoreDTO.referImageList:_goodsMoreDTO.objectiveImageList withMJPhotoBrowserDelegate:nil];
        }
    }
}


#pragma mark - button click



-(void)updataImageTable{
     UITableView *tableObject= [self.view viewWithTag:100000+_objectattStyle];
    [tableObject reloadData];
}


-(void)changeObjectStyle:(UISegmentedControl *)segment{
    _objectattStyle = (ObjectStyle)(segment.selectedSegmentIndex+(_goodsMoreDTO.referImageList.count?0:1));
    UITableView *tableObject= [self.view viewWithTag:100000+_objectattStyle];
    UIScrollView *scrollTap = [self.view viewWithTag:98];
    scrollTap.contentOffset = CGPointMake(SCREEN_WIDTH *segment.selectedSegmentIndex, 0);
    
    if (self.topRefreshControl) {
        self.topRefreshControl = nil;
    }
    self.topRefreshControl = [[RefreshControl alloc] initWithScrollView:tableObject delegate:self];
    [self.topRefreshControl setTopEnabled:YES];
    [tableObject reloadData];
    
}




#pragma  mark create TableViewCell

-(CSPScrollTableViewCell *)createCSPScrollTableViewCell:(NSIndexPath *)index withTable:(UITableView *)tableView{
    CSPScrollTableViewCell *toolCell = [tableView dequeueReusableCellWithIdentifier:@"CSPScrollTableViewCell"];
    if (!toolCell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"CSPScrollTableViewCell" bundle:nil] forCellReuseIdentifier:@"CSPScrollTableViewCell"];
        toolCell = [tableView dequeueReusableCellWithIdentifier:@"CSPScrollTableViewCell"];
    }
    [toolCell loadMode:_goodsMoreDTO];
    toolCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return toolCell;
}
-(CSPInfoTableViewCell *)createCSPInfoTableViewCell:(NSIndexPath *)index withTable:(UITableView *)tableView{
    CSPInfoTableViewCell *infoCell = [tableView dequeueReusableCellWithIdentifier:@"CSPInfoTableViewCell"];
    if (!infoCell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"CSPInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"CSPInfoTableViewCell"];
        infoCell = [tableView dequeueReusableCellWithIdentifier:@"CSPInfoTableViewCell"];
    }
    infoCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [infoCell loadDTO:_goodsMoreDTO];
    return infoCell;
}
-(CSPContentTableViewCell *)createCSPContentTableViewCell:(NSIndexPath *)index withTable:(UITableView *)tableView{
    CSPContentTableViewCell *contentCell = [tableView dequeueReusableCellWithIdentifier:@"CSPContentTableViewCell"];
    if (!contentCell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"CSPContentTableViewCell" bundle:nil] forCellReuseIdentifier:@"CSPContentTableViewCell"];
        contentCell = [tableView dequeueReusableCellWithIdentifier:@"CSPContentTableViewCell"];
    }
    contentCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [contentCell loadDTO:_goodsMoreDTO];
    return contentCell;
}
-(CSPColorTableViewCell *)createCSPColorTableViewCell:(NSIndexPath *)index withTable:(UITableView *)tableView{
    CSPColorTableViewCell *colorCell = [tableView dequeueReusableCellWithIdentifier:@"CSPColorTableViewCell"];
    if (!colorCell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"CSPColorTableViewCell" bundle:nil] forCellReuseIdentifier:@"CSPColorTableViewCell"];
        colorCell = [tableView dequeueReusableCellWithIdentifier:@"CSPColorTableViewCell"];
    }
    
    colorCell.selectionStyle = UITableViewCellSelectionStyleNone;
    colorCell.colorSizeLabel.text = @"选择 颜色 数量";
    return colorCell;
}

-(CSPGoodsInfoSubPicsTableViewCell *)createCSPGoodsInfoSubPicsTableViewCell:(NSIndexPath *)index withTable:(UITableView *)tableView{
    
    CSPGoodsInfoSubPicsTableViewCell *picsCell = [tableView dequeueReusableCellWithIdentifier:@"CSPGoodsInfoSubPicsTableViewCell"];
    if (!picsCell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"CSPGoodsInfoSubPicsTableViewCell" bundle:nil] forCellReuseIdentifier:@"CSPGoodsInfoSubPicsTableViewCell"];
        picsCell = [tableView dequeueReusableCellWithIdentifier:@"CSPGoodsInfoSubPicsTableViewCell"];
    }
    NSString *strUrl;
    
    if (tableView.tag == 100000) {
        
        ImgDTO *imgDTO = [_goodsMoreDTO.referImageList objectAtIndex:index.row];
        
        strUrl = imgDTO.picUrl;
        
    }else if(tableView.tag == 100001){
        
        ImgDTO *imgDTO = [_goodsMoreDTO.objectiveImageList objectAtIndex:index.row];
        
        strUrl = imgDTO.picUrl;
        
    }
    [picsCell setUrl:strUrl];
    
    return picsCell;
}
-(ArrartTableViewCell *)createArrartTableViewCell:(NSIndexPath *)index withTable:(UITableView *)tableView{
    ArrartTableViewCell *arrartCell = [tableView dequeueReusableCellWithIdentifier:@"ArrartTableViewCell"];
    if (!arrartCell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"ArrartTableViewCell" bundle:nil] forCellReuseIdentifier:@"ArrartTableViewCell"];
        arrartCell = [tableView dequeueReusableCellWithIdentifier:@"ArrartTableViewCell"];
    }
    AttrDTO *attrDTO = [_goodsMoreDTO.attrList objectAtIndex:index.row];
    arrartCell.arrartTitle.text =  attrDTO.attrName;
    arrartCell.arrartValue.text = attrDTO.attrValText;
    return arrartCell;
}
-(NoContentTableViewCell *)createNoContentTableViewCell:(NSIndexPath *)index withTable:(UITableView *)tableView{
    NoContentTableViewCell *noCell = [tableView dequeueReusableCellWithIdentifier:@"NoContentTableViewCell"];
    if (!noCell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"NoContentTableViewCell" bundle:nil] forCellReuseIdentifier:@"NoContentTableViewCell"];
        noCell = [tableView dequeueReusableCellWithIdentifier:@"NoContentTableViewCell"];
    }
    NSString *msg;
    switch (tableView.tag) {
        case 100000:
            msg = @"暂无参考图";
            break;
        case 100001:
            msg = @"暂无客观图";
            break;
        case 100002:
            msg = @"暂无规格参数";
            break;
        default:
            break;
    }

    noCell.notLabel.text = msg;
    return noCell;
}
#pragma mark - CSPMerchantClosedViewDelegate
-(void)backSubViewController{
    [self.navigationController popViewControllerAnimated:YES];
}
//!批发_在售:1； 零售_在售：2； 新发布:3； 全部_在售：4；
-(void)reviewGoodsList{
    
    ManageGoodsViewController * managerGoodsVC = [[ManageGoodsViewController alloc]init];
    
    //!ManageGoodsViewController:销售渠道 -1 全部； 0 批发； 1 零售 ；2批发和零售
    
    //!全部_在售、新发布 的时候， 看 全部_在售
    
    managerGoodsVC.type = @"-1";
    
    managerGoodsVC.isIntoUndercarriage = YES;
    
    [self.navigationController pushViewController:managerGoodsVC animated:YES];
}
-(void)reviewOtherList{
    
    ManageGoodsViewController * managerGoodsVC = [[ManageGoodsViewController alloc]init];
    
    //!ManageGoodsViewController:销售渠道 -1 全部； 0 批发； 1 零售 ；2批发和零售
    
    //!全部_在售、新发布 的时候， 看 全部_在售
    
    managerGoodsVC.type = @"-1";
    

    [self.navigationController pushViewController:managerGoodsVC animated:YES];
    
}

#pragma mark - UIScrollView delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.tag == 98) {
        NSInteger index = scrollView.contentOffset.x/self.view.frame.size.width;
        NSLog(@"index = %lu",(long)index);
       _imgSelectView .selectedSegmentIndex  = index;
        [self changeObjectStyle:_imgSelectView];
    }
}
#pragma mark-RefreshControlDelegate
- (void)refreshControl:(RefreshControl *)refreshControl didEngageRefreshDirection:(RefreshDirection) direction{
    
    if (direction==RefreshDirectionTop){
        
        
        //结束加载
        [self.bottomRefreshControl finishRefreshingDirection:RefreshDirectionBottom];
        
        
        //上拉
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
            
            self.scrollView.contentOffset = CGPointMake(0, 0);
            [self changeTextChangeHasText:[_goodsMoreDTO.details length]];

        } completion:^(BOOL finished) {
            
        }];
        
    }else if (direction == RefreshDirectionBottom){
        
        
        //结束加载
        [self.topRefreshControl finishRefreshingDirection:RefreshDirectionTop];
        UITableView *tableMast = [self.scrollView viewWithTag:10000];
        [tableMast reloadData];
        //下拉
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
            
            self.scrollView.contentOffset = CGPointMake(0, self.view.frame.size.height);
            [self changeTextChangeHasText:YES];


            
        } completion:^(BOOL finished) {
            
        }];
    }
    
}
- (CSPMerchantClosedView *)instanceMerchantClosedView {
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"CSPMerchantClosedView" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
