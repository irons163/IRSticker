//
//  IRStickerView.m
//  IRSticker
//
//  Created by Phil on 2019/9/6.
//  Copyright © 2019 Phil. All rights reserved.
//

#import "IRStickerView.h"
#import "IRStickerGestureRecognizer.h"
#import "UIImage+Bundle.h"

#define kStickerControlViewSize 30
#define kStickerHalfControlViewSize 15

#define kStickerMinScale 0.5f
#define kStickerMaxScale 2.0f

@interface IRStickerView () <UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIImageView *contentView;

@property (strong, nonatomic) UIImageView *leftTopControl;
@property (strong, nonatomic) UIImageView *rightTopControl;
@property (strong, nonatomic) UIImageView *leftBottomControl;
@property (strong, nonatomic) UIImageView *rightBottomControl;

@property (strong, nonatomic) CAShapeLayer *shapeLayer;

@property (assign, nonatomic) BOOL enableLeftTopControl;
@property (assign, nonatomic) BOOL enableRightTopControl;
@property (assign, nonatomic) BOOL enableLeftBottomControl;
@property (assign, nonatomic) BOOL enableRightBottomControl;

@end

@implementation IRStickerView

#pragma mark - Initial

- (instancetype)initWithContentFrame:(CGRect)frame contentImage:(UIImage *)contentImage {
    self = [super initWithFrame:CGRectMake(frame.origin.x - kStickerHalfControlViewSize, frame.origin.y - kStickerHalfControlViewSize, frame.size.width + kStickerControlViewSize, frame.size.height + kStickerControlViewSize)];
    if (self) {
        self.contentView = [[UIImageView alloc] initWithFrame:CGRectMake(kStickerHalfControlViewSize, kStickerHalfControlViewSize, frame.size.width, frame.size.height)];
        self.contentImage = contentImage;
        [self addSubview:self.contentView];
        
        self.rightBottomControl = [[UIImageView alloc] initWithFrame:CGRectMake(self.contentView.center.x + self.contentView.bounds.size.width / 2 - kStickerHalfControlViewSize, self.contentView.center.y + self.contentView.bounds.size.height / 2 - kStickerHalfControlViewSize, kStickerControlViewSize, kStickerControlViewSize)];
        self.rightBottomControl.image = [UIImage imageNamedForCurrentBundle:@"IRSticker.bundle/btn_resize.png"];
        [self addSubview:self.rightBottomControl];
        
        self.leftTopControl = [[UIImageView alloc] initWithFrame:CGRectMake(self.contentView.center.x - self.contentView.bounds.size.width / 2 - kStickerHalfControlViewSize, self.contentView.center.y - self.contentView.bounds.size.height / 2 - kStickerHalfControlViewSize, kStickerControlViewSize, kStickerControlViewSize)];
        self.leftTopControl.image = [UIImage imageNamedForCurrentBundle:@"IRSticker.bundle/btn_delete.png"];
        [self addSubview:self.leftTopControl];
        
        self.rightTopControl = [[UIImageView alloc] initWithFrame:CGRectMake(self.contentView.center.x + self.contentView.bounds.size.width / 2 - kStickerHalfControlViewSize, self.contentView.center.y - self.contentView.bounds.size.height / 2 - kStickerHalfControlViewSize, kStickerControlViewSize, kStickerControlViewSize)];
        self.rightTopControl.image = [UIImage imageNamedForCurrentBundle:@"IRSticker.bundle/btn_smile.png"];
        [self addSubview:self.rightTopControl];
        
        self.leftBottomControl = [[UIImageView alloc] initWithFrame:CGRectMake(self.contentView.center.x - self.contentView.bounds.size.width / 2 - kStickerHalfControlViewSize, self.contentView.center.y + self.contentView.bounds.size.height / 2 - kStickerHalfControlViewSize, kStickerControlViewSize, kStickerControlViewSize)];
        self.leftBottomControl.image = [UIImage imageNamedForCurrentBundle:@"IRSticker.bundle/btn_flip.png"];
        [self addSubview:self.leftBottomControl];
        
        [self initShapeLayer];
        [self setupConfig];
        [self attachGestures];
    }
    return self;
}

- (void)initShapeLayer {
    _shapeLayer = [CAShapeLayer layer];
    CGRect shapeRect = self.contentView.frame;
    [_shapeLayer setBounds:shapeRect];
    [_shapeLayer setPosition:CGPointMake(self.contentView.frame.size.width / 2, self.contentView.frame.size.height / 2)];
    [_shapeLayer setFillColor:[[UIColor clearColor] CGColor]];
    [_shapeLayer setStrokeColor:[[UIColor whiteColor] CGColor]];
    [_shapeLayer setLineWidth:2.0f];
    [_shapeLayer setLineJoin:kCALineJoinRound];
    _shapeLayer.allowsEdgeAntialiasing = YES;
    [_shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:5], [NSNumber numberWithInt:3], nil]];
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, shapeRect);
    [_shapeLayer setPath:path];
    CGPathRelease(path);
}

- (void)setupConfig {
    self.exclusiveTouch = YES;
    
    self.userInteractionEnabled = YES;
    self.contentView.userInteractionEnabled = YES;
    self.rightBottomControl.userInteractionEnabled = YES;
    self.leftTopControl.userInteractionEnabled = YES;
    self.rightTopControl.userInteractionEnabled = YES;
    self.leftBottomControl.userInteractionEnabled = YES;
    
    _enableRightTopControl = NO;
    _enableLeftBottomControl = NO;
    _enableLeftTopControl = YES;
    _enableRightBottomControl = YES;
    self.enabledControl = YES;
    
    _enabledShakeAnimation = YES;
    self.enabledBorder = YES;
}

- (void)attachGestures {
    // ContentView
    UIRotationGestureRecognizer *rotateGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotate:)];
    [rotateGesture setDelegate:self];
    [self.contentView addGestureRecognizer:rotateGesture];
    
    UIPinchGestureRecognizer *pinGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handleScale:)];
    [pinGesture setDelegate:self];
    [self.contentView addGestureRecognizer:pinGesture];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleMove:)];
    [panGesture setMinimumNumberOfTouches:1];
    [panGesture setMaximumNumberOfTouches:2];
    [panGesture setDelegate:self];
    [self.contentView addGestureRecognizer:panGesture];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [tapRecognizer setNumberOfTapsRequired:1];
    [tapRecognizer setDelegate:self];
    [self.contentView addGestureRecognizer:tapRecognizer];
    
    // DeleteControl
    UITapGestureRecognizer *tapRecognizer2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [tapRecognizer2 setNumberOfTapsRequired:1];
    [tapRecognizer2 setDelegate:self];
    [self.leftTopControl addGestureRecognizer:tapRecognizer2];
    
    // RightTopControl
    UITapGestureRecognizer *tapRecognizer3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [tapRecognizer3 setNumberOfTapsRequired:1];
    [tapRecognizer3 setDelegate:self];
    [self.rightTopControl addGestureRecognizer:tapRecognizer3];
    
    // LeftBottomControl
    UITapGestureRecognizer *tapRecognizer4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [tapRecognizer4 setNumberOfTapsRequired:1];
    [tapRecognizer4 setDelegate:self];
    [self.leftBottomControl addGestureRecognizer:tapRecognizer4];
    
    // ResizeControl
    IRStickerGestureRecognizer *singleHandGesture = [[IRStickerGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleHandAction:) anchorView:self.contentView];
    [self.rightBottomControl addGestureRecognizer:singleHandGesture];
    
    UITapGestureRecognizer *tapRecognizer5 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [tapRecognizer5 setNumberOfTapsRequired:1];
    [tapRecognizer5 setDelegate:self];
    [self.rightBottomControl addGestureRecognizer:tapRecognizer5];
}

#pragma mark - Handle Gestures

- (void)handleTap:(UITapGestureRecognizer *)gesture {
    if (gesture.view == self.contentView) {
        [self handleTapContentView];
    } else if (gesture.view == self.leftTopControl) {
        if (_enableLeftTopControl) {
            if (_delegate && [_delegate respondsToSelector:@selector(ir_StickerViewDidTapLeftTopControl:)]) {
                [_delegate ir_StickerViewDidTapLeftTopControl:self];
            } else {
                // Default : remove from super view.
                [self removeFromSuperview];
            }
        }
    } else if (gesture.view == self.rightTopControl) {
        if (_enableRightTopControl) {
            if (_delegate && [_delegate respondsToSelector:@selector(ir_StickerViewDidTapRightTopControl:)]) {
                [_delegate ir_StickerViewDidTapRightTopControl:self];
            }
        }
    } else if (gesture.view == self.leftBottomControl) {
        if (_enableLeftBottomControl) {
            if (_delegate && [_delegate respondsToSelector:@selector(ir_StickerViewDidTapLeftBottomControl:)]) {
                [_delegate ir_StickerViewDidTapLeftBottomControl:self];
            }
        }
    } else if (gesture.view == self.rightBottomControl) {
        if (_enableRightBottomControl) {
            if (_delegate && [_delegate respondsToSelector:@selector(ir_StickerViewDidTapRightBottomControl:)]) {
                [_delegate ir_StickerViewDidTapRightBottomControl:self];
            }
        }
    }
}

- (void)handleTapContentView {
    [self.superview bringSubviewToFront:self];
    // Perform animation
    if (_enabledShakeAnimation) {
        [self performShakeAnimation:self];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(ir_StickerViewDidTapContentView:)]) {
        [_delegate ir_StickerViewDidTapContentView:self];
    }
}

- (void)handleMove:(UIPanGestureRecognizer *)gesture {
    CGPoint translation = [gesture translationInView:[self superview]];
    // Boundary detection
    CGPoint targetPoint = CGPointMake(self.center.x + translation.x, self.center.y + translation.y);
    targetPoint.x = MAX(0, targetPoint.x);
    targetPoint.y = MAX(0, targetPoint.y);
    targetPoint.x = MIN(self.superview.bounds.size.width, targetPoint.x);
    targetPoint.y = MIN(self.superview.bounds.size.height, targetPoint.y);
    
    [self setCenter:targetPoint];
    [gesture setTranslation:CGPointZero inView:[self superview]];
}

- (void)handleScale:(UIPinchGestureRecognizer *)gesture {
    CGFloat scale = gesture.scale;
    // Scale limit
    CGFloat currentScale = [[self.contentView.layer valueForKeyPath:@"transform.scale"] floatValue];
    if (scale * currentScale <= kStickerMinScale) {
        scale = kStickerMinScale / currentScale;
    } else if (scale * currentScale >= kStickerMaxScale) {
        scale = kStickerMaxScale / currentScale;
    }
    
    self.contentView.transform = CGAffineTransformScale(self.contentView.transform, scale, scale);
    gesture.scale = 1;
    
    [self relocalControlView];
}

- (void)handleRotate:(UIRotationGestureRecognizer *)gesture {
    self.contentView.transform = CGAffineTransformRotate(self.contentView.transform, gesture.rotation);
    gesture.rotation = 0;
    
    [self relocalControlView];
}

- (void)handleSingleHandAction:(IRStickerGestureRecognizer *)gesture {
    CGFloat scale = gesture.scale;
    // Scale limit
    CGFloat currentScale = [[self.contentView.layer valueForKeyPath:@"transform.scale"] floatValue];
    if (scale * currentScale <= kStickerMinScale) {
        scale = kStickerMinScale / currentScale;
    } else if (scale * currentScale >= kStickerMaxScale) {
        scale = kStickerMaxScale / currentScale;
    }
    
    self.contentView.transform = CGAffineTransformScale(self.contentView.transform, scale, scale);
    self.contentView.transform = CGAffineTransformRotate(self.contentView.transform, gesture.rotation);
    [gesture reset];
    
    [self relocalControlView];
}

- (void)relocalControlView {
    CGPoint originalCenter = CGPointApplyAffineTransform(self.contentView.center, CGAffineTransformInvert(self.contentView.transform));
    self.rightBottomControl.center = CGPointApplyAffineTransform(CGPointMake(originalCenter.x + self.contentView.bounds.size.width / 2.0f, originalCenter.y + self.contentView.bounds.size.height / 2.0f), self.contentView.transform);
    self.leftTopControl.center = CGPointApplyAffineTransform(CGPointMake(originalCenter.x - self.contentView.bounds.size.width / 2.0f, originalCenter.y - self.contentView.bounds.size.height / 2.0f), self.contentView.transform);
    self.rightTopControl.center = CGPointApplyAffineTransform(CGPointMake(originalCenter.x + self.contentView.bounds.size.width / 2.0f, originalCenter.y - self.contentView.bounds.size.height / 2.0f), self.contentView.transform);
    self.leftBottomControl.center = CGPointApplyAffineTransform(CGPointMake(originalCenter.x - self.contentView.bounds.size.width / 2.0f, originalCenter.y + self.contentView.bounds.size.height / 2.0f), self.contentView.transform);
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.view == self.rightBottomControl && [gestureRecognizer isKindOfClass:[IRStickerGestureRecognizer class]]) {
        if (_enableRightBottomControl) {
            if (_delegate && [_delegate respondsToSelector:@selector(ir_StickerViewDidTapRightBottomControl:)]) {
                [_delegate ir_StickerViewDidTapRightBottomControl:self];
                return NO;
            }
        }
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]] || [otherGestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        return NO;
    } else {
        return YES;
    }
}

#pragma mark - Hit Test

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (self.hidden || !self.userInteractionEnabled || self.alpha < 0.01) {
        return nil;
    }
    if (_enabledControl) {
        if (_enableLeftTopControl && [self.leftTopControl pointInside:[self convertPoint:point toView:self.leftTopControl] withEvent:event]) {
            return self.leftTopControl;
        }
        if (_enableRightTopControl && [self.rightTopControl pointInside:[self convertPoint:point toView:self.rightTopControl] withEvent:event]) {
            return self.rightTopControl;
        }
        if (_enableLeftBottomControl && [self.leftBottomControl pointInside:[self convertPoint:point toView:self.leftBottomControl] withEvent:event]) {
            return self.leftBottomControl;
        }
        if (_enableRightBottomControl && [self.rightBottomControl pointInside:[self convertPoint:point toView:self.rightBottomControl] withEvent:event]) {
            return self.rightBottomControl;
        }
    }
    if ([self.contentView pointInside:[self convertPoint:point toView:self.contentView] withEvent:event]) {
        return self.contentView;
    }
    // return nil for other area.
    return nil;
}

#pragma mark - Other

- (void)performShakeAnimation:(UIView *)targetView {
    [targetView.layer removeAnimationForKey:@"anim"];
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.5f;
    animation.values = @[[NSValue valueWithCATransform3D:targetView.layer.transform],
                         [NSValue valueWithCATransform3D:CATransform3DScale(targetView.layer.transform, 1.05, 1.05, 1.0)],
                         [NSValue valueWithCATransform3D:CATransform3DScale(targetView.layer.transform, 0.95, 0.95, 1.0)],
                         [NSValue valueWithCATransform3D:targetView.layer.transform]
                         ];
    animation.removedOnCompletion = YES;
    [targetView.layer addAnimation:animation forKey:@"anim"];
}

- (void)performTapOperation {
    [self handleTapContentView];
}

#pragma mark - Property

- (void)setDelegate:(id<IRStickerViewDelegate>)delegate {
    if (delegate == nil) {
        NSAssert(delegate, @"Delegate shounldn't be nil!");
        return;
    }
    _delegate = delegate;
    
    if ([_delegate respondsToSelector:@selector(ir_StickerView:imageForLeftTopControl:)]) {
        UIImage *leftTopImage = [_delegate ir_StickerView:self imageForLeftTopControl:CGSizeMake(kStickerControlViewSize, kStickerControlViewSize)];
        self.rightTopControl.image = leftTopImage;
        if (leftTopImage) {
            _enableLeftTopControl = YES;
        } else {
            _enableLeftTopControl = NO;
        }
    }
    if ([_delegate respondsToSelector:@selector(ir_StickerView:imageForRightTopControl:)]) {
        UIImage *rightTopImage = [_delegate ir_StickerView:self imageForRightTopControl:CGSizeMake(kStickerControlViewSize, kStickerControlViewSize)];
        self.rightTopControl.image = rightTopImage;
        if (rightTopImage) {
            _enableRightTopControl = YES;
        } else {
            _enableRightTopControl = NO;
        }
    }
    if ([_delegate respondsToSelector:@selector(ir_StickerView:imageForLeftBottomControl:)]) {
        UIImage *leftBottomImage = [_delegate ir_StickerView:self imageForLeftBottomControl:CGSizeMake(kStickerControlViewSize, kStickerControlViewSize)];
        self.leftBottomControl.image = leftBottomImage;
        if (leftBottomImage) {
            _enableLeftBottomControl = YES;
        } else {
            _enableLeftBottomControl = NO;
        }
    }
    if ([_delegate respondsToSelector:@selector(ir_StickerView:imageForRightBottomControl:)]) {
        UIImage *rightBottomImage = [_delegate ir_StickerView:self imageForRightBottomControl:CGSizeMake(kStickerControlViewSize, kStickerControlViewSize)];
        self.rightBottomControl.image = rightBottomImage;
        if (rightBottomImage) {
            _enableRightBottomControl = YES;
        } else {
            _enableRightBottomControl = NO;
        }
    }
}

- (void)setEnabledControl:(BOOL)enabledControl {
    _enabledControl = enabledControl;
    self.leftTopControl.hidden = !_enabledControl;
    self.rightBottomControl.hidden = !_enabledControl;
    self.rightTopControl.hidden = !_enabledControl;
    self.leftBottomControl.hidden = !_enabledControl;
}

- (void)setEnabledBorder:(BOOL)enabledBorder {
    _enabledBorder = enabledBorder;
    if (_enabledBorder) {
        [self.contentView.layer addSublayer:self.shapeLayer];
    } else {
        [self.shapeLayer removeFromSuperlayer];
    }
}

- (void)setContentImage:(UIImage *)contentImage {
    _contentImage = contentImage;
    self.contentView.image = _contentImage;
}

@end
