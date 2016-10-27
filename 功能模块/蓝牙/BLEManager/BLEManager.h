//
//  BLEManager.h
//  XG
//
//  Created by 栗豫塬 on 16/10/17.
//  Copyright © 2016年 memobird. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
@class BLEManager;

@protocol BLEManagerDelegate <NSObject>
@optional

/**
 当本机蓝牙设备状态改变时会触发这个代理方法
 */
- (void)BLEManager:(BLEManager *)manager didUpdateManagerState:(CBManagerState)bleState;

/**
 搜索到周围蓝牙设备
 
 @param peripheral 搜索到的蓝牙设备
 @param RSSI       蓝牙强度标识
 */
- (void)BLEManager:(BLEManager *)manager didDiscoverPeripheral:(CBPeripheral *)peripheral RSSI:(NSNumber *)RSSI;

/**
 连接蓝牙设备成功,并搜索到该蓝牙设备上的服务
 
 @param peripheral      连接上的周围蓝牙设备
 @param service         该蓝牙设备提供的服务
 @param characteristics 连接到的该蓝牙设备的服务特征
 */
- (void)BLEManager:(BLEManager *)manager didConnectPeripheral:(CBPeripheral *)peripheral withService:(CBService *)service characteristics:(CBCharacteristic *)characteristics;

/**
 连接蓝牙设备失败

 */
- (void)BLEManager:(BLEManager *)manager didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error;

/**
 成功断开与蓝牙设备的连接,当与一个已经连接的蓝牙设备断开连接后会触发这个方法

 */
- (void)BLEManager:(BLEManager *)manager didDisconnectPeripheral:(CBPeripheral *)peripheral;

/**
 收到已连接的蓝牙设备发来的数据


 @param data           接收到的数据
 @param peripheral     发送数据的蓝牙设备
 @param charactUUID    发送数据的服务UUID
 */

- (void)BLEManager:(BLEManager *)manager didReciveData:(NSData *)data fromPeripheral:(CBPeripheral *)peripheral withCharactUUID:(NSString *)charactUUID;


@end



@interface BLEManager : NSObject

@property (nonatomic, weak) id<BLEManagerDelegate> delegate;

+ (instancetype)manager;

/**
 获取当前本地蓝牙设备状态
 */
- (CBManagerState)getCurrentBLEState;

/**
 扫描蓝牙设备

 @param filterName 进行过滤的蓝牙名字,若为nil则扫描全部设备不进行过滤
 */
- (void)scanPeripheralWithFilterName:(NSString *)filterName
                     withServiceUUID:(NSArray<CBUUID *> *)characterUUIDArray;;


/**
 停止扫描
 */
- (void)stopScanAndDisconnect:(CBPeripheral *)peripheral isCancel:(BOOL)cancle;

- (void)stopScan;

/**
 连接蓝牙设备

 @param peripheral 需要进行连接的蓝牙外设
 @param UUID       过滤蓝牙外设中服务特征的UUID,若为nil则不进行过滤
 */
- (void)connectPeripheral:(CBPeripheral *)peripheral
 withCBCharacteristicUUID:(NSArray<NSString *> *)characterUUIDArray;



/**
 取消/断开与蓝牙外设的连接
 */
- (void)cancelPeripheralConnection:(CBPeripheral *)peripheral;


/**
 向蓝牙外设中写入数据

 @param data            要写入的数据
 @param characteristics 蓝牙外设写入数据的服务特征(端口)
 */
- (void)sendData:(NSData *)data withCharacteristics:(CBCharacteristic *)characteristics;

@end
