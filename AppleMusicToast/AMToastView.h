//
//  AMToastView.h
//  AppleMusicToast
//
//  Created by YICAI YANG on 2018/4/30.
//  Copyright © 2018 William Steven Brohawn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice( AMToastViewDeviceExtension )

+ (void)impactBroveNotificationFeedbackIfAvailable;

@end

@interface UIBezierPath( AMToastViewPathExtension )

+ (UIBezierPath *)smoothRoundedRect:(CGRect)rect cornerRadius:(CGFloat)radius;

@end

typedef void (^AMToastViewDismissed)(void);

@interface AMToastView : UIView

@property( nonatomic, copy ) AMToastViewDismissed           toastDismissed;

+ (instancetype)presentFromRootView:(UIView *)view withMessage:(NSString *)message;

@end
