//
//  BlueToothResultViewController.m
//  Health
//
//  Created by VickyCao on 12/27/15.
//  Copyright © 2015 vickycao1221. All rights reserved.
//

#import "BlueToothResultViewController.h"
#import "BabyBluetooth.h"
#import "SVProgressHUD.h"
#import "BloodInputViewController.h"


#define channelOnPeropheralView @"peripheralView"
#define channelOnCharacteristicView @"CharacteristicView"

@interface BlueToothResultViewController () {
    BabyBluetooth *babyBluetooth;
}

@property (nonatomic, weak) IBOutlet UILabel *statusLabel;
@property (nonatomic, weak) IBOutlet UILabel *resultLabel;
@property (nonatomic, assign) BOOL isMyDisconnect;
@property (nonatomic, strong)CBPeripheral *currPeripheral;
@property (nonatomic, strong)CBService *currentService;
@property (nonatomic, strong)CBCharacteristic *characteristic;

@end

@implementation BlueToothResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"更新数据";
    self.isFromDevice = YES;
    if (self.isFromDevice) {
        //初始化BabyBluetooth 蓝牙库
        babyBluetooth = [BabyBluetooth shareBabyBluetooth];
        //设置蓝牙委托
        [self babyDelegate];
        
    }
//    [self testResult:@"fe6a755a01e888a7"];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.isFromDevice) {
        //设置委托后直接可以使用，无需等待CBCentralManagerStatePoweredOn状态
        [self searchForDevice];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self stopSearch];
    [self disconnectionDevice];
}

- (void)dealloc {
    NSLog(@"aaa");
}

#pragma mark -蓝牙配置和操作
//蓝牙网关初始化和委托方法设置
-(void)babyDelegate{
    __weak typeof(self) weakSelf = self;
    /**
     *  搜索设备
     */
    [babyBluetooth setBlockOnCentralManagerDidUpdateState:^(CBCentralManager *central) {
        if (central.state == CBCentralManagerStatePoweredOn) {
            weakSelf.statusLabel.text = @"设备打开成功，开始扫描设备";
        } else {
            weakSelf.statusLabel.text = @"请打开蓝牙设备后重试";
        }
    }];
    
    //设置扫描到设备的委托
    [babyBluetooth setBlockOnDiscoverToPeripherals:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
        if ([peripheral.name isEqualToString:@"ClinkBlood"]) {
            weakSelf.statusLabel.text = @"已找到平糖设备，准备连接";
            weakSelf.currPeripheral = peripheral;
            [weakSelf stopSearch];
            [weakSelf connectForDevice];
        }
    }];
    
    /**
     *  连接设备
     *
     */
    //设置设备连接成功的委托,同一个baby对象，使用不同的channel切换委托回调
    [babyBluetooth setBlockOnConnectedAtChannel:channelOnPeropheralView block:^(CBCentralManager *central, CBPeripheral *peripheral) {
        weakSelf.statusLabel.text = @"平糖蓝牙连接成功";
    }];
    
    //设置设备连接失败的委托
    [babyBluetooth setBlockOnFailToConnectAtChannel:channelOnPeropheralView block:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        weakSelf.statusLabel.text = [NSString stringWithFormat:@"平糖蓝牙连接失败"];

    }];
    
    //设置设备断开连接的委托
    [babyBluetooth setBlockOnDisconnectAtChannel:channelOnPeropheralView block:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        weakSelf.statusLabel.text = [NSString stringWithFormat:@"平糖蓝牙断开连接"];
        if (!weakSelf.isMyDisconnect) {
            [weakSelf stopSearch];
            [weakSelf disconnectionDevice];
            [weakSelf searchForDevice];
        }
        weakSelf.isMyDisconnect = NO;
    }];
    
    //设置发现设备的Services的委托
    [babyBluetooth setBlockOnDiscoverServicesAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, NSError *error) {
        for (CBService *s in peripheral.services) {
            ///插入section到tableview
            if ([s.UUID.UUIDString isEqualToString:@"FC00"]) {
                weakSelf.statusLabel.text = [NSString stringWithFormat:@"开始获取数据"];
                dispatch_async_on_main_queue(^{
                    [weakSelf readForCharacteristic];
                });
                
            }
        }
    }];
    
    //设置发现设service的Characteristics的委托
    [babyBluetooth setBlockOnDiscoverCharacteristicsAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, CBService *service, NSError *error) {
//        if ([service.peripheral.name isEqualToString:@"FCA1"]) {
//            [weakSelf getDescription];
//        }
        for (CBCharacteristic *c in service.characteristics) {
            if ([c.UUID.UUIDString isEqualToString:@"FCA1"]) {
                if (!c.isNotifying) {
                    weakSelf.characteristic = c;
                    [weakSelf setNotify];
                }
            }
        }
        
    }];
}

/**
 *  搜索设备
 */
- (void)searchForDevice {
    NSLog(@"搜索: %d, %p", __LINE__, __FUNCTION__);
    [self disconnectionDevice];
    babyBluetooth.scanForPeripherals().begin();
}

- (void)stopSearch {
    NSLog(@"停止搜索: %d, %p", __LINE__, __FUNCTION__);
    self.isMyDisconnect = YES;
    [babyBluetooth cancelScan];
}

/**
 *  连接设备
 */
- (void)connectForDevice {
    NSLog(@"连接: %d, %p", __LINE__, __FUNCTION__);
//    [SVProgressHUD showInfoWithStatus:@"开始连接设备"];
    //    babyBluetooth.having(self.currPeripheral).and.channel(channelOnPeropheralView).then.connectToPeripherals().discoverServices().discoverCharacteristics().readValueForCharacteristic().discoverDescriptorsForCharacteristic().readValueForDescriptors().begin();
    babyBluetooth.having(self.currPeripheral).and.channel(channelOnPeropheralView).then.connectToPeripherals(self.currPeripheral).discoverServices().begin();
}

/**
 *  断开设备
 */
- (void)disconnectionDevice {
    if (self.characteristic && self.characteristic.isNotifying) {
        [babyBluetooth cancelNotify:self.currPeripheral characteristic:self.characteristic];
    }
    
    [babyBluetooth cancelAllPeripheralsConnection];
}

/**
 *  搜索特征
 */
- (void)readForCharacteristic {
    //扫描选项->CBCentralManagerScanOptionAllowDuplicatesKey:忽略同一个Peripheral端的多个发现事件被聚合成一个发现事件
    NSDictionary *scanForPeripheralsWithOptions = @{CBCentralManagerScanOptionAllowDuplicatesKey:@YES};
    /*连接选项->
     CBConnectPeripheralOptionNotifyOnConnectionKey :当应用挂起时，如果有一个连接成功时，如果我们想要系统为指定的peripheral显示一个提示时，就使用这个key值。
     CBConnectPeripheralOptionNotifyOnDisconnectionKey :当应用挂起时，如果连接断开时，如果我们想要系统为指定的peripheral显示一个断开连接的提示时，就使用这个key值。
     CBConnectPeripheralOptionNotifyOnNotificationKey:
     当应用挂起时，使用该key值表示只要接收到给定peripheral端的通知就显示一个提
     */
    NSDictionary *connectOptions = @{CBConnectPeripheralOptionNotifyOnConnectionKey:@YES,
                                     CBConnectPeripheralOptionNotifyOnDisconnectionKey:@YES,
                                     CBConnectPeripheralOptionNotifyOnNotificationKey:@YES};
    
    [babyBluetooth setBabyOptionsAtChannel:channelOnPeropheralView scanForPeripheralsWithOptions:scanForPeripheralsWithOptions connectPeripheralWithOptions:connectOptions scanForPeripheralsWithServices:nil discoverWithServices:nil discoverWithCharacteristics:nil];
    
//    babyBluetooth.having(self.currPeripheral).and.channel(channelOnPeropheralView).then.discoverCharacteristics().readValueForCharacteristic().discoverDescriptorsForCharacteristic().readValueForDescriptors().begin();
    babyBluetooth.having(self.currPeripheral).and.channel(channelOnPeropheralView).then.connectToPeripherals().discoverServices().discoverCharacteristics().begin();
//    babyBluetooth.channel(channelOnPeropheralView).discoverCharacteristics();
//    babyBluetooth.connectToPeripherals(self.currPeripheral).discoverCharacteristics().begin();
}

- (void)setNotify {
    [babyBluetooth notify:self.currPeripheral characteristic:self.characteristic block:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
        NSLog(@"%@", characteristics.value);
        
        NSString *str = [self hexadecimalString:characteristics.value];
        if ([str containsString:@"55bbbbcc"]) {
            self.resultLabel.text = @"请滴血进行测量";
        } else {
            NSString *str1 = [str substringWithRange:NSMakeRange(10, 2)];
            NSString *str3 = [str substringWithRange:NSMakeRange(str.length - 4, 2)];
            NSString *str2 = [str substringWithRange:NSMakeRange(str.length - 2, 2)];
            if ([str1 isEqualToString:str2]) {
                // 倒计时
                self.resultLabel.text = str1;
            }
            if ([str3 isEqualToString:@"88"]) {
                // 测量结果
//                NSString *str4 = [self to10:[str substringWithRange:NSMakeRange(str.length - 6, 2)]];
                NSString *str5 = [self to10:[str substringWithRange:NSMakeRange(str.length - 8, 4)]];
//                NSString *result = [NSString stringWithFormat:@"%d", [str5 intValue]*256+[str4 intValue]];
                [SVProgressHUD showInfoWithStatus:@"测量成功"];
                NSString *result = [NSString stringWithFormat:@"%0.2f", [str5 intValue]/18.0];
                [self performSegueWithIdentifier:@"result" sender:result];
            }
        }
        NSLog(@"resume notify block");
    }];
}

// 十六进制转字符串
- (NSString*)hexadecimalString:(NSData *)data{
    NSString* result;
    const unsigned char* dataBuffer = (const unsigned char*)[data bytes];
    if(!dataBuffer){
        return nil;
    }
    NSUInteger dataLength = [data length];
    NSMutableString* hexString = [NSMutableString stringWithCapacity:(dataLength * 2)];
    for(int i = 0; i < dataLength; i++){
        [hexString appendString:[NSString stringWithFormat:@"%02lx", (unsigned long)dataBuffer[i]]];
    }
    result = [NSString stringWithString:hexString];
    return result;
}

// 转成十进制
- (NSString *)to10:(NSString *)num
{
    NSString *result = [NSString stringWithFormat:@"%ld", strtoul([num UTF8String],0,16)];
    return result;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    BloodInputViewController *inputVC = [segue destinationViewController];
    inputVC.resultStr = (NSString *)sender;
    inputVC.isFromDevice = YES;
}

- (void)testResult:(NSString *)str {
//    NSString *str4 = [self to10:[str substringWithRange:NSMakeRange(str.length - 6, 2)]];
    NSString *str5 = [self to10:[str substringWithRange:NSMakeRange(str.length - 8, 4)]];
//    NSString *result = [NSString stringWithFormat:@"%d", [str5 intValue]*256+[str4 intValue]];
    [SVProgressHUD showInfoWithStatus:@"测量成功"];
    NSString *result = [NSString stringWithFormat:@"%0.2f", [str5 intValue]/18.0];
    [self performSegueWithIdentifier:@"result" sender:result];
}

@end
