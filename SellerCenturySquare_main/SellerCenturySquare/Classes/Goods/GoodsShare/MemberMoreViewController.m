//
//  MemberMoreViewController.m
//  SellerCenturySquare
//
//  Created by caopenpen on 16/7/18.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "MemberMoreViewController.h"
#import "SlidePageManager.h"
#import "SearchGoodsTableViewCell.h"
#import "GoodsAuditViewController.h"
#import "RefreshTableView.h"
@interface MemberMoreViewController ()<SlidePageSquareViewDelegate>
@property (nonatomic,strong) SlidePageManager *manager ;
@property (strong, nonatomic) IBOutlet UIImageView *headImgView;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *shareCountLabel;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *segmentView;


@property (nonatomic,assign)GoodsShareStatus shareStatus;
@property(nonatomic,strong)RefreshTableView *refreshTableview;
@end

@implementation MemberMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"用户分享商品";
    [self customBackBarButton];
    _scrollView.tag = 1000;
    
    _shareStatus = AllShareStatus;
    _refreshTableview = [self.view viewWithTag:100000+_shareStatus];
    _refreshTableview.shareStatus = _shareStatus;
    _refreshTableview.userId = _userDTO.userId;
    [_refreshTableview.refreshHeader beginRefreshing];
    
    _headImgView.layer.masksToBounds = YES;
    _headImgView.layer.cornerRadius =  21.5f;
    
    [self createUI];
  
    [self createHead:_userDTO];

}


-(void)createHead:(GoodsShareDTO *)dto{
    [_headImgView sd_setImageWithURL:[NSURL URLWithString:dto.iconUrl] placeholderImage:[UIImage imageNamed:@"10_商品询单对话_个人"]];
    _userNameLabel.text = dto.userName;
    _shareCountLabel.text = [NSString stringWithFormat:@"分享商品次数%@次",dto.sharedGoodsNum];
}
#pragma mark 创建界面
-(void)createUI{
    //!顶部的滑动
    self.manager = [[SlidePageManager alloc]init];
    SlidePageSquareView * scView1 = (SlidePageSquareView*)[self.manager createBydataArr:@[@"全部",@"待审核",@"审核通过",@"审核未通过"] slidePageType:SlidePageTypeSquare  bgColor:[UIColor colorWithHex:0x333333] squareViewColor:[UIColor colorWithHex:0xffffff] unSelectTitleColor:[UIColor colorWithHex:0x999999] selectTitleColor:[UIColor blackColor] witTitleFont:[UIFont systemFontOfSize:14]];
    
    
    
    scView1.frame = CGRectMake(0, 0,SCREEN_WIDTH, 30);
    scView1.contentSize = CGSizeMake(SCREEN_WIDTH, 0);
    scView1.delegateForSlidePage = self;
    [_segmentView addSubview:scView1];
}
- (void)slidePageSquareView:(SlidePageSquareView*)view andBtnClickIndex:(NSInteger)index{
    [_scrollView  setContentOffset:CGPointMake(SCREEN_WIDTH*index,0 ) animated:YES];
    [self refrehTableviewWithPage:index];
}
#pragma mark scrollerViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.tag == 1000) {
        //!改变顶部的偏移
        self.manager.contentOffsetX = scrollView.contentOffset.x;
        
        //!根据页码选择哪个tableView可以滑动至顶部
        int page = scrollView.contentOffset.x/_segmentView.frame.size.width;
        
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
        int page = scrollView.contentOffset.x/_segmentView.frame.size.width;
        
        [self refrehTableviewWithPage:page];
    }
}
-(void)refrehTableviewWithPage:(GoodsShareStatus)status{
    if (_shareStatus != status) {
        _shareStatus = status;
        _refreshTableview = [self.view viewWithTag:100000+_shareStatus];
        _refreshTableview.shareStatus = _shareStatus;
        _refreshTableview.userId = _userDTO.userId;
        [_refreshTableview.refreshHeader beginRefreshing];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _refreshTableview.arrShareGoods.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    return cell.frame.size.height;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchGoodsTableViewCell *cell;// = [UITableViewCell alloc];
    cell = [self createSearchGoodsTableViewCell:indexPath withTable:tableView];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row >=_refreshTableview.arrShareGoods.count) {
        return ;
    }
    GoodsShareDTO *dto = [_refreshTableview.arrShareGoods objectAtIndex:indexPath.row];
    
    GoodsAuditViewController *auditVC = [[GoodsAuditViewController alloc] initWithNibName:@"GoodsAuditViewController" bundle:nil];
    auditVC.labelId = dto.labelId;
    auditVC.status = dto.status;
    [self.navigationController pushViewController:auditVC animated:YES];
}
#pragma  mark create TableViewCell


-(SearchGoodsTableViewCell *)createSearchGoodsTableViewCell:(NSIndexPath *)index withTable:(UITableView *)tableView{
    SearchGoodsTableViewCell*toolCell = [tableView dequeueReusableCellWithIdentifier:@"SearchGoodsTableViewCell"];
    if (!toolCell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"SearchGoodsTableViewCell" bundle:nil] forCellReuseIdentifier:@"SearchGoodsTableViewCell"];
        toolCell = [tableView dequeueReusableCellWithIdentifier:@"SearchGoodsTableViewCell"];
    }
    if (index.row >=_refreshTableview.arrShareGoods.count) {
        return toolCell;
    }
    GoodsShareDTO *goodsDTO = [_refreshTableview.arrShareGoods objectAtIndex:index.row];
    [toolCell loadMemberDTO:goodsDTO];
    toolCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return toolCell;
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
