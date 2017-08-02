//
//  ViewController.m
//  Text_HuaDong
//
//  Created by 666 on 2017/8/2.
//  Copyright © 2017年 Text. All rights reserved.
//

#import "ViewController.h"
#import "CJScroViewBar.h"

#define Bound_Width  [[UIScreen mainScreen] bounds].size.width
#define Bound_Height [[UIScreen mainScreen] bounds].size.height
// 获得RGB颜色
#define kColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]

@interface ViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"测试";
    
    
    [self createSegmentMenu];
    
}

- (void)createSegmentMenu{
    
    //数据源
    NSArray *array = @[@"测试1",@"测试2",@"测试3",@"测试4"];
    
    CJScroViewBar *scroView = [CJScroViewBar setTabBarPoint:CGPointMake(0, 0)];
    [scroView setData:array NormalColor
                       :kColor(16, 16, 16) SelectColor
                       :kColor(244, 92, 42) Font
                       :[UIFont systemFontOfSize:15]];
    
    
    [self.view addSubview:scroView];

    //设置默认值
    [CJScroViewBar setViewIndex:0];
    
    
    //TabBar回调
    [scroView getViewIndex:^(NSString *title, NSInteger index) {
        
        NSLog(@"title:%@ - index:%li",title,index);
        
        [UIView animateWithDuration:0.3 animations:^{
            self.scrollView.contentOffset = CGPointMake(index * Bound_Width, 0);
        }];
        
        /***********************【回调】***********************/
        //
        //         如果是tabbleView。这里可以写刷新操作
        //
        /***********************【回调】***********************/
    }];
    
    
    
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 47, Bound_Width, Bound_Height - 40 - 64)];
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = NO;
    self.scrollView.showsHorizontalScrollIndicator = YES;
    self.scrollView.contentSize = CGSizeMake(array.count*Bound_Width, 0);
    [self.view addSubview:self.scrollView];
    
    for (int i=0; i<array.count; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(i*Bound_Width, 0, CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame))];
        view.backgroundColor = [self randomColor];
        [self.scrollView addSubview:view];
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x / Bound_Width;
    
    //设置Bar的移动位置
    [CJScroViewBar setViewIndex:index];
}

- (UIColor *)randomColor{
    CGFloat red = arc4random()%255/255.0;
    CGFloat green = arc4random()%255/255.0;
    CGFloat blue = arc4random()%255/255.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
