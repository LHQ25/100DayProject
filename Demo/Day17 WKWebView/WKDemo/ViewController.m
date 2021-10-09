//
//  ViewController.m
//  WKDemo
//
//  Created by 因酷  on 2018/11/9.
//  Copyright © 2018年 YK. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>
#import "NSString+Tool.h"
@interface ViewController ()<WKUIDelegate , WKNavigationDelegate , WKScriptMessageHandler>

@property (nonatomic , strong) WKWebView *webView;
@property (nonatomic , strong) UITextView *textView;
@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 400, UIScreen.mainScreen.bounds.size.width, 100)];
    self.textView.backgroundColor = UIColor.cyanColor;
    [self.view addSubview:self.textView];
    
//    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"test.html" ofType:nil]]];
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://news.baidu.com"]];
    [self.webView loadRequest:req];
    
    
//    NSString *html = [NSString stringWithFormat:@"<!DOCTYPE html>\
//    <html lang=ch>\
//    <head>\
//    <meta charset=\"utf-8\">\
//    <meta content=\"width=device-width, initial-scale=1\" name=\"viewport\" />\
//    <title>资讯</title>\
//    </head>\
//    <style>\
//    *{\
//    margin: 0px;\
//    padding: 0px;\
//    }\
//    </style>\
//    <body>\
//    <div style=\"width: 100%%;background-color: white\">\
//    <p style=\"color: black;font-size: 15px;text-align: center;margin-top: 4px;margin-left: 20px;margin-right: 20px;font: 18px bold;\">父亲而违法违规威尔刚玩儿够味儿各位各位各位各位各位各位各位各位噢关雎尔</p>\
//    <table style=\"width: 100%%;margin-top: 4px\">\
//    <tr>\
//    <td style=\"width: 50%%;height: 30px;text-align: center\">\
//    <img id=\"collect\" style=\"height:20px; width: auto;vertical-align:middle;\"  src=\"%@\" alt=\"日期\">\
//    <span style=\"line-height: inherit;height: inherit;vertical-align: middle\">2012-12-12</span>\
//    </td>\
//    <td style=\"width: 50%%;height: 30px;text-align: center\">\
//    <img id=\"collect2\" style=\"height:20px; width: auto;vertical-align:\"  src=\"%@\" alt=\"查看\">\
//    <span style=\"line-height: inherit;height: inherit;vertical-align: middle;\">225</span>\
//    </td>\
//    </tr>\
//    </table>\
//    </div>\
//    </body>\
//    </html>",[self bundleImgResourceWithImageName:@"time@2x.png"],[self bundleImgResourceWithImageName:@"2eyes@2x.png"]];
//    [self.webView loadHTMLString:html baseURL:nil];
    
    self.view.backgroundColor = UIColor.redColor;
    
}
//MARK: -
//MARK: - WKNavigationDelegate
//MARK: - 响应服务器操作
//MARK: - 当web视图开始接收web内容时调用
-(void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    NSLog(@"当web视图开始接收web内容时调用");
}
//MARK: - 当web视图接收到服务器重定向时调用
-(void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"服务器重定向时调用");
}
//MARK: - 身份验证
//AMRK: - 当web视图需要响应身份验证时调用
//-(void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler{
//    NSLog(@"身份验证");
////    [[NSURLCredential alloc] init];
//    completionHandler(NSURLSessionAuthChallengeUseCredential,);
//}
//MARK: - 对错误做出反应
//MARK: - 在导航过程中发生错误时调用
-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    NSLog(@"在导航过程中发生错误时调用");
}
//MARK: -当web视图加载内容时发生错误时调用
-(void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    NSLog(@"web视图加载内容时发生错误时调用: %@",error);
}
//MARK: -跟踪负载进展
//MARK: -当导航完成时调用
-(void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    NSLog(@"当导航完成时调用");
    
//    执行JS方法
//    [webView evaluateJavaScript:@"cus();" completionHandler:^(id _Nullable data, NSError * _Nullable error) {
//        NSLog(@"23");
//    }];
}
//MARK: -当web视图的web内容进程终止时调用
-(void)webViewWebContentProcessDidTerminate:(WKWebView *)webView{
    NSLog(@"当web视图的web内容进程终止时调用");
}
//MARK: -允许导航
//MARK: -决定是否允许或取消导航
-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    NSLog(@"决定是否允许或取消导航");
    NSURLRequest *request = navigationAction.request;
    NSURL *url = request.URL;
    
    decisionHandler(WKNavigationActionPolicyAllow);
}
////MARK: -在知道导航响应之后决定是否允许或取消导航。
-(void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    NSLog(@"在知道导航响应之后决定是否允许或取消导航");
    decisionHandler(WKNavigationResponsePolicyAllow);
}
//MARK: -导航政策
//MARK: - WKNavigationActionPolicy
/**
 WKNavigationActionPolicyCancel
 取消导航。
 WKNavigationActionPolicyAllow
 允许导航继续
 */
//MARK: - WKNavigationResponsePolicy
/**
 WKNavigationResponsePolicyCancel
 取消导航。
 WKNavigationResponsePolicyAllow
 允许导航继续
 */

//MARK: -


//MARK: -
//MARK: - WKUIDelegate
//MARK: - 创建Web视图
//-(WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures{
//
//    return nil;
//}
//MARK: - 显示UI面板
//MARK: - 显示一个JavaScript警告面板
-(void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    NSLog(@"显示一个JavaScript警告面板");
    NSLog(@"%@------%@",message,frame);
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"警告面板" message:@"警告面板" preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:[UIAlertAction actionWithTitle:message style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击alert");
    }]];
    [self presentViewController:alertVC animated:YES completion:nil];
    
    completionHandler();
}
//MARK: - 显示一个JavaScript确认面板
-(void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    NSLog(@"显示一个JavaScript确认面板");
    NSLog(@"%@------%@",message,frame);
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"确认面板" message:@"确认面板" preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:[UIAlertAction actionWithTitle:message style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        completionHandler(NO);
    }]];
    [self presentViewController:alertVC animated:YES completion:nil];
    completionHandler(true);
}
//MARK: - 显示一个JavaScript文本输入面板
-(void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    NSLog(@"显示一个JavaScript文本输入面板");
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"确认面板" message:@"确认面板" preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        NSLog(@"%@",textField);
    }];
    [alertVC addAction:[UIAlertAction actionWithTitle:prompt style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(@"确认");
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:defaultText style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(@"取消");
    }]];
    [self presentViewController:alertVC animated:YES completion:nil];
}
//MARK: -对强制触摸动作的响应
//MARK: - 确定给定元素是否应该显示预览
//- (BOOL)webView:(WKWebView *)webView shouldPreviewElement:(WKPreviewElementInfo *)elementInfo{
//    return YES;
//}
//MARK: - 当用户执行一个peek操作时调用
//-(UIViewController *)webView:(WKWebView *)webView previewingViewControllerForElement:(WKPreviewElementInfo *)elementInfo defaultActions:(NSArray<id<WKPreviewActionItem>> *)previewActions{
//
//}
//MARK: -当用户对预览执行弹出操作时调用
//-(void)webView:(WKWebView *)webView commitPreviewingViewController:(UIViewController *)previewingViewController{
//
//}
//MARK: -关闭Web视图
-(void)webViewDidClose:(WKWebView *)webView{
    NSLog(@"关闭Web视图");
}
//MARK: -

//MARK: -
//MARK: - WKScriptMessageHandler  WebView调用原生方法
-(void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    NSLog(@"userContentController----didReceiveScriptMessage --- %@--%@",message.name,message.body);
    if ([message.name isEqualToString:@"noParameter"]) {
        self.textView.text = @"无参数传递";
    }else if ([message.name isEqualToString:@"singleParameter"]) {
        self.textView.text = message.body;
    }else if ([message.name isEqualToString:@"arrayParameter"]) {
        
        NSArray *array = message.body;
        NSData *data = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:nil];
        self.textView.text =[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }else if ([message.name isEqualToString:@"dictionaryParameter"]) {
        NSDictionary *dic = message.body;
        NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
        self.textView.text =[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.webView evaluateJavaScript:@"as();" completionHandler:^(id _Nullable data, NSError * _Nullable error) {
        ;
    }];
}

- (WKPreferences *)configWKPreferences{
    //web视图要使用的首选项对象
    WKPreferences *preferences = [[WKPreferences alloc] init];
    //最小字体大小
    preferences.minimumFontSize = 15;
    //指示是否启用了JavaScript ;默认值是YES。
    preferences.javaScriptEnabled = YES;
    //指示JavaScript是否可以打开没有用户交互的窗口。iOS默认值为NO
    preferences.javaScriptCanOpenWindowsAutomatically = NO;
    //指示是否应警告  针对可疑的欺诈性内容（例如网络钓鱼或恶意软件）显示
    if (@available(iOS 13.0, *)) {
        preferences.fraudulentWebsiteWarningEnabled = true;
    }
    return  preferences;
}

- (WKUserContentController *)configWKUserContent{
    
    //与web视图相关联的用户内容控制器
    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
    //window.webkit.messageHandlers.showMethod.postMessage({"k1":"v1","k2":"v2"});
    // 添加脚本消息处理程序  JS调OC方法    name ：js要 使用的  name
    [userContentController addScriptMessageHandler:self name:@"noParameter"]; //无参
    [userContentController addScriptMessageHandler:self name:@"singleParameter"]; //单参数
    [userContentController addScriptMessageHandler:self name:@"arrayParameter"]; //数组参数
    [userContentController addScriptMessageHandler:self name:@"dictionaryParameter"]; //字典参数
    //删除脚本消息处理程序
    //[userContentController removeScriptMessageHandlerForName:@"noParameter"];
    
    
    //注入JS代码
    /**
     scoure : 脚本的源代码
     WKUserScriptInjectionTimeAtDocumentStart
     在创建文档元素之后，但在加载任何其他内容之前注入脚本。
     WKUserScriptInjectionTimeAtDocumentEnd
     在文档完成加载之后，但在其他子资源完成加载之前注入脚本
     injectionTime : 将脚本注入网页的时间
     forMainFrameOnly : 指示脚本是否应该只注入主框架(YES)或所有框架(NO)
     */
    NSString *jsString = @"""\
    function changeColor(){\
        var div = document.getElementById(\"editDiv\");\
        div.style.backgroundColor = \"cyan\"\
    }\
    function addButton(){\
        var button = document.createElement('button');\
        button.onclick = changeColor;\
        button.type = \"button\";\
        button.style.width = \"200px\";\
        button.style.height = \"30px\";\
        button.innerText = \"changeColor\";\
        document.getElementById(\"showDiv\").append(button);\
    }\
    addButton()\
    """;
    ///注入一个按钮  点击可以修改背景色
    WKUserScript *userScript = [[WKUserScript alloc] initWithSource:jsString injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    [userContentController addUserScript:userScript];
    //删除所有关联的用户脚本
    //[userContentController removeAllUserScripts];
    
    //添加和删除内容规则
//    if (@available(iOS 11.0, *)) {
//        WKContentRuleList *ruleList = [[WKContentRuleList alloc] init];
//        [userContentController addContentRuleList:ruleList];
//        //删除一个规则列表
//        [userContentController removeContentRuleList:ruleList];
//        //删除所有规则列表
//        [userContentController removeAllContentRuleLists];
//    }
    return userContentController;
}
-(WKWebView *)webView{
    if (!_webView) {
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        //MARK: - 配置新Web视图的属性
        config.applicationNameForUserAgent = @"myUserAgent";//用户代理字符串中使用的应用程序名称。
        //web视图要使用的配置对象
        config.preferences = [self configWKPreferences];
        //页面Content  基本是和JS交互相关
        config.userContentController = [self configWKUserContent];
        //web视图使用的网站数据存储
//        NSSet *set = [WKWebsiteDataStore allWebsiteDataTypes];
//        NSLog(@"%@",set);
        WKWebsiteDataStore *dataStore = [WKWebsiteDataStore defaultDataStore];
        config.websiteDataStore = dataStore;
        
        //MARK: - 是允许网页缩放 默认值为NO
        config.ignoresViewportScaleLimits = NO;
        //MARK: - web视图是否完全加载到内存中才开始渲染; 默认值为NO
        config.suppressesIncrementalRendering = NO;
        
        //确定数据类型
        /**
         WKDataDetectorTypeNone
         不执行任何检测。
         WKDataDetectorTypePhoneNumber
         电话号码被检测，并变成链接。
         WKDataDetectorTypeLink
         检测到文本中的url并将其转换为链接。
         WKDataDetectorTypeAddress
         地址被检测并变成链接。
         WKDataDetectorTypeCalendarEvent
         将来的日期和时间会被检测并变成链接。
         WKDataDetectorTypeTrackingNumber
         跟踪号码被检测并变成链接。
         WKDataDetectorTypeFlightNumber
         航班号会被检测到，并变成链接。
         WKDataDetectorTypeLookupSuggestion
         WKDataDetectorTypeSpotlightSuggestion
         聚光灯的建议被检测并变成链接。
         弃用
         WKDataDetectorTypeAll
         当检测到上述所有数据类型时，都将转换为链接。选择此值将自动包括添加到此常量的任何新检测类型。
         */
        config.dataDetectorTypes = WKDataDetectorTypeNone;
        
        //MARK: - 设置媒体播放首
        config.allowsInlineMediaPlayback = NO;//HTML5视频是否内联播放 (是)或使用本机全屏控制器(否)。 默认值是NO;在iOS 10.0之前创建的应用程序必须使用webkit-playsinline属性。默认值为NO
        config.allowsAirPlayForMediaPlayback = YES;//是否允许AirPlay播放 ; 默认值是YES
        config.allowsPictureInPictureMediaPlayback = YES;//HTML5视频是否可以播放 画中画。 默认值是YES
        /**
         WKAudiovisualMediaTypeNone
         没有媒体类型需要用户手势开始播放。
         WKAudiovisualMediaTypeAudio
         包含音频的媒体类型需要用户手势才能开始播放。
         WKAudiovisualMediaTypeVideo
         包含视频的媒体类型需要用户手势才能开始播放。
         WKAudiovisualMediaTypeAll
         所有媒体类型都需要一个用户手势来开始播放。
         */
        config.mediaTypesRequiringUserActionForPlayback = WKAudiovisualMediaTypeNone;//确定哪些媒体类型需要用户手势开始播放
        
        //设置选择粒度
        /**
         WKSelectionGranularityCharacter
         选择端点可以放在任何字符边界。
         WKSelectionGranularityDynamic
         选择粒度根据选择的不同而自动变化。
         */
        config.selectionGranularity =  WKSelectionGranularityDynamic;//用户可以交互选择web视图中的内容的粒度级别
        
//        config setURLSchemeHandler:<#(nullable id<WKURLSchemeHandler>)#> forURLScheme:<#(nonnull NSString *)#>
        
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 400) configuration:config];
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        [self.view addSubview:_webView];
    }
    return _webView;
}


@end
