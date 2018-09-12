//
//  ViewController.m
//  LuckRound
//
//  Created by 邓伟浩 on 2018/6/30.
//  Copyright © 2018年 邓伟浩. All rights reserved.
//

#import "ViewController.h"
#import "PickTypeView.h"
#import "UtilsMacros.h"


@interface ViewController ()<CAAnimationDelegate>

@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UILabel *countLabel;

@property (nonatomic, assign) BOOL isAnimation;
@property (nonatomic, assign) int circleAngle;
@property (nonatomic, assign) long countNumber;

@property (nonatomic, assign) int selectType;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _countNumber = 5000;
    _selectType = 0;
    [self setUpRoundView];
    [self setUpCountLabel];
}

#pragma mark - 初始化View
- (void)setUpCountLabel {
    UILabel *countLabel;
    [self.view addSubview:({
        countLabel = [[UILabel alloc] init];
        countLabel.frame = CGRectMake(0, 0, KScreenWidth, 30);
        countLabel.textAlignment = NSTextAlignmentCenter;
        countLabel.text = NSStringFormat(@"现拥有积分: %ld", _countNumber);
        countLabel.center = CGPointMake(KScreenWidth/2, CGRectGetMinY(_bgImageView.frame)/2);
        _countLabel = countLabel;
    })];
    
}

- (void)setUpRoundView {
    
    //转盘背景
    _bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth-50, KScreenWidth-50)];
    _bgImageView.center = self.view.center;
    _bgImageView.image = [UIImage imageNamed:@"roundBack"];
    [self.view addSubview:_bgImageView];
    
    //添加指针
    UIImageView *btnimage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 100)];
    btnimage.image = [UIImage imageNamed:@"pick"];
    [self.view addSubview:btnimage];
    btnimage.center = _bgImageView.center;
    
    _bgImageView.userInteractionEnabled = YES;
    btnimage.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnClick)];
    [_bgImageView addGestureRecognizer:tap];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnClick)];
    [btnimage addGestureRecognizer:tap1];
    
    //添加文字
    NSArray *_prizeArray = @[@"谢谢参与",@"2倍",@"10倍",@"100倍",@"1倍",@"5倍"];
    NSUInteger count = _prizeArray.count;
    for (int i = 0; i < count; i ++) {
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, M_PI * CGRectGetHeight(_bgImageView.frame)/count, CGRectGetHeight(_bgImageView.frame)*3/5)];
        label.layer.anchorPoint = CGPointMake(0.5, 1.0);
        label.center = CGPointMake(CGRectGetHeight(_bgImageView.frame)/2, CGRectGetHeight(_bgImageView.frame)/2);
        label.text = [NSString stringWithFormat:@"%@", _prizeArray[i]];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont boldSystemFontOfSize:18];
        CGFloat angle = M_PI*2/count * i;
        label.transform = CGAffineTransformMakeRotation(angle);
        [_bgImageView addSubview:label];
        
    }
    
}

#pragma mark - 开始游戏
- (void)btnClick {
    
    //判断是否正在转
    if (_isAnimation) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"你点击的太快了" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    PickTypeView *pick = [[PickTypeView alloc] initWithType:_selectType];
    
    [pick show];
    kWeakSelf(self);
    pick.ok = ^(int type) {
        weakself.selectType = type;
//        NSLog(@"积分: %d", type);
        [weakself startRound];
    };
}

- (void)startRound {
//    NSLog(@"开始!");
    
    _isAnimation = YES;
    self.countNumber = self.countNumber - self.selectType;
    
    [self getCircleAngle];
    
    //设置转圈的圈数
    NSInteger circleNum = 3;
    
    CGFloat perAngle = M_PI/180.0;
    
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    id value = [NSNumber numberWithFloat:_circleAngle * perAngle + 360 * perAngle * circleNum];
    rotationAnimation.toValue = value;
    rotationAnimation.duration = 3.5f;
    rotationAnimation.delegate = self;
    
    //由快变慢
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    rotationAnimation.fillMode = kCAFillModeForwards;
    rotationAnimation.removedOnCompletion = NO;
    [_bgImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)getCircleAngle {
    //控制概率[0,1000)
    NSInteger lotteryPro = arc4random()%1000;
    
//    0   5   1   100   10   2
//   500  5  284   1   10    200
    if (lotteryPro < 500) {
        _circleAngle = 0;
    } else if (lotteryPro < 505) {
        _circleAngle = 60;
    } else if (lotteryPro < 789) {
        _circleAngle = 120;
    } else if (lotteryPro < 790) {
        _circleAngle = 180;
    } else if (lotteryPro < 800) {
        _circleAngle = 240;
    } else if (lotteryPro < 1000) {
        _circleAngle = 300;
    }
//    NSLog(@"lotteryPro = %ld, turnAngle = %ld", (long)lotteryPro, (long)_circleAngle);
}

#pragma mark - 动画结束
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    _isAnimation = NO;
//    NSLog(@"动画停止");
    NSString *title;
    _bgImageView.transform = CGAffineTransformMakeRotation(M_PI/180.0*_circleAngle);
    [_bgImageView.layer removeAllAnimations];
    
    int X = 0;
    if (_circleAngle == 0) {
        title = @"谢谢参与!";
        X = 0;
    } else if (_circleAngle == 60) {
        title = @"5倍";
        X = 5;
    } else if (_circleAngle == 120) {
        title = @"1倍";
        X = 1;
    } else if (_circleAngle == 180) {
        title = @"100倍";
        X = 100;
    } else if (_circleAngle == 240) {
        title = @"10倍";
        X = 10;
    } else if (_circleAngle == 300) {
        title = @"2倍";
        X = 2;
    }
    
    int addCount = X*_selectType;
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:title delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    
    _countNumber = _countNumber + addCount;
    _countLabel.text = NSStringFormat(@"现拥有积分: %ld", _countNumber);
    
    NSLog(@"当前积分:%ld, 投入积分:%d, 获得积分：%d", (long)_countNumber, _selectType, addCount);
}

@end
