//
//  LoginIn.m
//  WuJieKitchen
//
//  Created by 天津沃天科技 on 2019/5/28.
//  Copyright © 2019年 wotianshiyan. All rights reserved.
//

#import "LoginIn.h"
#import "SelectTypeView.h"
#import "TakeNum.h"
#import "KeyChainStore.h"
#import "LoginModel.h"
#import "LoginImgByCode.h"
#import "BigScreen.h"
@interface LoginIn ()
{
    NSString *typeStr;
    SelectTypeView *typeView;
    NSString *codeStr;
}
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UIButton *numBtn;

@property (strong, nonatomic) IBOutlet UITextField *userName_tf;
@property (strong, nonatomic) IBOutlet UITextField *pw_tf;

@property (weak, nonatomic) IBOutlet UIImageView *loginImav;

@end

@implementation LoginIn

- (void)viewDidLoad {
    [super viewDidLoad];
 
    _numLab.text=[self getUUIDByKeyChain];
 
   NSLog(@"机器码  %@",[self getUUIDByKeyChain]);
    
    
    [HttpManager checkTheUpdate:@"1342931428" responseResult:^(NSString * c1, NSString *c2, BOOL c3) {
        if ([self isNO:c1]) {
            self->codeStr=[self getUUIDByKeyChain];
            self->_numLab.hidden=NO;
            self->_numBtn.hidden=NO;
            
        }else{
            //固定机器码
   //   self->codeStr = @"95D34CA8-6A5B-41C8-8690-53576B2C2949";
        self->codeStr = @"00:08:22:3c:b1:c2";//13902154471 A123456  无界大屏
   // self->codeStr = @"08:00:27:E0:E2:CF";//asd01123  asd01123 无界大屏拿号
            self->_numLab.hidden=YES;
            self->_numBtn.hidden=YES;
        }
        [self getLoginImage];
        if (c3) { //用户版本 < appStore 进入
    
        }
        
    }];

}
- (NSString *)getUUIDByKeyChain{
    // 这个key的前缀最好是你的BundleID
    NSString*strUUID = (NSString*)[KeyChainStore load:@"www.wujiemall.com.bigScreen"];
    //首次执行该方法时，uuid为空
    if([strUUID isEqualToString:@""]|| !strUUID)
    {
        // 获取UUID 这个是要引入<AdSupport/AdSupport.h>的
        strUUID =[[UIDevice currentDevice] identifierForVendor].UUIDString;
        
        if(strUUID.length ==0 || [strUUID isEqualToString:@"00000000-0000-0000-0000-000000000000"])
        {
            //生成一个uuid的方法
            CFUUIDRef uuidRef= CFUUIDCreate(kCFAllocatorDefault);
            strUUID = (NSString*)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault,uuidRef));
            CFRelease(uuidRef);
        }
        
        //将该uuid保存到keychain
        [KeyChainStore save:@"www.wujiemall.com.bigScreen" data:strUUID];
    }
    return strUUID;
}

- (IBAction)numPress:(id)sender {
   
    [self getUUIDByKeyChain];
    
}

//隐藏NavigationBar
-(void) viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:YES]; //设置隐藏
    [super viewWillAppear:animated];
}

-(void) viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [super viewWillDisappear:animated];
}
-(void)viewDidAppear:(BOOL)animated
{
   typeView=[[SelectTypeView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
    [self.view.window addSubview:typeView];
    [typeView.takeNumBtn addTarget:self action:@selector(butPress:) forControlEvents:UIControlEventTouchUpInside];

    [typeView.bigScreenBtn addTarget:self action:@selector(butPress:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)butPress:(UIButton *)but
{
    if (but.tag==1001) {
        typeStr=@"2";//无界拿号
        _userName_tf.text=[[NSUserDefaults standardUserDefaults] objectForKey:@"userName_2"];
        _pw_tf.text=[[NSUserDefaults standardUserDefaults] objectForKey:@"pw_2"];
    }
    else
    {
        typeStr=@"1";//无界大屏
        _userName_tf.text=[[NSUserDefaults standardUserDefaults] objectForKey:@"userName_1"];
        _pw_tf.text=[[NSUserDefaults standardUserDefaults] objectForKey:@"pw_1"];
    }
    [typeView removeFromSuperview];
}

- (IBAction)submitPress:(id)sender {
    
    
    LoginModel *model=[[LoginModel alloc]init];
    if (_userName_tf.text.length==0) {
        [MBProgressHUD showSuccess:@"请输入用户名" toView:self.view];
        return;
    }
    if (_pw_tf.text.length==0) {
        [MBProgressHUD showSuccess:@"请输入密码" toView:self.view];
        return;
    }
    
    model.password=_pw_tf.text;
    model.code=codeStr ;
    model.manage_id=_userName_tf.text;
    model.code_type=typeStr;
    [MBProgressHUD showMessage:nil toView:self.view];
    [model LoginModelSuccessBlock:^(NSString * _Nonnull code, NSString * _Nonnull message, id  _Nonnull data) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if ([code intValue]==200) {
            LoginModel *login=(LoginModel *)data;
            [model save:login.data];
            
            [[NSUserDefaults standardUserDefaults] setObject:login.data.access_token forKey:@"access_token"];
            [[NSUserDefaults standardUserDefaults] setObject:login.data.token_type forKey:@"token_type"];
           
            if ([self->typeStr isEqualToString:@"2"]) {
                
                [[NSUserDefaults standardUserDefaults] setObject:self->_pw_tf.text forKey:@"pw_2"];
                [[NSUserDefaults standardUserDefaults] setObject:self->_userName_tf.text forKey:@"userName_2"];
                   [[NSUserDefaults standardUserDefaults] synchronize];
                TakeNum *num=[[TakeNum  alloc]init];
                [self.navigationController pushViewController:num animated:YES];
                
            }
            else
            {
                [[NSUserDefaults standardUserDefaults] setObject:self->_pw_tf.text forKey:@"pw_1"];
                [[NSUserDefaults standardUserDefaults] setObject:self->_userName_tf.text forKey:@"userName_1"];
                   [[NSUserDefaults standardUserDefaults] synchronize];
                
                BigScreen*num=[[BigScreen  alloc]init];
                [self.navigationController pushViewController:num animated:YES];
            }
        }
        else
        {
            [MBProgressHUD showSuccess:message toView:self.view];
        }
        
        
    } andFailure:^(NSError * _Nonnull error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showError:[error localizedDescription] toView:self.view];
    }];
    
 
 
}
-(void)getLoginImage
{
    LoginImgByCode *code=[[LoginImgByCode alloc]init];
    code.code= codeStr;
    [MBProgressHUD showMessage:nil toView:self.view];
    [code LoginImgByCodeSuccessBlock:^(NSString * _Nonnull code, NSString * _Nonnull message ,NSString * data) {
           [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if ([code intValue]==200) {
            if (data.length>0) {
                [self->_loginImav sd_setImageWithURL:[NSURL URLWithString:data] placeholderImage:[UIImage imageNamed:@"无界优品默认空视图"]];
            }
        }
        else
        {
               [MBProgressHUD showSuccess:message toView:self.view];
        }
       
     
    } andFailure:^(NSError * _Nonnull error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showError:[error localizedDescription] toView:self.view];
    }];
}
#pragma mark - 判断版本号
- (BOOL)isNO:(NSString *)c1 {
    // app版本
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *localVerson = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    //将版本号按照.切割后存入数组中
    NSArray *localArray = [localVerson componentsSeparatedByString:@"."];
    NSMutableArray * localArray_sub = [[NSMutableArray alloc] init];
    [localArray_sub addObjectsFromArray:localArray];
    NSArray *appArray = [c1 componentsSeparatedByString:@"."];
    NSMutableArray * appArray_sub = [[NSMutableArray alloc] init];
    [appArray_sub addObjectsFromArray:appArray];
    
    NSInteger num = 0;//循环次数
    if (localArray_sub.count > appArray_sub.count) {
        num = localArray_sub.count;
        for (int i = 0; i < localArray_sub.count - appArray_sub.count; i++) {
            [appArray_sub addObject:@"0"];
        }
    }
    if (localArray_sub.count < appArray_sub.count) {
        num = appArray_sub.count;
        for (int i = 0; i < appArray_sub.count - localArray_sub.count; i++) {
            [localArray_sub addObject:@"0"];
        }
    }
    if (localArray_sub.count == appArray_sub.count) {
        num = localArray_sub.count;
    }
    if (localArray_sub == appArray_sub) {
        return NO;
    }
    for(int i = 0; i < num; i++){//以最短的数组长度为遍历次数,防止数组越界
        //取出每个部分的字符串值,比较数值大小
        if([localArray_sub[i] integerValue] > [appArray_sub[i] integerValue]) {
            //从前往后比较数字大小,一旦分出大小,跳出循环
            return NO;
        }
    }
    return YES;
}
@end
