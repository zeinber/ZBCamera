//
//  ViewController.m
//  ZBCamera
//
//  Created by zeinber on 2018/9/8.
//  Copyright © 2018年 zeinber. All rights reserved.
//

#import "ViewController.h"

#import "ZBCamera.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *pickImageView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)takePhoto:(id)sender {
    [ZBCamera showCameraWithViewController:self pickImageBlock:^(UIImage *image, NSError *error) {
        NSLog(@"image:%@",image);
        self.pickImageView.image = image;
    }];
}

@end
