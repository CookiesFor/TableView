//
//  ViewController.m
//  SecondaryDemo
//
//  Created by SIMPLE PLAN on 16/3/18.
//  Copyright © 2016年 SIMPLE PLAN. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking.h>
#import <Masonry.h>

#define kScreenSize [UIScreen mainScreen].bounds.size

@interface ViewController ()

@property(nonatomic,copy)NSString *sectionStr;
@property(nonatomic,strong)NSMutableArray *cellDataArr;
@property(nonatomic,strong)NSMutableDictionary *mDict;
@property(nonatomic,strong)NSMutableArray *titleArr;
@property(nonatomic,strong)NSMutableArray *valueArr;
@property(nonatomic,strong)NSMutableDictionary *valueDict;
@property(nonatomic,strong)NSMutableArray *IDArr;
@property(nonatomic,strong)NSMutableArray *collectionArr;
@property(nonatomic,copy)NSString *IDStr;
@property(nonatomic)NSInteger count;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _count = 0;
    _IDArr = [[NSMutableArray alloc]init];
    _collectionArr = [[NSMutableArray alloc]init];
    _cellDataArr = [[NSMutableArray alloc]init];
    _valueDict = [[NSMutableDictionary alloc]init];
    _mDict = [[NSMutableDictionary alloc]init];
    _titleArr = [[NSMutableArray alloc]init];
    _valueArr = [[NSMutableArray alloc]init];
    [self createRequest];
    
    [self createTableView];
    [self createCollectionView];
//    [self createView];
    
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
//    [self.view addSubview:btn];
//    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.size.mas_equalTo(CGSizeMake(100, 100));
//        make.top.mas_equalTo(100);
//        make.left.mas_equalTo(100);
//        
//    }];
//    
//    [btn setBackgroundColor:[UIColor redColor]];
//    
//    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
}

-(void)btnClick:(UIButton *)btn
{

}


//下载section的数据
-(void)createRequest
{
    _manager = [AFHTTPSessionManager manager];
    
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [_manager POST:@"http://ceshi.kuaikuaipaobei.com/api/shops.php?action=hangye" parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        
        NSDictionary *data = dict[@"data"];
        
        
        NSEnumerator * enumeratorKey = [data keyEnumerator];
        
        for (NSObject *dataDict in enumeratorKey) {
            
            
            NSObject *object = [data objectForKey:dataDict];
            
            [_IDArr addObject:dataDict];
            
            NSLog(@"object%@",_IDArr);
            
            [_valueDict setObject:object forKey:[data objectForKey:dataDict][@"title"]];
            
//            NSEnumerator * enumeratorKey1 = [[data objectForKey:dataDict] keyEnumerator];
//            NSObject *ob;
//            for (ob in enumeratorKey1) {
            
//                [_valueArr addObject:[[data objectForKey:dataDict] objectForKey:ob]];
//            
//            }
            
            
            [_titleArr addObject:[data objectForKey:dataDict][@"title"]];
            
//            [_valueArr removeObject:[data objectForKey:dataDict][@"title"] ];
//           
//            [_mDict setObject:_valueArr forKey:[data objectForKey:dataDict][@"title"] ];
            
        }
        
        [self.tableView reloadData];
        
        if (_titleArr.count>0)
        {
            NSEnumerator * enumeratorKey1 = [[_valueDict objectForKey:_titleArr[0]] keyEnumerator];
            
            
            NSObject *ob;
            
            for (ob in enumeratorKey1)
            {
                
                [_cellDataArr addObject:[[_valueDict objectForKey:_titleArr[0]] objectForKey:ob]];
  
            }
            
            [_cellDataArr removeObject:_titleArr[0]];
            
            for (NSDictionary *vale in _cellDataArr)
            {
                
                [_collectionArr addObject:vale[@"value"]];
                
            }
            
            [self.collectionView reloadData];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    
}
-(void)createCollectionView
{
    self.collectionView = [[UITableView alloc]init];
    [self.view addSubview:self.collectionView];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor grayColor];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.tableView.mas_right).offset(0);
        make.size.mas_equalTo(CGSizeMake(kScreenSize.width-(kScreenSize.width/2-60), kScreenSize.height));
        make.top.mas_equalTo(0);
        
    }];
    
    
    
    
}

-(void)createView
{
    UIView *lineView = [[UIView alloc]init];
    [self.view addSubview:lineView];
    lineView.backgroundColor = [UIColor redColor];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.tableView.mas_right).offset(0);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.right.equalTo(self.collectionView.mas_left).offset(0);
        
    }];
    
    
}


-(void)createTableView
{
    self.tableView = [[UITableView alloc]init];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.dataSource = self;
    self.tableView.delegate  = self;
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(kScreenSize.width/2-60, kScreenSize.height));
        
        
    }];
    
    
}

/**
 *  两种方式，一种cell，，一种setion，cell
 *
 */

#pragma mark -UITableView协议
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (tableView == _tableView) {
        
        NSArray *arr = [NSArray arrayWithArray:self.titleArr];
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 45)];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = view.bounds;
        [button addTarget:self action:@selector(sectionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
       
        button.tag = section+101;
        [button setTitle:arr[section] forState:UIControlStateNormal];
        [view addSubview:button];
        
        
        
        
        return view;
    }
    return nil;
    
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
//    if (tableView ==_collectionView) {
        return 1;
//    }else
//    
//    
//    return self.titleArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    if (tableView == _collectionView) {
        
        return _collectionArr.count;
        
    }
    
    return _titleArr.count;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
//    if (tableView == _tableView) {
//        return 45;
//    }
    
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *str = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        
    }
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    
    
    
    if (tableView == _tableView) {
        
        
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.text = self.titleArr[indexPath.row];
        
        
        return cell;
        
    }
    
    cell.backgroundColor = [UIColor grayColor];
    cell.textLabel.text = self.collectionArr[indexPath.row];
    
    return cell;
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tableView) {
        
        
        [_cellDataArr removeAllObjects];
        [_collectionArr removeAllObjects];
        
        NSEnumerator * enumeratorKey1 = [[_valueDict objectForKey:_titleArr[indexPath.row]] keyEnumerator];
        
        
        
        for (NSObject *ob in enumeratorKey1) {
            
            [_cellDataArr addObject:[[_valueDict objectForKey:_titleArr[indexPath.row]] objectForKey:ob]];
            
            
        }
        
        [_cellDataArr removeObject:_titleArr[indexPath.row]];
        for (NSDictionary *vale in _cellDataArr) {
            
            [_collectionArr addObject:vale[@"value"]];
            
        }
        
        _IDStr = _IDArr[indexPath.row];
        _sectionStr = _titleArr[indexPath.row];
        _count = 1;
        [self.collectionView reloadData];
        
    }else
    {
        /**
         *  自己实现剩余的需求！！！
         */
        if (_count == 0) {
            NSLog(@"你选择的是：第%@类，%@~~~%@",_IDArr.firstObject,_titleArr.firstObject,_collectionArr[indexPath.row]);
        }else
        {
            NSLog(@"你选择的是：第%@类，%@~~~%@",_IDStr,_sectionStr,_collectionArr[indexPath.row]);
        }
        
        
    
    }
    
    
}

//在下面的函数中调用下载函数点击组时调用的下载函数
-(void)sectionBtnClick:(UIButton *)btn
{
    
//    [btn setBackgroundColor:[UIColor redColor]];
    
    
    [_cellDataArr removeAllObjects];
    [_collectionArr removeAllObjects];
    
    NSEnumerator * enumeratorKey1 = [[_valueDict objectForKey:_titleArr[btn.tag-101]] keyEnumerator];

    
    
    for (NSObject *ob in enumeratorKey1) {

        [_cellDataArr addObject:[[_valueDict objectForKey:_titleArr[btn.tag-101]] objectForKey:ob]];
        
        
    }
    
    [_cellDataArr removeObject:_titleArr[btn.tag-101]];
    for (NSDictionary *vale in _cellDataArr) {

        [_collectionArr addObject:vale[@"value"]];
        
    }
    [self.collectionView reloadData];
   
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
