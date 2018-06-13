//
//  bluetoothViewController.m
//  ipadtest2
//
//  Created by kench on 2018/6/4.
//  Copyright © 2018年 kench. All rights reserved.
//

#import "bluetoothViewController.h"
#import "AppDelegate.h"
#import <CoreBluetooth/CoreBluetooth.h>

#import "MBProgressHUD.h"
#import "TableViewAnimationKitHeaders.h"

#import "ViewController.h"
#import "bluetoothCell.h"

#import "NotificationSender.h"//通知的发布者

#define kServiceUUID @"0000ffe0-0000-1000-8000-00805f9b34fb" //服务的UUID
#define kCharacteristicUUID @"0000ffe1-0000-1000-8000-00805f9b34fb" //特征的UUID




@interface bluetoothViewController ()<CBCentralManagerDelegate,UITableViewDelegate,UITableViewDataSource,CBPeripheralDelegate,writemessagedelegate>
@property(nonatomic,strong)CBCentralManager *bluetoothManager;//蓝牙最主要的中心

@property(nonatomic,strong)NSMutableArray *bluearray;//装载蓝牙的数组
@property(nonatomic,strong)NSMutableArray *adarray;//装在出来rssi等额外的advertise信息的数组

@property(nonatomic,strong)UITableView *bluetv;//显示蓝牙的列表

@property(nonatomic,strong)UIButton *search;//搜索蓝牙的按钮

@property(nonatomic,strong)ViewController *main;//用来跳转ViewController的vc

@property (nonatomic,strong)CBPeripheral *myPeripheral;
@property (nonatomic,strong)CBCharacteristic *myCharacteristic;
//myPeripheral  myCharacteristic用来传array到蓝牙

@property(nonatomic,strong)MBProgressHUD *blueprogress;//加载请稍后的动画

@property(nonatomic,assign)NSUInteger  index;//用来重连是present控制器的判断（需要再看一下）

@end

@implementation bluetoothViewController

//#pragma mark 懒加载bluetoothManager ================
//-(CBCentralManager *)bluetoothManager {
//    if (_bluetoothManager == nil) {
//        _bluetoothManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
//    }
//    return _bluetoothManager;
//}
#pragma mark 懒加载ViewController ================
-(ViewController *)main{
    NSLog(@"huhuhu");
    if (_main == nil) {
        _main = [[ViewController alloc]init];
        _main.delegate = self;
    }
    return _main;
}

#pragma mark 懒加载bluearray ================
-(NSMutableArray *)bluearray{
    if (_bluearray == nil) {
        _bluearray = [[NSMutableArray alloc]init];
    }
    return _bluearray;
}

#pragma mark 懒加载adarray ================
-(NSMutableArray *)adarray{
    if (_adarray == nil) {
        _adarray = [[NSMutableArray alloc]init];
    }
    return _adarray;
}

#pragma mark alertcontroller ================
-(void)alert :(NSString *)title andmessage:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *shure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    
    [alert addAction:shure];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

#pragma mark 设置横屏没商量 ================
- (void)setNewOrientation:(BOOL)fullscreen
{
    
    if (fullscreen) {
        
        NSNumber *resetOrientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationUnknown];
        
        [[UIDevice currentDevice] setValue:resetOrientationTarget forKey:@"orientation"];
        
        
        
        NSNumber *orientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft];
        
        [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
        
    }else{
        
        NSNumber *resetOrientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationUnknown];
        
        [[UIDevice currentDevice] setValue:resetOrientationTarget forKey:@"orientation"];
        
        
        
        NSNumber *orientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
        
        [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
        
    }
    
}
-(void)orientationcontrol{
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.allowRotation = YES;//(以上2行代码,可以理解为打开横屏开关)
    [self setNewOrientation:YES];//调用转屏代码
}

#pragma mark 连接蓝牙的动画 ================
-(void)createprogress{
    self.blueprogress = [[MBProgressHUD alloc]initWithView:self.view];
    self.blueprogress.mode = MBProgressHUDModeIndeterminate;
    self.blueprogress.label.text =  @"加载中，请稍后";
    self.blueprogress.progress = 1;
    [self.view addSubview:self.blueprogress];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    
    [self orientationcontrol];//控制横屏
    
    self.view .backgroundColor = [UIColor whiteColor];
    
    [self createtv];
    
    [ self createbutton:120];
    
    [self createprogress];
    
    self.index = 0;//初始化index为0
    
}

#pragma mark createtv =================
-(void)createtv{
    UITableView *tv = [[UITableView alloc]initWithFrame:CGRectMake(10, 60, self.view.frame.size.width *0.4, self.view.frame.size.height - 100) style:UITableViewStylePlain];
    
  //  tv.backgroundColor = [UIColor redColor];
    
    tv.separatorStyle = UITableViewCellSeparatorStyleNone;//tableview的去掉分割线
    
    [self.view addSubview:tv];
    
    tv.delegate = self;
    tv.dataSource = self;
    
    self.bluetv = tv;
    
    tv.hidden = YES;
    
}

#pragma mark createbutton ================
-(void)createbutton : (CGFloat )h {
    NSLog(@"width = %f",self.view.frame.size.width);
    NSLog(@"height = %f",self.view.frame.size.height);
    CGFloat margin = 30;
    CGFloat H = h;
    CGFloat W = H;
    CGFloat X =  self.view.frame.size.height - margin  - h ;
    CGFloat Y = self.view.frame.size.width*0.5 - h*0.5;
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(X,Y, W, H)];

    [btn setTitle:@"搜索蓝牙" forState:UIControlStateNormal];

    btn.backgroundColor = [UIColor redColor];

    btn.layer.cornerRadius = W *0.5;
    
    [btn addTarget:self action:@selector(searchclick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn];
    self.search = btn;
}

-(void)searchclick{

  
    [self.search setTitle:@"刷新" forState:UIControlStateNormal];
    
    self.bluearray = nil;
    self.bluetv.hidden = YES;
    
     //[self.blueprogress showAnimated:YES];//点击搜索按钮时弹出动画
    //动画在判断蓝牙可用的时候才进行判断 而不是现在！！！
    
    //创建中心设备管理器并设置当前控制器视图为代理
    _bluetoothManager=[[CBCentralManager alloc]initWithDelegate:self queue:nil];
}

#pragma mark datasource的两个方法 ================
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.bluearray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cid = @"cid";
    
    bluetoothCell *cell = [tableView dequeueReusableCellWithIdentifier:cid];
    if (cell == nil) {
        cell = [[bluetoothCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cid];
    }
     CBPeripheral *p = [self.bluearray objectAtIndex:indexPath.row];

    if (!p.name) {
        cell.bluelabel.text = @"未知";
        cell.layer.cornerRadius = 20;
    }else{
          cell.bluelabel.text = p.name;
        cell.layer.cornerRadius = 20;
    }
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
 
}

#pragma mark tableView的动画 ====================
- (void)starAnimationWithTableView:(UITableView *)tableView {
    
    [TableViewAnimationKit showWithAnimationType:self.bluearray.count tableView:tableView];
    //[TableViewAnimationKit overTurnAnimationWithTableView:tableView];
}

#pragma mark didSelectRowAtIndexPath ================
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
     NSMutableDictionary *dict2 = [self.adarray objectAtIndex:indexPath.row];
    
    int kCBAdvDataIsConnectable = [[dict2 objectForKey:@"kCBAdvDataIsConnectable"]intValue];
    NSLog(@"kCBAdvDataIsConnectable = %d",kCBAdvDataIsConnectable);
    if (kCBAdvDataIsConnectable == 0) {
        [self alert:@"连接错误" andmessage:@"抱歉，此蓝牙暂不可连接"];
    }else{
        [self.blueprogress showAnimated:YES];//在进行连接的时候显示动画 第二段动画开始
        
        [self.bluetoothManager connectPeripheral: [self.bluearray objectAtIndex:indexPath.row] options:nil];
        
        
    }
    
}


#pragma mark bluetoothManager的第一个代理方法  用来检测蓝牙是否开启 ================
//中心服务器状态更新后
-(void)centralManagerDidUpdateState:(CBCentralManager *)central{
    switch (central.state) {
        case CBManagerStatePoweredOn:
            NSLog(@"BLE已打开.");
            //扫描外围设备
               //        [central scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:kServiceUUID]] options:@{CBCentralManagerScanOptionAllowDuplicatesKey:@YES}];
                [self.blueprogress showAnimated:YES];//创建一个动画
            [central scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey:@YES}];
            break;
            
        default:
            NSLog(@"此设备不支持BLE或未打开蓝牙功能，无法作为外围设备.");
          //  [self jumpto:UIApplicationOpenSettingsURLString];
            break;
    }
}

#pragma mark 本来想自己转跳到设置界面 直接使用系统的故先废弃
-(void)jumpto :(NSString *)string{
    NSURL *url = [NSURL URLWithString:string];

    if([[UIApplication sharedApplication] canOpenURL:url]) {

        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {

            NSLog(@"跳转成功回调");

        }];
}
}

#pragma mark  发现外围设备====================
-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI{
      NSLog(@"发现外围设备 = %@",peripheral);
    
    if (peripheral.name) {
        if (![self.bluearray containsObject:peripheral]) {
            [self.bluearray addObject:peripheral];
            [self.adarray addObject:advertisementData];//两个数组装载的是不同的数组
        }
    }
//    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(stopscan) userInfo:nil repeats:NO];
//
//    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    
    [self performSelector:@selector(stopscan) withObject:nil afterDelay:3.0f];//实验
    
    
}

#pragma mark  发现外围设备后应该停止扫描====================
-(void)stopscan{
    
    //停止扫描
    [self.bluetoothManager stopScan];
    
     self.bluetv.hidden = NO;
    
    [self.bluetv reloadData];//重新载入数据
    [self starAnimationWithTableView:self.bluetv];//给tableview的生成加一个动画
    
    [self.blueprogress hideAnimated:YES];//拿掉动画1
    
    
    
}


#pragma mark ==========检测是否连接完成=======
//连接成功
-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
        NSLog(@"连接外围设备成功!");
    //设置外围设备的代理为当前视图控制器
    peripheral.delegate=self;
    //外围设备开始寻找服务
    [peripheral discoverServices:@[[CBUUID UUIDWithString:kServiceUUID]]];
    
}

//连接失败
-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    NSLog(@"连接外围设备失败!");
}

#pragma mark - CBPeripheral 代理方法
//外围设备寻找到服务后
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    NSLog(@"已发现可用服务...");
    if(error){
        NSLog(@"外围设备寻找服务过程中发生错误，错误信息：%@",error.localizedDescription);
    }
    //遍历查找到的服务
    CBUUID *serviceUUID=[CBUUID UUIDWithString:kServiceUUID];
    CBUUID *characteristicUUID=[CBUUID UUIDWithString:kCharacteristicUUID];
    for (CBService *service in peripheral.services) {
        if([service.UUID isEqual:serviceUUID]){
            //外围设备查找指定服务中的特征
            [peripheral discoverCharacteristics:@[characteristicUUID] forService:service];
        }
    }
}

//外围设备寻找到特征后
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    NSLog(@"已发现可用特征...");
    if (error) {
        NSLog(@"外围设备寻找特征过程中发生错误，错误信息：%@",error.localizedDescription);
    }
    //遍历服务中的特征
    CBUUID *serviceUUID=[CBUUID UUIDWithString:kServiceUUID];
    CBUUID *characteristicUUID=[CBUUID UUIDWithString:kCharacteristicUUID];
    if ([service.UUID isEqual:serviceUUID]) {
        for (CBCharacteristic *characteristic in service.characteristics) {
            if ([characteristic.UUID isEqual:characteristicUUID]) {
                //情景一：通知
                /*找到特征后设置外围设备为已通知状态（订阅特征）：
                 *1.调用此方法会触发代理方法：-(void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
                 *2.调用此方法会触发外围设备的订阅代理方法
                 */
                [peripheral setNotifyValue:YES forCharacteristic:characteristic];
                
                self.myPeripheral = peripheral;
                self.myCharacteristic = characteristic;//为全局的特征和服务赋值，可以在穿数据的时候使用
                
            }
        }
    }
}

//特征值被更新后
-(void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    NSLog(@"收到特征更新通知...");
    
    [self.blueprogress hideAnimated:YES];//拿掉动画2
    
    if (self.index ==0) {
          [self presentViewController:self.main animated:YES completion:nil];
    }
    self.index = 1;

    NSNotification *connectnotification = [NSNotification notificationWithName:@"connect" object:nil   userInfo:@{@"connectstate":@"  蓝牙已连接"}];
    
    [[NSNotificationCenter defaultCenter]postNotification:connectnotification];
    
    
    if (error) {
        NSLog(@"更新通知状态时发生错误，错误信息：%@",error.localizedDescription);
    }
    
    //给特征值设置新的值
    CBUUID *characteristicUUID=[CBUUID UUIDWithString:kCharacteristicUUID];
    if ([characteristic.UUID isEqual:characteristicUUID]) {
        if (characteristic.isNotifying) {
            if (characteristic.properties==CBCharacteristicPropertyNotify) {
                NSLog(@"已订阅特征通知.");
                return;
            }else if (characteristic.properties ==CBCharacteristicPropertyRead) {
                //从外围设备读取新值,调用此方法会触发代理方法：-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
                [peripheral readValueForCharacteristic:characteristic];
            }
            
        }else{
            NSLog(@"停止已停止.");
          
            //取消连接
            [self.bluetoothManager cancelPeripheralConnection:peripheral];
        }
    }
}

#pragma mark 连接掉了之后发布一个通知给vc后自动重连
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    NSLog(@"  已经断开蓝牙");
    
   NSNotification *notification = [NSNotification notificationWithName:@"blue" object:nil   userInfo:@{@"accident":@"  蓝牙已断开，正在尝试重新连接......."}];
    
    [[NSNotificationCenter defaultCenter]postNotification:notification];
    
    
    [self.bluetoothManager connectPeripheral:peripheral options:nil];
    //尝试重新连接
    
}

#pragma mark 写数据================
-(void)writemessage:(ViewController *)viewcontroller andmutablearray:(NSMutableArray *)array{
    NSString *arraystring =[NSString stringWithFormat:@"%@",array];
    NSLog(@"arraystring = %@",arraystring);
    
     NSData *data =[arraystring dataUsingEncoding:NSUTF8StringEncoding];
    
    [self.myPeripheral writeValue:data forCharacteristic:self.myCharacteristic type:CBCharacteristicWriteWithoutResponse];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
