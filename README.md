# FXKit
基础功能封装组件, 每个类、类别除系统库以外, 无其他依赖, 皆可单独抽出使用.

## 组件工程结构
```
- FXKit
  - Util: 工具类
    FXFileUtil: 文件路径获取; 文件创建、删除、是否存在; 文件大小, 输出格式化等;
  - Category: 类别
    - NSPrefix:
      NSTimer+FXWeakTarget: 不会强引用Target的NSTimer. Target释放时会会自动失效Timer.
      NSArray+Rearrange: 数组倒叙, 去重.
      NSUserDefaults+SynchronizeSetter: 提供"setObject:forKey:"的同步方法.
    - CAPrefix:
      CADisplayLink+FXWeakTarget: 不会强引用Target的DisplayLink. Target释放时会还会自动失效CADisplayLink.
```

