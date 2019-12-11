//
//  UIImage+Bundle.h
//  IRMusicPlayer
//
//  Created by Phil on 2019/11/1.
//  Copyright © 2019 Phil. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Bundle)

+ (UIImage *)imageNamedForCurrentBundle:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
