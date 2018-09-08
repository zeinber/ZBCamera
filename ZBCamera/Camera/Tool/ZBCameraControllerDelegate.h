//
//  ZBCameraControllerDelegate.h
//
//  Created by zeinber on 2018/9/5.
//  Copyright (c) 2018年 zeinber. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ZBCameraControllerDelegate <NSObject>
- (void)didFinishPickWithImage:(UIImage *)image;
- (void)startCapture;
- (void)stopCapture;
- (void)flashLightStateChange;
@end
