# Flutter 3.41 Sliver 完整继承体系

## 一、Widget 层（Sliver Widgets）

    Widget
    └── RenderObjectWidget
    └── SliverWithKeepAliveWidget
    └── SliverMultiBoxAdaptorWidget
    ├── SliverList
    ├── SliverFixedExtentList
    ├── SliverPrototypeExtentList
    ├── SliverGrid
    ├── SliverAnimatedList
    └── SliverAnimatedGrid
    
    └── SingleChildRenderObjectWidget
       ├── SliverToBoxAdapter
       ├── SliverPadding
       ├── SliverOpacity
       ├── SliverIgnorePointer
       ├── SliverOffstage
       ├── SliverLayoutBuilder
       ├── SliverVisibility
       ├── DecoratedSliver ⭐（新增）
       └── SliverConstrainedCrossAxis ⭐（新增）
       
    └── MultiChildRenderObjectWidget
     ├── SliverMainAxisGroup ⭐（新增）
     ├── SliverCrossAxisGroup ⭐（新增）
     └── SliverCrossAxisExpanded ⭐（新增）
       
    └── 其他 Sliver Widget
       ├── SliverAppBar（Material）
       ├── SliverPersistentHeader
       ├── SliverFillRemaining
       ├── SliverFillViewport
       ├── SliverOverlapAbsorber
       ├── SliverOverlapInjector
       └── SliverSafeArea 
---

## 二、Element 层

    Element
    └── RenderObjectElement
    ├── SliverMultiBoxAdaptorElement
    ├── SingleChildRenderObjectElement
    └── SliverPersistentHeaderElement
    
---

## 三、RenderObject 层（核心）

    RenderObject
    └── RenderSliver
    ├── RenderSliverSingleBoxAdapter
    │ ├── RenderSliverToBoxAdapter
    │ ├── RenderSliverPadding
    │ ├── RenderSliverOpacity
    │ ├── RenderSliverIgnorePointer
    │ ├── RenderSliverOffstage
    │ └── RenderSliverLayoutBuilder
    │
    ├── RenderSliverMultiBoxAdaptor
    │ ├── RenderSliverList
    │ ├── RenderSliverFixedExtentList
    │ ├── RenderSliverPrototypeExtentList
    │ ├── RenderSliverGrid
    │ ├── RenderSliverAnimatedList
    │ └── RenderSliverAnimatedGrid
    │
    ├── RenderSliverPersistentHeader
    │ ├── RenderSliverPinnedPersistentHeader
    │ ├── RenderSliverFloatingPersistentHeader
    │ └── RenderSliverScrollingPersistentHeader
    │
    ├── RenderSliverFillRemaining
    ├── RenderSliverFillViewport
    ├── RenderSliverOverlapAbsorber
    ├── RenderSliverOverlapInjector
    └── RenderSliverSafeArea
    
---

## 四、Delegate / 辅助体系

    - SliverChildBuilderDelegate（懒加载，推荐）
    - SliverChildListDelegate（静态）
    - SliverGridDelegateWithFixedCrossAxisCount
    - SliverGridDelegateWithMaxCrossAxisExtent
    - SliverPersistentHeaderDelegate

---

## 五、使用场景总结

    ### 容器
    - CustomScrollView：组合所有 Sliver
    
    ### 列表
    - SliverList：不定高（默认）
    - SliverFixedExtentList：定高（性能最好）
    - SliverPrototypeExtentList：prototype 高度
    
    ### 网格
    - SliverGrid：网格布局
    
    ### 适配
    - SliverToBoxAdapter：普通 Widget 转 Sliver（⚠️少用）
    
    ### 布局
    - SliverPadding  
    - SliverFillRemaining  
    - SliverFillViewport  
    - SliverSafeArea  
    
    ### Header
    - SliverAppBar：折叠 / 悬浮 / 吸顶  
    - SliverPersistentHeader：自定义吸顶  
    
    ### 动画
    - SliverAnimatedList  
    - SliverAnimatedGrid  
    
    ### 嵌套
    - SliverOverlapAbsorber  
    - SliverOverlapInjector  
    
    ### 控制
    - SliverOpacity  
    - SliverVisibility  
    - SliverIgnorePointer  
    - SliverOffstage  

---

## 六、核心结论

    - Sliver 本质：可滚动分片布局
    - 性能核心：RenderSliverMultiBoxAdaptor
    - 三层结构：Widget → Element → RenderSliver
    
    ### 标准结构
    
        CustomScrollView
        ├── SliverAppBar
        ├── SliverList / Grid
        └── SliverFillRemaining
