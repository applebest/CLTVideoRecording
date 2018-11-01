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




typedef NS_ENUM(NSUInteger, imagePickerUseType) {
    imagePickerUseType_TakingPictures = 0, // 拍照
    imagePickerUseType_RecordingVideo, // 录像
    imagePickerUseType_ChoosePhotos, // 选照片
};



typedef void(^imageBlock)(NSMutableArray *imageArr);

typedef void(^videoBlock)(NSMutableArray *videoArr);


@interface CLTVideoRecording : NSObject


/**
 拍照 选照片 录像

 @param viewController 用于present
 @param type 使用类型
 @param imageBlock 图片回调
 @param videoBlock 视频回调
 */
- (void)getVideoRecordingDataWithViewController:(UIViewController *)viewController useType:(imagePickerUseType)type imageBlock:(imageBlock)imageBlock videoBlock:(videoBlock)videoBlock;


@end
