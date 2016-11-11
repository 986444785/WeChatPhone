//
//  HttpEngine.m
//  WeChatphone
// 
//  Created by BBC on 16/4/19.
//  Copyright © 2016年 Chen. All rights reserved.
//

#import "HttpEngine.h"
#import "MBProgressHUD.h"
#import "People.h"
#import "JSONKit.h"
#import "ZYSavemanger.h"
#import "ZYPhoneAction.h"
#import "ZYLinkManSingleton.h"
@implementation HttpEngine 
/**
 *  前往系统设置
 */ 
+(void)systemSetting 
{
    //跳转到设置界面
    NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication]canOpenURL:url]) {
        [[UIApplication sharedApplication]openURL:url];
    }
}

+(void)requestTestDataCompate:(void(^)(NSDictionary *responsedic))complate
{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];

//    NSDictionary * parms = [NSDictionary dictionaryWithObjectsAndKeys:@"appKey",@"we_ios_1.0",@"uuid",@"901118",@"sign",@"740C0D658E2D1B3833B334DBC46995805FF7289E",@"sessionid",@"7139f796d54e7c00ec5e891c0b9157cd",@"other_half_uid",@"910573",@"method",@"pretendLovers.truth.nextQuestion", nil]
//    [manager POST:<#(nonnull NSString *)#> parameters:<#(nullable id)#> constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//
//    } progress:^(NSProgress * _Nonnull uploadProgress) {
//
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//
//    }];
}



+(void)telephoneCallWithPhoneNum:(NSString *)phoneNum  Object:(id)object Compate:(void(^)(NSDictionary *responsedic))complate
{

    NSDictionary * profileDic = [self getToken];

    NSString * baseUrl = [NSString stringWithFormat:@"/app/index.php?i=%@&m=yk_phone&c=entry&do=webcall",profileDic[WE_ID]];

    NSString * mainUrl = [NSString stringWithFormat:@"%@%@",profileDic[HOST],baseUrl];

    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithObjectsAndKeys:phoneNum,@"phone", nil];

    AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];

    [manger.requestSerializer setValue:profileDic[TOKEN] forHTTPHeaderField:@"token"];

        [manger POST:mainUrl parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {

        } progress:^(NSProgress * _Nonnull uploadProgress) {

        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

            complate(responseObject); 

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

            NSLog(@"error   %@",error);
        }];
} 

#pragma mark -- 果断电话
+(void)telePhoneHandleUpWithPhoneNum:(NSString *)phoneNum
{
    NSDictionary * profileDic = [self getToken];

    NSString * baseUrl = [NSString stringWithFormat:@"/app/index.php?i=%@&m=yk_phone&c=entry&do=webhangup",profileDic[WE_ID]];

    NSString * mainUrl = [NSString stringWithFormat:@"%@%@",profileDic[HOST],baseUrl];

    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithObjectsAndKeys:phoneNum,@"phone", nil];

    AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];

    [manger.requestSerializer setValue:profileDic[TOKEN] forHTTPHeaderField:@"token"];

    [manger POST:mainUrl parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {

    } progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

//        NSLog(@"responseObject:%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error:%@",error);
    }];
}
 

#pragma mark -- -验证token
+(void)verifyTokenWithStr:(NSString *)token Complate:(void(^)(BOOL isToken))complate
{

} 
  
#pragma mark --- profile
+(void)getProfileWithObject:(id)Object Complate:(void(^)(NSDictionary *responseDic))complate
{
    NSDictionary * profileDic = [self getToken];

    NSString * mainUrl = [NSString stringWithFormat:@"%@/app/index.php?i=%@&m=yk_phone&c=entry&do=webprofile",profileDic[HOST],profileDic[WE_ID]];

    AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];
    [manger.requestSerializer setValue:profileDic[TOKEN] forHTTPHeaderField:@"token"];

    [manger POST:mainUrl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {

    } progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        if ([responseObject[@"success"] intValue]==1) {
            complate(responseObject[@"data"]);
        }else{
            [GCDQueue executeInMainQueue:^{
                [LSFMessageHint showToolMessage:responseObject[@"message"] hideAfter:3.0 yOffset:0];
            }];
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error:%@",error);
  
        [GCDQueue executeInMainQueue:^{
//              [LSFMessageHint showToolMessage:[NSString stringWithFormat:@"%@",error] hideAfter:3.0 yOffset:0];
        }];

    }];

}

#pragma mark ---- 上传通讯录
+(void)upLoadAddressBookWithArrays:(NSArray *)arrays WithObject:(id)object Complate:(void(^)(NSDictionary *responseDic))complate
{
    MBProgressHUD * hud = nil;
    if (object) {
        UIViewController * vc = (UIViewController *)object;

        hud = [MBProgressHUD showHUDAddedTo:vc.view animated:YES];
        hud.labelText = @"loading....";
    }


//转化为json
    NSArray * items = [self transportWithArrays:arrays];

    NSString * jsonStr = [items JSONString];

    NSData *plainData      = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];

     NSString * base64Str   = [plainData  base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];

    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithObjectsAndKeys:base64Str,@"contacts", nil];

      NSDictionary * profileDic = [self getToken];

    NSString * mainUrl = [NSString stringWithFormat:@"%@/app/index.php?i=%@&m=yk_phone&c=entry&do=webupload",profileDic[HOST],profileDic[WE_ID]];

    AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];

    [manger.requestSerializer setValue:profileDic[WE_ID] forHTTPHeaderField:@"token"];

    [manger POST:mainUrl parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {

    } progress:^(NSProgress * _Nonnull uploadProgress) {

        hud.progress = uploadProgress.fractionCompleted;

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        [hud hide:YES];


        [LSFMessageHint showToolMessage:responseObject[@"message"] hideAfter:2.0 yOffset:0];

        complate(responseObject);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        [hud hide:YES];

    }];

}

#pragma mark -- -绑定手机号码 
+(void)bindingPhoneNumber:(NSString *)phoneNumber withMesssageToken:(NSString *)messageToken Complate:(void(^)(NSDictionary * response))complate
{ 
    NSDictionary * dic = [self getToken];
    NSString * mainUrl = [NSString stringWithFormat:@"%@/app/index.php?i=%@&m=yk_phone&c=entry&do=webbind",dic[HOST],dic[WE_ID]];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];

  [manager.requestSerializer setValue:dic[TOKEN] forHTTPHeaderField:@"token"];
    NSDictionary * parmas = [NSDictionary dictionaryWithObjectsAndKeys:phoneNumber,@"phone",messageToken,@"code", nil];

    [manager POST:mainUrl parameters:parmas progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        complate(responseObject);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

    }];
}
 
#pragma mark -- 获取验证码
+(void)getMessageTokenWithPhoneNumber:(NSString *)phoneNumber Complate:(void(^)(NSDictionary*response))complate
{
    NSDictionary * dic = [self getToken];
    NSString * mainUrl = [NSString stringWithFormat:@"%@/app/index.php?i=%@&m=yk_phone&c=entry&do=webgetverify",dic[HOST],dic[WE_ID]];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];

      [manager.requestSerializer setValue:dic[TOKEN] forHTTPHeaderField:@"token"];

    NSDictionary * parmas = [NSDictionary dictionaryWithObjectsAndKeys:phoneNumber,@"phone", nil];

    [manager POST:mainUrl parameters:parmas progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        //        [LSFMessageHint showToolMessage:<#(NSString *)#> hideAfter:<#(NSTimeInterval)#> yOffset:<#(CGFloat)#>]
                complate(responseObject);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

#pragma mark --- 关于二维码
+(void)getTwoCodeComplate:(void (^)(NSDictionary *response))complate
{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];

    NSString * mainUrl = @"http://v.rzlapp.com/app/app.json";

    [manager GET:mainUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        complate(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
           NSLog(@"error   %@",[NSString stringWithFormat:@"%@",error]);
    }];

}

#pragma mark -- 获取token
+(NSDictionary *)getToken
{
    NSString * host = [[NSUserDefaults standardUserDefaults]objectForKey:HOST];
    NSString * token = [[NSUserDefaults standardUserDefaults]objectForKey:TOKEN];
    NSString * weid = [[NSUserDefaults standardUserDefaults]objectForKey:WE_ID];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:host,HOST,token,TOKEN,weid,WE_ID ,nil];
    return dic;
}

 
#pragma mark --  保存token
//获取对应消息
+(void)saveTokenWIthDataDic:(NSDictionary *)dataDic
{
    NSString * token = dataDic[@"token"];
    if (![token isEqual:[NSNull class]] && token.length > 0) {
//        NSLog(@"保存token");
        [[NSUserDefaults standardUserDefaults] setObject:token forKey:TOKEN];
        [[NSUserDefaults standardUserDefaults] setObject:dataDic[@"we_id"] forKey:WE_ID];
        [[NSUserDefaults standardUserDefaults] setObject:dataDic[@"server"] forKey:HOST];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
}


// *******************  sockserver event *******************************//
#pragma mark --- event
+(NSString *)eventWorkWithMessage:(NSString *)message
{
    NSDictionary * baseDic = [HttpEngine parseJSONStringToNSDictionary:message];

    NSDictionary * dataDic = [baseDic objectForKey:@"data"];

    NSDictionary * backDic = nil;

    NSString * commandStr = dataDic[@"cmd"] ;

    if ([baseDic[@"flag"] intValue]==0) {
        if ([commandStr isEqualToString:@"get_contacts"]) {

            NSArray * array = [ZYSavemanger getTongXunLuWithargs:dataDic];

            NSDictionary * lastDic = [NSDictionary dictionaryWithObjectsAndKeys:array,@"items" ,nil];
            backDic = [NSDictionary dictionaryWithObjectsAndKeys:@"true",@"success",@"success",@"message",@"200",@"code",lastDic , @"data",nil];
        }else if ([commandStr isEqualToString:@"del_contacts"]){

            [ZYPhoneAction deleteLinkMainWithDict:dataDic];
            backDic = [NSDictionary dictionaryWithObjectsAndKeys:@"true",@"success",@"success",@"message",@"200",@"code", nil,@"data",nil];

        }else if ([commandStr isEqualToString:@"add_contacts"]){

            [ZYPhoneAction addLinkMainWithDict:dataDic];
            backDic = [NSDictionary dictionaryWithObjectsAndKeys:@"true",@"success",@"success",@"message",@"200",@"code", nil,@"data",nil];

        }else if ([commandStr isEqualToString:@"sync_contacts"]){
            //同步到服务器？

            backDic = [NSDictionary dictionaryWithObjectsAndKeys:@"success",@"success",@"同步成功！",@"message",@"200",@"code", nil,@"data",nil];

            [self prepareForUploadingAddressBook];

        }else{

            backDic = [NSDictionary dictionaryWithObjectsAndKeys:@"false",@"success",@"未能完成操作",@"message",@"400",@"code", nil,@"data",nil];
        }

        NSMutableDictionary * mutableDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"1",@"flag",baseDic[@"msg_id"] ,@"msg_id",backDic,@"data" ,nil];

        NSString * jsonStr = [HttpEngine dictionaryToJson:mutableDic];

        return jsonStr;

    }else{

        [HttpEngine saveTokenWIthDataDic:dataDic];

        return nil;
        
    } 
}

#pragma mark ---- 准备同步通讯录
+(void)prepareForUploadingAddressBook
{

    static BOOL isFinish = YES ;

    if (isFinish) {
        isFinish = !isFinish ;

        dispatch_queue_t queue = dispatch_queue_create("upLoading", DISPATCH_QUEUE_CONCURRENT);

        dispatch_async(queue, ^{
            [NSThread sleepForTimeInterval:2];
            NSLog(@"dispatch_async1");


            ZYLinkManSingleton * singleton = [ZYLinkManSingleton defaultSingletonISRefresh:NO];

            [self upLoadAddressBookWithArrays:singleton.peoples WithObject:nil Complate:^(NSDictionary *responseDic) {

                            isFinish = !isFinish ;

                NSLog(@"responseDic   \n %@",responseDic);

            }];

        });

    }

}



// *******************  分割线 *******************************//




+(NSMutableArray *)transportWithArrays:(NSArray *)arrays
{
    NSMutableArray * mutablearrray = [NSMutableArray array];

    for (People * p in arrays) {

        NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:p.name,@"name",p.phoneNum,@"phone", nil];

        [mutablearrray addObject:dic];
    }

    return mutablearrray;
}


#pragma mark ---- json转化
+ (NSDictionary *)parseJSONStringToNSDictionary:(NSString *)JSONString {
    NSData *JSONData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
    return responseJSON;
}

#pragma mark ---- 字典转化字符串
+ (NSString*)dictionaryToJson:(NSDictionary *)dic{
    
    NSError *parseError = nil;

    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];

    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}

//1. 整形判断
+ (BOOL)isPureInt:(NSString *)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

@end
