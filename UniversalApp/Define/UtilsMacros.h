//
//  define.h
//  MiAiApp
//
//  Created by JadeM on 2017/5/18.
//  Copyright © 2017年 JadeM. All rights reserved.
//

// 全局工具类宏定义

#ifndef define_h
#define define_h

#define K_VERSION_SHORT  [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]

#define K_VERSION  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]

//轻量缓存
#define defaults [NSUserDefaults standardUserDefaults]

#define JSON_STR(A) [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:@[A] options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding]
#define LARGER(A,B) (A) > (B) ? (A) : (B)
#define  SMALLER(A,B) (A) < (B) ? (A) : (B)
#define INTERVAL(x,min,max) (x) >= (min) && (x) <= (max) ? x : (x) < (min) ? (min) : max
#define K_ABS_ZERO(S) ([S intValue] >= 0) ? S : @"0"

#define kString_Format(fmt, ...) [NSString stringWithFormat:fmt, ##__VA_ARGS__]
#define MAP_LENGTH_DASH(S) ([S length] > 0) ? S : @"--"

#define STRINGIFY(S) #S
#define DEFER_STRINGIFY(S) STRINGIFY(S)
#define PRAGMA_MESSAGE(MSG) _Pragma(STRINGIFY(message(MSG)))
#define FORMATTED_MESSAGE(MSG) "[TODO-" DEFER_STRINGIFY(__COUNTER__) "] " MSG " \n" \
DEFER_STRINGIFY(__FILE__) " line " DEFER_STRINGIFY(__LINE__)
#define KEYWORDIFY try {} @catch (...) {}
// 最终使用下面的宏
#define TODO(MSG) KEYWORDIFY PRAGMA_MESSAGE(FORMATTED_MESSAGE(MSG))


// 表示释放对象，并且将该对象赋值为nil。
#define TT_RELEASE_SAFELY(__POINTER) { [__POINTER release]; __POINTER = nil; }
// 停止时间计数器，并且将该计数器赋值为nil
#define TT_INVALIDATE_TIMER(__TIMER) { [__TIMER invalidate]; __TIMER = nil; }
// 检测对象是否为nil，如果不为nil释放对象，最后赋值为nil。
#define TT_RELEASE_CF_SAFELY(__REF) { if (nil != (__REF)) { CFRelease(__REF); __REF = nil; } }

//缩写
#define APP_DELEGATE_INSTANCE                       ((AppDelegate*)([UIApplication sharedApplication].delegate))
#define USER_DEFAULT                                [NSUserDefaults standardUserDefaults]
#define MAIN_STORY_BOARD(Name)                      [UIStoryboard storyboardWithName:Name bundle:nil]
#define NS_NOTIFICATION_CENTER
//系统
#define iOS7orLater ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define iOS8orLater ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define iOS9orLater ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)
#define iOS10orLater ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0)
#define iOS11orLater ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0)
//设备设备
#define isiPhone4 CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size)
#define isiPhone5 CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size)
#define isiPhone5S CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size)
#define isiPhone6 CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size)
#define isiPhone6Plus CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size)
#define isiPhone6s CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size)
#define isiPhone6sPlus CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size)
#define isiPhone7 CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size)
#define isiPhone7Plus CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size)
#define isiPhone8ZoomIN CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size)
#define isiPhone8PlusZoomIN  CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size)
#define isiPhoneXZoomIn CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size)
#define isiPhoneX CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size)

//----------------------图片相关----------------------------
//读取本地图片
#define LOADIMAGE(file,ext) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:file ofType:ext]]
//定义UIImage对象
#define IMAGE(A) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:A ofType:nil]]
//定义UIImage对象
#define ImageNamed(_pointer) [[UIImage imageNamed:_pointer]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
//1像素线宽的宏。
#define KSINGLELINE_WIDTH  1.0f/([UIScreen mainScreen].scale)

#define random_color [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1]

///** 系统状态栏 */
// iOS系统版本
#define SYSTEM_VERSION [[[UIDevice currentDevice] systemVersion] doubleValue]
// 标准系统状态栏高度
#define SYS_STATUSBAR_HEIGHT (isiPhoneX ? 44 : 20)
// 热点栏高度
#define HOTSPOT_STATUSBAR_HEIGHT (isiPhoneX ? 0 : 20)
// 导航栏（UINavigationController.UINavigationBar）高度
#define NAVIGATIONBAR_HEIGHT (44)
// 工具栏（UINavigationController.UIToolbar）高度
#define TOOLBAR_HEIGHT (44)
// 标签栏（UITabBarController.UITabBar）高度
#define TABBAR_HEIGHT (isiPhoneX ? 83: 49)

#define NAV_HEIGHT (SYS_STATUSBAR_HEIGHT + NAVIGATIONBAR_HEIGHT)

#define TABBAR_X_DIF_HEIGHT (isiPhoneX ? 34: 0)

//字体
#define FONT_CUSTOM                     @"Avenir-heavy"
#define FONT_CUSTOM_LIGHT               @"Avenir"
#define FONT_SYSTEM                     @"Helvetica"
#define FONT_HELVETICABOLD              @"Helvetica-Bold"
#define FONT_HELVETICANEUE              @"HelveticaNeue"
#define FONT_HELVETICALIGHT             @"HelveticaNeue-Light"
#define FONT_HELVETICANEUEBOLD          @"HelveticaNeue-Bold"

#define isiPhone [[UIDevice currentDevice].model isEqualToString:@"iPhone"]
#define isiPad [[UIDevice currentDevice].model isEqualToString:@"iPad"]
#define isiPod [[UIDevice currentDevice].model isEqualToString:@"iPod touch"]
#define isiPadPro CGSizeEqualToSize(CGSizeMake(1366, 1024), [[UIScreen mainScreen] currentMode].size)

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define IS_OS_5_OR_LATER                            SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"5.0")
#define IS_OS_6_OR_LATER                            SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")
#define IS_OS_7_OR_LATER                            SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")
#define IS_OS_8_OR_LATER                            SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")
#define IS_OS_9_OR_LATER                            SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")
#define IS_OS_10_OR_LATER                           SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"10.0")

//获取系统对象
#define kApplication        [UIApplication sharedApplication]
#define kAppWindow          [UIApplication sharedApplication].delegate.window
#define kAppDelegate        [AppDelegate shareAppDelegate]
#define kRootViewController [UIApplication sharedApplication].delegate.window.rootViewController
#define kUserDefaults       [NSUserDefaults standardUserDefaults]
#define kNotificationCenter [NSNotificationCenter defaultCenter]

#define kStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
#define kNavBarHeight 44.0
#define kTabBarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height>20?83:49)
#define kTopHeight (kStatusBarHeight + kNavBarHeight)

//获取屏幕宽高
#define KScreenWidth ([[UIScreen mainScreen] bounds].size.width)
#define KScreenHeight [[UIScreen mainScreen] bounds].size.height
#define kScreen_Bounds [UIScreen mainScreen].bounds

#define Iphone6ScaleWidth KScreenWidth/375.0
#define Iphone6ScaleHeight KScreenHeight/667.0
//根据ip6的屏幕来拉伸
#define kRealValue(with) ((with)*(KScreenWidth/375.0f))

//强弱引用
#define kWeakSelf(type)  __weak typeof(type) weak##type = type;
#define kStrongSelf(type) __strong typeof(type) type = weak##type;

//View 圆角和加边框
#define ViewBorderRadius(View, Radius, Width, Color)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]

// View 圆角
#define ViewRadius(View, Radius)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES]

//property 属性快速声明 别用宏定义了，使用代码块+快捷键实现吧

// 当前系统版本
#define CurrentSystemVersion [[UIDevice currentDevice].systemVersion doubleValue]
//当前语言
#define CurrentLanguage (［NSLocale preferredLanguages] objectAtIndex:0])

//-------------------打印日志-------------------------
//DEBUG  模式下打印日志,当前行
#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(...)
#endif

//拼接字符串
#define NSStringFormat(format,...) [NSString stringWithFormat:format,##__VA_ARGS__]

//颜色
#define KClearColor [UIColor clearColor]
#define KWhiteColor [UIColor whiteColor]
#define KBlackColor [UIColor blackColor]
#define KGrayColor [UIColor grayColor]
#define KGray2Color [UIColor lightGrayColor]
#define KBlueColor [UIColor blueColor]
#define KRedColor [UIColor redColor]
#define kRandomColor    KRGBColor(arc4random_uniform(256)/255.0,arc4random_uniform(256)/255.0,arc4random_uniform(256)/255.0)        //随机色生成
//----------------------颜色相关----------------------------
#define COLOR_KEYBOARD      [ToolHelper colorWithHexString:@"#DCDCDC"]//DCDCDC（键盘灰）
#define COLOR_DARKBLACK     [ToolHelper colorWithHexString:@"#000000"]//000000（大标题黑）
#define COLOR_BLUE          [ToolHelper colorWithHexString:@"#368DE7"]//368DE7（主色）
#define COLOR_GREEN         [ToolHelper colorWithHexString:@"#28A946"]//28A946（跌）
#define COLOR_RED           [ToolHelper colorWithHexString:@"#E84342"]//E84342（涨）
#define COLOR_YELLOW        [ToolHelper colorWithHexString:@"#F2AD27"]//F2AD27（按钮）
#define COLOR_ORANGE        [ToolHelper colorWithHexString:@"#FC6432"]//FC6432（图标）
#define COLOR_DARKGREY      [ToolHelper colorWithHexString:@"#4A4A4A"]//4A4A4A（小文字灰）
#define COLOR_LINE          [ToolHelper colorWithHexString:@"#C7C7C7"]//C7C7C7（线灰）
#define COLOR_LIGHTGRAY     [ToolHelper colorWithHexString:@"#999999"]//999999（时间／简介灰）
#define COLOR_BACK          [ToolHelper colorWithHexString:@"#f0f0f0"]//F0F0F0（底色灰）
#define COLOR_WHITE         [ToolHelper colorWithHexString:@"#ffffff"]//FFFFFF (白色)
#define COLOR_DESCRIPTION   [ToolHelper colorWithHexString:@"#cccccc"]//cccccc (描述灰)

//字体
#define BOLDSYSTEMFONT(FONTSIZE)[UIFont boldSystemFontOfSize:FONTSIZE]
#define SYSTEMFONT(FONTSIZE)    [UIFont systemFontOfSize:FONTSIZE]
#define FONT(NAME, FONTSIZE)    [UIFont fontWithName:(NAME) size:(FONTSIZE)]


//定义UIImage对象
#define ImageWithFile(_pointer) [UIImage imageWithContentsOfFile:([[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@@%dx", _pointer, (int)[UIScreen mainScreen].nativeScale] ofType:@"png"])]
#define IMAGE_NAMED(name) [UIImage imageNamed:name]

//数据验证
#define StrValid(f) (f!=nil && [f isKindOfClass:[NSString class]] && ![f isEqualToString:@""])
#define SafeStr(f) (StrValid(f) ? f:@"")
#define HasString(str,key) ([str rangeOfString:key].location!=NSNotFound)

#define ValidStr(f) StrValid(f)
#define ValidDict(f) (f!=nil && [f isKindOfClass:[NSDictionary class]])
#define ValidArray(f) (f!=nil && [f isKindOfClass:[NSArray class]] && [f count]>0)
#define ValidNum(f) (f!=nil && [f isKindOfClass:[NSNumber class]])
#define ValidClass(f,cls) (f!=nil && [f isKindOfClass:[cls class]])
#define ValidData(f) (f!=nil && [f isKindOfClass:[NSData class]])

//获取一段时间间隔
#define kStartTime CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
#define kEndTime  NSLog(@"Time: %f", CFAbsoluteTimeGetCurrent() - start)
//打印当前方法名
#define ITTDPRINTMETHODNAME() ITTDPRINT(@"%s", __PRETTY_FUNCTION__)


//发送通知
#define KPostNotification(name,obj) [[NSNotificationCenter defaultCenter] postNotificationName:name object:obj];

//弱引用-强引用
#define uWeakSelf typeof(self) __weak weakSelf = self;
#define uStrongSelf typeof(self) __block strongSelf = self;

//单例化一个类
#define SINGLETON_FOR_HEADER(className) \
\
+ (className *)shared##className;

#define SINGLETON_FOR_CLASS(className) \
\
+ (className *)shared##className { \
static className *shared##className = nil; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
shared##className = [[self alloc] init]; \
}); \
return shared##className; \
}



#endif /* define_h */
