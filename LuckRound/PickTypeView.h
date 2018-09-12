//
//  PickTypeView.h
//  LuckRound
//
//  Created by 邓伟浩 on 2018/6/30.
//  Copyright © 2018年 邓伟浩. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ok)(int type);

@interface PickTypeView : UIView


- (instancetype)initWithType:(int)type;

- (void)show;
@property (nonatomic, copy) ok ok;

@end
