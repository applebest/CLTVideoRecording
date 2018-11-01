//
//  ViewController.m
//  videoRecording
//
//  Created by xindongyuan on 2017/2/22.
//  Copyright © 2017年 clt. All rights reserved.
//

#import "ViewController.h"

#import "CLTVideoRecording.h"


@interface ViewController ()

@property (nonatomic,strong) CLTVideoRecording *videoRecordingServe;


@end

@implementation ViewController

- (CLTVideoRecording *)videoRecordingServe
{
    if (!_videoRecordingServe) {
        
        _videoRecordingServe = [CLTVideoRecording new];
        
    }
    
    return _videoRecordingServe;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    // UIImagePickerControllerSourceTypeCamera && UIImagePickerControllerCameraCaptureModePhoto   拍照
    
    // UIImagePickerControllerSourceTypeCamera && UIImagePickerControllerCameraCaptureModeVideo   录像
    
    
    //  UIImagePickerControllerSourceTypePhotoLibrary && UIImagePickerControllerCameraCaptureModePhoto   相册

    [self.videoRecordingServe getVideoRecordingDataWithViewController:self useType:imagePickerUseType_RecordingVideo imageBlock:^(NSMutableArray *imageArr) {

        NSLog(@"image %@",imageArr);

    } videoBlock:^(NSMutableArray *videoArr) {
        NSLog(@"video %@",videoArr);
    }];
    
     
    
     
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
