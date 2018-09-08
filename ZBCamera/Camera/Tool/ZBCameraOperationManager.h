//
//  ZBCameraOperationManager.h
//
//  Created by zeinber on 2018/9/5.
//  Copyright (c) 2018年 zeinber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "ZBCameraControllerDelegate.h"
//摄像头
enum ZBCameraChoose {
    ZBCameraFront=0,
    ZBCameraBack
};
//闪光灯
enum ZBFlashLightState {
    ZBFlashLightOff = 0,//关闭
    ZBFlashLightOpen,//开启
    ZBFlashLightAuto,//自动
    ZBFlashLightDisabled//不可用
};
@interface ZBCameraOperationManager : NSObject
///闪光灯状态
@property(nonatomic,assign)enum ZBFlashLightState flashLightState;
///摄像头状态
@property(nonatomic,assign)enum ZBCameraChoose cameraChoose;
///显示涂层
@property(nonatomic,strong) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;
///摄像头方向
@property (nonatomic, assign) AVCaptureVideoOrientation captureVideoOrientation;
///代理
@property(nonatomic,weak)id<ZBCameraControllerDelegate>cameraDelegate;
///初始化camera
-(void)initializeCameraWithPreview:(UIImageView *)preview;
///初始化AVCaptureSession
-(void)setCaptureSession;
- (AVCaptureDevice *)choseCamera;
///捕捉图片
- (void)captureImage;
///开始采集
- (void)startCaptureImage;
///停止采集
- (void)stopCaptureImageWithIsCallBack:(BOOL)isCallBack;
@end
