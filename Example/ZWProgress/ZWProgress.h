//
//  ZWProgress.h
//  ZWProgress
//
//  Created by Nitinan Assawanuwat on 5/19/2557 BE.
//  Copyright (c) 2557 Nitinan Assawanuwat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZWProgress : UIView

@property (nonatomic, strong) NSLayoutConstraint *bottomContraint;
@property (nonatomic, strong) UIViewController *currentController;

+ (void) showProgress;
+ (void) dismiss;

@end
