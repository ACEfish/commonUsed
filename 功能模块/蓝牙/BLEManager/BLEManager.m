//
//  BLEManager.m
//  XG
//
//  Created by 栗豫塬 on 16/10/17.
//  Copyright © 2016年 memobird. All rights reserved.
//

#import "BLEManager.h"

@interface BLEManager ()<CBCentralManagerDelegate, CBPeripheralDelegate>

@property (nonatomic, strong) CBCentralManager *centralManager;
@property (nonatomic, strong) CBPeripheral *peripheral;
@property (nonatomic, strong) CBCharacteristic *characteristic;
@property (nonatomic, strong) NSArray *bleCharactUUIDArray;
@property (nonatomic, copy) NSString *bleFilterName;
@property (nonatomic, strong) NSMutableArray *perialsArray;

@end


@implementation BLEManager

#pragma mark ---- init Method

+(instancetype)manager {
    static BLEManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[BLEManager alloc] init];
    });
    return manager;
}

- (instancetype)init {
    if (self = [super init]) {
        _centralManager = [[CBCentralManager alloc]initWithDelegate:self queue:nil];
        self.bleCharactUUIDArray = nil;
        self.bleFilterName = nil;
        self.perialsArray = [NSMutableArray array];
    }
    return self;
}

#pragma mark ---- Custom Method


- (void)scanPeripheralWithFilterName:(NSString *)filterName withServiceUUID:(NSArray<CBUUID *> *)characterUUIDArray{
    [self stopScan];
    [_centralManager scanForPeripheralsWithServices:characterUUIDArray options:nil];
    self.bleFilterName = filterName;
    [self.perialsArray removeAllObjects];
}


- (void)stopScan {
    if ([_centralManager isScanning]) {
        [_centralManager stopScan];
        self.bleFilterName = nil;
        [self.perialsArray removeAllObjects];
    }
}

- (void)stopScanAndDisconnect:(CBPeripheral *)peripheral isCancel:(BOOL)cancle {
    [self stopScan];
    if (peripheral && cancle) {
        [self cancelPeripheralConnection:peripheral];
    }
}



- (void)connectPeripheral:(CBPeripheral *)peripheral withCBCharacteristicUUID:(NSArray<NSString *> *)characterUUIDArray {
    if (peripheral) {
        [_centralManager connectPeripheral:peripheral options:nil];
        self.bleCharactUUIDArray = characterUUIDArray;
    }
}


- (void)cancelPeripheralConnection:(CBPeripheral *)peripheral {
    if (peripheral) {
        [_centralManager cancelPeripheralConnection:peripheral];
        self.peripheral = nil;
        self.bleCharactUUIDArray = nil;
    }
    
}

- (CBManagerState)getCurrentBLEState {
    return self.centralManager.state;
}


#pragma mark ---- send && get Data

- (void)sendData:(NSData *)data {
    [self.peripheral writeValue:data forCharacteristic:self.characteristic type:CBCharacteristicWriteWithResponse];
}

- (void)sendData:(NSData *)data withCharacteristics:(CBCharacteristic *)characteristics {
    //判断该特征值是否可写
    if (characteristics.properties & CBCharacteristicPropertyWrite) {
        [self.peripheral writeValue:data forCharacteristic:characteristics type:CBCharacteristicWriteWithResponse];
    }
}

#pragma mark ---- CBCentralManagerDelegate

/*
 本机设备（iPhone/iPad）蓝牙状态改变
 */
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    if ([self.delegate respondsToSelector:@selector(BLEManager:didUpdateManagerState:)]) {
        [self.delegate BLEManager:self didUpdateManagerState:central.state];
    }
}
/*
 扫描到了一个蓝牙设备peripheral
 */
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    if (self.bleFilterName) {
        if (![peripheral.name isEqualToString:self.bleFilterName]) {
            return;
        }
    }
    if (![self.perialsArray containsObject:peripheral]) {
        [self.perialsArray addObject:peripheral];
        if (_delegate &&
            [_delegate respondsToSelector:@selector(BLEManager:didDiscoverPeripheral:RSSI:)]) {
            [_delegate BLEManager:self didDiscoverPeripheral:peripheral RSSI:RSSI];
        }
    }
}
/*
 成功连接蓝牙设备peripheral
 */
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    peripheral.delegate = self;

    [peripheral discoverServices:nil];
}
/*
 连接蓝牙设备peripheral失败
 */
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    if (_delegate &&
        [_delegate respondsToSelector:@selector(BLEManager:didFailToConnectPeripheral:error:)]) {
        [_delegate BLEManager:self didFailToConnectPeripheral:peripheral error:error];
    }

}
/*
 蓝牙设备peripheral已断开
 */
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    if (_delegate &&
        [_delegate respondsToSelector:@selector(BLEManager:didDisconnectPeripheral:)]) {
        [_delegate BLEManager:self didDisconnectPeripheral:peripheral];
    }
}




#pragma mark ---- CBPeripheralDelegate

/*
 蓝牙设备peripheral的RSS值改变(RSSI就是蓝牙信号强度)
 */



- (void)peripheral:(CBPeripheral *)peripheral didReadRSSI:(NSNumber *)RSSI error:(NSError *)error {

}


/*
 从peripheral成功读取到services
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    if (error) {
    }
    NSArray *services = peripheral.services;
    
    for (CBService *service in services) {
        [peripheral discoverCharacteristics:nil forService:service];
    }
}

/*
 从peripheral的service成功读取到characteristics
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    BOOL exist = NO;
    for (CBCharacteristic *charact in service.characteristics) {
        if (self.bleCharactUUIDArray) {
            for (NSString *uuidStr in self.bleCharactUUIDArray) {
                if ([charact.UUID.UUIDString isEqualToString:uuidStr]) {
                    exist = YES;
                }
            }
            
        }
        if (!self.bleCharactUUIDArray || exist) {
            self.peripheral = peripheral;
            self.characteristic = charact;
            [self.peripheral setNotifyValue:YES forCharacteristic:charact];
            if ([self.delegate respondsToSelector:@selector(BLEManager:didConnectPeripheral:withService:characteristics:)]) {
                [self.delegate BLEManager:self didConnectPeripheral:peripheral withService:service characteristics:charact];
            }
            return;
        }
    }
}

/*
 从蓝牙设备peripheral接收到数据
 */
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    
    NSData *data = characteristic.value;
    if (data) {
        if ([self.delegate respondsToSelector:@selector(BLEManager:didReciveData:fromPeripheral:withCharactUUID:)]) {
            [self.delegate BLEManager:self didReciveData:data fromPeripheral:peripheral withCharactUUID:characteristic.UUID.UUIDString];
        }
    }
    
}

/*
 向蓝牙设备peripheral成功写入数据，写数据时需要以CBCharacteristicWriteWithResponse才会调用
 */
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
}









@end
