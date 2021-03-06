# AppMonitor

[![CI Status](https://img.shields.io/travis/StoneStoneStone/AppMonitor.svg?style=flat)](https://travis-ci.org/StoneStoneStone/AppMonitor)
[![Version](https://img.shields.io/cocoapods/v/AppMonitor.svg?style=flat)](https://cocoapods.org/pods/AppMonitor)
[![License](https://img.shields.io/cocoapods/l/AppMonitor.svg?style=flat)](https://cocoapods.org/pods/AppMonitor)
[![Platform](https://img.shields.io/cocoapods/p/AppMonitor.svg?style=flat)](https://cocoapods.org/pods/AppMonitor)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## DemoCode

### 卡顿监测 & CPU消耗
```objective-c
typedef NS_OPTIONS(NSUInteger, AppMonitorOptions) {
    AppMonitorCPUUsage = 1 << 0,
    AppMonitorMainRunLoopStuck = 1 << 1,
};

@interface AppMonitor : NSObject

+ (instancetype)sharedInstance;

- (void)startMointor:(AppMonitorOptions)options;

- (void)stopMointor:(AppMonitorOptions)options;

@end
```

### 函数调用分析
```objective-c
@interface AppMonitor (FuncTime)

- (void)start;
- (void)startWithMaxDepth:(int)depth;
- (void)startWithMinTimeCost:(double)ms;
- (void)startWithMaxDepth:(int)depth minTimeCost:(double)ms;

- (void)saveToDB;

- (void)stop;
- (void)clearMemory;

@end
```

### 线程安全的本地缓存
```objective-c
// 本类只负责本地记录，上传需求比较灵活，此处不再封装
@interface AppMonitor (Record)

- (void)recordStackInfo:(AMStackModel *)model;
- (void)clearStackInfo;

- (void)recordFuncInfo:(AMFuncCostModel *)model;
- (void)clearFuncInfo;

@end
```

## Tasks
- [ ] 程序有消耗性能的地方 thread get state。这个也会被监控检查出，所以可以过滤掉这样的堆栈信息
 

## Requirements

## Installation

AppMonitor is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'ISAppMonitor'
```

## Search
```ruby
-> ISAppMonitor (0.1.9)
   集成有关App的性能监控功能
   pod 'ISAppMonitor', '~> 0.1.9'
   - Homepage: https://github.com/iBlackStone/AppMonitor
   - Source:   https://github.com/iBlackStone/AppMonitor.git
   - Versions: 0.1.9 [Master repo]
   - Subspecs:
     - ISAppMonitor/Core (0.1.9)
     - ISAppMonitor/Database (0.1.9)
     - ISAppMonitor/Model (0.1.9)
     - ISAppMonitor/Utils (0.1.9)
(END)
```

## Author

参考大牛代码，感谢他们无私的分享
1.  戴铭 -  [iOS开发高手课](https://time.geekbang.org/column/intro/161?code=Qjb1JtJcvAPISj9QjxdKrAmeXmURMroQbkOcLNm0jeY%3D&from=singlemessage&isappinstalled=0)

## License

AppMonitor is available under the MIT license. See the LICENSE file for more info.
