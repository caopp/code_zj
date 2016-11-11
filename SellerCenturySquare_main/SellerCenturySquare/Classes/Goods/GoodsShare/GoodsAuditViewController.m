//
//  GoodsAuditViewController.m
//  SellerCenturySquare
//
//  Created by caopenpen on 16/7/8.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "GoodsAuditViewController.h"
#import "GoodsAboutTableViewCell.h"
#import "GoodsImgTableViewCell.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "LoginDTO.h"
@interface GoodsAuditViewController ()
@property (strong, nonatomic) IBOutlet UILabel *auditTimeLabel;
@property (strong, nonatomic) IBOutlet UITableView *auditTableView;
@property (strong, nonatomic) IBOutlet UIImageView *headImgView;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *imgCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *shareStatusLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UIView *auditView;
@property (strong, nonatomic) IBOutlet UILabel *labelComm;
@property (strong, nonatomic) IBOutlet UILabel *labelNoComm;
@property (strong, nonatomic)  GoodsShareDTO *goodsShareDTO;
@property (strong, nonatomic) IBOutlet UIButton *passBtn;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;
@property (strong, nonatomic) IBOutlet UIButton *noPassBtn;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *viewTopConstraint;
@property (assign,nonatomic)AuditType auditType;
@end

@implementation GoodsAuditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"零售_商品分享及提成审核";
    if ([_status intValue] == 1) {
        _heightConstraint.constant = 50;
        _passBtn.hidden = NO;
        _noPassBtn.hidden = NO;
    }else{
        _heightConstraint.constant = 0;
        _passBtn.hidden = YES;
        _noPassBtn.hidden = YES;
    }
    
    _headImgView.layer.masksToBounds = YES;
    _headImgView.layer.cornerRadius = 21.0f;
    [self  customBackBarButton];
    [self requestData];
}
-(void)addData:(GoodsShareDTO *)dto{
    [_headImgView sd_setImageWithURL:[NSURL URLWithString:dto.iconUrl] placeholderImage:[UIImage imageNamed:@"10_商品询单对话_个人"]];
    _userNameLabel.text = dto.userName;
    _imgCountLabel.text = [NSString stringWithFormat:@"分享图片：窗口图%@张 参考图%@张",dto.wPicNum,dto.rPicNum];
    
    NSString *strW = [NSString stringWithFormat:@"分享图片：窗口图%@张",dto.wPicNum];
    NSString *strP = [NSString stringWithFormat:@" 参考图%@张",dto.rPicNum];
    NSMutableAttributedString *attributeW = [self createStringWithString:strW withRange:NSMakeRange(8, [strW length]-9)];
    NSMutableAttributedString *attributeP = [self createStringWithString:strP withRange:NSMakeRange(4, [strP length]-5)];
    [attributeW appendAttributedString:attributeP];
    _imgCountLabel.attributedText = attributeW;
    _shareStatusLabel.text = [self returnStatus:dto.status];
    _timeLabel.text = [NSString stringWithFormat:@"提交时间：%@",dto.createDate];
    if (dto.auditDate&&[dto.auditDate length]) {
        _auditTimeLabel.hidden = NO;
        _auditTimeLabel.text = [NSString stringWithFormat:@"审核时间：%@",dto.auditDate];
        _viewTopConstraint.constant = 100;
    }else{
        _auditTimeLabel.hidden = YES;
        _viewTopConstraint.constant = 80;

    }
}
-(void)showAuditView{
    _labelComm.text = @"不允许显示分享的图片,\n不允许生成用于提成分享的商品页面";
    _labelNoComm.text = @"不允许显示分享的图片,\n可以生成用于提成分享的商品页面";
    _auditView.hidden = NO;
}
-(void)showAlertView:(NSString *)strTitle withContent:(NSString *)strContent{
    UIAlertView *aleverView = [[UIAlertView alloc] initWithTitle:strTitle message:strContent delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [aleverView show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex NS_DEPRECATED_IOS(2_0, 9_0){
    if(buttonIndex){
        
        [self passType:_auditType];
        
    }else{
    }
}
#pragma mark 请求数据
-(void)requestData{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HttpManager sendHttpRequestForAuditDetailWtihLabelId:_labelId success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *responseDic =  [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([responseDic[@"code"] isEqualToString:@"000"]) {
            NSDictionary *dic = responseDic[@"data"];
            
            _goodsShareDTO = [[GoodsShareDTO alloc] init];
            [_goodsShareDTO setDictFrom:dic];
            [self addData:_goodsShareDTO];
            [_auditTableView reloadData];
        }
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];

    }];
    
    
}

-(void)passType:(AuditType )auditType{
    
 //auditType	1审核通过;2审核提成通过,图片审核不通过;3审核不通过	int	必填
    [HttpManager sendHttpRequestForAuditWtihLabelId:_labelId withAuditType:auditType  success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *responseDic =  [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([responseDic[@"code"] isEqualToString:@"000"]) {
            [self.view makeMessage:responseDic[@"errorMessage"] duration:2 position:@"center"];
            [self performSelector:@selector(navBack) withObject:nil afterDelay:2];
        }else{
            [self.view makeMessage:responseDic[@"errorMessage"] duration:2 position:@"center"];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        
    }];
    
    
}
#pragma mark - UIButton Click event 

- (IBAction)auditAction:(UIButton *)sender {
    if (sender.tag == 1) {//审核不通过
       if ([_goodsShareDTO.userType intValue]) {
            [self showAuditView];
        }else{
            _auditType = AuditTypeNoPass;
            [self showAlertView:@"确定审核不通过？" withContent:@"参考图片不显示在用户分享的商品详情页面中"];

        }
    }else{//审核通过
        _auditType = AuditTypePass;

        if ([_goodsShareDTO.userType intValue]) {
            

            [self showAlertView:@"确定通过此商品的图片分享及提成比例？" withContent:@"审核通过后，参考图片可显示在用户分享的商品详情页面中。"];
        }else{
            [self showAlertView:@"确定通过此商品的图片分享？" withContent:@"审核通过后，参考图片可显示在用户分享的商品详情页面中"];
        }
    }
    
}

- (IBAction)auditCommAction:(UIButton *)sender {
    if (sender.tag == 3) {
        _auditType = AuditTypeNoPass;
        [self showAlertView:@"确定审核不通过？" withContent:@"不允许显示分享的图片，不允许生成用于提成分享的商品页面。"];
    }else{
        _auditType = AuditTypeDeductPass;
         [self showAlertView:@"确定审核不通过？" withContent:@"不允许显示分享的图片，可以生成用于提成分享的商品页面。"];
    }
}
-(void)navBack{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark-UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    return cell.frame.size.height;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section) {
        return 30;
    }else{
        return 0;
    }
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *viewHead = [[UIView alloc] init];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH, 30)];
    label.backgroundColor = [UIColor whiteColor];
    label.text = (section ==1)?[NSString stringWithFormat:@"分享窗口图%@张",_goodsShareDTO.wPicNum]:[NSString stringWithFormat:@"分享参考图%@张",_goodsShareDTO.rPicNum];
    label.font = [UIFont systemFontOfSize:14];
    [viewHead addSubview:label];
    return viewHead;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            
            return _goodsShareDTO.windownList.count;
            break;
        case 2:
            return _goodsShareDTO.referenceList.count;
            break;
        default:
            break;
    }
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CSPBaseTableViewCell *cell;
    if (indexPath.section == 0) {
       cell = [self createGoodsAboutTableViewCell:indexPath withTable:tableView];
    }else{
        
        cell = [self createGoodsImageTableViewCell:indexPath withTable:tableView];
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        GoodsImgTableViewCell *cell = [_auditTableView cellForRowAtIndexPath:indexPath];
        [self tapImgBk:cell.goodsImgView withindex:indexPath.row withArray:_goodsShareDTO.windownList];
    }else if (indexPath.section == 2){
        GoodsImgTableViewCell *cell = [_auditTableView cellForRowAtIndexPath:indexPath];
        [self tapImgBk:cell.goodsImgView withindex:indexPath.row withArray:_goodsShareDTO.referenceList];
    }
   
}


-(void)tapImgBk:(UIImageView *)srcview withindex:(NSInteger)index withArray:(NSArray *)objectiveArray{
    
    int count = (int )objectiveArray.count;
    
    
    if (objectiveArray.count==0) {
        return;
    }
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++) {
        // 替换为中等尺寸图片
        GoodsSharePicDTO *dto = [objectiveArray objectAtIndex:i];
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:dto.imageUrl];
        photo.srcImageView = srcview; // 来源于哪个UIImageView
        [photos addObject:photo];
    }
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = index; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];
}
#pragma  mark create TableViewCell

-(CSPBaseTableViewCell *)createGoodsAboutTableViewCell:(NSIndexPath *)index withTable:(UITableView *)tableView{
    GoodsAboutTableViewCell*toolCell = [tableView dequeueReusableCellWithIdentifier:@"GoodsAboutTableViewCell"];
    if (!toolCell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"GoodsAboutTableViewCell" bundle:nil] forCellReuseIdentifier:@"GoodsAboutTableViewCell"];
        toolCell = [tableView dequeueReusableCellWithIdentifier:@"GoodsAboutTableViewCell"];
    }
    toolCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [toolCell refigDTO:_goodsShareDTO];
    return toolCell;
}
-(CSPBaseTableViewCell *)createGoodsImageTableViewCell:(NSIndexPath *)index withTable:(UITableView *)tableView{
    GoodsImgTableViewCell*toolCell = [tableView dequeueReusableCellWithIdentifier:@"GoodsImgTableViewCell"];
    if (!toolCell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"GoodsImgTableViewCell" bundle:nil] forCellReuseIdentifier:@"GoodsImgTableViewCell"];
        toolCell = [tableView dequeueReusableCellWithIdentifier:@"GoodsImgTableViewCell"];
    }
    toolCell.selectionStyle = UITableViewCellSelectionStyleNone;
    GoodsSharePicDTO *dto;
    if (index.section ==1) {
        dto = _goodsShareDTO.windownList[index.row];
    }else if (index.section ==2){
        dto = _goodsShareDTO.referenceList[index.row];
    }
    [toolCell refigDTO:dto];
    return toolCell;
}

-(NSString *)returnStatus:(NSNumber *)status{
    switch ([status intValue]) {
        case 1:
            return @"待审核";
            break;
        case 2:
            return @"审核通过";
            break;
        case 3:
            return @"审核未通过";
            break;
        default:
            break;
    }
    return @"";
}
-(NSMutableAttributedString *)createStringWithString:(NSString *)strMode withRange:(NSRange)range{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:strMode];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0xfd4f57] range:range];
    return str;
    
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
