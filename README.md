# FXKit
基础功能封装组件, 每个类、类别除系统库以外, 无其他依赖, 皆可单独抽出使用.

## 组件工程结构
```
- FXKit
  - Util: 
    - FXFileUtil: 文件路径获取; 文件创建、删除、是否存在; 文件大小, 输出格式化等;
    - FXDateUtil: 各种日期的获取方法; 日期的格式化方法;
    - FXPageUtil: 分页模型数据管理

  - Enhancement: 
    - FXReuseObjectQueue: 通用复用队列

  - Category: 
    - NSPrefix:
      - NSTimer+FXWeakTarget: 不会强引用Target的NSTimer. Target释放时会会自动失效Timer.
      - NSArray+FXRearrange: 数组倒叙, 去重.
      - NSUserDefaults+FXSynchronizeSetter: 提供"setObject:forKey:"的同步方法.
    
    - UIPrefix:
      - UIView+FXOverlayCornerRadius: 通过生成与背景颜色同色的镂空图片覆盖在View上来实现"圆角", 无离屏渲染
    
    - CAPrefix:
      - CADisplayLink+FXWeakTarget: 不会强引用Target的DisplayLink. Target释放时会还会自动失效CADisplayLink.
```

