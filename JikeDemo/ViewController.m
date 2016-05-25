//
//  ViewController.m
//  JikeDemo
//
//  Created by Lin Wei on 4/28/16.
//  Copyright © 2016 linw. All rights reserved.
//

#import "ViewController.h"
#import "JikeDemoHeaderView.h"

static NSString *tableViewCellIdentifier = @"JikeDemoIdentifier";
static NSString *separatorCellIdentifier = @"JikeDemoSepartorTableViewCellIdentifier";

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *JikeDemoTableView;
@property (nonatomic, weak) id<JKTableViewDidScrollProtocol> delegate;
@property (nonatomic, strong) JikeDemoHeaderView *headerView;
@property (nonatomic, strong) UINavigationBar *navigationBar;

@end

@implementation ViewController

#pragma mark - view controller lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [_JikeDemoTableView registerNib:[UINib nibWithNibName:@"JikeDemoTableViewCell" bundle:nil]
             forCellReuseIdentifier:tableViewCellIdentifier];
    
    [_JikeDemoTableView registerNib:[UINib nibWithNibName:@"JikeDemoSepartorTableViewCell" bundle:nil]
             forCellReuseIdentifier:separatorCellIdentifier];
    _JikeDemoTableView.dataSource = self;
    _JikeDemoTableView.delegate = self;
    self.automaticallyAdjustsScrollViewInsets = false;
    
    _JikeDemoTableView.tableFooterView = [UIView new];
    _JikeDemoTableView.rowHeight = UITableViewAutomaticDimension;
    _JikeDemoTableView.estimatedRowHeight = 105.00;
    
    _JikeDemoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _JikeDemoTableView.scrollIndicatorInsets = UIEdgeInsetsMake(20, 0, 0, 0);
    
    _headerView = [[UINib nibWithNibName:@"JikeDemoHeaderView" bundle:nil] instantiateWithOwner:nil
                                                                                        options:nil][0];
    self.delegate = _headerView;
    
    _JikeDemoTableView.tableHeaderView = _headerView;
    
    self.navigationController.navigationBarHidden = true;
    
    _navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 64)];
    
    UINavigationItem *newItem = [[UINavigationItem alloc] init];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] init];
    barButton.title = @"JikeDemo";
    newItem.rightBarButtonItem = barButton;
    [_navigationBar setItems:@[newItem]];
    [self.view addSubview:_navigationBar];
    _navigationBar.alpha = 0.0;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidAppear:(BOOL)animated {
}

#pragma mark - UITableView datasource/delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    if (indexPath.row % 2) {
        cell = [tableView dequeueReusableCellWithIdentifier:tableViewCellIdentifier
                                               forIndexPath:indexPath];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:separatorCellIdentifier
                                               forIndexPath:indexPath];
    }
    
    return cell;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 10.0f;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    UIView *view = [UIView new];
//    view.backgroundColor = [UIColor lightGrayColor];
//    return view;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:false];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    /* 用section做cell的separator
    CGFloat sectionHeaderHeight = 10;
    CGFloat factor = scrollView.contentOffset.y / scrollView.bounds.size.height;
    NSLog(@"contentOffset.y %f", scrollView.contentOffset.y);
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
    */
    
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY < 0) {
        if (offsetY < -50) {
            _JikeDemoTableView.contentOffset = CGPointMake(0, -50);
            offsetY=-50;
        }
    }
    
    
    CGFloat delegateOffsetY = [self.delegate jk_tableviewShowNavigationBar];
    if (offsetY > 0) {
        CGFloat fraction = offsetY / delegateOffsetY;
        if (offsetY >= 300 - 64) {
            _navigationBar.items[0].title = [self.delegate jk_tableViewTitle];
        } else {
            _navigationBar.items[0].title = @"";
        }
        if (fraction > 1) {
            fraction = 1.0f;
        } else if (fraction < 0.5) {
            _navigationBar.items[0].title = @"";
        }
        _navigationBar.alpha = fraction;

    } else {
        [UIView animateWithDuration:0.5f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             _navigationBar.alpha = 0.0;
                         } completion:^(BOOL finished) {
                             _navigationBar.items[0].title = @"";
                         }];
    }
    [self.delegate jk_tableviewDidScrollToContentOffsetY:offsetY];
}

@end
