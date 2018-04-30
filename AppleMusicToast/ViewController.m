//
//  ViewController.m
//  AppleMusicToast
//
//  Created by YICAI YANG on 2018/4/30.
//  Copyright © 2018 William Steven Brohawn. All rights reserved.
//

#import "ViewController.h"
#import "AMToastView.h"

@interface ViewController()

@property( nonatomic, strong ) UIButton             *button;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self setButton:({
        UIButton *aButton = [[UIButton alloc] init];
        [aButton setTitle:NSLocalizedString(@"Show toast", nil) forState:UIControlStateNormal];
        [aButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [aButton setTitleColor:[UIColor colorWithWhite:1 alpha:.4f] forState:UIControlStateHighlighted];
        [aButton setBackgroundColor:[self.view tintColor]];
        [aButton setContentEdgeInsets:UIEdgeInsetsMake(0, 44, 0, 44)];
        [aButton addTarget:self action:@selector(showToast) forControlEvents:UIControlEventTouchUpInside];
        [aButton.layer setMask:[CAShapeLayer layer]];
        [aButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.view addSubview:aButton];
        [aButton.heightAnchor constraintEqualToConstant:48.0f].active = YES;
        [aButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
        [aButton.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor].active = YES;
        aButton;
    })];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    UIBezierPath *path = [UIBezierPath smoothRoundedRect:self.button.bounds cornerRadius:8.0f];
    [((CAShapeLayer *)self.button.layer.mask) setPath:[path CGPath]];
}

- (void)showToast
{
    [AMToastView presentFromRootView:self.view withMessage:NSLocalizedString(@"Added to Library", nil)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
