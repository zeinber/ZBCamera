//
//  ZBCameraConfigTool.m
//
//  Created by zeinber on 2018/9/5.
//  Copyright © 2018年 zeinber. All rights reserved.
//

#import "ZBCameraConfigTool.h"

@implementation ZBCameraConfigTool
+ (UIImage *)getResourceImageName:(NSString *)imageName {
    return [UIImage imageWithContentsOfFile:[[NSBundle bundleWithURL:[[NSBundle bundleForClass:NSClassFromString(@"ZBCameraResource")] URLForResource:@"ZBCameraResource" withExtension:@"bundle"]] pathForResource:imageName ofType:@"png"]];
}
@end
