//
//  IRStickerGestureRecognizer.h
//  IRSticker
//
//  Created by Phil on 2019/9/6.
//  Copyright © 2019 Phil. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface IRStickerGestureRecognizer : UIGestureRecognizer

@property (assign, nonatomic) CGFloat scale;
@property (assign, nonatomic) CGFloat rotation;

- (nonnull instancetype)initWithTarget:(nullable id)target action:(nullable SEL)action anchorView:(nonnull UIView *)anchorView;

- (void)reset;

@end

NS_ASSUME_NONNULL_END
