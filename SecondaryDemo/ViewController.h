//
//  ViewController.h
//  SecondaryDemo
//
//  Created by SIMPLE PLAN on 16/3/18.
//  Copyright © 2016年 SIMPLE PLAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking.h>
@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
   
    UITableView *_collectionView;
    
   
    UITableView *_tableView;
    
    
    
    AFHTTPSessionManager *_manager;
    
}
//用来存放每一组的状态
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UITableView *collectionView;
@property(nonatomic,strong)AFHTTPSessionManager *manager;


@end

