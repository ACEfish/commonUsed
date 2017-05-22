//
//  RichScanViewController.m
//  conductor
//
//  Created by 陈煌 on 16/6/24.
//  Copyright © 2016年 intretech. All rights reserved.
//

#import "RichScanViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "QRCodeAreaView.h"
#import "QRCodeBackgroundView.h"
#import "WebViewController.h"
#import "ScanResultsViewController.h"


@interface RichScanViewController ()<AVCaptureMetadataOutputObjectsDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) AVCaptureSession *session;//输入输出的中间桥梁
@property (nonatomic, strong) QRCodeAreaView   *areaView;//扫描区域视图
@property (nonatomic, strong) NSString         *keyURL;
@property (nonatomic, strong) UIButton         *torchButton;

@end

@implementation RichScanViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self initUI];
    
#if TARGET_IPHONE_SIMULATOR == 0
    [self initQRCode];
#else
    self.view.backgroundColor = [UIColor whiteColor];
    ITLog(@"请在真机上运行");
#endif

    [ITNotificationCenter addObserver:self selector:@selector(receviceAnalyzeQRCodeReq:) name:[ClientMsgType_EnumDescriptor() enumNameForValue:ClientMsgType_AnalyzeQrCodeRsp] object:nil];
    
    [ITNotificationCenter addObserver:self selector:@selector(receviceEquipInfoByKey:) name:[ClientMsgType_EnumDescriptor() enumNameForValue:ClientMsgType_GetEquipInfoByKeyRsp] object:nil];
    
}


- (void)analyzeQRCodeReq:(NSString *)keyURL {
    
    MsgAnalyzeQrCodeReq *analyzeQrCodeReq = [[MsgAnalyzeQrCodeReq alloc] init];
    [analyzeQrCodeReq setURL:keyURL];
    self.keyURL = keyURL;
    [[MQTTManager sharedInstance]sendMessageWithMsgType:ClientMsgType_AnalyzeQrCodeReq Data:analyzeQrCodeReq.data Topic:PublishLoginServerTopic];
}

- (void)receviceAnalyzeQRCodeReq:(NSNotification *)notice{
    
    MsgAnalyzeQrCodeRsp *analyzeQrCode = notice.object;
    
    if (analyzeQrCode.result == YQLoginResultType_ErrQrUnrecognized) {
        
        [self pushWebVC:self.keyURL];
        
    }
    
    else if (analyzeQrCode.result == YQLoginResultType_ErrSuccess){
        
        [self getEquipInfoByKey:analyzeQrCode.key];
    }
 
}



/**
 *  分析二维码以后拿到key，根据key再去获取用户数据
 */
- (void)getEquipInfoByKey:(NSString *)key {
    
    MsgGetEquipInfoByKeyReq *getEquipInfoByKeyReq = [[MsgGetEquipInfoByKeyReq alloc] init];
    getEquipInfoByKeyReq.key = key;
    getEquipInfoByKeyReq.userId = [UserDataManager sharedInstance].currentUser.userId.intValue;
    [[MQTTManager sharedInstance]sendMessageWithMsgType:ClientMsgType_GetEquipInfoByKeyReq Data:getEquipInfoByKeyReq.data Topic:PublishLoginServerTopic];
}

- (void)receviceEquipInfoByKey:(NSNotification *)notice {
    
    MsgGetEquipInfoByKeyRsp *equipInfoByKeyRsp = notice.object;
    
    ScanResultsViewController *scanResultsVC = [[ScanResultsViewController alloc]init];
    scanResultsVC.equipInfoByKey = equipInfoByKeyRsp;
    [self.navigationController pushViewController:scanResultsVC animated:YES];
    
}


- (void)initUI {
    //扫描区域
    CGRect areaRect = CGRectMake((SCREEN_WIDTH - 250)/2, (SCREEN_HEIGHT - 250)/2, 250, 250);
    
    //半透明背景
    QRCodeBackgroundView *backgroundView = [[QRCodeBackgroundView alloc]initWithFrame:self.view.bounds];
    backgroundView.scanFrame = areaRect;
    [self.view addSubview:backgroundView];
    
    //设置扫描区域
    self.areaView = [[QRCodeAreaView alloc]initWithFrame:areaRect];
    [self.view addSubview:self.areaView];
    
    //提示文字
    UILabel *promptLable = [[UILabel alloc]init];
    promptLable.text = @"让对方打开指挥家APP,点击[+] - [二维码],";
    promptLable.font = [UIFont systemFontOfSize:14.0];
    promptLable.textColor = [UIColor whiteColor];
    promptLable.y = CGRectGetMaxY(self.areaView.frame) + 20;
    [promptLable sizeToFit];
    promptLable.center = CGPointMake(self.areaView.center.x, promptLable.center.y);
    [self.view addSubview:promptLable];
    
    UILabel *label = [[UILabel alloc]init];
    label.text = @"扫描成功后就加入对方的指挥家啦";
    label.font = [UIFont systemFontOfSize:14.0];
    label.textColor = [UIColor whiteColor];
    label.y = CGRectGetMaxY(self.areaView.frame) + 40;
    [label sizeToFit];
    label.center = CGPointMake(self.areaView.center.x, label.center.y);
    [self.view addSubview:label];
    
    //返回键
    UIButton *backbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    backbutton.frame = CGRectMake(16, 26, 42, 42);
    [backbutton setBackgroundImage:[UIImage imageNamed:@"QR_back"] forState:UIControlStateNormal];
    [backbutton addTarget:self action:@selector(clickBackButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backbutton];
    
    //从相册选取图片
    UIButton *pickPhotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    pickPhotoBtn.x = SCREEN_WIDTH / 2 - 20;
    pickPhotoBtn.y = CGRectGetMaxY(self.view.frame) - 90;
    pickPhotoBtn.width = pickPhotoBtn.height = 40;
    [pickPhotoBtn setBackgroundImage:[UIImage imageNamed:@"QR_photoPicker"] forState:UIControlStateNormal];
    [pickPhotoBtn addTarget:self action:@selector(pickPhotoButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pickPhotoBtn];
    
    UILabel *pickPhotolabel = [[UILabel alloc]init];
    pickPhotolabel.text = @"从相册选取二维码";
    pickPhotolabel.font = [UIFont systemFontOfSize:13.0];
    pickPhotolabel.textColor = [UIColor whiteColor];
    pickPhotolabel.y = CGRectGetMaxY(self.view.frame) - 40;
    [pickPhotolabel sizeToFit];
    pickPhotolabel.center = CGPointMake(self.areaView.center.x, pickPhotolabel.center.y);
    [self.view addSubview:pickPhotolabel];
    
    //TorchBtn
    UIButton *torchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    torchBtn.frame = CGRectMake(SCREEN_WIDTH - 58, 26, 42, 42);
    [torchBtn setBackgroundImage:[UIImage imageNamed:@"QR_Right_OFF"] forState:UIControlStateNormal];
    [torchBtn setBackgroundImage:[UIImage imageNamed:@"QR_Right_ON"] forState:UIControlStateSelected];
    [torchBtn setBackgroundImage:[UIImage imageNamed:@"QR_Right_ON"] forState:UIControlStateHighlighted];
    [torchBtn addTarget:self action:@selector(OpenOrCloseTorch:) forControlEvents:UIControlEventTouchUpInside];
    
    self.torchButton = torchBtn;
    [self.view addSubview:torchBtn];

}

- (void)OpenOrCloseTorch:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (![device hasTorch]) {
        ITLog(@"no torch");
    }else{
        [device lockForConfiguration:nil];
        sender.isSelected ? [device setTorchMode: AVCaptureTorchModeOn]: [device setTorchMode: AVCaptureTorchModeOff];
        [device unlockForConfiguration];
    }
}


- (void)initQRCode {
    //获取摄像设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    //创建输出流
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc]init];
    
    //设置代理 在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //设置识别区域
    //深坑，这个值是按比例0~1设置，而且X、Y要调换位置，width、height调换位置
    output.rectOfInterest =
    CGRectMake(self.areaView.y     /SCREEN_HEIGHT,
               self.areaView.x     /SCREEN_WIDTH,
               self.areaView.height/SCREEN_HEIGHT,
               self.areaView.width /SCREEN_WIDTH);
    
    
    //初始化链接对象
    self.session = [[AVCaptureSession alloc]init];
    //高质量采集率
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    
    [self.session addInput:input];
    [self.session addOutput:output];
    
    //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
    output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    
    AVCaptureVideoPreviewLayer *layer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    
    layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    layer.frame = self.view.layer.bounds;
    
    [self.view.layer insertSublayer:layer atIndex:0];
    
    //开始捕获
    [self.session startRunning];

    
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    
    if (metadataObjects.count>0) {
        [self.session stopRunning];//停止扫描
        [self.areaView stopAnimaion];//暂停动画
        AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects firstObject];
        NSURL *resultUrl = [[NSURL alloc] initWithString:metadataObject.stringValue];
        if ([resultUrl.scheme isEqualToString:@"wand"]) {
            [[EquipmentDataManager sharedInstance] requestAddBleWand:resultUrl.resourceSpecifier];
            [ICNavigationController popViewController:self.navigationController animated:YES direction:ICNavigationControllerDirectionLeft];
        } else {
            [self analyzeQRCodeReq:metadataObject.stringValue];
        }
    }
}


#pragma  mark - Deklegate -
- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [self.session stopRunning];//停止扫描
    [self.areaView stopAnimaion];//暂停动画
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage* image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    if (!image){
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{ CIDetectorAccuracy : CIDetectorAccuracyHigh }];
    NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
    
    if (features.count >=1) {
        
        CIQRCodeFeature *feature = [features objectAtIndex:0];
        NSString *scanResult = feature.messageString;
        [self analyzeQRCodeReq:scanResult];

    }else {

        [ITAlertBlockView showWithTitle:ITLocalStr(未发现二维码) subTitle:ITLocalStr(换一个试试) cancleBtnTitle:ITLocalStr(继续扫描) cancleBtnBlock:^{
            [self.session startRunning];
            [self.areaView startAnimaion];
        }];
    }
}


#pragma mark - Private Methods -

- (void)clickBackButton{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)pickPhotoButton {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    picker.delegate = self;
    
    picker.allowsEditing = YES;
    
    [self presentViewController:picker animated:YES completion:nil];
    
}

- (void)pushWebVC:(NSString *)ansStr {
    
    WebViewController *webView = [[WebViewController alloc]init];
    
    webView.URL = ansStr;
    
    [self.navigationController pushViewController:webView animated:YES];

}


- (void)viewWillAppear:(BOOL)animated{
    
    self.navigationController.navigationBarHidden = YES;
    
    [self.session startRunning];//停止扫描
    [self.areaView startAnimaion];//暂停动画
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    self.navigationController.navigationBarHidden = NO;
}


@end
