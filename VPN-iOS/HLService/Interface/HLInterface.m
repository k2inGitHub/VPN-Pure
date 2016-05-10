//
//  RateUs.m
//  zuanshimicheng
//
//  Created by zhangrui on 14-5-23.
//
//

#import "HLInterface.h"
#import "NSString+KTAddition.h"
#import "NSUserDefaults+KTAdditon.h"


@implementation HLInterface


+(instancetype)sharedInstance{
    static HLInterface* instance = nil;
    if(instance == nil){
        @synchronized(self){
            if(instance == nil){
                instance = [[HLInterface alloc] init];
            }
        }
    }
    return  instance;
}
-(instancetype)init{
    self = [super init];
    if(self){

        
    }
    return self;
}

//总接口
#define MainUrl @"http://203.195.128.244/ao2/u3d.php"

-(void)startGet{
    
    [self BeginData];
    
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *appName = [infoDict objectForKey:@"CFBundleIdentifier"];
    NSString *appVersion = [infoDict objectForKey:@"CFBundleShortVersionString"];
    
    NSDictionary *dict = @{@"app_bundle_id"    : appName,
                           @"app_version"    : appVersion,
                           };
    
    NSString *string1 = [[NSString stringFromJasonDict:dict] encodeNetData];
    NSString *string2 = [NSString stringWithFormat:@"%@?content=%@",MainUrl,string1];
    NSLog(@"%@",string2);
    
    NSURL *url=[NSURL URLWithString:string2];
    
    //第二步，通过URL创建网络请求
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    //NSURLRequest初始化方法第一个参数：请求访问路径，第二个参数：缓存协议，第三个参数：网络请求超时时间（秒）
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSString *str = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
    
    NSData * data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *root = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    NSLog(@"base data = %@", root);
    for (NSString *key in [root allKeys]) {
//        NSLog(@"key = %@ value = %@", key, [root objectForKey:key]);
        NSString *value = [root objectForKey:key];
        if ((NSNull *)value != [NSNull null]) {
//            NSLog(@"set key = %@", key);
            [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
        }
    }
    
    [self LoadData];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

-(void)LoadData{
    
    self.ctrl_admob_banner_switch = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"ctrl_admob_banner_switch"];
    
    self.ctrl_admob_banner_id = [[NSUserDefaults standardUserDefaults] stringForKey:@"ctrl_admob_banner_id" defaultValue:@""];
    
    self.ctrl_admob_pop_id = [[NSUserDefaults standardUserDefaults] stringForKey:@"ctrl_admob_pop_id" defaultValue:@""];
    
    self.ctrl_banner_switch = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"ctrl_banner_switch"];
    
    self.ctrl_banner_iphone_id = [[NSUserDefaults standardUserDefaults] stringForKey:@"ctrl_banner_iphone_id" defaultValue:@""];
    
    self.ctrl_banner_ipad_id = [[NSUserDefaults standardUserDefaults] stringForKey:@"ctrl_banner_ipad_id" defaultValue:@""];
    
    self.unityad_code = [[NSUserDefaults standardUserDefaults] stringForKey:@"unityad_code" defaultValue:@""];
    
    self.vungle_code = [[NSUserDefaults standardUserDefaults] stringForKey:@"vungle_code" defaultValue:@""];
    
    self.ctrl_pop_switch = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"ctrl_pop_switch"];				//插屏总开关
    
    self.ctrl_admob_pop_switch = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"ctrl_admob_pop_switch"];		//Admob 插屏开关
    
    self.ctrl_unityad_pop_switch = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"ctrl_unityad_pop_switch"];		//UnityAD 插屏开关
    
    self.ctrl_mango_pop_switch = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"ctrl_mango_pop_switch"];		//芒果 插屏开关
    
    
    self.ctrl_vungle_pop_switch = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"ctrl_vungle_pop_switch"];
    
    self.ctrl_unsafe_admob_pop_switch = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"ctrl_unsafe_admob_pop_switch"];		//Admob 插屏开关
    
    self.ctrl_unsafe_unityad_pop_switch = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"ctrl_unsafe_unityad_pop_switch"];		//UnityAD 插屏开关
    
    self.ctrl_unsafe_mango_pop_switch = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"ctrl_unsafe_mango_pop_switch"];		//芒果 插屏开关
    
    self.ctrl_unsafe_vungle_pop_switch = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"ctrl_unsafe_vungle_pop_switch"];
    
    self.ctrl_admob_pop_time = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"ctrl_admob_pop_time"];
    
    self.ctrl_unityad_pop_time = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"ctrl_unityad_pop_time"];
    
    self.ctrl_mango_pop_time = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"ctrl_mango_pop_time"];
    
    self.ctrl_vungle_pop_time = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"ctrl_vungle_pop_time"];
    
    self.encouraged_ad_strategy = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"encouraged_ad_strategy"];
    
    self.encouraged_ad_strategy_unityad_switch = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"encouraged_ad_strategy_unityad_switch"];
    
    self.encouraged_ad_strategy_vungle_switch = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"encouraged_ad_strategy_vungle_switch"];
    
    self.umeng_code = [[NSUserDefaults standardUserDefaults] stringForKey:@"umeng_code" defaultValue:@""];
    
    self.umeng_Channel = [[NSUserDefaults standardUserDefaults] stringForKey:@"umeng_Channel" defaultValue:@""];
    
    self.market_reviwed_status = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"market_reviwed_status"];
    
    self.comment_ctrl_switch = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"comment_ctrl_switch"];
    
    self.comment_content = [[NSUserDefaults standardUserDefaults] stringForKey:@"comment_content" defaultValue:@""];
    
    self.comment_btnok = [[NSUserDefaults standardUserDefaults] stringForKey:@"comment_btnok" defaultValue:@""];
    
    self.comment_btncancel = [[NSUserDefaults standardUserDefaults] stringForKey:@"comment_btncancel" defaultValue:@""];
    
    self.comment_download_link = [[NSUserDefaults standardUserDefaults] stringForKey:@"comment_download_link" defaultValue:@""];
    
    self.itunes_update_ctrl_switch = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"itunes_update_ctrl_switch"];
    
    self.itunes_update_content = [[NSUserDefaults standardUserDefaults] stringForKey:@"itunes_update_content" defaultValue:@""];
    
    self.itunes_update_btnok = [[NSUserDefaults standardUserDefaults] stringForKey:@"itunes_update_btnok" defaultValue:@""];
    
    self.itunes_update_btncancel = [[NSUserDefaults standardUserDefaults] stringForKey:@"itunes_update_btncancel" defaultValue:@""];
    
    self.itunes_updated_url = [[NSUserDefaults standardUserDefaults] stringForKey:@"itunes_updated_url" defaultValue:@""];
    
    //预留开关
    self.ctrl_internal_01 = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"ctrl_internal_01"];
    
    self.ctrl_internal_02 = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"ctrl_internal_02"];
    
    self.ctrl_internal_03 = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"ctrl_internal_03"];
    
    self.ctrl_internal_04 = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"ctrl_internal_04"];
    
    self.ctrl_internal_05 = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"ctrl_internal_05"];
    
    self.girl_start = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"girl_start"];

    self.girl_img_url = [[NSUserDefaults standardUserDefaults] stringForKey:@"girl_img_url" defaultValue:@""];
    
    self.ctrl_unlock_img_switch = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"ctrl_unlock_img_switch"];
    
    self.ctrl_left_banner_id = [[NSUserDefaults standardUserDefaults] stringForKey:@"ctrl_left_banner_id" defaultValue:@""];
    self.ctrl_left_banner_switch = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"ctrl_left_banner_switch"];
    self.ctrl_left_pop_id = [[NSUserDefaults standardUserDefaults] stringForKey:@"ctrl_left_pop_id" defaultValue:@""];
    self.ctrl_fixed_pop_id = [[NSUserDefaults standardUserDefaults] stringForKey:@"ctrl_fixed_pop_id" defaultValue:@""];
    self.ctrl_left_pop_switch = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"ctrl_left_pop_switch"];
    self.ctrl_unsafe_left_pop_switch = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"ctrl_unsafe_left_pop_switch"];
    self.ctrl_btn_img_url_01 = [[NSUserDefaults standardUserDefaults] stringForKey:@"ctrl_btn_img_url_01" defaultValue:@""];
    self.ctrl_btn_img_url_02 = [[NSUserDefaults standardUserDefaults] stringForKey:@"ctrl_btn_img_url_02" defaultValue:@""];
    self.ctrl_btn_img_url_03 = [[NSUserDefaults standardUserDefaults] stringForKey:@"ctrl_btn_img_url_03" defaultValue:@""];
    self.ctrl_btn_img_url_04 = [[NSUserDefaults standardUserDefaults] stringForKey:@"ctrl_btn_img_url_04" defaultValue:@""];
    
    self.loading_left_pop_switch = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"loading_left_pop_switch"];
    self.loading_admob_pop_switch = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"loading_admob_pop_switch"];
    self.loading_mango_pop_switch = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"loading_mango_pop_switch"];
    
    self.button_left_pop_switch = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"button_left_pop_switch"];
    self.button_unityad_pop_switch = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"button_unityad_pop_switch"];
    self.button_vungle_pop_switch = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"button_vungle_pop_switch"];
    
    self.ctrl_unlock_video_switch = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"ctrl_unlock_video_switch"];
    self.ctrl_unlock_default_video_switch = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"ctrl_unlock_default_video_switch"];
    self.girl_video_url = [[NSUserDefaults standardUserDefaults] stringForKey:@"girl_video_url" defaultValue:@""];
    
    [self FixData];
}

-(void)BeginData{
    [[NSUserDefaults standardUserDefaults] setObject:@"itunes_update_ctrl_switch" forKey:@"0"];
}

-(void)FixData{
    if(self.ctrl_banner_iphone_id.length == 0){
        self.ctrl_banner_iphone_id = @"064314b67636452d9e33e745d7996c12";
    }
    if(self.ctrl_banner_ipad_id.length == 0){
        self.ctrl_banner_ipad_id = @"60b93ae9f72f41b5b45d17125889eb32";
    }
    if (_market_reviwed_status == 0) {
        _girl_start = 0;
    }
}



@end
