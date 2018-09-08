//
//  ZBCamera.h
//  ZBCamera
//
//  Created by zeinber on 2018/9/8.
//  Copyright © 2018年 zeinber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^PickImageBlock) (UIImage *image, NSError *error);

@interface ZBCamera : NSObject
///调起自定义相机
+ (void)showCameraWithViewController:(UIViewController *)vc pickImageBlock:(PickImageBlock)pickImageBlock;
@end
