//
//  UtilsMacros.h
//  LuckRound
//
//  Created by 邓伟浩 on 2018/6/30.
//  Copyright © 2018年 邓伟浩. All rights reserved.
//

// 全局工具类宏定义

#ifndef define_h
#define define_h

#define KScreenWidth ([[UIScreen mainScreen] bounds].size.width)
#define KScreenHeight [[UIScreen mainScreen] bounds].size.height
#define kAppWindow          [UIApplication sharedApplication].delegate.window
#define NSStringFormat(format,...) [NSString stringWithFormat:format,##__VA_ARGS__]

//View 圆角和加边框
#define ViewBorderRadius(View, Radius, Width, Color)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]

// View 圆角
#define ViewRadius(View, Radius)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES]

#define IMAGE_NAMED(name) [UIImage imageNamed:name]

#define kWeakSelf(type)  __weak typeof(type) weak##type = type;

#endif /* define_h */
