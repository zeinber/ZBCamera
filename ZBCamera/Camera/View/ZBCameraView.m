//
//  ZBCameraView.m
//
//  Created by zeinber on 2018/9/5.
//  Copyright © 2018年 zeinber. All rights reserved.
//

#import "ZBCameraView.h"
#import "ZBCameraConfigTool.h"

@implementation ZBCameraView

#pragma mark - init method
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIImageView *imagePreview = [[UIImageView alloc] init];
        [self addSubview:imagePreview];
        imagePreview.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint *imagePre_topLy = [NSLayoutConstraint constraintWithItem:imagePreview attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0f constant:0];
        [self addConstraint:imagePre_topLy];
        NSLayoutConstraint *imagePre_leftLy = [NSLayoutConstraint constraintWithItem:imagePreview attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0];
        [self addConstraint:imagePre_leftLy];
        NSLayoutConstraint *imagePre_bottomLy = [NSLayoutConstraint constraintWithItem:imagePreview attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0];
        [self addConstraint:imagePre_bottomLy];
        NSLayoutConstraint *imagePre_rightLy = [NSLayoutConstraint constraintWithItem:imagePreview attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0f constant:0];
        [self addConstraint:imagePre_rightLy];
        imagePreview.userInteractionEnabled = YES;
        //    [imagePreview layoutIfNeeded];
        _imagePreview = imagePreview;
        
        UIImageView *imageResultView = [[UIImageView alloc] init];
        [self addSubview:imageResultView];
        imageResultView.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint *imageResult_topLy = [NSLayoutConstraint constraintWithItem:imageResultView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0f constant:0];
        [self addConstraint:imageResult_topLy];
        NSLayoutConstraint *imageResult_leftLy = [NSLayoutConstraint constraintWithItem:imageResultView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0];
        [self addConstraint:imageResult_leftLy];
        NSLayoutConstraint *imageResult_bottomLy = [NSLayoutConstraint constraintWithItem:imageResultView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0];
        [self addConstraint:imageResult_bottomLy];
        NSLayoutConstraint *imageResult_rightLy = [NSLayoutConstraint constraintWithItem:imageResultView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0f constant:0];
        [self addConstraint:imageResult_rightLy];
        imageResultView.userInteractionEnabled = NO;
        imageResultView.hidden = YES;
        imageResultView.contentMode = UIViewContentModeScaleAspectFit;
        //    [imageResultView layoutIfNeeded];
        _imageResultView = imageResultView;
        
        UIView *bottomBgView = [[UIView alloc] init];
        [self addSubview:bottomBgView];
        bottomBgView.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint *bottomBg_leftLy = [NSLayoutConstraint constraintWithItem:bottomBgView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0];
        [self addConstraint:bottomBg_leftLy];
        NSLayoutConstraint *bottomBg_bottomLy = [NSLayoutConstraint constraintWithItem:bottomBgView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0];
        [self addConstraint:bottomBg_bottomLy];
        NSLayoutConstraint *bottomBg_rightLy = [NSLayoutConstraint constraintWithItem:bottomBgView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0f constant:0];
        [self addConstraint:bottomBg_rightLy];
        NSLayoutConstraint *bottomBg_heightLy = [NSLayoutConstraint constraintWithItem:bottomBgView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:64];
        [self addConstraint:bottomBg_heightLy];
        bottomBgView.backgroundColor = [UIColor blackColor];
        bottomBgView.alpha = 0.4;
        
        UIView *photoBar = [[UIView alloc] init];
        [self addSubview:photoBar];
        photoBar.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint *photoBar_leftLy = [NSLayoutConstraint constraintWithItem:photoBar attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0];
        [self addConstraint:photoBar_leftLy];
        NSLayoutConstraint *photoBar_bottomLy = [NSLayoutConstraint constraintWithItem:photoBar attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0];
        [self addConstraint:photoBar_bottomLy];
        NSLayoutConstraint *photoBar_rightLy = [NSLayoutConstraint constraintWithItem:photoBar attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0f constant:0];
        [self addConstraint:photoBar_rightLy];
        NSLayoutConstraint *photoBar_heightLy = [NSLayoutConstraint constraintWithItem:photoBar attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:64];
        [self addConstraint:photoBar_heightLy];
        _photoBar = photoBar;
        
        UIButton *canceOrCloseButton = [[UIButton alloc] init];
        [photoBar addSubview:canceOrCloseButton];
        canceOrCloseButton.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint *canceOrClose_leftLy = [NSLayoutConstraint constraintWithItem:canceOrCloseButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:photoBar attribute:NSLayoutAttributeLeft multiplier:1.0f constant:10];
        [photoBar addConstraint:canceOrClose_leftLy];
        NSLayoutConstraint *canceOrClose_centerYLy = [NSLayoutConstraint constraintWithItem:canceOrCloseButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:photoBar attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0];
        [photoBar addConstraint:canceOrClose_centerYLy];
        canceOrCloseButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [canceOrCloseButton setTitle:@"关闭" forState:UIControlStateNormal];
        [canceOrCloseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

        _canceOrCloseButton = canceOrCloseButton;
        
        UIButton *photoCaptureButton = [[UIButton alloc] init];
        [photoBar addSubview:photoCaptureButton];
        photoCaptureButton.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint *photoCapture_centerXLy = [NSLayoutConstraint constraintWithItem:photoCaptureButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:photoBar attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0];
        [photoBar addConstraint:photoCapture_centerXLy];
        NSLayoutConstraint *photoCapture_centerYLy = [NSLayoutConstraint constraintWithItem:photoCaptureButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:photoBar attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0];
        [photoBar addConstraint:photoCapture_centerYLy];
        NSLayoutConstraint *photoCapture_widthLy = [NSLayoutConstraint constraintWithItem:photoCaptureButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:50];
        [photoBar addConstraint:photoCapture_widthLy];
        NSLayoutConstraint *photoCapture_heightLy = [NSLayoutConstraint constraintWithItem:photoCaptureButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:50];
        [photoBar addConstraint:photoCapture_heightLy];
        [photoCaptureButton setImage:[ZBCameraConfigTool getResourceImageName:@"take_snap"] forState:UIControlStateNormal];
  
        _photoCaptureButton = photoCaptureButton;
        
        UIButton *sureImageButton = [[UIButton alloc] init];
        [photoBar addSubview:sureImageButton];
        sureImageButton.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint *sureImage_rightLy = [NSLayoutConstraint constraintWithItem:sureImageButton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:photoBar attribute:NSLayoutAttributeRight multiplier:1.0f constant:-10];
        [photoBar addConstraint:sureImage_rightLy];
        NSLayoutConstraint *sureImage_centerYLy = [NSLayoutConstraint constraintWithItem:sureImageButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:photoBar attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0];
        [photoBar addConstraint:sureImage_centerYLy];
        sureImageButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [sureImageButton setTitle:@"选择照片" forState:UIControlStateNormal];
        [sureImageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

        _sureImageButton = sureImageButton;
        
        UIButton *flashToggleButton = [[UIButton alloc] init];
        [self addSubview:flashToggleButton];
        flashToggleButton.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint *flashToggle_topLy = [NSLayoutConstraint constraintWithItem:flashToggleButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0f constant:15];
        [self addConstraint:flashToggle_topLy];
        NSLayoutConstraint *flashToggle_leftLy = [NSLayoutConstraint constraintWithItem:flashToggleButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0f constant:10];
        [self addConstraint:flashToggle_leftLy];
        [flashToggleButton setImage:[ZBCameraConfigTool getResourceImageName:@"flash-off"] forState:UIControlStateNormal];

        _flashToggleButton = flashToggleButton;
        
        UIButton *cameraToggleButton = [[UIButton alloc] init];
        [self addSubview:cameraToggleButton];
        cameraToggleButton.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint *cameraToggle_topLy = [NSLayoutConstraint constraintWithItem:cameraToggleButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0f constant:15];
        [self addConstraint:cameraToggle_topLy];
        NSLayoutConstraint *cameraToggle_rightLy = [NSLayoutConstraint constraintWithItem:cameraToggleButton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0f constant:-10];
        [self addConstraint:cameraToggle_rightLy];
        [cameraToggleButton setImage:[ZBCameraConfigTool getResourceImageName:@"front-camera"] forState:UIControlStateNormal];

        _cameraToggleButton = cameraToggleButton;
        
        [self layoutIfNeeded];
    }
    return self;
}

@end
