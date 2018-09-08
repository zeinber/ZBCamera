//
//  ZBCameraView.h
//
//  Created by zeinber on 2018/9/5.
//  Copyright © 2018年 zeinber. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZBCameraView : UIView
@property (nonatomic, strong) UIButton *photoCaptureButton;//拍照按钮
@property (nonatomic, strong) UIButton *cameraToggleButton;//摄像头切换
@property (nonatomic, strong) UIButton *flashToggleButton;//闪光灯控制
@property (nonatomic, strong) UIImageView *imagePreview;//拍照取景显示
@property (nonatomic, strong) UIView *photoBar;//拍照dock
@property (nonatomic, strong) UIButton *canceOrCloseButton;//关闭按钮
@property (nonatomic, strong) UIButton *sureImageButton;//选择照片
@end
