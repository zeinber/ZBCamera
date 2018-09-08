//
//  ZBCameraController.h
//
//  Created by zeinber on 2018/9/5.
//  Copyright (c) 2018年 zeinber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBCameraControllerDelegate.h"

typedef void(^ChooseImageBlock) (UIImage *image);

@interface ZBCameraController : UIViewController
@property (nonatomic, copy) ChooseImageBlock chooseImageBlock;
@end
