//
//  CSPMessageDetailTableViewController.m
//  BuyerCenturySquare
//
//  Created by GuChenlong on 7/16/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPMessageDetailTableViewController.h"
#import "CSPPersonCenterShopTableViewCell.h"


@interface CSPMessageDetailTableViewController ()

@end

@implementation CSPMessageDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    if (section == 0) {
        return 1;
    }else{
        return 3;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    

    CSPPersonCenterShopTableViewCell *shopCell = [tableView dequeueReusableCellWithIdentifier:@"CSPPersonCenterShopTableViewCell"];

    if (!shopCell) {
        
        [tableView registerNib:[UINib nibWithNibName:@"CSPPersonCenterShopTableViewCell" bundle:nil] forCellReuseIdentifier:@"CSPPersonCenterShopTableViewCell"];
        shopCell = [tableView dequeueReusableCellWithIdentifier:@"CSPPersonCenterShopTableViewCell"];
        
    }
  
    return shopCell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}



@end
