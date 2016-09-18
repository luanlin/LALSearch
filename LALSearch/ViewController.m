//
//  ViewController.m
//  LALSearch
//
//  Created by 卢安林 on 16/9/13.
//  Copyright © 2016年 LAL. All rights reserved.
//

#import "ViewController.h"
#import "UISearchBar+FMAdd.h"
#import "HKSearchManager.h"
#import "HKSearchRecordTableViewCell.h"

#define HEX_COLOR(x_RGB) [UIColor colorWithRed:((float)((x_RGB & 0xFF0000) >> 16))/255.0 green:((float)((x_RGB & 0xFF00) >> 8))/255.0 blue:((float)(x_RGB & 0xFF))/255.0 alpha:1.0f]


@interface ViewController ()<UISearchBarDelegate,UICollectionViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,weak)UITextField *searchField;
@property (nonatomic,weak)UISearchBar *customSearchBar;
@property (nonatomic,strong)NSArray *myArray;//搜索记录的数组
@property (nonatomic,strong)NSMutableArray *myMutableArray;
@property (nonatomic,weak)UITableView *tableView;

@end
static NSString *searchRecordCell = @"cell";
@implementation ViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:NO];
    [self searchRecordTabelView];
    [self readNSUserDefaults];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationController.navigationBar.barTintColor=[UIColor redColor];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *BJView = [[UIView alloc]initWithFrame:CGRectMake(40, 33,self.view.frame.size.width-80,40)];
    self.navigationItem.titleView = BJView;
    
    UISearchBar *customSearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0,BJView.bounds.size.width,40)];
    customSearchBar.delegate = self;
    customSearchBar.placeholder = @"请输入搜索内容";
    [customSearchBar becomeFirstResponder];
    
    [BJView addSubview:customSearchBar];
    self.customSearchBar = customSearchBar;
    
    // 设置背景颜色
    //设置背景图是为了去掉上下黑线
    customSearchBar.backgroundImage = [[UIImage alloc] init];
    // 设置SearchBar的颜色主题为白色
    customSearchBar.barTintColor =  HEX_COLOR(0xF2F2F2);
    
    // 设置圆角和边框颜色
    UITextField *searchField = [customSearchBar valueForKey:@"searchField"];
    if (searchField) {
        
        [searchField setBackgroundColor: HEX_COLOR(0xF2F2F2)];
        searchField.layer.cornerRadius = 14.0f;
        searchField.layer.borderColor =  HEX_COLOR(0xF2F2F2).CGColor;
        searchField.layer.borderWidth = 1;
        searchField.layer.masksToBounds = YES;
        searchField.keyboardType = UIReturnKeySearch;
    }
    self.searchField = searchField;
    
    //修正光标颜色
    [searchField setTintColor:[UIColor redColor]];

    // 设置输入框文字颜色和字体
    [customSearchBar fm_setTextColor:[UIColor blackColor]];
    [customSearchBar fm_setTextFont:[UIFont systemFontOfSize:14]];
    
    //修改搜索图标
    UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"搜索"]];
    img.frame = CGRectMake(10, 0,20,20);
    self.searchField.leftView = img;
    self.searchField.leftViewMode = UITextFieldViewModeAlways;
    
    //修改clearButton
    UIButton *clearButton = [self.searchField valueForKey:@"_clearButton"];
    [clearButton setImage:[UIImage imageNamed:@"icon_9_1"] forState:UIControlStateNormal];

}

/** 搜索记录tableView */
-(void)searchRecordTabelView
{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    [tableView registerClass:[HKSearchRecordTableViewCell class] forCellReuseIdentifier:searchRecordCell];
    
}
#pragma mark -tableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.myMutableArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HKSearchRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:searchRecordCell];
    if (self.myMutableArray.count!=0) {
        
        //确保搜索的新纪录总在第一个
        cell.labeText.text = self.myMutableArray[self.myMutableArray.count-1-indexPath.row];
        
    }
    
    return cell;
}
#pragma mark - tableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *hisView = [[UIView alloc]init];
    hisView.backgroundColor = [UIColor whiteColor];
    //搜索历史标题
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"搜索历史";
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textColor = [UIColor colorWithRed:134.0/255 green:134.0/255 blue:134.0/255 alpha:1.0];
    [hisView addSubview:titleLabel];
    
    //删除历史记录
    UIButton *Deletbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [Deletbtn setImage:[UIImage imageNamed:@"历史删除"] forState:UIControlStateNormal];
    [hisView addSubview:Deletbtn];
    [Deletbtn addTarget:self action:@selector(deleteBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    if (self.myMutableArray.count == 0) {
        
        hisView.frame = CGRectZero;
        titleLabel.frame = CGRectZero;
        Deletbtn.frame = CGRectZero;
        
    }else{
        
        hisView.frame = CGRectMake(0, 0, self.view.frame.size.width, 45);
        titleLabel.frame = CGRectMake(20, 15, 60, 15);
        Deletbtn.frame = CGRectMake(self.view.frame.size.width-50,0,40, 45);
    }
    return hisView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.searchField.text = self.myMutableArray[self.myMutableArray.count-1-indexPath.row];
  
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        if (indexPath.row < [self.myMutableArray count]) {
            
            //删除单个记录的时候，也要按照之前的排序
            [self.myMutableArray removeObjectAtIndex:self.myMutableArray.count-1-indexPath.row];
            
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            
            [self saveNSUserDefaults];
            
        }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    scrollView = self.tableView;
    [self.searchField resignFirstResponder];
}
//实时监听searchBar的输入框变化
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{

    NSLog(@"textDidChange:%@",searchText);
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (self.searchField.text.length > 0) {
        
        [HKSearchManager SearchText:self.searchField.text];//缓存搜索记录
        [self readNSUserDefaults];
        
    }
    
    //判断是否有相同记录，有就移除
    if (self.myMutableArray == nil) {
        
        self.myMutableArray = [[NSMutableArray alloc]init];
        
    }else if ([self.myMutableArray containsObject:self.searchField.text]){
        
        [self.myMutableArray removeObject:self.searchField.text];
    }
    [self.myMutableArray addObject:self.searchField.text];
    
    [self saveNSUserDefaults];
    
}
/** 删除历史记录 */
- (void)deleteBtnAction:(UIButton *)sender{
    
    [HKSearchManager removeAllArray];
    self.myMutableArray = nil;
    [self.tableView reloadData];
}
/** 本地保存 */
-(void)saveNSUserDefaults
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.myMutableArray forKey:@"myArray"];
    [defaults synchronize];
    [self.tableView reloadData];
}
/** 取出缓存的数据 */
-(void)readNSUserDefaults{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    //读取数组NSArray类型的数据
    NSArray * myArray = [userDefaultes arrayForKey:@"myArray"];
    
    //这里要把数组转换为可变数组
    NSMutableArray *myMutableArray = [NSMutableArray arrayWithArray:myArray];
    
    self.myMutableArray = myMutableArray;
    [self.tableView reloadData];
    NSLog(@"myArray======%@",myArray);
}

@end
