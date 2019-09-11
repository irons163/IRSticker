//
//  IRStickerGestureRecognizer.m
//  IRSticker
//
//  Created by Phil on 2019/9/6.
//  Copyright © 2019 Phil. All rights reserved.
//

#import "IRStickerGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

@interface IRStickerGestureRecognizer ()

@property (strong, nonatomic) UIView *anchorView;

@end

@implementation IRStickerGestureRecognizer

- (nonnull instancetype)initWithTarget:(nullable id)target action:(nullable SEL)action anchorView:(nonnull UIView *)anchorView {
    IRStickerGestureRecognizer *gesture = [[IRStickerGestureRecognizer alloc] initWithTarget:target action:action];
    gesture.anchorView = anchorView;
    return gesture;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // Only support single hand.
    if ([[event touchesForGestureRecognizer:self] count] > 1) {
        self.state = UIGestureRecognizerStateFailed;
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.state == UIGestureRecognizerStatePossible) {
        self.state = UIGestureRecognizerStateBegan;
    } else {
        self.state = UIGestureRecognizerStateChanged;
    }
    
    UITouch *touch = [touches anyObject];
    CGPoint anchorViewCenter = self.anchorView.center;
    CGPoint currentPoint = [touch locationInView:self.anchorView.superview];
    CGPoint previousPoint = [touch previousLocationInView:self.anchorView.superview];
    
    CGFloat currentRotation = atan2f((currentPoint.y - anchorViewCenter.y), (currentPoint.x - anchorViewCenter.x));
    CGFloat previousRotation = atan2f((previousPoint.y - anchorViewCenter.y), (previousPoint.x - anchorViewCenter.x));
    
    CGFloat currentRadius = [self distanceBetweenFirstPoint:currentPoint secondPoint:anchorViewCenter];
    CGFloat previousRadius = [self distanceBetweenFirstPoint:previousPoint secondPoint:anchorViewCenter];
    CGFloat scale = currentRadius / previousRadius;
    
    [self setRotation:(currentRotation - previousRotation)];
    [self setScale:scale];
}

- (CGFloat)distanceBetweenFirstPoint:(CGPoint)first secondPoint:(CGPoint)second {
    CGFloat deltaX = second.x - first.x;
    CGFloat deltaY = second.y - first.y;
    return sqrt(deltaX * deltaX + deltaY * deltaY);
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.state == UIGestureRecognizerStateChanged) {
        self.state = UIGestureRecognizerStateEnded;
    } else {
        self.state = UIGestureRecognizerStateFailed;
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.state = UIGestureRecognizerStateFailed;
}

- (void)reset {
    self.rotation = 0;
    self.scale = 1;
}

@end
