//
//  ZBCameraOperationManager.m
//
//  Created by zeinber on 2018/9/5.
//  Copyright (c) 2018年 zeinber. All rights reserved.
//

#import "ZBCameraOperationManager.h"
#import <CoreMotion/CoreMotion.h>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
@interface ZBCameraOperationManager() {
    AVCaptureDevice *_frontCamera;//前置摄像头
    AVCaptureDevice *_backCamera;//后置摄像头
    AVCaptureDeviceInput *_frontInput;
    AVCaptureDeviceInput *_backInput;
    AVCaptureSession *_session;
    AVCaptureStillImageOutput *_stillImageOutput;//静态图片输出
    BOOL _deviceAuthorized;//相机是否授权
    dispatch_queue_t _videoQueue;
    CGFloat _captureZoom;
}
@property (nonatomic, strong) CMMotionManager *motionManager;

@end
@implementation ZBCameraOperationManager
#pragma mark - lazy load
- (CMMotionManager *)motionManager {
    if (!_motionManager) {
        _motionManager = [[CMMotionManager alloc] init];
        _motionManager.accelerometerUpdateInterval = 0.01;
    }
    return _motionManager;
}

#pragma mark - init
- (instancetype)init {
    if (self = [super init]) {
        if (!_videoQueue) {
            _videoQueue = dispatch_queue_create("com.zeinber.VideoQueue", DISPATCH_QUEUE_SERIAL);
        }
        if (!_session) {
            _session = [[AVCaptureSession alloc] init];
            _session.sessionPreset = AVCaptureSessionPresetPhoto;
        }
        if (!_stillImageOutput) {
            _stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
            NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey, nil];
            [_stillImageOutput setOutputSettings:outputSettings];
        }
        if (!_captureVideoPreviewLayer) {
            _captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_session];
        }
        //检查授权
        [self checkDeviceAuthorizationStatus];
    }
    return self;
}

//初始化camera
- (void)initializeCameraWithPreview:(UIImageView *)preview {
    if (_deviceAuthorized) {
        ///添加缩放手势
        UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];
        [preview addGestureRecognizer:pinchGestureRecognizer];
        _captureZoom = 1;

        [_captureVideoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
        _captureVideoPreviewLayer.frame = preview.bounds;
        _captureVideoPreviewLayer.backgroundColor = [UIColor blackColor].CGColor;
        [preview.layer addSublayer:_captureVideoPreviewLayer];
        //获取硬件采集设备
        NSArray *devices = [AVCaptureDevice devices];
        if (devices.count == 0) {
            [self showAlertToUserWithTitle:@"提示" Message:@"未开启相机授权\n请您进行以下操作：设置->隐私->相机，打开App相机权限"];
            return;
        }
        
        for (AVCaptureDevice *device in devices) {
            if ([device hasMediaType:AVMediaTypeVideo]) {
                [device lockForConfiguration:nil];
                if ([device position] == AVCaptureDevicePositionBack) {//进来将摄像头状态都置为关闭状态，与当前显示同步
                    _backCamera = device;
                    _backInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
                    if ([device isFlashAvailable]) {
                        device.flashMode = AVCaptureFlashModeOff;
                    }
                }else {
                    _frontCamera = device;
                    _frontInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
                    if ([device isFlashAvailable]) {
                        device.flashMode = AVCaptureFlashModeOff;
                    }
                }
                [device unlockForConfiguration];
            }
        }
        
        //默认是主摄像头
        self.cameraChoose=ZBCameraBack;
        [self setCaptureSession];
        if (self.cameraDelegate) {
            [self.cameraDelegate flashLightStateChange];
        }
    }
}

#pragma mark - set method
- (void)setCameraChoose:(enum ZBCameraChoose)cameraChoose {
    _cameraChoose = cameraChoose;
    AVCaptureDevice *camera = [self choseCamera];
    [self setCameraConfigWithCaptureDevice:camera flashLightState:self.flashLightState];
}

- (AVCaptureDevice *)choseCamera {
    switch (self.cameraChoose) {
        case ZBCameraBack:
            return _backCamera;
        case ZBCameraFront:
            return _frontCamera;
        default:
            return nil;
    }
}

#pragma mark - private method
//检查用户相机授权
- (void)checkDeviceAuthorizationStatus {
    if ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo]==AVAuthorizationStatusDenied) {
        _deviceAuthorized = NO;
    }else {
        _deviceAuthorized = YES;
        self.captureVideoOrientation = AVCaptureVideoOrientationPortrait;
        __weak typeof(self) weakSelf = self;
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        //加速计
        if (self.motionManager.accelerometerAvailable) {
            [self.motionManager startAccelerometerUpdatesToQueue:queue withHandler:^(CMAccelerometerData * _Nullable accelerometerData, NSError * _Nullable error) {
                if (error) {
                    NSLog(@"图片定位相机加速计 未开:%@",error);
                    [weakSelf.motionManager stopAccelerometerUpdates];
                }else {
                    CGFloat x = accelerometerData.acceleration.x;
                    CGFloat y = accelerometerData.acceleration.y;
//                    CGFloat z = accelerometerData.acceleration.z;
                    if (fabs(x) <= 0.2 && 1 - fabs(y) <= 0.2 && y < 0) {
                        weakSelf.captureVideoOrientation = AVCaptureVideoOrientationPortrait;
                    }else if (1 - fabs(x) <= 0.2 && fabs(y) <= 0.2 && x > 0) {
                        weakSelf.captureVideoOrientation = AVCaptureVideoOrientationLandscapeLeft;
                    }else if (fabs(x) <= 0.2 && 1 - fabs(y) <= 0.2 && y > 0) {
                        weakSelf.captureVideoOrientation = AVCaptureVideoOrientationPortraitUpsideDown;
                    }else if (1 - fabs(x) <= 0.2 && fabs(y) <= 0.2 && x < 0) {
                        weakSelf.captureVideoOrientation = AVCaptureVideoOrientationLandscapeRight;
                    }
//                    NSLog(@"\nx 加速度--> %f\n y 加速度--> %f\n z 加速度--> %f\n", x, y, z);
                    // 根据 accelerometerData.acceleration.x/y/z来区分手机横竖屏状态。
                }
            }];
        }
        
    }
}

//设置闪光灯
- (void)setFlashLightState:(enum ZBFlashLightState)FlashLightState {
    _flashLightState = FlashLightState;
    //设置闪光灯
    [self setCameraConfigWithCaptureDevice:_frontCamera flashLightState:FlashLightState];
    [self setCameraConfigWithCaptureDevice:_backCamera flashLightState:FlashLightState];
    if (self.cameraDelegate) {
        [self.cameraDelegate flashLightStateChange];
    }
}

- (void)setCameraConfigWithCaptureDevice:(AVCaptureDevice *)captureDevice flashLightState:(enum ZBFlashLightState)flashLightState {
    AVCaptureFlashMode flashMode = 0;
    switch (flashLightState) {
        case ZBFlashLightOpen:
            flashMode = AVCaptureFlashModeOn;
            break;
        case ZBFlashLightOff:
            flashMode = AVCaptureFlashModeOff;
            break;
        case ZBFlashLightAuto:
            flashMode = AVCaptureFlashModeAuto;
            break;
        case ZBFlashLightDisabled:
            NSLog(@"摄像头不可用");
            return;
    }
    
    if (flashLightState != ZBFlashLightDisabled) {
        [captureDevice lockForConfiguration:nil];
        if ([captureDevice isFlashModeSupported:flashMode]) {
            [captureDevice setFlashMode:flashMode];
        }
        [captureDevice unlockForConfiguration];
    }
}

//设置AVCaptureSession以及输入输出端
- (void)setCaptureSession {
    NSLog(@"3333333");
    if (self.cameraChoose == ZBCameraFront) {
        [_session removeInput:_backInput];
        [_session addInput:_frontInput];
    }else {
        [_session removeInput:_frontInput];
        [_session addInput:_backInput];
    }
    if ([_session canAddOutput:_stillImageOutput]) {
        [_session addOutput:_stillImageOutput];
    }
    [self startCaptureImage];
}

#pragma mark--捕捉并处理处理图片
//捕捉图片
- (void)captureImage {
    //查找video采集端口ƒ
    AVCaptureConnection *videoConnection = nil;
    //遍历连接
    for (AVCaptureConnection *connection in _stillImageOutput.connections) {
        //遍历输入端口
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] ) {
                videoConnection = connection;
                break;
            }
        }
        //找到video端口后停止遍历
        if (videoConnection) {
            break;
        }
    }
    [videoConnection setVideoOrientation:_captureVideoOrientation];
    __weak typeof(self) weakSelf = self;
    [_stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
        if (imageSampleBuffer != NULL) {
            [weakSelf stopCaptureImageWithIsCallBack:YES];
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
            UIImage *image = [UIImage imageWithData:imageData];
            [weakSelf.cameraDelegate didFinishPickWithImage:image];
        }else {
            [weakSelf startCaptureImage];
            NSLog(@"保存失败:%@",error);
        }
    }];
}

//开启
- (void)startCaptureImage {
    if (_session.isRunning == NO){
        dispatch_async(_videoQueue, ^{
            [_session startRunning];
            if ([self.cameraDelegate respondsToSelector:@selector(startCapture)]) {
                [self.cameraDelegate startCapture];
            }
        });
    }
}
//停止
- (void)stopCaptureImageWithIsCallBack:(BOOL)isCallBack {
    if (_session.isRunning == YES){
        dispatch_async(_videoQueue, ^{
            [_session stopRunning];
            if (isCallBack) {
                if ([self.cameraDelegate respondsToSelector:@selector(stopCapture)]) {
                    [self.cameraDelegate stopCapture];
                }
            }
        });
    }
}

#pragma mark - gesture
- (void)pinchView:(UIPinchGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        sender.scale = _captureZoom;
    }else if (sender.state == UIGestureRecognizerStateEnded) {
        if (sender.scale < 1) {
            _captureZoom = 1;
        }else if (sender.scale > [self maxZoomFactor]) {
            _captureZoom = [self maxZoomFactor];
        }else {
            _captureZoom = [NSString stringWithFormat:@"%.2lf",sender.scale].floatValue;
        }
    }
    if (sender.state == UIGestureRecognizerStateBegan || sender.state == UIGestureRecognizerStateChanged) {
        [self cameraBackgroundDidChangeZoom:sender.scale pinchView:sender];
    }
}

- (CGFloat)maxZoomFactor {
    return [self choseCamera].activeFormat.videoMaxZoomFactor > 3 ? 3 : [self choseCamera].activeFormat.videoMaxZoomFactor;
}

// 数码变焦 1-3倍
- (void)cameraBackgroundDidChangeZoom:(CGFloat)zoom pinchView:(UIPinchGestureRecognizer *)sender {
    AVCaptureDevice *captureDevice = [self choseCamera];
    CGFloat maxZoomFactor = [self maxZoomFactor];
    if (zoom < 1) {
        zoom = 1;
    }else if (zoom > maxZoomFactor) {
        zoom = maxZoomFactor;
    }
    NSLog(@"\nzoom:%lf\nstate:%ld",zoom,(long)sender.state);
    NSError *error;
    if ([captureDevice lockForConfiguration:&error]) {
        captureDevice.videoZoomFactor = zoom;
    }else {
        // Handle the error appropriately.
    }
}

#pragma mark - dealloc
- (void)dealloc {
    NSLog(@"manager_dealloc");
}

#pragma mark--提示用户
- (void)showAlertToUserWithTitle:(NSString *)title Message:(NSString*)mesg {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:mesg delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
    [alert setTitle:title];
    [alert setMessage:mesg];
    [alert show];
}
@end
#pragma clang diagnostic pop
