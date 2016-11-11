//
//  TransitionManager.m
//  BuyerCenturySquare
//
//  Created by skyxfire on 10/29/15.
//  Copyright © 2015 pactera. All rights reserved.
//

#import "TransitionManager.h"

#define SCREEN_WIDTH MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)
#define SCREEN_HEIGHT MAX([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width)

@implementation TransitionManager

// This is used for percent driven interactive transitions, as well as for container controllers that have companion animations that might need to
// synchronize with the main animation.
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.75;
}
// This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
//    UIViewController *fromViewController =
//    (UIViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController =
    (UIViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:[toViewController view]];
    
    toViewController.view.transform =  CGAffineTransformMakeTranslation(0, SCREEN_HEIGHT);
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        toViewController.view.transform =  CGAffineTransformMakeTranslation(0, 0);
    }];
}

@end
