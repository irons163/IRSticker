//
//  ViewController.m
//  demo
//
//  Created by Phil on 2019/9/6.
//  Copyright © 2019 Phil. All rights reserved.
//

#import "ViewController.h"
#import <IRSticker/IRSticker.h>

@interface ViewController () <IRStickerViewDelegate>

@property (strong, nonatomic) IRStickerView *selectedSticker;

@property (strong,nonatomic) UIDynamicAnimator * animator;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initial];
}

- (void)initial {
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackground:)];
    [tapRecognizer setNumberOfTapsRequired:1];
    [self.view addGestureRecognizer:tapRecognizer];
    
    IRStickerView *sticker1 = [[IRStickerView alloc] initWithContentFrame:CGRectMake(0, 0, 150, 150) contentImage:[UIImage imageNamed:@"sticker1.png"]];
    sticker1.center = self.view.center;
    sticker1.enabledControl = NO;
    sticker1.enabledBorder = NO;
    sticker1.delegate = self;
    sticker1.tag = 1;
    [self.view addSubview:sticker1];
    
    IRStickerView *sticker2 = [[IRStickerView alloc] initWithContentFrame:CGRectMake(0, 0, 150, 150) contentImage:[UIImage imageNamed:@"sticker2.png"]];
    sticker2.center = self.view.center;
    sticker2.enabledControl = NO;
    sticker2.enabledBorder = NO;
    sticker2.delegate = self;
    sticker2.tag = 2;
    [self.view addSubview:sticker2];
    
    IRStickerView *sticker3 = [[IRStickerView alloc] initWithContentFrame:CGRectMake(0, 0, 150, 150) contentImage:[UIImage imageNamed:@"sticker3.png"]];
    sticker3.center = self.view.center;
    sticker3.enabledControl = NO;
    sticker3.enabledBorder = NO;
    sticker3.delegate = self;
    sticker3.tag = 3;
    [self.view addSubview:sticker3];
    
    [sticker1 performTapOperation];
}

- (void)tapBackground:(UITapGestureRecognizer *)recognizer {
    if (self.selectedSticker) {
        self.selectedSticker.enabledControl = NO;
        self.selectedSticker.enabledBorder = NO;
        self.selectedSticker = nil;
    }
}

#pragma mark - StickerViewDelegate

- (UIImage *)ir_StickerView:(IRStickerView *)stickerView imageForRightTopControl:(CGSize)recommendedSize {
    return [UIImage imageNamed:@"StickerView.bundle/btn_smile.png"];
}

- (UIImage *)ir_StickerView:(IRStickerView *)stickerView imageForLeftBottomControl:(CGSize)recommendedSize {
    return [UIImage imageNamed:@"StickerView.bundle/btn_flip.png"];
}

- (void)ir_StickerViewDidTapContentView:(IRStickerView *)stickerView {
    NSLog(@"Tap[%zd] ContentView", stickerView.tag);
    if (self.selectedSticker) {
        self.selectedSticker.enabledBorder = NO;
        self.selectedSticker.enabledControl = NO;
    }
    self.selectedSticker = stickerView;
    self.selectedSticker.enabledBorder = YES;
    self.selectedSticker.enabledControl = YES;
}

- (void)ir_StickerViewDidTapDeleteControl:(IRStickerView *)stickerView {
    NSLog(@"Tap[%zd] DeleteControl", stickerView.tag);
    for (UIView *subView in self.view.subviews) {
        if ([subView isKindOfClass:[IRStickerView class]]) {
            [(IRStickerView *)subView performTapOperation];
            break;
        }
    }
}

- (void)ir_StickerViewDidTapLeftBottomControl:(IRStickerView *)stickerView {
    NSLog(@"Tap[%zd] LeftBottomControl", stickerView.tag);
    UIImageOrientation targetOrientation = (stickerView.contentImage.imageOrientation == UIImageOrientationUp ? UIImageOrientationUpMirrored : UIImageOrientationUp);
    UIImage *invertImage =[UIImage imageWithCGImage:stickerView.contentImage.CGImage
                                              scale:1.0
                                        orientation:targetOrientation];
    stickerView.contentImage = invertImage;
}

- (void)ir_StickerViewDidTapRightTopControl:(IRStickerView *)stickerView {
    NSLog(@"Tap[%zd] RightTopControl", stickerView.tag);
    [_animator removeAllBehaviors];
    UISnapBehavior * snapbehavior = [[UISnapBehavior alloc] initWithItem:stickerView snapToPoint:self.view.center];
    snapbehavior.damping = 0.65;
    [self.animator addBehavior:snapbehavior];
}

@end

