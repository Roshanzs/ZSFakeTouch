//
//  ZSFakeTouch.m
//  zstest
//
//  Created by 紫贝壳 on 2017/8/29.
//  Copyright © 2017年 stark. All rights reserved.
//

#import "ZSFakeTouch.h"
#import "UITouch-KIFAdditions.h"
#import "UIApplication-KIFAdditions.h"
#import "UIEvent+KIFAdditions.h"

static UITouch *zsTouch;

@implementation ZSFakeTouch
+(void)beginTouchWithPoint:(CGPoint)point{
    zsTouch = [[UITouch alloc] initAtPoint:point inWindow:[UIApplication sharedApplication].keyWindow];
    CGRect keyboardFrame ;
    keyboardFrame = CGRectMake(0, 0, 0, 258);
    if([[[UIApplication sharedApplication].windows lastObject] isKindOfClass:NSClassFromString(@"UIRemoteKeyboardWindow")] && (CGRectContainsPoint(CGRectMake(0, [UIApplication sharedApplication].keyWindow.frame.size.height-keyboardFrame.size.height, [UIApplication sharedApplication].keyWindow.frame.size.width, keyboardFrame.size.height), point))) {
        zsTouch = [[UITouch alloc] initAtPoint:point inWindow:[self lastWindow]];
        [zsTouch setLocationInWindow:point];
    }
    UIEvent *event = [self eventWithTouches:@[zsTouch]];
    [[UIApplication sharedApplication] sendEvent:event];
    if ((zsTouch.phase==UITouchPhaseBegan)||zsTouch.phase==UITouchPhaseMoved) {
        [zsTouch setPhaseAndUpdateTimestamp:UITouchPhaseStationary];
    }
}

+(void)endTouchWithPoint:(CGPoint)point{
    [zsTouch setLocationInWindow:point];
    [zsTouch setPhaseAndUpdateTimestamp:UITouchPhaseEnded];
    UIEvent *event = [self eventWithTouches:@[zsTouch]];
    [[UIApplication sharedApplication] sendEvent:event];
}

+(void)moveTouchWithPoint:(CGPoint)point{
    [zsTouch setLocationInWindow:point];
    [zsTouch setPhaseAndUpdateTimestamp:UITouchPhaseMoved];
    UIEvent *event = [self eventWithTouches:@[zsTouch]];
    [[UIApplication sharedApplication] sendEvent:event];
    [zsTouch setPhaseAndUpdateTimestamp:UITouchPhaseStationary];
}

+ (UIWindow *)lastWindow
{
    NSArray *windows = [UIApplication sharedApplication].windows;
    for(UIWindow *window in [windows reverseObjectEnumerator]) {
        if ([window isKindOfClass:[UIWindow class]] &&
            CGRectEqualToRect(window.bounds, [UIScreen mainScreen].bounds))
            return window;
    }
    return [UIApplication sharedApplication].keyWindow;
}

+ (UIEvent *)eventWithTouches:(NSArray *)touches
{
    // _touchesEvent is a private selector, interface is exposed in UIApplication(KIFAdditionsPrivate)
    UIEvent *event = [[UIApplication sharedApplication] _touchesEvent];
    [event _clearTouches];
    [event kif_setEventWithTouches:touches];
    
    for (UITouch *aTouch in touches) {
        [event _addTouch:aTouch forDelayedDelivery:NO];
    }
    return event;
}
@end
