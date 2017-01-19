//
//  UIButton+Delay.m
//  delayButton
//
//  Created by 张衡 on 2016/12/5.
//  Copyright © 2016年 张衡. All rights reserved.
//

#import "UIButton+Delay.h"
#import <objc/runtime.h>

static const char *intervalKey = "interval";
static const char *lastIntervalKey = "lastIntervalKey";

@interface UIButton ()
@property (nonatomic, assign) NSTimeInterval lastInterval;
@end

@implementation UIButton (Delay)

- (void)swizzle_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    self.interval = self.interval <= 0 ? 2 : self.interval;
    BOOL ok = [[NSDate date] timeIntervalSince1970] - self.interval >= self.lastInterval;
    if (ok) {
        self.lastInterval = [[NSDate date] timeIntervalSince1970];
        [self swizzle_sendAction:action to:target forEvent:event];
    }
}

+ (void)load {
    swizzleMethod([self class], @selector(sendAction:to:forEvent:), @selector(swizzle_sendAction:to:forEvent:));
}

void swizzleMethod(Class class, SEL originalSelector, SEL swizzledSelector) {
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

- (void)setInterval:(NSTimeInterval)interval {
    objc_setAssociatedObject(self, intervalKey, @(interval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSTimeInterval)interval {
    return [objc_getAssociatedObject(self, intervalKey) doubleValue];
}

- (void)setLastInterval:(NSTimeInterval)lastInterval {
    objc_setAssociatedObject(self, lastIntervalKey, @(lastInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSTimeInterval)lastInterval {
    return [objc_getAssociatedObject(self, lastIntervalKey) doubleValue];
}
@end
