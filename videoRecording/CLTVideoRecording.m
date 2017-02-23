//
//  CLTVideoRecording.m
//  videoRecording
//
//  Created by xindongyuan on 2017/2/22.
//  Copyright © 2017年 clt. All rights reserved.
//

#import "CLTVideoRecording.h"


#define UI_IS_IOS8_AND_HIGHER   ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)



@interface CLTVideoRecording ()
<
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate
>

@property (nonatomic,strong) UIImagePickerController *imagePicker;

@property (nonatomic,strong) NSMutableArray *imageArr; // 装图片数据

@property (nonatomic,strong) NSMutableArray *videoArr; // 装视频数据

@property (nonatomic,assign) BOOL isVideo; // 是否是视频

@property (nonatomic,copy) dataBlock  videoRecordingBlock;

@property (nonatomic, strong) UIViewController        *viewController;


@end

@implementation CLTVideoRecording


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _imagePicker = [[UIImagePickerController alloc]init];
        _imagePicker.editing = NO;
        _imagePicker.allowsEditing = NO;
        _imagePicker.delegate = self;
        _imageArr = [NSMutableArray array];
        _videoArr = [NSMutableArray array];
        _isVideo = NO;
        
    }
    return self;
}

- (void)getVideoRecordingDataWithViewController:(UIViewController *)viewController SourceType:(UIImagePickerControllerSourceType)sourceType CameraCaptureMode:(UIImagePickerControllerCameraCaptureMode )model VideoRecordingDataBlock:(dataBlock )dataBlock
{
    
    if (sourceType == UIImagePickerControllerSourceTypeCamera ) {
        
        if (![self imagePickerControlerIsAvailabelToCamera]) {
            
            if (UI_IS_IOS8_AND_HIGHER) {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"您的手机不支持拍照" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *comfirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    return;
                }];
                [alertController addAction:comfirmAction];
                [self.viewController presentViewController:alertController animated:YES completion:nil];
                
            }
            else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"您的手机不支持拍照" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                return;
            }
        }
        
    }
    
    if (![self AVAuthorizationStatusIsGranted]) {
        if (UI_IS_IOS8_AND_HIGHER) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"相机未授权" message:@"请到设置-隐私-相机中修改" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *comfirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                return;
            }];
            [alertController addAction:comfirmAction];
            [self.viewController presentViewController:alertController animated:YES completion:nil];
            
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"相机未授权" message:@"请到设置-隐私-相机中修改" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
    }
    
    self.viewController = viewController;
    self.videoRecordingBlock = dataBlock;
    
    self.imagePicker.sourceType = sourceType;

    self.imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    
    
    if (sourceType == UIImagePickerControllerSourceTypeCamera) {
        
        
        self.imagePicker.cameraCaptureMode = model;
        self.imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        
        self.imagePicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
    }
    
    
    if (self.viewController.presentedViewController == nil) {
    
        [self.viewController presentViewController:self.imagePicker animated:YES completion:nil];
    }
    
}


// 判断硬件是否支持拍照
- (BOOL)imagePickerControlerIsAvailabelToCamera {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        return YES;
    } else {
        return NO;
    }
}


#pragma mark - 照机授权判断
- (BOOL)AVAuthorizationStatusIsGranted  {
    __block BOOL isGranted = NO;
    //判断是否授权相机
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    switch (authStatus) {
        case 0: { //第一次使用，则会弹出是否打开权限
            [AVCaptureDevice requestAccessForMediaType : AVMediaTypeVideo completionHandler:^(BOOL granted) {
                //授权成功
                if (granted) {
                    isGranted = YES;
                }
                else{
                    isGranted = NO;
                }
            }];
        }
            break;
        case 1:{
            //还未授权
            isGranted = NO;
        }
            break;
        case 2:{
            //主动拒绝授权
            isGranted = NO;
        }
            break;
        case 3: {
            //已授权
            isGranted = YES;
        }
            break;
            
        default:
            break;
    }
    return isGranted;
}

#pragma mark 取消
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
   
    [self.imagePicker dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]) {
        
         NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
        NSURL *newURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@%@.mp4",NSTemporaryDirectory(),[NSProcessInfo processInfo].globallyUniqueString]];
        [self videoTransformation:videoURL outputURL:newURL];
        
    }
    else if ([mediaType isEqualToString:(NSString *)kUTTypeImage])
    {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        self.isVideo = NO;
        [self.imageArr addObject:UIImageJPEGRepresentation(image, 0.5)];
        
        if (self.videoRecordingBlock) {
            self.videoRecordingBlock(self.imageArr,self.isVideo,self.videoArr);
        }
        
        
    }
    
    
    [self.imagePicker dismissViewControllerAnimated:YES completion:nil];

    
}


#pragma mark - 视频转换
- (void)videoTransformation:(NSURL *)inputURL outputURL:(NSURL *)outputURL {
    NSData *data = [NSData dataWithContentsOfFile:inputURL.path];
    NSLog(@"This video begin %0.3fMB", data.length / (1024.0 *1024.0) );
    
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:inputURL options:nil];
    
    AVAssetExportSession *session = [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetMediumQuality];
    session.outputURL = outputURL;
    session.outputFileType = AVFileTypeQuickTimeMovie;
    [session exportAsynchronouslyWithCompletionHandler:^{
        NSLog(@"progress %0.02f", session.progress);
        switch (session.status) {
            case AVAssetExportSessionStatusWaiting:{
                NSLog(@"等待ing");
            }break;
            case AVAssetExportSessionStatusExporting:{
                NSLog(@"转化ing");
            }break;
            case AVAssetExportSessionStatusCompleted:{
                NSData *data = [NSData dataWithContentsOfFile:outputURL.path];
                NSLog(@"This video finish %0.3fMB", data.length / (1024.0 *1024.0) );
                
                
                UISaveVideoAtPathToSavedPhotosAlbum(outputURL.path, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
                NSLog(@"完成ing");
            }break;
            case AVAssetExportSessionStatusFailed:{
                NSLog(@"%@", session.error);
                NSLog(@"失败ing");
            }break;
            case AVAssetExportSessionStatusCancelled:{
                NSLog(@"取消ing");
            }break;
                
            default:
                break;
        }
    }];
}

#pragma mark - 录视频
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSLog(@"%@", videoPath);
    NSData *data = [NSData dataWithContentsOfFile:videoPath];
    
    
    [self.videoArr addObject:data];
 
    
    if (error) {
        NSLog(@"image save is Failure %@", error);
        
        if (UI_IS_IOS8_AND_HIGHER) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"存储视频错误" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *comfirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                return;
            }];
            [alertController addAction:comfirmAction];
            [self.viewController presentViewController:alertController animated:YES completion:nil];
            
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"存储视频错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        
        
    }else {
        
        self.isVideo = YES;
        
        if (self.videoRecordingBlock) {
            self.videoRecordingBlock(self.imageArr,self.isVideo,self.videoArr);
        }
        
    }
}

@end
