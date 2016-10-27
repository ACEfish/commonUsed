//
//  ViewController.m
//  相机
//
//  Created by qingyun on 16/1/20.
//  Copyright © 2016年 qingyun.com. All rights reserved.
//

#import "ViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>


@interface ViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   // [self tookPhoto];
    [self pickPhoto];
    
    // Do any additional setup after loading the view, typically from a nib.
}
#pragma mark ----准备工作

//判断媒体源是否可用
/** 媒体源类型(SourceType)
 typedef NS_ENUM(NSInteger, UIImagePickerControllerSourceType) {
 UIImagePickerControllerSourceTypePhotoLibrary,
 UIImagePickerControllerSourceTypeCamera,
 UIImagePickerControllerSourceTypeSavedPhotosAlbum
 } __TVOS_PROHIBITED;
 */
- (BOOL)isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

/** 判断（前或后）摄像头是否可用
 UIImagePickerControllerCameraDeviceRear,
 UIImagePickerControllerCameraDeviceFront
 */
- (BOOL)isFontCameraAvailable{
    return  [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}
//判断某个摄像头的闪光的功能是否可用
- (BOOL)isFlashAvailableOnFrontCamera{
    return [UIImagePickerController isFlashAvailableForCameraDevice:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL)cameraSupportMedia:(NSString *)paraMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paraMediaType length] == 0) {
        NSLog(@"Media Type is empty");
        return NO;
    }
    //确定这个媒体源上的媒体类型是否可用
    NSArray *availabelMediaType = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    //block 块枚举 遍历数组
    [availabelMediaType enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paraMediaType]) {
            result = YES;
            *stop = YES;
        }
        
    }];
    return result;
}

// kUTTypeImage图片媒体类型
- (BOOL)doesCameraSupportTakingPhoto{
    //__bridge 将一个KUTTypeImage类型 转为 NSString类型
    return [self cameraSupportMedia: (__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

//判断是否可以从照片库检索照片
//照片库媒体源是否可用
- (BOOL)isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL)canUserPickVideoFromPhotoLibrary{
    return [self cameraSupportMedia:(__bridge NSString *)kUTTypeVideo sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL)canPickPhotoFromLibrary{
    return [self cameraSupportMedia:(__bridge NSString *)kUTTypeImage  sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
#pragma mark ----从照片库检索照片

- (void)pickPhoto{
    if ([self isPhotoLibraryAvailable]) {
        UIImagePickerController *controller = [[UIImagePickerController alloc]init];
        controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        NSMutableArray *mediaTypes = [NSMutableArray array];
        if ([self canPickPhotoFromLibrary]) {
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
        }
        if ([self canUserPickVideoFromPhotoLibrary]) {
            [mediaTypes addObject:(__bridge NSString *)kUTTypeVideo];
        }
        controller.mediaTypes = mediaTypes;
        controller.delegate = self;
        [self.navigationController presentViewController:controller animated:YES completion:nil];

    }
}


#pragma mark ----摄像头拍照

- (void)tookPhoto{
    if ([self isCameraAvailable] && [self doesCameraSupportTakingPhoto]) {
        NSLog(@"可以拍照");
        
        UIImagePickerController *controller = [[UIImagePickerController alloc]init];
        controller.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        NSString *reqiredMediaType = (__bridge NSString *) kUTTypeImage;
        controller.mediaTypes = @[reqiredMediaType];
        
        controller.allowsEditing = YES;
        controller.delegate= self;
        [self.navigationController presentViewController:controller animated:YES completion:nil];
    }
}
#pragma mark ----misc
// 保存图片的选择器方法示例
- (void)imageWasSavedSuccessFully:(UIImage *)paramImage didFinishSavingWIthError:(NSError *)paramError contextInfo:(void *)paramContextInfo{
    if (paramError == nil) {
        NSLog(@"Image was saved successfully");
    }else{
        NSLog(@"保存图片时 发生错误");
        NSLog(@"%@",paramError);
    }
}
#pragma mark -----UIImagePickerControllerdelegate代理方法
//拍摄一张照片后
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    
    //Info是一个数值字典，用于告知项目的数据，以及项目源数据。。。。该方法中要做的第一件事就是要读取UIImagePickerControllerMediaType 关键字的值，判断拍摄资源类型

        NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:(__bridge NSString *)kUTTypeVideo]) {
        NSURL *urlOfVedio =[info objectForKey:UIImagePickerControllerMediaURL];
        //包含用户拍摄URL 地址
        NSLog(@"MOVIE URL== %@",urlOfVedio);
    }

    if ([mediaType isEqualToString:(__bridge NSString *)kUTTypeImage]) {
#if 1
        //获取元数据 这里只提供图像，并非视频
        //获取图片medata  是一个字典  包含很多用户拍摄图像的信息
        NSDictionary *metadata = [info objectForKey:UIImagePickerControllerMediaMetadata];
        //获取图片
        UIImage *theImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        /**
         UIImagePickerControllerCropRect  如果编辑被启用（allowEditing），该关键字的值包含裁剪区域的矩形
        UIImagePickerControllerEditedImage 如果编辑被启用，该关键字的值包含编辑过的（调整大小和缩放）图像
         */
        NSLog(@"metadata ==%@",metadata);
        NSLog(@"image == %@",theImage);
#endif
#pragma mark ----往照片库中存储照片
#if 0
        UIImage *theImage =nil;
        if ([picker allowsEditing]) {
            theImage = [info objectForKey:UIImagePickerControllerEditedImage];
        }else{
            theImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
        //示例的选择器方法  可以不写
        SEL selectorTocall = @selector(imageWasSavedSuccessFully:didFinishSavingWIthError:contextInfo:);
        /**使用这个方法存储到照片库，
         参数一：图像
         二：目标对象
         三：一个指定选择器的参数。保存完成时必须调用
         四、一个上下文，在保存操作结束后该值传递给指定选择器
         2、3、4可选
         */
        UIImageWriteToSavedPhotosAlbum(theImage, self, selectorTocall, NULL);
#endif
        
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

//图像失去其操作被取消
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    NSLog(@"取消操作");
    [picker dismissViewControllerAnimated:YES completion:nil];

}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
