//
//  ViewController.m
//  ZWProgress
//
//  Created by Nitinan Assawanuwat on 5/19/2557 BE.
//  Copyright (c) 2557 Nitinan Assawanuwat. All rights reserved.
//

#import "ViewController.h"
#import "ZWProgress.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [ZWProgress showProgress];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [ZWProgress dismiss];
    });
}

@end
