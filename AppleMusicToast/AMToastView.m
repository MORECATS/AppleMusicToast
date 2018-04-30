//
//  AMToastView.m
//  AppleMusicToast
//
//  Created by YICAI YANG on 2018/4/30.
//  Copyright © 2018 William Steven Brohawn. All rights reserved.
//

#import "AMToastView.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation UIDevice( AMToastViewDeviceExtension )

+ (void)impactBroveNotificationFeedbackIfAvailable
{
    if( NSClassFromString(@"UINotificationFeedbackGenerator") )
    {
        UINotificationFeedbackGenerator *generator = [[UINotificationFeedbackGenerator alloc] init];
        [generator prepare];
        [generator notificationOccurred:UINotificationFeedbackTypeSuccess];
    }
}

@end

#define TOP_LEFTR(X, Y)     CGPointMake(rect.origin.x + X * limitedRadius,\
rect.origin.y + Y * limitedRadius)
#define TOP_RIGHT(X, Y)     CGPointMake(rect.origin.x + rect.size.width - X * limitedRadius,\
rect.origin.y + Y * limitedRadius)
#define BTM_RIGHT(X, Y)     CGPointMake(rect.origin.x + rect.size.width - X * limitedRadius,\
rect.origin.y + rect.size.height - Y * limitedRadius)
#define BTM_LEFTR(X, Y)     CGPointMake(rect.origin.x + X * limitedRadius,\
rect.origin.y + rect.size.height - Y * limitedRadius)

@implementation UIBezierPath( AMToastViewPathExtension )

+ (UIBezierPath *)smoothRoundedRect:(CGRect)rect cornerRadius:(CGFloat)radius
{
    UIBezierPath* path = UIBezierPath.bezierPath;
    CGFloat limit = MIN(rect.size.width, rect.size.height) / 2 / 1.52866483;
    CGFloat limitedRadius = MIN(radius, limit);
    
    [path     moveToPoint:TOP_LEFTR(1.52866483, 0.00000000)];
    [path  addLineToPoint:TOP_RIGHT(1.52866471, 0.00000000)];
    [path addCurveToPoint:TOP_RIGHT(0.66993427, 0.06549600)
            controlPoint1:TOP_RIGHT(1.08849323, 0.00000000)
            controlPoint2:TOP_RIGHT(0.86840689, 0.00000000)];
    [path  addLineToPoint:TOP_RIGHT(0.63149399, 0.07491100)];
    [path addCurveToPoint:TOP_RIGHT(0.07491176, 0.63149399)
            controlPoint1:TOP_RIGHT(0.37282392, 0.16905899)
            controlPoint2:TOP_RIGHT(0.16906013, 0.37282401)];
    [path addCurveToPoint:TOP_RIGHT(0.00000000, 1.52866483)
            controlPoint1:TOP_RIGHT(0.00000000, 0.86840701)
            controlPoint2:TOP_RIGHT(0.00000000, 1.08849299)];
    [path  addLineToPoint:BTM_RIGHT(0.00000000, 1.52866471)];
    [path addCurveToPoint:BTM_RIGHT(0.06549569, 0.66993493)
            controlPoint1:BTM_RIGHT(0.00000000, 1.08849323)
            controlPoint2:BTM_RIGHT(0.00000000, 0.86840689)];
    [path  addLineToPoint:BTM_RIGHT(0.07491111, 0.63149399)];
    [path addCurveToPoint:BTM_RIGHT(0.63149399, 0.07491111)
            controlPoint1:BTM_RIGHT(0.16905883, 0.37282392)
            controlPoint2:BTM_RIGHT(0.37282392, 0.16905883)];
    [path addCurveToPoint:BTM_RIGHT(1.52866471, 0.00000000)
            controlPoint1:BTM_RIGHT(0.86840689, 0.00000000)
            controlPoint2:BTM_RIGHT(1.08849323, 0.00000000)];
    [path  addLineToPoint:BTM_LEFTR(1.52866483, 0.00000000)];
    [path addCurveToPoint:BTM_LEFTR(0.66993397, 0.06549569)
            controlPoint1:BTM_LEFTR(1.08849299, 0.00000000)
            controlPoint2:BTM_LEFTR(0.86840701, 0.00000000)];
    [path  addLineToPoint:BTM_LEFTR(0.63149399, 0.07491111)];
    [path addCurveToPoint:BTM_LEFTR(0.07491100, 0.63149399)
            controlPoint1:BTM_LEFTR(0.37282401, 0.16905883)
            controlPoint2:BTM_LEFTR(0.16906001, 0.37282392)];
    [path addCurveToPoint:BTM_LEFTR(0.00000000, 1.52866471)
            controlPoint1:BTM_LEFTR(0.00000000, 0.86840689)
            controlPoint2:BTM_LEFTR(0.00000000, 1.08849323)];
    [path  addLineToPoint:TOP_LEFTR(0.00000000, 1.52866483)];
    [path addCurveToPoint:TOP_LEFTR(0.06549600, 0.66993397)
            controlPoint1:TOP_LEFTR(0.00000000, 1.08849299)
            controlPoint2:TOP_LEFTR(0.00000000, 0.86840701)];
    [path  addLineToPoint:TOP_LEFTR(0.07491100, 0.63149399)];
    [path addCurveToPoint:TOP_LEFTR(0.63149399, 0.07491100)
            controlPoint1:TOP_LEFTR(0.16906001, 0.37282401)
            controlPoint2:TOP_LEFTR(0.37282401, 0.16906001)];
    [path addCurveToPoint:TOP_LEFTR(1.52866483, 0.00000000)
            controlPoint1:TOP_LEFTR(0.86840701, 0.00000000)
            controlPoint2:TOP_LEFTR(1.08849299, 0.00000000)];
    [path closePath];
    return path;
}

@end

@interface AMToastView()<CAAnimationDelegate>

@property( nonatomic, strong ) UIVisualEffectView               *centerView;

@property( nonatomic, strong ) CAShapeLayer                     *checkmarkLayer;
@property( nonatomic, strong ) UILabel                          *textLabel;

@end

@implementation AMToastView

+ (instancetype)presentFromRootView:(UIView *)view withMessage:(NSString *)message
{
    AMToastView *toastView = [[AMToastView alloc] init];
    
    [toastView.textLabel setText:message];
    
    [toastView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [view addSubview:toastView];
    [toastView.topAnchor constraintEqualToAnchor:view.topAnchor].active = YES;
    [toastView.leftAnchor constraintEqualToAnchor:view.leftAnchor].active = YES;
    [toastView.rightAnchor constraintEqualToAnchor:view.rightAnchor].active = YES;
    [toastView.bottomAnchor constraintEqualToAnchor:view.bottomAnchor].active = YES;
    
    [toastView setTransform:CGAffineTransformMakeScale(.8f, .8f)];
    [toastView layoutIfNeeded];
    [UIView animateWithDuration:.25f delay:.0f options:( 7 << 16 )
                     animations:^{ [toastView animateToVisible]; }
                     completion:^(BOOL f){ [toastView animateToCheck]; }];
    
    return toastView;
}

- (void)animateToVisible
{
    if( @available(iOS 11.0, *) )
    {
        [self.centerView setEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
    }
    else
    {
        [self.centerView setBackgroundColor:[UIColor whiteColor]];
    }
    [self setTransform:CGAffineTransformIdentity];
    [self.textLabel setAlpha:1.0f];
}

- (void)animateToInvisible
{
    [self setTransform:CGAffineTransformMakeScale(.8f, .8f)];
    [self setAlpha:0];
}

- (void)animateToCheck
{
    NSURL *URL = [NSURL URLWithString:@"/System/Library/Audio/UISounds/payment_success.caf"];
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)URL, &soundID);
    AudioServicesPlaySystemSound(soundID);
    
    [UIDevice impactBroveNotificationFeedbackIfAvailable];
    
    [self.checkmarkLayer setPath:({
        UIBezierPath *f = [UIBezierPath bezierPath];
        [f moveToPoint:CGPointMake(74, 100)];
        [f addLineToPoint:CGPointMake(108, 140)];
        [f addLineToPoint:CGPointMake(184, 66)];
        [f CGPath];
    })];
    [self.checkmarkLayer addAnimation:({
        CABasicAnimation *f = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        [f setDuration:.6f];
        [f setFromValue:@(.0f)];
        [f setToValue:@(1.0f)];
        [f setTimingFunction:[CAMediaTimingFunction functionWithControlPoints:.23 :1 :.32 :1]];
        [f setRemovedOnCompletion:YES];
        [f setDelegate:self];
        f;
    }) forKey:nil];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [UIView animateWithDuration:.25f delay:.5f options:( 7 << 16)
                     animations:^{ [self animateToInvisible]; }
                     completion:^(BOOL f){ [self finialAnimations]; }];
}

- (void)finialAnimations
{
    if( self.toastDismissed )
    {
        self.toastDismissed();
    }
    [self removeFromSuperview];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    UIBezierPath *path = [UIBezierPath smoothRoundedRect:self.centerView.bounds cornerRadius:20.0f];
    [((CAShapeLayer *)self.centerView.layer.mask) setPath:path.CGPath];
}

- (instancetype)init
{
    if( [super init] )
    {
        [self setBackgroundColor:[UIColor clearColor]];
        
        [self setCenterView:({
            UIVisualEffectView *f = [[UIVisualEffectView alloc] init];
            [f setUserInteractionEnabled:NO];
            [f.layer setMask:[CAShapeLayer layer]];
            [f setTranslatesAutoresizingMaskIntoConstraints:NO];
            [self addSubview:f];
            [f.widthAnchor constraintEqualToConstant:244.0f].active = YES;
            [f.heightAnchor constraintEqualToAnchor:f.widthAnchor].active = YES;
            [f.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
            [f.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
            f;
        })];
        [self setCheckmarkLayer:({
            CAShapeLayer *f = [CAShapeLayer layer];
            [f setBackgroundColor:[UIColor clearColor].CGColor];
            [f setFillColor:[UIColor clearColor].CGColor];
            [f setStrokeColor:[UIColor colorWithWhite:89 / 255.0f alpha:1.0f].CGColor];
            [f setFrame:CGRectMake(0, 0, 244, 244)];
            [f setLineWidth:10.0f];
            [f setLineCap:kCALineCapRound];
            [f setLineJoin:kCALineJoinRound];
            [f setStrokeStart:0];
            [f setStrokeEnd:1.0];
            [self.centerView.contentView.layer addSublayer:f];
            f;
        })];
        [self setTextLabel:({
            UILabel *f = [[UILabel alloc] init];
            [f setAlpha:.0f];
            [f setBackgroundColor:[UIColor clearColor]];
            [f setTextAlignment:NSTextAlignmentCenter];
            [f setFont:({
                UIFontDescriptor *fontDescriptor =
                [UIFont preferredFontForTextStyle:UIFontTextStyleTitle3].fontDescriptor;
                [UIFont systemFontOfSize:fontDescriptor.pointSize weight:UIFontWeightBold];
            })];
            [f setTextColor:[UIColor colorWithWhite:89 / 255.0f alpha:1.0f]];
            [f setTranslatesAutoresizingMaskIntoConstraints:NO];
            [self addSubview:f];
            [f.bottomAnchor constraintEqualToAnchor:self.centerView.bottomAnchor constant:-36.0f].active = YES;
            [f.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
            f;
        })];
    }
    return self;
}

@end
