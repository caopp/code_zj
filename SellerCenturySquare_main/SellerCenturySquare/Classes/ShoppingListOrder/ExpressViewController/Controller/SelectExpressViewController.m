//
//  SelectExpressViewController.m
//  SellerCenturySquare
//
//  Created by 左键视觉 on 16/3/26.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "SelectExpressViewController.h"
#import "ChineseToPinyin.h"
#import "MyUserDefault.h"
#import "ExpressCompanyDefault.h"//!快递公司的单例

@interface SelectExpressViewController ()<UITableViewDataSource,UITableViewDelegate>
{

    UITableView * _tableView;
    
    NSMutableArray * dataArray;
    
    NSMutableArray * sectionTitleArray;

}
@end

@implementation SelectExpressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    
    [self customBackBarButton];
    
    self.title = @"选择快递公司";
    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    
    //!创建tableView
    [self createTableView];
    
    //!判断是否请求新的快递公司
    [self JudewhetherGetNewExpressInfo];
    
    
}
#pragma mark 创建tableView
-(void)createTableView{

    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height - 20) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return dataArray.count;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    NSDictionary * dic = dataArray[section];
    
    NSMutableArray * infoArray = dic[@"expressInfoArray"];
    
    return infoArray.count;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 37;
    
}
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{

    return sectionTitleArray;

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
    }
    
    if (dataArray.count) {
        
        NSDictionary * dic = dataArray[indexPath.section];
        
        NSMutableArray * infoArray = dic[@"expressInfoArray"];
        
        if (infoArray.count) {
            
            NSDictionary * componyDic = infoArray[indexPath.row];
            cell.textLabel.text = componyDic[@"companyName"];
            
        }
    }

    
    return cell;

}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    [headerView setBackgroundColor:[UIColor colorWithHex:0xf7f7f7 alpha:1]];
    UILabel * headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(13, 0, 50, headerView.frame.size.height)];
    [headerLabel setTextColor:[UIColor blackColor]];
    
    [headerView addSubview:headerLabel];
    
    NSDictionary * dic = dataArray[section];
    headerLabel.text = dic[@"firstLetter"];
    

    return headerView;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 20;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (self.selectBlock) {
        
        NSDictionary * dic = dataArray[indexPath.section];
        
        NSMutableArray * infoArray = dic[@"expressInfoArray"];
        
        self.selectBlock(infoArray[indexPath.row]);
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
    


}
#pragma mark 判断是否需要请求新的快递数据
-(void)JudewhetherGetNewExpressInfo{
    
    
    NSString * name = @"logistics.data.version";
    
    [HttpManager sendHttpRequestForJudgeWheterGetNewExpressListSuccesPropName:name Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([dic[@"code"] isEqualToString:@"000"]) {
            
            NSString * propValue = dic[@"data"][0][@"propValue"];
         
            NSString * savedPropValue =[MyUserDefault getPropValue];
            
            //!本地存储的版本信息 和 请求的相同：读取本地的快递信息
            if ([savedPropValue isEqualToString:propValue]) {
                
                ExpressCompanyDefault * companydefault = [ExpressCompanyDefault shareManager];

                if ([companydefault.firstTitleDataArray count]) {//!本地有数据
                    
                    dataArray = companydefault.compayDataArray;
                    sectionTitleArray = companydefault.firstTitleDataArray;
                    
                    [_tableView reloadData];

                }else{
                    
                    //!请求新快递公司数据
                    [self requestExpressData:propValue];

                }
                
                
            }else{//!没有存储过快递信息，存储，并请求快递公司数据
            
               
                //!请求新快递公司数据
                [self requestExpressData:propValue];
                
            }
            
            
        }else{
        
            [self.view makeMessage:[NSString stringWithFormat:@"%@",dic[@"errorMessage"]] duration:2.0 position:@"center"];
        
            //!请求新快递公司数据
            [self requestExpressData:@""];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       
        
        [self.view makeMessage:@"加载失败，目前的网络不顺畅!请检查手机是否联网。" duration:2.0f position:@"center"];

        
    }];
    
    
    
    
}
#pragma mark 请求快递公司数据
-(void)requestExpressData:(NSString *)propValue{

    dataArray = [NSMutableArray arrayWithCapacity:0];
    sectionTitleArray = [NSMutableArray arrayWithCapacity:0];
    
    [HttpManager sendHttpRequestForExpressListSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([dic[@"code"] isEqualToString:@"000"]) {
            
            for (NSDictionary * infoDic in dic[@"data"]) {
                //!取出公司名称
                NSString * companyName = infoDic[@"companyName"];
                //!取出公司名称 的首字母
                NSString * firstLetter  = [NSString stringWithFormat:@"%c",[ChineseToPinyin sortSectionTitle:companyName]];
                
                [self putAllData:firstLetter withExpressDic:infoDic];
                
                
            }
            
            //!对数组进行排序
            NSSortDescriptor * sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"firstLetter" ascending:YES];
            
            [dataArray sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
            
            //!sectionTitle

            for (NSDictionary * allDic in dataArray) {
                
                NSString * firstLetterStr = allDic[@"firstLetter"];
                [sectionTitleArray addObject:firstLetterStr];
                
               
            }
            
            [_tableView reloadData];
            
            //!存储当前的版本信息
            [MyUserDefault savePropValue:propValue];
            
            //!数据保存到本地
            ExpressCompanyDefault * companyDefalut = [ExpressCompanyDefault shareManager];
            companyDefalut.compayDataArray = dataArray;
            companyDefalut.firstTitleDataArray = sectionTitleArray;
            [companyDefalut Data_Save];
            
            
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       
        
    }];



}

-(void)putAllData:(NSString *)firstLetter withExpressDic:(NSDictionary *)expressDic{

    //!数组中数据 个数为0，说明此key的字典还未放入数组
    if (!dataArray.count) {
        
        [self putExpressInfoInDataArray:firstLetter withExpressDic:expressDic];
        
        
    }else{
        //!遍历数组，查看数组中是否已经有首字母 为 firstLetter 的字典
    
        BOOL isIn = NO;//!标记是否把快递公司保存进去了
        
        for (NSMutableDictionary  * dic in dataArray) {
            
            NSString * getFirstLetter = dic[@"firstLetter"];
            
            if ([getFirstLetter isEqualToString:firstLetter]) {//!如果有
                
                //!去除存放公司内容的数组
                NSMutableArray * expressArray = dic[@"expressInfoArray"];
                if (!expressArray) {//!如果数组还没有 创建，就先创建数组
                    
                    expressArray = [NSMutableArray arrayWithCapacity:0];
                    
                }
                
                [expressArray addObject:expressDic];//!把快递公司数据存放到字典
                
                [dic setObject:expressArray forKey:@"expressInfoArray"];

                isIn = YES;//!标记保存了
                
            }
            
            
        }
        //!数据数组变量完后，仍旧没有把快递公司内容 放到数组中，就放
        if (!isIn) {
            
            [self putExpressInfoInDataArray:firstLetter withExpressDic:expressDic];

            
        }
    
    
    
    }
    

}

- (void) putExpressInfoInDataArray:(NSString *)firstLetter withExpressDic:(NSDictionary *)expressDic{

    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:0];
    
    [dic setObject:firstLetter forKey:@"firstLetter"];
    
    //!把首字母相同的 公司内容放到一个数组里面
    NSMutableArray * expressArray = [NSMutableArray arrayWithCapacity:0];
    
    [expressArray addObject:expressDic];
    
    [dic setObject:expressArray forKey:@"expressInfoArray"];
    
    [dataArray addObject:dic];



}
#pragma mark 存储快递公司信息到本地

#pragma mark 读取快递公司信息


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
