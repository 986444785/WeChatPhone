//
//  ZYAboutToken.m
//  WeChatphone
//
//  Created by BBC on 16/5/3.
//  Copyright © 2016年 Chen. All rights reserved.
//

#import "ZYAboutToken.h"
#import "TipAlertView.h"
#import "Header.h"
#import "SDWebImageManager.h"
@implementation ZYAboutToken


//没有和微信网页链接？
+(void)unLinkWithWXwebviewWithObject:(id)Object
{
    //先判断有没有token

    NSString * token = [[NSUserDefaults standardUserDefaults]objectForKey:TOKEN];
    if (token == nil) {
        //请求二维码

        [HttpEngine getTwoCodeComplate:^(NSDictionary *response) {

            NSLog(@"response %@",response);

            [self showAlertViewWithObject:Object Withdic:response];

        }];
    }

}

+(void)showAlertViewWithObject:(id)object Withdic:(NSDictionary *)dic
{

    TipAlertView * alert = [[TipAlertView alloc]initWithMessage:dic[@"message"] ImageUrl:dic[@"qrcode"] buttonTitles:@[@"确定"]];

    alert.RefuseBlock = ^(){

        [self saveImageWithUrl:dic[@"qrcode"]];

    };

    [alert show];
}

/**
 *  保存图片到手机相册
 */
+(void)saveImageWithUrl:(NSString *)imageUrl
{
     [[SDWebImageManager sharedManager]downloadImageWithURL:[NSURL URLWithString:imageUrl] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {

     } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {

         if (finished) {
             [LSFMessageHint showToolMessage:@"保存成功" hideAfter:1.0 yOffset:0];

                 UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
         }
     }];

}
+(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    //do something
}
@end 
