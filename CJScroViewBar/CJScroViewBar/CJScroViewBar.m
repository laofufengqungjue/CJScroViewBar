/**
 *                                         ,s555SB@@&
 *                                      :9H####@@@@@Xi
 *                                     1@@@@@@@@@@@@@@8
 *                                   ,8@@@@@@@@@B@@@@@@8
 *                                  :B@@@@X3hi8Bs;B@@@@@Ah,
 *             ,8i                  r@@@B:     1S ,M@@@@@@#8;
 *            1AB35.i:               X@@8 .   SGhr ,A@@@@@@@@S
 *            1@h31MX8                18Hhh3i .i3r ,A@@@@@@@@@5
 *            ;@&i,58r5                 rGSS:     :B@@@@@@@@@@A
 *             1#i  . 9i                 hX.  .: .5@@@@@@@@@@@1
 *              sG1,  ,G53s.              9#Xi;hS5 3B@@@@@@@B1
 *               .h8h.,A@@@MXSs,           #@H1:    3ssSSX@1
 *               s ,@@@@@@@@@@@@Xhi,       r#@@X1s9M8    .GA981
 *               ,. rS8H#@@@@@@@@@@#HG51;.  .h31i;9@r    .8@@@@BS;i;
 *                .19AXXXAB@@@@@@@@@@@@@@#MHXG893hrX#XGGXM@@@@@@@@@@MS
 *                s@@MM@@@hsX#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&,
 *              :GB@#3G@@Brs ,1GM@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@B,
 *            .hM@@@#@@#MX 51  r;iSGAM@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@8
 *          :3B@@@@@@@@@@@&9@h :Gs   .;sSXH@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@:
 *      s&HA#@@@@@@@@@@@@@@M89A;.8S.       ,r3@@@@@@@@@@@@@@@@@@@@@@@@@@@r
 *   ,13B@@@@@@@@@@@@@@@@@@@5 5B3 ;.         ;@@@@@@@@@@@@@@@@@@@@@@@@@@@i
 *  5#@@#&@@@@@@@@@@@@@@@@@@9  .39:          ;@@@@@@@@@@@@@@@@@@@@@@@@@@@;
 *  9@@@X:MM@@@@@@@@@@@@@@@#;    ;31.         H@@@@@@@@@@@@@@@@@@@@@@@@@@:
 *   SH#@B9.rM@@@@@@@@@@@@@B       :.         3@@@@@@@@@@@@@@@@@@@@@@@@@@5
 *     ,:.   9@@@@@@@@@@@#HB5                 .M@@@@@@@@@@@@@@@@@@@@@@@@@B
 *           ,ssirhSM@&1;i19911i,.             s@@@@@@@@@@@@@@@@@@@@@@@@@@S
 *              ,,,rHAri1h1rh&@#353Sh:          8@@@@@@@@@@@@@@@@@@@@@@@@@#:
 *            .A3hH@#5S553&@@#h   i:i9S          #@@@@@@@@@@@@@@@@@@@@@@@@@A.
 *
 *
 *    又看源码，看你妹妹呀！
 */

#import "CJScroViewBar.h"

#define Bound_Width  [[UIScreen mainScreen] bounds].size.width
#define Bound_Height [[UIScreen mainScreen] bounds].size.height
// 获得RGB颜色
#define kColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]

@interface CJScroViewBar(){
    NSArray *tempArray;
}
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIButton *selectedBtn;
@end

@implementation CJScroViewBar

+ (CJScroViewBar *)sharedTabBar{
    static CJScroViewBar *CustomTabBar = nil;
    static dispatch_once_t tabBar;
    dispatch_once(&tabBar, ^{
        CustomTabBar = [[self alloc] init];
    });
    return CustomTabBar;
}

+ (CJScroViewBar *)setTabBarPoint:(CGPoint)points{
    return [[CJScroViewBar sharedTabBar] setTabBarPoint:points];
}

- (CJScroViewBar *)setTabBarPoint:(CGPoint)point{
    CGRect frame = self.frame;
    frame.origin.x = point.x;
    frame.origin.y = point.y;
    self.frame = frame;
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self loadUI];
    }
    return self;
}

- (void)loadUI{
    self.frame = CGRectMake(0, 0, Bound_Width, 47);
    self.backgroundColor = [UIColor whiteColor];
    self.layer.borderWidth = 0.6;
    self.layer.borderColor = [UIColor colorWithRed:0.698f green:0.698f blue:0.698f alpha:1.00f].CGColor;
}

- (void)setData:(NSArray *)titles NormalColor:(UIColor *)normal_color SelectColor:(UIColor *)select_color Font:(UIFont *)font{
    
    tempArray = titles;
    CGFloat _width = Bound_Width / titles.count;
    
    for (int i=0; i<titles.count; i++) {
        UIButton *item = [UIButton buttonWithType:UIButtonTypeCustom];
        item.frame = CGRectMake(i * _width, 0, _width, CGRectGetHeight(self.frame));
        [item setTitle:titles[i] forState:UIControlStateNormal];
        [item setTitleColor:normal_color forState:UIControlStateNormal];
        [item setTitleColor:select_color forState:UIControlStateSelected];
        item.titleLabel.font = font;
        item.tag = i + 10;
        [item addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:item];
        
        if (i == 0) {
            
            item.selected = YES;
            self.selectedBtn = item;
            self.lineView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame) - 3, _width, 3)];
            self.lineView.layer.cornerRadius = 3.0;
            self.lineView.backgroundColor = kColor(244, 92, 42);
            self.lineView.layer.masksToBounds = YES;
            [self addSubview:self.lineView];
        }
    }
    
    
    
}

- (void)clickItem:(UIButton *)button{
    
    [self setAnimation:button.tag-10];
    
    if (self.indexBlock != nil) {
        self.indexBlock(tempArray[button.tag-10],button.tag-10);
    }
}

/***********************【属性】***********************/

- (void)setLineColor:(UIColor *)lineColor{
    self.lineView.backgroundColor = lineColor;
}

- (void)setLineHeight:(CGFloat)lineHeight{
    CGRect frame = self.lineView.frame;
    frame.size.height = lineHeight;
    frame.origin.y = CGRectGetHeight(self.frame) - lineHeight - 1;
    self.lineView.frame = frame;
}

- (void)setLineCornerRadius:(CGFloat)lineCornerRadius{
    self.lineView.layer.cornerRadius = lineCornerRadius;
}

/***********************【回调】***********************/

- (void)getViewIndex:(IndexBlock)block{
    self.indexBlock = block;
}

+ (void)setViewIndex:(NSInteger)index{
    [[CJScroViewBar sharedTabBar] setViewIndex:index];
}

- (void)setViewIndex:(NSInteger)index{
    if (index < 0) {
        index = 0;
    }
    
    if (index > tempArray.count - 1) {
        index = tempArray.count - 1;
    }
    
    [self setAnimation:index];
}

/***********************【其他】***********************/

- (void)setAnimation:(NSInteger)index{
    
    UIButton *tempBtn = (UIButton *)[self viewWithTag:index+10];
    self.selectedBtn.selected = NO;
    tempBtn.selected = YES;
    self.selectedBtn = tempBtn;
    
    CGFloat x = index * (Bound_Width / tempArray.count);
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.lineView.frame;
        frame.origin.x = x;
        self.lineView.frame = frame;
    }];
}


@end
