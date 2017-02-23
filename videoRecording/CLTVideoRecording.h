//
//  CLTVideoRecording.h
//  videoRecording
//
//  Created by xindongyuan on 2017/2/22.
//  Copyright © 2017年 clt. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

#import <AVFoundation/AVFoundation.h>

#import <MobileCoreServices/MobileCoreServices.h>


// 回调block  imageArr 图片data数组 ，从相册选择和拍照的图片都在里面 isVideo 是否是录像 ， videoArr 视频data数组

typedef void(^dataBlock)(NSMutableArray *imageArr,BOOL isVideo ,NSMutableArray *videoArr);

@interface CLTVideoRecording : NSObject





/**
 拍照  选照片  录像

 @param viewController 当前控制器 传递 self
 @param sourceType 拍照或选照片
 @param model  拍照或录像
 @param dataBlock 回调block
 */
- (void)getVideoRecordingDataWithViewController:(UIViewController *)viewController SourceType:(UIImagePickerControllerSourceType)sourceType CameraCaptureMode:(UIImagePickerControllerCameraCaptureMode )model VideoRecordingDataBlock:(dataBlock )dataBlock;



@end
