#import <Foundation/Foundation.h>

@interface HLInterface : NSObject {
    
}

@property(nonatomic,assign) int eventToRate;
@property(nonatomic,assign) BOOL haveRated;


@property(nonatomic,assign) int ctrl_admob_banner_switch;

@property(nonatomic,copy) NSString *ctrl_admob_banner_id;

@property(nonatomic,copy) NSString *ctrl_admob_pop_id;

@property(nonatomic,assign) int ctrl_banner_switch;

@property(nonatomic,copy) NSString *ctrl_banner_iphone_id;

@property(nonatomic,copy) NSString *ctrl_banner_ipad_id;

@property(nonatomic,copy) NSString *unityad_code;

@property(nonatomic,copy) NSString *vungle_code;  //vungle id

@property(nonatomic,assign) int ctrl_pop_switch;				//插屏总开关

@property(nonatomic,assign) int ctrl_admob_pop_switch;		//Admob 插屏开关

@property(nonatomic,assign) int ctrl_unityad_pop_switch;		//UnityAD 插屏开关

@property(nonatomic,assign) int ctrl_mango_pop_switch;		//芒果 插屏开关

@property(nonatomic,assign) int ctrl_vungle_pop_switch; //vungle安全开关

@property(nonatomic,assign) int ctrl_unsafe_admob_pop_switch;		//Admob 插屏开关

@property(nonatomic,assign) int ctrl_unsafe_unityad_pop_switch;		//UnityAD 插屏开关

@property(nonatomic,assign) int ctrl_unsafe_mango_pop_switch;		//芒果 插屏开关

@property(nonatomic,assign) int ctrl_unsafe_vungle_pop_switch;      //vungle不安全开关

@property(nonatomic,assign) int ctrl_admob_pop_time;

@property(nonatomic,assign) int ctrl_unityad_pop_time;

@property(nonatomic,assign) int ctrl_mango_pop_time;

@property(nonatomic,assign) int ctrl_vungle_pop_time;  //vungle冷却时间

@property(nonatomic,assign) int encouraged_ad_strategy;

@property(nonatomic,assign) int encouraged_ad_strategy_unityad_switch;//激励型广告 unity开关

@property (nonatomic,assign) int encouraged_ad_strategy_vungle_switch;//激励型广告 vungle开关

@property(nonatomic,copy) NSString *umeng_code;

@property(nonatomic,copy) NSString *umeng_Channel;

@property(nonatomic,assign) int market_reviwed_status;

@property(nonatomic,assign) int comment_ctrl_switch;

@property(nonatomic,copy) NSString *comment_content;

@property(nonatomic,copy) NSString *comment_btnok;

@property(nonatomic,copy) NSString *comment_btncancel;

@property(nonatomic,copy) NSString *comment_download_link;

@property(nonatomic,assign) int itunes_update_ctrl_switch;

@property(nonatomic,copy) NSString *itunes_update_content;

@property(nonatomic,copy) NSString *itunes_update_btnok;

@property(nonatomic,copy) NSString *itunes_update_btncancel;

@property(nonatomic,copy) NSString *itunes_updated_url;

//预留开关
@property(nonatomic,assign) int ctrl_internal_01;

@property(nonatomic,assign) int ctrl_internal_02;

@property(nonatomic,assign) int ctrl_internal_03;

@property(nonatomic,assign) int ctrl_internal_04;

@property(nonatomic,assign) int ctrl_internal_05;

@property (nonatomic, assign) int girl_start;

@property (nonatomic, assign) int ctrl_unlock_img_switch;

@property (nonatomic, assign) int ctrl_left_banner_switch;

@property (nonatomic, assign) int ctrl_left_pop_switch;//安全补余插屏开关

@property (nonatomic, assign) int ctrl_unsafe_left_pop_switch ;//不安全补余插屏开关


@property (nonatomic, copy) NSString *girl_img_url;

@property (nonatomic, copy) NSString *ctrl_left_banner_id;

@property (nonatomic, copy) NSString *ctrl_left_pop_id;

@property (nonatomic, copy) NSString *ctrl_fixed_pop_id;

@property (nonatomic, assign) NSString *ctrl_btn_img_url_01;
@property (nonatomic, assign) NSString *ctrl_btn_img_url_02;
@property (nonatomic, assign) NSString *ctrl_btn_img_url_03;
@property (nonatomic, assign) NSString *ctrl_btn_img_url_04;

@property (nonatomic, assign) int loading_left_pop_switch;
@property (nonatomic, assign) int loading_admob_pop_switch;
@property (nonatomic, assign) int loading_mango_pop_switch;

@property (nonatomic, assign) int button_left_pop_switch;
@property (nonatomic, assign) int button_unityad_pop_switch;
@property (nonatomic, assign) int button_vungle_pop_switch;

@property (nonatomic, assign) int ctrl_unlock_video_switch;
@property (nonatomic, assign) int ctrl_unlock_default_video_switch;
@property (nonatomic, copy) NSString *girl_video_url;

+(instancetype)sharedInstance;
-(void)startGet;

@end