# ZBCamera

## 集成步骤
+ 您需要在Info.plist文件中添加 Privacy - Camera Usage Description 的配置，并在调起相机时授权应用使用相机的权限。
+ 在文件头部引入头文件 
``` #import "ZBCamera.h" ```
+ 在调用的位置添加 
```objectivec
[ZBCamera showCameraWithViewController:self pickImageBlock:^(UIImage *image, NSError *error) {
     ///接收图片的回调
     NSLog(@"image:%@",image);
}];
```
