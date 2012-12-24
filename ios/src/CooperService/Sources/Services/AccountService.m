//
//  AccountService.m
//  Cooper
//
//  Created by sunleepy on 12-7-9.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "AccountService.h"

@implementation AccountService

+ (void)login:(NSString*)username 
     password:(NSString*)password 
      context:(NSMutableDictionary *)context 
     delegate:(id)delegate
{
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    [data setObject:username forKey:@"userName"];
    [data setObject:password forKey:@"password"];
    
    NSMutableDictionary *headers = [NSMutableDictionary dictionary];
    [headers setObject:@"xmlhttp" forKey:@"X-Requested-With"];
    
    NSString* url = [[[ConstantClass instance] rootPath] stringByAppendingFormat:LOGIN_URL];
    NSLog(@"【Login登录请求】%@", url);
    
    [NetworkManager doAsynchronousPostRequest:url Delegate:delegate data:data WithInfo:context addHeaders:headers];
}

+ (void)workbenchLogin:(NSString *)domain
              username:(NSString *)username
              password:(NSString *)password
               context:(NSMutableDictionary*)context
              delegate:(id)delegate
{
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    [data setObject:domain forKey:@"domain"];
    [data setObject:username forKey:@"userName"];
    [data setObject:password forKey:@"password"];
    
    NSString* url = [[[ConstantClass instance] rootPath] stringByAppendingFormat:WORKBENCHLOGIN_URL];
    NSLog(@"【WorkbenchLogin登录请求】%@", url);
    
    [NetworkManager doAsynchronousPostRequest:url Delegate:delegate data:data WithInfo:context addHeaders:nil];
}

+ (void) login:(NSString *)domain 
      username:(NSString *)username 
      password:(NSString *)password 
       context:(NSMutableDictionary *)context 
      delegate:(id)delegate
{
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    [data setObject:@"login" forKey:@"state"];
    [data setObject:domain forKey:@"cbDomain"];
    [data setObject:username forKey:@"tbLoginName"];
    [data setObject:password forKey:@"tbPassword"];
    
    NSString* url = [[[ConstantClass instance] rootPath] stringByAppendingFormat:ARKLOGIN_URL];
    NSLog(@"【ArkLogin登录请求】 %@", url);
    
    [NetworkManager doAsynchronousPostRequest:url Delegate:delegate data:data WithInfo:context addHeaders:nil];
}

+ (void)googleLogin:(NSString*)refreshToken
            context:(NSMutableDictionary*)context
           delegate:(id)delegate
{
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    [data setObject:refreshToken forKey:@"refreshToken"];
    
    NSString* url = [[[ConstantClass instance] rootPath] stringByAppendingFormat:@"/Account/GoogleLoginByRefreshToken"];
    NSLog(@"【GoogleLogin登录请求】%@", url);
    [NetworkManager doAsynchronousPostRequest:url Delegate:delegate data:data WithInfo:context addHeaders:nil];
}

+ (void)googleLogin:(NSString *)error 
               code:(NSString*)code 
              state:(NSString*)state 
               mobi:(NSString*)mobi 
               joke:(NSString*)joke
            context:(NSMutableDictionary *)context 
           delegate:(id)delegate
{
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    [data setObject:error forKey:@"error"];
    [data setObject:code forKey:@"code"];
    [data setObject:state forKey:@"state"];
    [data setObject:mobi forKey:@"mobi"];
    [data setObject:joke forKey:@"joke"];
    
    NSString* url = [[[ConstantClass instance] rootPath] stringByAppendingFormat:GOOGLE_LOGIN_URL];
    NSLog(@"【GoogleLogin登录请求】%@", url);
    [NetworkManager doAsynchronousPostRequest:url Delegate:delegate data:data WithInfo:context addHeaders:nil];
}

+ (void)logout:(NSMutableDictionary*)context 
      delegate:(id)delegate
{
    NSString* url = [[[ConstantClass instance] rootPath] stringByAppendingFormat:LOGOUT_URL];
    NSLog(@"【注销请求】%@",url);
    [NetworkManager doAsynchronousPostRequest:url Delegate:delegate data:nil WithInfo:context addHeaders:nil];
}

@end
