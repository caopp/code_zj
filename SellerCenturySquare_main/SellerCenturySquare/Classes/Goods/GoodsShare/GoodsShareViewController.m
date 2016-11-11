//
//  GoodsShareViewController.m
//  SellerCenturySquare
//
//  Created by caopenpen on 16/7/7.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "GoodsShareViewController.h"
#import "SlidePageManager.h"
#import "GoodsShareTableViewCell.h"
#import "GoodsAuditViewController.h"
#import "AuditSearchViewController.h"
#import "GoodsShareDTO.h"
#import "RefreshTableView.h"
@interface GoodsShareViewController ()<SlidePageSquareViewDelegate>
{
    NSArray *arrStatus;
}
@property (strong, nonatomic) IBOutlet UIScrollView *segmentScroll;
@property (strong, nonatomic) IBOutlet UIView *headView;

@property (nonatomic,strong) SlidePageManager *manager ;
@property (nonatomic,assign)GoodsShareStatus shareStatus;
@property (strong, nonatomic) IBOutlet UILabel *countLabel;
@property (nonatomic,strong)RefreshTableView *refreshTableview;
@end

@implementation GoodsShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self customBackBarButton];
    self.title = @"零售_商品分享及提成审核";
    [[self rdv_tabBarController] setTabBarHidden:YES];
    UIBarButtonItem *rightButtonItem = [self barButtonWithtTitle:@"搜索" font:[UIFont systemFontOfSize:13]];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    _shareStatus =  UnShareStatus;

    [self createUI];
}

-(void)viewDidAppear:(BOOL)animated{
    _segmentScroll.tag = 1000;
    _segmentScroll.contentSize = CGSizeMake(3*SCREEN_WIDTH, 0);

}

-(void)viewWillAppear:(BOOL)animated{
    _refreshTableview = [self.view viewWithTag:1000+_shareStatus];
    _refreshTableview.shareStatus = _shareStatus;
    [_refreshTableview.refreshHeader beginRefreshing];
}

#pragma mark 创建界面
-(void)refreshLabel{
    _countLabel.text  =[NSString stringWithFormat:@"   %@ %ld",[arrStatus objectAtIndex:_shareStatus-1],_refreshTableview.totalCount];
}

-(void)createUI{
    arrStatus = @[@"待审核",@"审核通过",@"审核未通过"];
    
    //!顶部的滑动
    self.manager = [[SlidePageManager alloc]init];
    SlidePageSquareView * scView1 = (SlidePageSquareView*)[self.manager createBydataArr:arrStatus slidePageType:SlidePageTypeSquare  bgColor:[UIColor colorWithHex:0x333333] squareViewColor:[UIColor colorWithHex:0xffffff] unSelectTitleColor:[UIColor colorWithHex:0x999999] selectTitleColor:[UIColor blackColor] witTitleFont:[UIFont systemFontOfSize:14]];
    
    
    
    scView1.frame = CGRectMake(0, 0,SCREEN_WIDTH, 32);
    scView1.contentSize = CGSizeMake(SCREEN_WIDTH, 0);
    scView1.delegateForSlidePage = self;
    [self.view addSubview:scView1];
}
#pragma mark - event touch
- (void)slidePageSquareView:(SlidePageSquareView*)view andBtnClickIndex:(NSInteger)index{
       [_segmentScroll  setContentOffset:CGPointMake(SCREEN_WIDTH*index,0 ) animated:YES];
    [self refrehTableviewWithPage:index+1];
}

- (void)rightButtonClick:(UIButton *)sender{
    AuditSearchViewController *auditSearchVC = [[AuditSearchViewController alloc] initWithNibName:@"AuditSearchViewController" bundle:nil];
    [self.navigationController pushViewController:auditSearchVC animated:YES];
}


#pragma mark scrollerViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.tag == 1000) {
        //!改变顶部的偏移
        self.manager.contentOffsetX = scrollView.contentOffset.x;
        
        //!根据页码选择哪个tableView可以滑动至顶部
        int page = scrollView.contentOffset.x/_segmentScroll.frame.size.width;
        

        
        if (page == 0) {
            
            // [self setScrollerToTopWithOnSale:YES withNewSale:NO withNotSale:NO];
           
            
        }else if(page == 1){
            
            //[self setScrollerToTopWithOnSale:NO withNewSale:YES withNotSale:YES];
            
        }else{
            
            // [self setScrollerToTopWithOnSale:NO withNewSale:NO withNotSale:YES];
            
        }

    }
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView.tag == 1000) {
        int page = scrollView.contentOffset.x/_segmentScroll.frame.size.width;
      
        [self refrehTableviewWithPage:page+1];
    }
}
-(void)refrehTableviewWithPage:(GoodsShareStatus)status{
    if (_shareStatus != status) {
        _shareStatus = status;
        _refreshTableview = [self.view viewWithTag:1000+_shareStatus];
        _refreshTableview.shareStatus = _shareStatus;
        [self refreshLabel];
        [_refreshTableview.refreshHeader beginRefreshing];
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    [self refreshLabel];
    return _refreshTableview.arrShareGoods.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    return cell.frame.size.height;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GoodsShareTableViewCell *cell;// = [UITableViewCell alloc];
                    cell = [self createGoodsShareTableViewCell:indexPath withTable:tableView];
                
               return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row >=_refreshTableview.arrShareGoods.count) {
        return;
    }
    GoodsShareDTO *dto = [_refreshTableview.arrShareGoods objectAtIndex:indexPath.row];

    GoodsAuditViewController *auditVC = [[GoodsAuditViewController alloc] initWithNibName:@"GoodsAuditViewController" bundle:nil];
    auditVC.labelId = dto.labelId;
    auditVC.status = dto.status;
    [self.navigationController pushViewController:auditVC animated:YES];
}

#pragma  mark create TableViewCell

-(GoodsShareTableViewCell *)createGoodsShareTableViewCell:(NSIndexPath *)index withTable:(UITableView *)tableView{
    GoodsShareTableViewCell *shareCell = [tableView dequeueReusableCellWithIdentifier:@"GoodsShareTableViewCell"];
    if (!shareCell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"GoodsShareTableViewCell" bundle:nil] forCellReuseIdentifier:@"GoodsShareTableViewCell"];
        shareCell = [tableView dequeueReusableCellWithIdentifier:@"GoodsShareTableViewCell"];
    }
    if (_refreshTableview.arrShareGoods.count>index.row) {
        GoodsShareDTO *dto = [_refreshTableview.arrShareGoods objectAtIndex:index.row];
        [shareCell configDto:dto];
    }
   
    shareCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return shareCell;
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
