//
//  PickTypeView.m
//  LuckRound
//
//  Created by 邓伟浩 on 2018/6/30.
//  Copyright © 2018年 邓伟浩. All rights reserved.
//

#import "PickTypeView.h"
#import "UtilsMacros.h"

@interface PickTypeView ()

/** 背景视图 */
@property (nonatomic, strong) UIView *backgroundView;
/** 内容视图 */
@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) NSArray *typeArray;

@property (nonatomic, strong) UIButton *lastSelectButton;
@property (nonatomic, assign) int type;

@end

@implementation PickTypeView

- (instancetype)initWithType:(int)type {
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        _typeArray = @[@(5), @(10), @(20), @(50), @(100), @(200)];
        _type = type;
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI {
    
    [self addSubview:({
        _backgroundView = [[UIView alloc] init];
        _backgroundView.alpha = 0.5;
        _backgroundView.backgroundColor = [UIColor blackColor];
        _backgroundView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
        _backgroundView;
    })];
    
    [self addSubview:({
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.frame = CGRectMake(0, 0, KScreenWidth-40, 250);
        _contentView.center = self.center;
        
        _contentView;
    })];
    
    UILabel *tipsLabel;
    UIButton *closeButton;
    UILabel *tipsLabel2;
    [_contentView addSubview:({
        tipsLabel = [[UILabel alloc] init];
        tipsLabel.frame = CGRectMake(0, 0, _contentView.frame.size.width, 50);
        tipsLabel.text = @"选择投入的积分";
        tipsLabel.textAlignment = NSTextAlignmentCenter;
        tipsLabel.backgroundColor = [UIColor orangeColor];
        tipsLabel;
    })];
    [_contentView addSubview:({
        closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeButton setImage:IMAGE_NAMED(@"icon_close_commitDone") forState:UIControlStateNormal];
        closeButton.frame = CGRectMake(_contentView.frame.size.width-60, 0, 50, 50);
        [closeButton addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
        closeButton;
    })];
    
    [_contentView addSubview:({
        tipsLabel2 = [[UILabel alloc] init];
        tipsLabel2.frame = CGRectMake(0, CGRectGetMaxY(tipsLabel.frame), _contentView.frame.size.width, 50);
        tipsLabel2.text = @"每局消耗投入的积分，可赢取随机倍数奖励";
        tipsLabel2.textAlignment = NSTextAlignmentCenter;
        tipsLabel2.font = [UIFont systemFontOfSize:12];
        tipsLabel2;
    })];
    
    
    CGFloat leftGap = 15;
    CGFloat buttonGap = 20;
    CGFloat buttonWidth = (_contentView.frame.size.width-2*leftGap-2*buttonGap)/3;
    CGFloat buttonHeight = 40;
    
    for (int i = 0; i < 6; i++) {
        UIButton *typeButton = [[UIButton alloc] init];
        [_contentView addSubview:typeButton];
        typeButton.tag = i;
        
        typeButton.frame = CGRectMake(leftGap+(buttonWidth+buttonGap)*(i%3), 100+(i/3)*(buttonHeight+10), buttonWidth, buttonHeight);
        NSMutableAttributedString *titleStr = [[NSMutableAttributedString alloc] initWithString:NSStringFormat(@"%@元", _typeArray[i]) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0], NSForegroundColorAttributeName:[UIColor orangeColor]}];
        [typeButton setAttributedTitle:titleStr forState:UIControlStateNormal];
        typeButton.backgroundColor = [UIColor clearColor];
        ViewBorderRadius(typeButton, 4, 1, [UIColor orangeColor]);
        [typeButton addTarget:self action:@selector(selectType:) forControlEvents:UIControlEventTouchUpInside];
        
        NSNumber *number = _typeArray[i];
        if (_type == number.intValue) {
            [self selectType:typeButton];
        }
        
    }
    
    [_contentView addSubview:({
        UIButton *okButton = [[UIButton alloc] init];
        okButton.frame = CGRectMake(_contentView.frame.size.width/2-50, 210, 100, 30);
        NSMutableAttributedString *titleStr = [[NSMutableAttributedString alloc] initWithString:@"确认" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0], NSForegroundColorAttributeName:[UIColor whiteColor]}];
        [okButton setAttributedTitle:titleStr forState:UIControlStateNormal];
        okButton.backgroundColor = [UIColor redColor];
        ViewRadius(okButton, 15);
        [okButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        okButton;
    })];
    
}

- (void)releaseLastButton {
    NSMutableAttributedString *titleStr = [[NSMutableAttributedString alloc] initWithString:NSStringFormat(@"%@元", _typeArray[_lastSelectButton.tag]) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0], NSForegroundColorAttributeName:[UIColor orangeColor]}] ;
    [_lastSelectButton setAttributedTitle:titleStr forState:UIControlStateNormal];
    _lastSelectButton.backgroundColor = [UIColor clearColor];
    ViewBorderRadius(_lastSelectButton, 4, 1, [UIColor orangeColor]);
}

- (void)selectType:(UIButton *)button {
    if (_lastSelectButton != nil) {
        
        [self releaseLastButton];
    }
    _lastSelectButton = button;
    
    NSMutableAttributedString *titleStr = [[NSMutableAttributedString alloc] initWithString:NSStringFormat(@"%@元", _typeArray[button.tag]) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0], NSForegroundColorAttributeName:[UIColor whiteColor]}] ;
    [button setAttributedTitle:titleStr forState:UIControlStateNormal];
    button.backgroundColor = [UIColor orangeColor];
    ViewBorderRadius(button, 4, 1, [UIColor orangeColor]);
    
    NSNumber *number = _typeArray[button.tag];
    _type = number.intValue;
    
}

- (void)buttonClicked:(id)sender {
    if (_type == 0) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择投入积分" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    [self removeAnimation];
    if (self.ok) {
        self.ok(_type);
    }
}

- (void)close:(UIButton *)button {
    [self removeAnimation];
}

- (void)show {
    
    [kAppWindow addSubview:self];
    self.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    
    self.alpha = 0;
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)removeAnimation {
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
