//
//  HomeController.m
//  城市厨房
//
//  Created by 臧昊 on 15/1/20.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//

#import "HomeController.h"
#import "SearchViewController.h"
#import "WBNavigationController.h"
#import "ModelManager.h"
#import "ModelRequestResult.h"
#import <CoreData/CoreData.h>
#import "Advertisement.h"

#import "AdvScrollView.h"
#import "HomeOddCell.h"

#import "HomeGoodsShow.h"
#import "MBProgressHUD.h"
#define kScrollCount 4

@interface HomeController ()
{
    AdvScrollView *_advscrollView;
    NSMutableArray *_advArray;
    NSManagedObjectContext *_context;
    NSMutableArray *_homeGoodsArray;
    
}
@property (nonatomic, retain) MBProgressHUD *hud;
@end

@implementation HomeController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BackgroundColor;
    [self addNav];
    
    // 广告数组
    _advArray = [NSMutableArray array];
    // 首屏商品数组
    _homeGoodsArray = [NSMutableArray array];
    
    // 打开数据库
    [self openDB];
        // 提取图片url到数组
    NSArray *array_1 = [NSMutableArray arrayWithArray:[self allImageString]];
        // 数据库中加载首屏广告url
    if (array_1.count) {
        for (Advertisement *adv in array_1) {
            [_advArray addObject:adv.imageString];
        }
    }
    
    // 获取沙盒内首屏商品数组并赋值到homeGoodsShow数组
    NSMutableArray *array_2 = [[[NSUserDefaults standardUserDefaults] objectForKey:@"homeGoods"] mutableCopy];
    if (array_2.count == 0) {
        array_2 = [NSMutableArray array];
    }
    if(array_2.count){
        for (NSData *data in array_2) {
            HomeGoodsShow *homeGoodsShow = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            [_homeGoodsArray addObject:homeGoodsShow];
        }
    }
    
//    self.automaticallyAdjustsScrollViewInsets = NO;
    if (_homeGoodsArray.count == 0) {
        
//        self.hud.labelText = @"加载中";
    }
    // 如果网络状态正常，发送广告请求
    if (kCheckNetStatus)
    {
        [[ModelManager sharedManager] httpRequestGetAdvertisement];
        [[ModelManager sharedManager] httpRequestGetHomeGoods];
        self.hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(advertisementFinished:) name:kModelRequestGetAdvetisement object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(homeGoodsFinished:) name:kModelRequestGetHomeGoods object:nil];
    
//    NSDictionary *dic = [NSDictionary dictionary];
  
}



-(void)advertisementFinished:(NSNotification *)notification
{
    ModelRequestResult *result = [notification.userInfo objectForKey:DICT_MODEL_REQUEST_RESULT_KEY];
    
//    NSLog(@"%d", result.succ);
    
    //************************************************************************如果网络请求成功
    if (result.succ) {
        // 取出数据中字典pic对应的字符串
        NSString *picString = [result.responseObject objectForKey:@"pic"];
        // 通过逗号分割成图片url
        NSArray *picArray = [picString componentsSeparatedByString:@","];
        // 添加新获取数据到数组
        _advArray = [NSMutableArray arrayWithArray:picArray];
        NSLog(@"%@", _advArray);
        // 删除数据库中旧数据
        [self removeAdvImageString];
        // 添加新获取数据到数据库
        for (NSString *imageString in picArray) {
            [self addAdvImageString:imageString];
        }

//        for (NSDictionary *dict in pics) {
            //************************************************************************数据库中插入获得数据
//            [PostCoreDataObject insertObjectWithJsonDict:dict];
//        }
    }
    //************************************************************************数据库中搜索广告内容
//    self.advertisementArray = [NSArray arrayWithArray:[PostCoreDataObject fetchAdvertisementObjects]];
//    NSMutableArray *titles = [[NSMutableArray alloc]init];
//    NSMutableArray *images = [[NSMutableArray alloc]init];
    
//    for (int i = 0; i < _advArray.count; i++) {
//        PostCoreDataObject *post = self.advertisementArray[i];
//        if (post.thumbnail) {
//            [images addObject:post.thumbnail];
//            [titles addObject:post.title];
//        }
//    }
    [self.tableView reloadData];
    //    [self.topScrollView updateWithImages:images andTitle:titles];
}

- (void)homeGoodsFinished:(NSNotification *)notification
{
    ModelRequestResult *result = [notification.userInfo objectForKey:DICT_MODEL_REQUEST_RESULT_KEY];
//    NSLog(@"%@",result.responseString);
    if (result.succ) {
        NSArray *dataArray = [result.responseObject objectForKey:@"data"];
//        NSLog(@"%@", dataArray);
        [_homeGoodsArray removeAllObjects];
        NSMutableArray *array = [[[NSUserDefaults standardUserDefaults] objectForKey:@"homeGoods"] mutableCopy];
        if (array.count) {
            [array removeAllObjects];
        }else{
            array = [NSMutableArray array];
        }
        for (NSDictionary *dict in dataArray) {
//            NSLog(@"111111111%@",dict);
            HomeGoodsShow *homeGoodsShow = [[HomeGoodsShow alloc]init];
            [homeGoodsShow initWithDict:dict];
            [_homeGoodsArray addObject:homeGoodsShow];
//            NSString *i = @"dasdas";
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:homeGoodsShow];
            
            [array addObject:data];
        }
//        NSArray *arr = [NSArray arrayWithArray:array];
        [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"homeGoods"];
        // 快速执行上一句话
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.tableView reloadData];
    }
    
    [_hud hide:YES];
}


- (void)addNav
{
    UIImage *image = [UIImage imageNamed:@"logo.png"];
    UIImageView *button = [[UIImageView alloc]initWithImage:image];
    
    button.bounds = CGRectMake(0, 0, image.size.width * 0.6, image.size.height * 0.6);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem.enabled = NO;
    UIImage *image1 = [UIImage imageNamed:@"code.png"];
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setBackgroundImage:image1 forState:UIControlStateNormal];
    button1.enabled = NO;
    button1.bounds = CGRectMake(0, 0, image.size.width / 2, image.size.height / 2);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button1];
    UIImage *searchImage = [[UIImage alloc]init];
    if([UIScreen mainScreen].bounds.size.width == 320){
        searchImage = [UIImage imageNamed:@"iPhone5S.png"];
    }else if ([UIScreen mainScreen].bounds.size.width == 375){
        searchImage = [UIImage imageNamed:@"iPhone6.png"];
    }else{
        searchImage = [UIImage imageNamed:@"iPhone6P.png"];
    }
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchButton setBackgroundImage:searchImage forState:UIControlStateNormal];
    [searchButton setBackgroundImage:searchImage forState:UIControlStateHighlighted];
    searchButton.frame = CGRectMake(0, 0, 0, searchImage.size.height * 0.35);
    self.navigationItem.titleView = searchButton;
    //    self.navigationItem.titleView.hidden = NO;
    [searchButton addTarget:self action:@selector(popupSearchView) forControlEvents:UIControlEventTouchDown];
}

- (void)popupSearchView
{
    SearchViewController * search = [[SearchViewController alloc]init];
    WBNavigationController *nav = [[WBNavigationController alloc]initWithRootViewController:search];
    [self presentViewController:nav animated:NO completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return self.view.frame.size.width * 0.375;
    }else{
        return 30 + self.view.frame.size.width * 0.5 + 50;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0 || section == 1) {
        return 0.001;
    }else{
        return 10;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        _advscrollView = [[AdvScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width * 0.375) addScrollViewWithImages:_advArray];
        [cell.contentView addSubview:_advscrollView];
        return cell;
    }else{
        NSString *CellIdentifier = [NSString stringWithFormat:@"cell%ld%ld", (long)indexPath.section, (long)indexPath.row];
        HomeOddCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[HomeOddCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        if (_homeGoodsArray.count) {
            cell.homeGoods = _homeGoodsArray[indexPath.section - 1];
        }
        return cell;
    }
}



- (void)openDB
{
    /*
     回顾SQLite的操作方式（持久化）
     
     1. opendb打开数据库，如果第一次运行，会在沙盒中创建数据库
     2. 打开数据库之后，会生成一个数据库连接的句柄->_db，后续的数据库操作均基于该句柄进行
     3. 创建数据表(IF NOT EXISTS)
     
     ** Core Data的操作方式
     1. 将所有定义好的数据模型文件合并成为一个数据模型（NSManagedObjectModel）
     建立起针对实体对应的数据表的SQL语句，以便创建数据表
     2. 用数据模型来创建持久化存储调度，此时就具备了创建表的能力
     3. 为存储调度添加持久化的数据存储（SQLite数据库），如果没有，新建并创建数据表
     如果已经存在，直接打开数据库。
     
     在打开数据库之后，会判断实体当前的结构与数据表的描述结构是否一致，如果不一致，会提示打开失败！
     */
    // 创建数据库
    // 1. 实例化数据模型(将所有定义的模型都加载进来)
    // merge——合并
    NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    // 2. 实例化持久化存储调度，要建立起桥梁，需要模型
    NSPersistentStoreCoordinator *store = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    
    // 3. 添加一个持久化的数据库到存储调度
    // 3.1 建立数据库保存在沙盒的URL
    NSArray *docs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [docs[0] stringByAppendingPathComponent:@"my.db"];
    NSURL *url = [NSURL fileURLWithPath:path];
    
    // 3.2 打开或者新建数据库文件
    // 如果文件不存在，则新建之后打开
    // 否者直接打开数据库
    NSError *error = nil;
    [store addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:&error];
    
    if (error) {
        NSLog(@"打开数据库出错 - %@", error.localizedDescription);
    } else {
        NSLog(@"打开数据库成功！");
        
        _context = [[NSManagedObjectContext alloc] init];
        
        _context.persistentStoreCoordinator = store;
    }
}

- (void)addAdvImageString: (NSString *)imageString
{
    // 1. 实例化并让context“准备”将一条个人记录增加到数据库
    Advertisement *adv = [NSEntityDescription insertNewObjectForEntityForName:@"Advertisement" inManagedObjectContext:_context];
    
    adv.imageString = imageString;
    
    // 3. 保存(让context保存当前的修改)
    if ([_context save:nil]) {
        NSLog(@"新增成功");
    } else {
        NSLog(@"新增失败");
    }
}

- (void)removeAdvImageString
{
    // 1. 实例化查询请求
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Advertisement"];
    
    // 2. 设置谓词条件
//    request.predicate = [NSPredicate predicateWithFormat:@"name = '张老头'"];
    
    // 3. 由上下文查询数据
    NSArray *result = [_context executeFetchRequest:request error:nil];
    
    // 4. 输出结果
    for (Advertisement *adv in result) {
        
        // 删除一条记录
        [_context deleteObject:adv];

    }
    
    // 5. 通知_context保存数据
    if ([_context save:nil]) {
        NSLog(@"删除成功");
    } else {
        NSLog(@"删除失败");
    }
}

- (NSArray *)allImageString
{
    // 1. 实例化一个查询(Fetch)请求
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Advertisement"];
    
    // 3. 条件查询，通过谓词来实现的
    //    request.predicate = [NSPredicate predicateWithFormat:@"age < 60 && name LIKE '*五'"];
    // 在谓词中CONTAINS类似于数据库的 LIKE '%王%'
    //    request.predicate = [NSPredicate predicateWithFormat:@"phoneNo CONTAINS '1'"];
    // 如果要通过key path查询字段，需要使用%K
    //    request.predicate = [NSPredicate predicateWithFormat:@"%K CONTAINS '1'", @"phoneNo"];
    // 直接查询字表中的条件
    
    // 2. 让_context执行查询数据
    return [_context executeFetchRequest:request error:nil];
    
//    for ( *p in array) {
//        NSLog(@"%@ %@ %@", p.name, p.age, p.phoneNo);
//        
//        // 在CoreData中，查询是懒加载的
//        // 在CoreData本身的SQL查询中，是不使用JOIN的，不需要外键
//        // 这种方式的优点是：内存占用相对较小，但是磁盘读写的频率会较高
//        for (Book *b in p.books) {
//            NSLog(@"%@ %@ %@", b.name, b.price, b.author);
//        }
//    }
    
    //    for (Book *b in array) {
    //        NSLog(@"%@ %@ %@", b.name, b.price, b.author);
    //    }
}

@end
