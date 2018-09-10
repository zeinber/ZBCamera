//
//  ZBCameraController.m
//
//  Created by zeinber on 2018/9/5.
//  Copyright (c) 2018年 zeinber. All rights reserved.
//

#import "ZBCameraController.h"
#import "ZBCameraView.h"
#import "ZBCameraOperationManager.h"
#import "ZBCameraConfigTool.h"

#pragma mark - 型号&版本适配
///当前设备是否是iPhoneX
#define isPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#pragma mark - 全局尺寸宏
#define STATUSBAR_HEIGHT (isPhoneX ? 44 : 20)
#define NAVIGATIONBAR_WIDTH 24
#define NAVIGATIONBAR_HEIGHT 44
#define TABBAR_HEIGHT 49
#define SafeBottomMargin         (isPhoneX ? 34 : 0)
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define FlashLightModeCount 3 //闪光灯模式
@interface ZBCameraController () <ZBCameraControllerDelegate> {
    ZBCameraOperationManager *_cameraManager;
    NSInteger _lightModeIndex;
    BOOL _isTakingPhoto;//是否正在拍照
    UIImage *_chooseImage;//选择的照片
}

@property (nonatomic, strong) ZBCameraView *cameraView;
@end

@implementation ZBCameraController

#pragma mark - lazy load
- (ZBCameraView *)cameraView {
    if (!_cameraView) {
        CGFloat top = 0;
        if (isPhoneX) {
            top = STATUSBAR_HEIGHT;
        }
        _cameraView = [[ZBCameraView alloc] initWithFrame:CGRectMake(0, top, SCREEN_WIDTH, SCREEN_HEIGHT - SafeBottomMargin - top)];
        [self.view addSubview:_cameraView];
        [_cameraView.canceOrCloseButton addTarget:self action:@selector(cancelOrCloseClick:) forControlEvents:UIControlEventTouchUpInside];
        [_cameraView.photoCaptureButton addTarget:self action:@selector(snapImage:) forControlEvents:UIControlEventTouchUpInside];
        [_cameraView.sureImageButton addTarget:self action:@selector(sureImageClick:) forControlEvents:UIControlEventTouchUpInside];
        [_cameraView.flashToggleButton addTarget:self action:@selector(toggleFlash) forControlEvents:UIControlEventTouchUpInside];
        [_cameraView.cameraToggleButton addTarget:self action:@selector(switchCamera:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cameraView;
}

#pragma mark - view Func
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSetUpView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark - private method
- (void)initSetUpView {
    self.view.backgroundColor = [UIColor blackColor];
    self.cameraView.hidden = NO;
    
    //初始化变量
    _lightModeIndex = 0;
    _isTakingPhoto = YES;
    //添加管理器
    _cameraManager = [[ZBCameraOperationManager alloc] init];
    _cameraManager.cameraDelegate = self;
    [_cameraManager initializeCameraWithPreview:self.cameraView.imagePreview];
    [self setUpTabBar];
}

- (void)setUpTabBar {
    if (_isTakingPhoto) {
        [self.cameraView.canceOrCloseButton setTitle:@"关闭" forState:UIControlStateNormal];
        self.cameraView.photoCaptureButton.hidden = NO;
        self.cameraView.sureImageButton.hidden = YES;
        self.cameraView.imageResultView.hidden = YES;
        self.cameraView.imagePreview.hidden = NO;
        [_cameraManager startCaptureImage];
    }else {
        [self.cameraView.canceOrCloseButton setTitle:@"取消" forState:UIControlStateNormal];
        self.cameraView.photoCaptureButton.hidden = YES;
        self.cameraView.sureImageButton.hidden = NO;
        self.cameraView.imageResultView.hidden = NO;
        self.cameraView.imagePreview.hidden = YES;
        [_cameraManager stopCaptureImageWithIsCallBack:YES];
    }
}

#pragma mark - click event
- (void)snapImage:(id)sender {
    [[_cameraManager class] cancelPreviousPerformRequestsWithTarget:_cameraManager selector:@selector(captureImage) object:nil];
    [_cameraManager performSelector:@selector(captureImage)];
    
}

- (void)cancelOrCloseClick:(UIButton *)sender {
    if (!_isTakingPhoto) {//取消
        _isTakingPhoto = YES;
    }else {//关闭
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    [self setUpTabBar];
}

- (void)switchCamera:(UIButton *)sender {
    _cameraManager.cameraChoose = !_cameraManager.cameraChoose;
    [_cameraManager setCaptureSession];
}

- (void)toggleFlash {
    if (_lightModeIndex>=FlashLightModeCount-1) {
        _lightModeIndex=0;
    }else {
        _lightModeIndex++;
    }
    NSString *imagename=@"";
        switch (_lightModeIndex) {
            case 0:
                imagename=@"flash-off";
               [_cameraManager setFlashLightState:ZBFlashLightOff];
                break;
            case 1:
                imagename=@"flash";
                [_cameraManager setFlashLightState:ZBFlashLightOpen];
                break;
            case 2:
                imagename=@"flash-auto";
                [_cameraManager setFlashLightState:ZBFlashLightAuto];
                break;
            default:
                break;
        }
    [self.cameraView.flashToggleButton setImage:[ZBCameraConfigTool getResourceImageName:imagename] forState:UIControlStateNormal];
    [self.cameraView.flashToggleButton setImage:[ZBCameraConfigTool getResourceImageName:imagename] forState:UIControlStateHighlighted];
    
}

- (void)sureImageClick:(UIButton *)sender {
    if (self.chooseImageBlock) {
        self.chooseImageBlock(_chooseImage);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - other
- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (BOOL)shouldAutorotate {
    [self.view layoutIfNeeded];
    return YES;
}

- (void)dealloc {
    NSLog(@"controller_dealloc");
}

#pragma mark - delegate
- (void)didFinishPickWithImage:(UIImage *)image {
    _isTakingPhoto = NO;
    _chooseImage = image;
    self.cameraView.imageResultView.image = image;
    [self setUpTabBar];
}

- (void)startCapture {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.cameraView.flashToggleButton.hidden = NO;
        self.cameraView.cameraToggleButton.hidden = NO;
    });
}

- (void)stopCapture {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.cameraView.flashToggleButton.hidden = YES;
        self.cameraView.cameraToggleButton.hidden = YES;
    });
}

- (void)flashLightStateChange {
    //同步设置闪关灯按钮
    if (_cameraManager.flashLightState == ZBFlashLightDisabled) {
        //闪光灯按钮半透明
        [self.cameraView.flashToggleButton setAlpha:0.6f];
        [self.cameraView.flashToggleButton setEnabled:NO];
    }else {
        //闪光灯按钮半透明
        [self.cameraView.flashToggleButton setAlpha:1.0f];
        [self.cameraView.flashToggleButton setEnabled:YES];
    }
}
@end
