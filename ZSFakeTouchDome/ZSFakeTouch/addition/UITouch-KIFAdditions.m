//
//  UITouch-KIFAdditions.m
//  KIF
//
//  Created by Eric Firestone on 5/20/11.
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.

#import "UITouch-KIFAdditions.h"
#import "LoadableCategory.h"
#import <objc/runtime.h>

KW_FIX_CATEGORY_BUG_M(UITouch_KIFAdditions)

MAKE_CATEGORIES_LOADABLE(UITouch_KIFAdditions)

typedef struct {
    unsigned int _firstTouchForView:1;
    unsigned int _isTap:1;
    unsigned int _isDelayed:1;
    unsigned int _sentTouchesEnded:1;
    unsigned int _abandonForwardingRecord:1;
} UITouchFlags;



@implementation UITouch (KIFAdditions)

- (id)initInView:(UIView *)view;
{
    CGRect frame = view.frame;
    CGPoint centerPoint = CGPointMake(frame.size.width * 0.5f, frame.size.height * 0.5f);
    return [self initAtPoint:centerPoint inView:view];
}

- (id)initAtPoint:(CGPoint)point inWindow:(UIWindow *)window;
{
    self = [super init];
    if (self == nil) {
        return nil;
    }
    
    // Create a fake tap touch
    [self setWindow:window]; // Wipes out some values.  Needs to be first.
    
    //[self setTapCount:1];
    [self _setLocationInWindow:point resetPrevious:YES];
    
    UIView *hitTestView = [window hitTest:point withEvent:nil];
    
    [self setView:hitTestView];
    [self setPhase:UITouchPhaseBegan];
    NSLog(@"initAtPoint setPhase 0");
    if ([self respondsToSelector:@selector(_setIsFirstTouchForView:)]) {
        [self setIsTap:YES];
        [self _setIsFirstTouchForView:YES];
    } else {
        [self _setIsTapToClick:YES];
        // We modify the touchFlags ivar struct directly.
        // First entry is _firstTouchForView
        Ivar flagsIvar = class_getInstanceVariable(object_getClass(self), "_touchFlags");
        
        ptrdiff_t touchFlagsOffset = ivar_getOffset(flagsIvar);
        char *flags = (__bridge void *)self + touchFlagsOffset;
        *flags = *flags | (char)0x01;
    }
    
    
    
    [self setTimestamp:[[NSProcessInfo processInfo] systemUptime]];
    if ([self respondsToSelector:@selector(setGestureView:)]) {
        [self setGestureView:hitTestView];
    }
    
    // Starting with iOS 9, internal IOHIDEvent must be set for UITouch object
    NSOperatingSystemVersion iOS9 = {9, 0, 0};
    if ([NSProcessInfo instancesRespondToSelector:@selector(isOperatingSystemAtLeastVersion:)] && [[NSProcessInfo new] isOperatingSystemAtLeastVersion:iOS9]) {
        [self kif_setHidEvent];
    }
    
    return self;
}

- (void)resetTouch{
    // Create a fake tap touch
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    CGPoint point = CGPointMake(0, 0);
    [self setWindow:window]; // Wipes out some values.  Needs to be first.
    
    //[self setTapCount:1];
    [self _setLocationInWindow:CGPointMake(0, 0) resetPrevious:YES];
    
    UIView *hitTestView = [window hitTest:point withEvent:nil];
    
    [self setView:hitTestView];
    [self setPhase:UITouchPhaseBegan];
    //NSLog(@"resetTouch setPhase 0");
    if ([self respondsToSelector:@selector(_setIsFirstTouchForView:)]) {
        [self setIsTap:YES];
        [self _setIsFirstTouchForView:YES];
    } else {
        [self _setIsTapToClick:YES];
        // We modify the touchFlags ivar struct directly.
        // First entry is _firstTouchForView
        Ivar flagsIvar = class_getInstanceVariable(object_getClass(self), "_touchFlags");
        
        ptrdiff_t touchFlagsOffset = ivar_getOffset(flagsIvar);
        char *flags = (__bridge void *)self + touchFlagsOffset;
        *flags = *flags | (char)0x01;
    }
    
    [self setTimestamp:[[NSProcessInfo processInfo] systemUptime]];
    if ([self respondsToSelector:@selector(setGestureView:)]) {
        [self setGestureView:hitTestView];
    }
    
    // Starting with iOS 9, internal IOHIDEvent must be set for UITouch object
    NSOperatingSystemVersion iOS9 = {9, 0, 0};
    if ([NSProcessInfo instancesRespondToSelector:@selector(isOperatingSystemAtLeastVersion:)] && [[NSProcessInfo new] isOperatingSystemAtLeastVersion:iOS9]) {
        [self kif_setHidEvent];
    }
}

- (id)initTouch;
{
    //NSLog(@"init...touch...");
    self = [super init];
    if (self == nil) {
        return nil;
    }
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGPoint point = CGPointMake(0, 0);
    [self setWindow:window]; // Wipes out some values.  Needs to be first.
    
    [self _setLocationInWindow:point resetPrevious:YES];
    
    UIView *hitTestView = [window hitTest:point withEvent:nil];
    
    [self setView:hitTestView];
    [self setPhase:UITouchPhaseEnded];
    //NSLog(@"init...touch...setPhase 3");
    if ([self respondsToSelector:@selector(_setIsFirstTouchForView:)]) {
        [self setIsTap:YES];
        [self _setIsFirstTouchForView:YES];
    } else {
        [self _setIsTapToClick:YES];
        // We modify the touchFlags ivar struct directly.
        // First entry is _firstTouchForView
        Ivar flagsIvar = class_getInstanceVariable(object_getClass(self), "_touchFlags");
        ptrdiff_t touchFlagsOffset = ivar_getOffset(flagsIvar);
        char *flags = (__bridge void *)self + touchFlagsOffset;
        *flags = *flags | (char)0x01;
    }
    
    
    [self setTimestamp:[[NSProcessInfo processInfo] systemUptime]];
    if ([self respondsToSelector:@selector(setGestureView:)]) {
        [self setGestureView:hitTestView];
    }
    
    // Starting with iOS 9, internal IOHIDEvent must be set for UITouch object
    NSOperatingSystemVersion iOS9 = {9, 0, 0};
    if ([NSProcessInfo instancesRespondToSelector:@selector(isOperatingSystemAtLeastVersion:)] && [[NSProcessInfo new] isOperatingSystemAtLeastVersion:iOS9]) {
        [self kif_setHidEvent];
    }
    return self;
}


- (id)initAtPoint:(CGPoint)point inView:(UIView *)view;
{
    return [self initAtPoint:[view.window convertPoint:point fromView:view] inWindow:view.window];
}

//
// setLocationInWindow:
//
// Setter to allow access to the _locationInWindow member.
//
- (void)setLocationInWindow:(CGPoint)location
{
    [self setTimestamp:[[NSProcessInfo processInfo] systemUptime]];
    [self _setLocationInWindow:location resetPrevious:NO];
}

- (void)setPhaseAndUpdateTimestamp:(UITouchPhase)phase
{
    //NSLog(@"setPhaseAndUpdateTimestamp : %ld",(long)phase);
    [self setTimestamp:[[NSProcessInfo processInfo] systemUptime]];
    [self setPhase:phase];
}

- (void)kif_setHidEvent {
    IOHIDEventRef event = kif_IOHIDEventWithTouches(@[self]);
    [self _setHidEvent:event];
    CFRelease(event);
}

@end
