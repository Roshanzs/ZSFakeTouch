//
//  ZSFakeTouch.h
//  zstest
//
//  Created by 紫贝壳 on 2017/8/29.
//  Copyright © 2017年 stark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ZSFakeTouch : NSObject
//开始点触
+(void)beginTouchWithPoint:(CGPoint)point;
//结束点触
+(void)endTouchWithPoint:(CGPoint)point;
//移动
+(void)moveTouchWithPoint:(CGPoint)point;

@end
