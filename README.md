# ZSFakeTouch
Simulate touch events for iOS 模拟点击
### 代码导入
* 一 , 导入`ZSFakeTouch`文件夹到你的项目中 (文件夹在 Demo 中可以找到)
* 二 , 在你需要使用的 viewController 中，`#import "ZSFakeTouch.h"`;
* 三 , 在需要点击的位置敲入代码即可
````
开始点击
    [ZSFakeTouch beginTouchWithPoint:CGPointMake(300,40)];
结束点击
    [ZSFakeTouch endTouchWithPoint:CGPointMake(300,40)];
移动
    [ZSFakeTouch moveTouchWithPoint:CGPointMake(300,40)];

````
