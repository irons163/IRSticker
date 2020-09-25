![Build Status](https://img.shields.io/badge/build-%20passing%20-brightgreen.svg)
![Platform](https://img.shields.io/badge/Platform-%20iOS%20-blue.svg)

# IRSticker 

- IRSticker is a powerful sticker for iOS.
- See swift version in here: [IRSticker-swift](https://github.com/irons163/IRSticker-swift).

## Features
- Customize your stickers image.
- Customize your sitcker functions, max to 4.
- Default functions support:
    - Delete
    - Flip
    - Move back to center of main view
    - Scale and move

## Install
### Git
- Git clone this project.
- Copy this project into your own project.
- Add the .xcodeproj into you  project and link it as embed framework.
#### Options
- You can remove the `demo` and `ScreenShots` folder.

### Cocoapods
- Add `pod 'IRSticker'`  in the `Podfile`
- `pod install`

## Usage

### Basic
- Add StickerView.
```obj-c
#import <IRSticker/IRSticker.h>

IRStickerView *sticker1 = [[IRStickerView alloc] initWithContentFrame:CGRectMake(0, 0, 150, 150) contentImage:[UIImage imageNamed:@"sticker1.png"]];
sticker1.center = self.view.center;
sticker1.enabledControl = NO;
sticker1.enabledBorder = NO;
sticker1.tag = 1;
sticker1.delegate = self;
[self.view addSubview:sticker1];
```

- Use `IRStickerViewDelegate`, see in the demo project.
```obj-c
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
```

## Screenshots
| Stickers | After effections |
|:---:|:---:|
| ![Demo](./ScreenShots/demo1.png) | ![Passcode Settings](./ScreenShots/demo2.png) |

## Copyright
##### This project is inspired from [Single-hand-Sticker](https://github.com/chenkaijie4ever/Single-hand-Sticker).
