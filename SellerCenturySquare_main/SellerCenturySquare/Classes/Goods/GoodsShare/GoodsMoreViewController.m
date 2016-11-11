//
//  GoodsMoreViewController.m
//  SellerCenturySquare
//
//  Created by caopenpen on 16/7/18.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "GoodsMoreViewController.h"
#import "SlidePageManager.h"
#import "GoodsAuditViewController.h"
#import "GoodsMoreTableViewCell.h"
#import "RefreshTableView.h"
@interface GoodsMoreViewController ()<SlidePageSquareViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *segmentView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic,strong) SlidePageManager *manager ;
@property (nonatomic,assign)GoodsShareStatus shareStatus;
@property (strong, nonatomic) IBOutlet UILabel *shareLabel;
@property (strong, nonatomic) IBOutlet UILabel *goodsNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *goodsWillNoLabel;
@property (strong, nonatomic) IBOutlet UILabel *goodsColorLabel;
@property (strong, nonatomic) IBOutlet UILabel *goodsPriceLabel;
@property (strong, nonatomic) IBOutlet UIImageView *goodsImgView;

@property(nonatomic,strong)RefreshTableView *refreshTableview;

@end

@implementation GoodsMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"商品分享记录";
    [self customBackBarButton];

    _scrollView.tag = 1000;
    
    _shareStatus = AllShareStatus;
    _refreshTableview = [self.view viewWithTag:100000+_shareStatus];
    _refreshTableview.goodsNo = _goodsDTO.goodsNo;
    _refreshTableview.shareStatus = _shareStatus;
    [_refreshTableview.refreshHeader beginRefreshing];
    

    [self createUI];

    [self createHead:nil];
    // Do any additional setup after loading the view from its nib.
}

-(void)createHead:(GoodsShareDTO *)dto{
    _shareLabel.text = [NSString stringWithFormat:@"商品分享了%@次，审核通过%@次",_goodsDTO.shareNum,_goodsDTO.auditPassNum];
    [_goodsImgView sd_setImageWithURL:[NSURL URLWithString:_goodsDTO.imgUrl] placeholderImage:[UIImage imageNamed:@"middle_placeHolder"]];
    _goodsNameLabel.text = _goodsDTO.goodsName;
    _goodsWillNoLabel.text = [NSString stringWithFormat:@"货号：%@",_goodsDTO.goodsWillNo];
    _goodsColorLabel.text = [NSString stringWithFormat:@"颜色：%@",_goodsDTO.color];
    _goodsPriceLabel.text = [NSString stringWithFormat:@"零售价：￥%@",_goodsDTO.retailPrice];
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
        _refreshTableview.goodsNo = _goodsDTO.goodsNo;
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
    GoodsMoreTableViewCell *cell;// = [UITableViewCell alloc];
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

-(GoodsMoreTableViewCell *)createGoodsShareTableViewCell:(NSIndexPath *)index withTable:(UITableView *)tableView{
    GoodsMoreTableViewCell *shareCell = [tableView dequeueReusableCellWithIdentifier:@"GoodsMoreTableViewCell"];
    if (!shareCell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"GoodsMoreTableViewCell" bundle:nil] forCellReuseIdentifier:@"GoodsMoreTableViewCell"];
        shareCell = [tableView dequeueReusableCellWithIdentifier:@"GoodsMoreTableViewCell"];
    }
    if (index.row >=_refreshTableview.arrShareGoods.count) {
        return shareCell;
    }
    GoodsShareDTO *dto = [_refreshTableview.arrShareGoods objectAtIndex:index.row];
    [shareCell configDto:dto];
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
