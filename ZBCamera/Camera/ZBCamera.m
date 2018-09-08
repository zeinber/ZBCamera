//
//  ZBCamera.m
//  ZBCamera
//
//  Created by zeinber on 2018/9/8.
//  Copyright © 2018年 zeinber. All rights reserved.
//

#import "ZBCamera.h"
#import "ZBCameraController.h"
#import <AVFoundation/AVFoundation.h>

@implementation ZBCamera
///调起自定义相机
+ (void)showCameraWithViewController:(UIViewController *)vc pickImageBlock:(PickImageBlock)pickImageBlock {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] && [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo] != AVAuthorizationStatusDenied) {
        ZBCameraController *cameraVc = [[ZBCameraController alloc] init];
        cameraVc.chooseImageBlock = ^(UIImage *image) {
            NSLog(@"image:%@",image);
            pickImageBlock(image,nil);
        };
        [vc presentViewController:cameraVc animated:YES completion:nil];
    }else {
        NSLog(@"相机调用失败");
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您的设备暂不支持此功能" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSError *error = [NSError errorWithDomain:@"设备暂不支持此功能" code:-101 userInfo:nil];
            pickImageBlock(nil,error);
        }];
        [alertController addAction:confirmAction];
        [vc presentViewController:alertController animated:YES completion:nil];
        
    }
}
@end
