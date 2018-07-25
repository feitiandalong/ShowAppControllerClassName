//
//  UIViewController+ClassName.m
//  GetControllerName
//
//  Created by 程龙 on 17/5/23.
//  Copyright © 2017年 程龙. All rights reserved.
//

#import "UIViewController+ClassName.h"
#import <objc/runtime.h>

#define kClassNameTag 200000

static BOOL displayControllerClassName = NO;

@implementation UIViewController (ClassName)

+ (void)displayControllerClassName:(BOOL)yesOrNo{
    
    displayControllerClassName = yesOrNo;
    if (displayControllerClassName) {
    
        [self displayClassName];
    }else{
        
        [self removeClassName];
    }
}

+ (void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelector = @selector(viewDidAppear:);
        SEL swizzledSelector = @selector(yn_viewDidAppear:);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        BOOL didAddMethod = class_addMethod(class,
                                            originalSelector,
                                            method_getImplementation(swizzledMethod),
                                            method_getTypeEncoding(swizzledMethod));
        
        if (didAddMethod) {
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

#pragma mark - Method Swizzling
- (void)yn_viewDidAppear:(BOOL)animated
{
    [self yn_viewDidAppear:animated];
    
    if (displayControllerClassName) {
        [[self class] displayClassName];
    }
}

+ (void)displayClassName
{
    UIWindow *window = [self appWindow];
    
    UILabel *classNameLabel;
    if ([window viewWithTag:kClassNameTag]) {
        classNameLabel = (UILabel *)[window viewWithTag:kClassNameTag];
        [window bringSubviewToFront:classNameLabel];
    } else {
        classNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 15, window.bounds.size.width, 20)];
        classNameLabel.textColor = [UIColor redColor];
        classNameLabel.font = [UIFont systemFontOfSize:12];
        classNameLabel.tag = kClassNameTag;
        [window addSubview:classNameLabel];
        [window bringSubviewToFront:classNameLabel];
    }
    
    const char *className = class_getName(self.class);
    NSString *classNameStr = @(className);
    
    if ([self needDisplay:classNameStr]) {
        [classNameLabel setText:classNameStr];
    }
}

+ (void)removeClassName
{
    UIWindow *window = [self appWindow];
    
    UILabel *classNameLabel;
    if ([window viewWithTag:kClassNameTag]) {
        classNameLabel = (UILabel *)[window viewWithTag:kClassNameTag];
        [classNameLabel removeFromSuperview];
    }
}

+ (BOOL)needDisplay:(NSString *)className
{
    if ([className isEqualToString:@"UIInputWindowController"]) {
        return NO;
    } else if ([className isEqualToString:@"UINavigationController"]) {
        return NO;
    } else {
        return YES;
    }
}

+ (UIWindow *)appWindow
{
    id<UIApplicationDelegate> appDelegate = [UIApplication sharedApplication].delegate;
    return [appDelegate window];
}


@end
