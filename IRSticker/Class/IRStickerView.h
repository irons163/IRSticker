//
//  IRStickerView.h
//  IRSticker
//
//  Created by Phil on 2019/9/6.
//  Copyright © 2019 Phil. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol IRStickerViewDelegate;

@interface IRStickerView : UIView

@property (assign, nonatomic) BOOL enabledControl; // determine the control view is shown or not, default is YES
@property (assign, nonatomic) BOOL enabledShakeAnimation; // default is YES
@property (assign, nonatomic) BOOL enabledBorder; // default is YES

@property (strong, nonatomic) UIImage *contentImage;
@property (assign, nonatomic) id<IRStickerViewDelegate> delegate;

- (instancetype)initWithContentFrame:(CGRect)frame contentImage:(UIImage *)contentImage;

- (void)performTapOperation;

@end

@protocol IRStickerViewDelegate <NSObject>

@optional

- (void)ir_StickerViewDidTapContentView:(IRStickerView *)stickerView;

- (UIImage *)ir_StickerView:(IRStickerView *)stickerView imageForLeftTopControl:(CGSize)recommendedSize;

- (void)ir_StickerViewDidTapLeftTopControl:(IRStickerView *)stickerView; // Effective when image is provided.

- (UIImage *)ir_StickerView:(IRStickerView *)stickerView imageForRightTopControl:(CGSize)recommendedSize;

- (void)ir_StickerViewDidTapRightTopControl:(IRStickerView *)stickerView; // Effective when image is provided.

- (UIImage *)ir_StickerView:(IRStickerView *)stickerView imageForLeftBottomControl:(CGSize)recommendedSize;

- (void)ir_StickerViewDidTapLeftBottomControl:(IRStickerView *)stickerView; // Effective when image is provided.

- (UIImage *)ir_StickerView:(IRStickerView *)stickerView imageForRightBottomControl:(CGSize)recommendedSize;

- (void)ir_StickerViewDidTapRightBottomControl:(IRStickerView *)stickerView; // Effective when image is provided.

@end
NS_ASSUME_NONNULL_END
