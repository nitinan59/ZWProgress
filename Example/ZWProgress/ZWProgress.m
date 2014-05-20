//
//  ZWProgress.m
//  ZWProgress
//
//  Created by Nitinan Assawanuwat on 5/19/2557 BE.
//  Copyright (c) 2557 Nitinan Assawanuwat. All rights reserved.
//

#import "ZWProgress.h"

@implementation ZWProgress

@synthesize bottomContraint;

static ZWProgress *progress;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithRed:47.0/255.0
                                                   green:52.0/255.0
                                                    blue:67.0/255.0
                                                   alpha:1.0];
        
        CGRect bounds = self.bounds;
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:bounds
                                                       byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)
                                                             cornerRadii:CGSizeMake(7.0, 7.0)];
        
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.frame = bounds;
        maskLayer.path = maskPath.CGPath;
        
        self.layer.mask = maskLayer;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor whiteColor];
        label.text = @"Loading...";
        [label sizeToFit];
        [label setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [indicator setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [self addSubview:label];
        [self addSubview:indicator];
        
        [label addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:label.frame.size.width]];
        
        [label addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:label.frame.size.height]];
        
        [indicator addConstraint:[NSLayoutConstraint constraintWithItem:indicator
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:indicator.frame.size.width]];
        
        [indicator addConstraint:[NSLayoutConstraint constraintWithItem:indicator
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:indicator.frame.size.height]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                         attribute:NSLayoutAttributeCenterX
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeCenterX
                                                        multiplier:1.0
                                                          constant:10.0]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                         attribute:NSLayoutAttributeCenterY
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeCenterY
                                                        multiplier:1.0
                                                          constant:0.0]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:indicator
                                                         attribute:NSLayoutAttributeCenterY
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeCenterY
                                                        multiplier:1.0
                                                          constant:0.0]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:indicator
                                                         attribute:NSLayoutAttributeTrailing
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:label
                                                         attribute:NSLayoutAttributeLeading
                                                        multiplier:1.0
                                                          constant:-5.0]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                         attribute:NSLayoutAttributeWidth
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:nil
                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                        multiplier:1.0
                                                          constant:self.frame.size.width]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                         attribute:NSLayoutAttributeHeight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:nil
                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                        multiplier:1.0
                                                          constant:self.frame.size.height]];
        [indicator startAnimating];
        
    }
    return self;
}
+(void)showProgress
{
    @synchronized(progress)
    {
        if(progress && progress.currentController)
        {
            // dismiss current controller first
            [ZWProgress dismiss];
        }
        if (!progress){
            progress = [[ZWProgress alloc] initWithFrame:CGRectMake(0, 0, 140, 30)];
            progress.backgroundColor = [UIColor colorWithRed:47.0/255.0
                                                       green:52.0/255.0
                                                        blue:67.0/255.0
                                                       alpha:1.0];
        }
        
        progress.currentController = [self getTopController];
        
        float bottomLayoutGuide = 0;
        if(progress.currentController.tabBarController){
            bottomLayoutGuide = progress.currentController.tabBarController.tabBar.frame.size.height;
        }
        
        progress.center = progress.currentController.view.center;
        
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGRect rect = progress.frame;
        rect.origin.y = screenRect.size.height - bottomLayoutGuide;
        progress.frame = rect;
        
        if([progress.currentController.view isKindOfClass:[UIScrollView class]]){
            [progress.currentController.view.superview addSubview:progress];
        }else{
            [progress.currentController.view addSubview:progress];
        }
        
        [UIView animateWithDuration:0.2 animations:^{
            CGRect transition = progress.frame;
            transition.origin.y -= progress.frame.size.height;
            progress.frame = transition;
        }];
    }
}
+(void)dismiss
{
    @synchronized(progress)
    {
        if(progress){
            progress.bottomContraint.constant = progress.frame.size.height-[[progress.currentController bottomLayoutGuide] length];
            [UIView animateWithDuration:0.2
                             animations:^{
                                 CGRect transition = progress.frame;
                                 transition.origin.y += progress.frame.size.height;
                                 progress.frame = transition;
                             }
                             completion:^(BOOL finished) {
                                 [progress removeFromSuperview];
                                 progress = nil;
                             }];
        }
    }
}
+ (UIViewController*) getTopController
{
    UIViewController *topViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    while (topViewController.presentedViewController) {
        topViewController = topViewController.presentedViewController;
    }
    if([topViewController isKindOfClass:[UINavigationController class]]){
        UINavigationController *nav = (UINavigationController*)topViewController;
        return [nav topViewController];
    }else if([topViewController isKindOfClass:[UITabBarController class]]){
        UITabBarController *tab = (UITabBarController*) topViewController;
        return [tab selectedViewController];
    }
    
    return topViewController;
}

@end
