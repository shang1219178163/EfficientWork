## UIAppearance 主题色设置总结
 
 ```  
1. 关于 UIAppearance
UI_APPEARANCE_SELECTOR 的api被设置之后，每次view被moveToWindow的时候都会触发。
使用 UIAppearance 只有在视图未添加到 window 时才会生效，对于已经在 window 中的视图并不会生效。
           
// 返回接受外观设置的代理
+ (instancetype)appearance;
// 当出现在某个类的出现时候才会改变
+ (instancetype)appearanceWhenContainedInInstancesOfClasses:(NSArray<Class <UIAppearanceContainer>> *)containerTypes NS_AVAILABLE_IOS(9_0);
// 针对不同 trait 下的应用的 apperance 进行很简单的设定
+ (instancetype)appearanceForTraitCollection:(UITraitCollection *)trait NS_AVAILABLE_IOS(8_0);
// 当出现在某个特征的出现时候才会改变    
+ (instancetype)appearanceForTraitCollection:(UITraitCollection *)trait whenContainedInInstancesOfClasses:(NSArray<Class <UIAppearanceContainer>> *)containerTypes  NS_AVAILABLE_IOS(9_0);
// 示例
[[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil]
       setBackgroundImage:myNavBarButtonBackgroundImage forState:state barMetrics:metrics];
[[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], [UIPopoverController class], nil]
        setBackgroundImage:myPopoverNavBarButtonBackgroundImage forState:state barMetrics:metrics];
[[UIBarButtonItem appearanceWhenContainedIn:[UIToolbar class], nil]
        setBackgroundImage:myToolbarButtonBackgroundImage forState:state barMetrics:metrics];
[[UIBarButtonItem appearanceWhenContainedIn:[UIToolbar class], [UIPopoverController class], nil]
        setBackgroundImage:myPopoverToolbarButtonBackgroundImage forState:state barMetrics:metrics];

UITraitCollection是iOS8.0新推出的一个类,这个类封装了像水平和竖直方向的 Size Class 等信息。该类型的对象是定义在一个名字为UITraitEnvironment的协议中,该协议默认被UIView与UIViewController等遵守。
可以直接通过View或者controller的traitCollection属性获取该对象。如果没有指定某一控件的traitCollection属性,那么将使用其父控件的traitCollection属性值。
// 示例
UIView.appearanceForTraitCollection(UIView().traitCollection).backgroundColor = UIColor.redColor() //这句代码会将所有UIView类型的视图的背景色设置成红色,当然这句代码也写在了AppleDelegate里的didFinishLaunchingWithOptions方法中。

2. 如何让自定义 view 的属性支持 UIAppearance？
OC 在方法的最后用 UI_APPEARANCE_SELECTOR 标注
swift 中没有宏的概念，如果想让某个属性支持 UIAppearance 可以为该属性使用 dynamic 关键字
    
【Version 10.2.1 (10E1001) 下】 过滤支持文件：
/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk/System/Library/Frameworks/UIKit.framework/Headers
grep -H UI_APPEARANCE_SELECTOR ./* | sed 's/ __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_5_0) UI_APPEARANCE_SELECTOR;//'
    
获取支持如下：
./UIActivityIndicatorView.h:@property (null_resettable, readwrite, nonatomic, strong) UIColor *color NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
./UIAppearance.h:/* To participate in the appearance proxy API, tag your appearance property selectors in your header with UI_APPEARANCE_SELECTOR.
./UIAppearance.h:#define UI_APPEARANCE_SELECTOR __attribute__((annotate("ui_appearance_selector")))
./UIBarButtonItem.h:- (void)setBackgroundImage:(nullable UIImage *)backgroundImage forState:(UIControlState)state barMetrics:(UIBarMetrics)barMetrics NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
./UIBarButtonItem.h:- (nullable UIImage *)backgroundImageForState:(UIControlState)state barMetrics:(UIBarMetrics)barMetrics NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
./UIBarButtonItem.h:- (void)setBackgroundImage:(nullable UIImage *)backgroundImage forState:(UIControlState)state style:(UIBarButtonItemStyle)style barMetrics:(UIBarMetrics)barMetrics NS_AVAILABLE_IOS(6_0) UI_APPEARANCE_SELECTOR;
./UIBarButtonItem.h:- (nullable UIImage *)backgroundImageForState:(UIControlState)state style:(UIBarButtonItemStyle)style barMetrics:(UIBarMetrics)barMetrics NS_AVAILABLE_IOS(6_0) UI_APPEARANCE_SELECTOR;
./UIBarButtonItem.h:- (void)setBackgroundVerticalPositionAdjustment:(CGFloat)adjustment forBarMetrics:(UIBarMetrics)barMetrics NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
./UIBarButtonItem.h:- (CGFloat)backgroundVerticalPositionAdjustmentForBarMetrics:(UIBarMetrics)barMetrics NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
./UIBarButtonItem.h:- (void)setTitlePositionAdjustment:(UIOffset)adjustment forBarMetrics:(UIBarMetrics)barMetrics NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
./UIBarButtonItem.h:- (UIOffset)titlePositionAdjustmentForBarMetrics:(UIBarMetrics)barMetrics NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
./UIBarButtonItem.h:- (void)setBackButtonBackgroundImage:(nullable UIImage *)backgroundImage forState:(UIControlState)state barMetrics:(UIBarMetrics)barMetrics NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR __TVOS_PROHIBITED;
./UIBarButtonItem.h:- (nullable UIImage *)backButtonBackgroundImageForState:(UIControlState)state barMetrics:(UIBarMetrics)barMetrics NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR __TVOS_PROHIBITED;
./UIBarButtonItem.h:- (void)setBackButtonTitlePositionAdjustment:(UIOffset)adjustment forBarMetrics:(UIBarMetrics)barMetrics NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR __TVOS_PROHIBITED;
./UIBarButtonItem.h:- (UIOffset)backButtonTitlePositionAdjustmentForBarMetrics:(UIBarMetrics)barMetrics NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR __TVOS_PROHIBITED;
./UIBarButtonItem.h:- (void)setBackButtonBackgroundVerticalPositionAdjustment:(CGFloat)adjustment forBarMetrics:(UIBarMetrics)barMetrics NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR __TVOS_PROHIBITED;
./UIBarButtonItem.h:- (CGFloat)backButtonBackgroundVerticalPositionAdjustmentForBarMetrics:(UIBarMetrics)barMetrics NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR __TVOS_PROHIBITED;
./UIBarItem.h:- (void)setTitleTextAttributes:(nullable NSDictionary<NSAttributedStringKey,id> *)attributes forState:(UIControlState)state NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
./UIBarItem.h:- (nullable NSDictionary<NSAttributedStringKey,id> *)titleTextAttributesForState:(UIControlState)state NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
./UIButton.h:@property(nonatomic)          UIEdgeInsets contentEdgeInsets UI_APPEARANCE_SELECTOR; // default is UIEdgeInsetsZero. On tvOS 10 or later, default is nonzero except for custom buttons.
./UIButton.h:- (void)setTitleColor:(nullable UIColor *)color forState:(UIControlState)state UI_APPEARANCE_SELECTOR; // default if nil. use opaque white
./UIButton.h:- (void)setTitleShadowColor:(nullable UIColor *)color forState:(UIControlState)state UI_APPEARANCE_SELECTOR; // default is nil. use 50% black
./UIButton.h:- (void)setBackgroundImage:(nullable UIImage *)image forState:(UIControlState)state UI_APPEARANCE_SELECTOR; // default is nil
./UINavigationBar.h:@property(nonatomic,assign) UIBarStyle barStyle UI_APPEARANCE_SELECTOR __TVOS_PROHIBITED;
./UINavigationBar.h:@property(nonatomic,assign,getter=isTranslucent) BOOL translucent NS_AVAILABLE_IOS(3_0) UI_APPEARANCE_SELECTOR; // Default is NO on iOS 6 and earlier. Always YES if barStyle is set to UIBarStyleBlackTranslucent
./UINavigationBar.h:@property (nonatomic, readwrite, assign) BOOL prefersLargeTitles UI_APPEARANCE_SELECTOR API_AVAILABLE(ios(11.0)) API_UNAVAILABLE(tvos);
./UINavigationBar.h:@property(nullable, nonatomic,strong) UIColor *barTintColor NS_AVAILABLE_IOS(7_0) UI_APPEARANCE_SELECTOR;  // default is nil
./UINavigationBar.h:- (void)setBackgroundImage:(nullable UIImage *)backgroundImage forBarPosition:(UIBarPosition)barPosition barMetrics:(UIBarMetrics)barMetrics NS_AVAILABLE_IOS(7_0) UI_APPEARANCE_SELECTOR;
./UINavigationBar.h:- (nullable UIImage *)backgroundImageForBarPosition:(UIBarPosition)barPosition barMetrics:(UIBarMetrics)barMetrics NS_AVAILABLE_IOS(7_0) UI_APPEARANCE_SELECTOR;
./UINavigationBar.h:- (void)setBackgroundImage:(nullable UIImage *)backgroundImage forBarMetrics:(UIBarMetrics)barMetrics NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
./UINavigationBar.h:- (nullable UIImage *)backgroundImageForBarMetrics:(UIBarMetrics)barMetrics NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
./UINavigationBar.h:@property(nullable, nonatomic,strong) UIImage *shadowImage NS_AVAILABLE_IOS(6_0) UI_APPEARANCE_SELECTOR;
./UINavigationBar.h:@property(nullable,nonatomic,copy) NSDictionary<NSAttributedStringKey, id> *titleTextAttributes NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
./UINavigationBar.h:@property(nullable, nonatomic, copy) NSDictionary<NSAttributedStringKey, id> *largeTitleTextAttributes UI_APPEARANCE_SELECTOR API_AVAILABLE(ios(11.0)) API_UNAVAILABLE(tvos);
./UINavigationBar.h:- (void)setTitleVerticalPositionAdjustment:(CGFloat)adjustment forBarMetrics:(UIBarMetrics)barMetrics NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
./UINavigationBar.h:- (CGFloat)titleVerticalPositionAdjustmentForBarMetrics:(UIBarMetrics)barMetrics NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
./UINavigationBar.h:@property(nullable,nonatomic,strong) UIImage *backIndicatorImage NS_AVAILABLE_IOS(7_0) UI_APPEARANCE_SELECTOR __TVOS_PROHIBITED;
./UINavigationBar.h:@property(nullable,nonatomic,strong) UIImage *backIndicatorTransitionMaskImage NS_AVAILABLE_IOS(7_0) UI_APPEARANCE_SELECTOR __TVOS_PROHIBITED;
./UIPageControl.h:@property(nullable, nonatomic,strong) UIColor *pageIndicatorTintColor NS_AVAILABLE_IOS(6_0) UI_APPEARANCE_SELECTOR;
./UIPageControl.h:@property(nullable, nonatomic,strong) UIColor *currentPageIndicatorTintColor NS_AVAILABLE_IOS(6_0) UI_APPEARANCE_SELECTOR;
./UIProgressView.h:@property(nonatomic, strong, nullable) UIColor* progressTintColor  NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
./UIProgressView.h:@property(nonatomic, strong, nullable) UIColor* trackTintColor     NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
./UIProgressView.h:@property(nonatomic, strong, nullable) UIImage* progressImage      NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
./UIProgressView.h:@property(nonatomic, strong, nullable) UIImage* trackImage         NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
./UIRefreshControl.h:@property (nullable, nonatomic, strong) NSAttributedString *attributedTitle UI_APPEARANCE_SELECTOR;
./UISearchBar.h:@property(nullable, nonatomic,strong) UIColor *barTintColor NS_AVAILABLE_IOS(7_0) UI_APPEARANCE_SELECTOR;  // default is nil
./UISearchBar.h:@property(nullable, nonatomic,strong) UIImage *backgroundImage NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
./UISearchBar.h:@property(nullable, nonatomic,strong) UIImage *scopeBarBackgroundImage NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
./UISearchBar.h:- (void)setBackgroundImage:(nullable UIImage *)backgroundImage forBarPosition:(UIBarPosition)barPosition barMetrics:(UIBarMetrics)barMetrics NS_AVAILABLE_IOS(7_0) UI_APPEARANCE_SELECTOR;  // Use UIBarMetricsDefaultPrompt to set a separate backgroundImage for a search bar with a prompt
./UISearchBar.h:- (nullable UIImage *)backgroundImageForBarPosition:(UIBarPosition)barPosition barMetrics:(UIBarMetrics)barMetrics NS_AVAILABLE_IOS(7_0) UI_APPEARANCE_SELECTOR;
./UISearchBar.h:- (void)setSearchFieldBackgroundImage:(nullable UIImage *)backgroundImage forState:(UIControlState)state NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
./UISearchBar.h:- (nullable UIImage *)searchFieldBackgroundImageForState:(UIControlState)state NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
./UISearchBar.h:- (void)setImage:(nullable UIImage *)iconImage forSearchBarIcon:(UISearchBarIcon)icon state:(UIControlState)state NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
./UISearchBar.h:- (nullable UIImage *)imageForSearchBarIcon:(UISearchBarIcon)icon state:(UIControlState)state NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
./UISearchBar.h:- (void)setScopeBarButtonBackgroundImage:(nullable UIImage *)backgroundImage forState:(UIControlState)state NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
./UISearchBar.h:- (nullable UIImage *)scopeBarButtonBackgroundImageForState:(UIControlState)state NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
./UISearchBar.h:- (void)setScopeBarButtonDividerImage:(nullable UIImage *)dividerImage forLeftSegmentState:(UIControlState)leftState rightSegmentState:(UIControlState)rightState NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
./UISearchBar.h:- (nullable UIImage *)scopeBarButtonDividerImageForLeftSegmentState:(UIControlState)leftState rightSegmentState:(UIControlState)rightState NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
./UISearchBar.h:- (void)setScopeBarButtonTitleTextAttributes:(nullable NSDictionary<NSAttributedStringKey,id> *)attributes forState:(UIControlState)state NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
./UISearchBar.h:- (nullable NSDictionary<NSAttributedStringKey, id> *)scopeBarButtonTitleTextAttributesForState:(UIControlState)state NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
./UISearchBar.h:@property(nonatomic) UIOffset searchFieldBackgroundPositionAdjustment NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
./UISearchBar.h:@property(nonatomic) UIOffset searchTextPositionAdjustment NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
./UISearchBar.h:- (void)setPositionAdjustment:(UIOffset)adjustment forSearchBarIcon:(UISearchBarIcon)icon NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
./UISearchBar.h:- (UIOffset)positionAdjustmentForSearchBarIcon:(UISearchBarIcon)icon NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
./UISegmentedControl.h:- (void)setBackgroundImage:(nullable UIImage *)backgroundImage forState:(UIControlState)state barMetrics:(UIBarMetrics)barMetrics NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
./UISegmentedControl.h:- (nullable UIImage *)backgroundImageForState:(UIControlState)state barMetrics:(UIBarMetrics)barMetrics NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
./UISegmentedControl.h:- (void)setDividerImage:(nullable UIImage *)dividerImage forLeftSegmentState:(UIControlState)leftState rightSegmentState:(UIControlState)rightState barMetrics:(UIBarMetrics)barMetrics NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
./UISegmentedControl.h:- (nullable UIImage *)dividerImageForLeftSegmentState:(UIControlState)leftState rightSegmentState:(UIControlState)rightState barMetrics:(UIBarMetrics)barMetrics  NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
./UISegmentedControl.h:- (void)setTitleTextAttributes:(nullable NSDictionary<NSAttributedStringKey,id> *)attributes forState:(UIControlState)state NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
./UISegmentedControl.h:- (nullable NSDictionary<NSAttributedStringKey,id> *)titleTextAttributesForState:(UIControlState)state NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
./UISegmentedControl.h:- (void)setContentPositionAdjustment:(UIOffset)adjustment forSegmentType:(UISegmentedControlSegment)leftCenterRightOrAlone barMetrics:(UIBarMetrics)barMetrics NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
./UISegmentedControl.h:- (UIOffset)contentPositionAdjustmentForSegmentType:(UISegmentedControlSegment)leftCenterRightOrAlone barMetrics:(UIBarMetrics)barMetrics NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
./UISlider.h:@property(nullable, nonatomic,strong) UIColor *minimumTrackTintColor NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
./UISlider.h:@property(nullable, nonatomic,strong) UIColor *maximumTrackTintColor NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
./UISlider.h:@property(nullable, nonatomic,strong) UIColor *thumbTintColor NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
./UIStepper.h:- (void)setBackgroundImage:(nullable UIImage*)image forState:(UIControlState)state NS_AVAILABLE_IOS(6_0) UI_APPEARANCE_SELECTOR;
./UIStepper.h:- (nullable UIImage*)backgroundImageForState:(UIControlState)state NS_AVAILABLE_IOS(6_0) UI_APPEARANCE_SELECTOR;
./UIStepper.h:- (void)setDividerImage:(nullable UIImage*)image forLeftSegmentState:(UIControlState)leftState rightSegmentState:(UIControlState)rightState NS_AVAILABLE_IOS(6_0) UI_APPEARANCE_SELECTOR;
./UIStepper.h:- (nullable UIImage*)dividerImageForLeftSegmentState:(UIControlState)state rightSegmentState:(UIControlState)state NS_AVAILABLE_IOS(6_0) UI_APPEARANCE_SELECTOR;
./UIStepper.h:- (void)setIncrementImage:(nullable UIImage *)image forState:(UIControlState)state NS_AVAILABLE_IOS(6_0) UI_APPEARANCE_SELECTOR;
./UIStepper.h:- (nullable UIImage *)incrementImageForState:(UIControlState)state NS_AVAILABLE_IOS(6_0) UI_APPEARANCE_SELECTOR;
./UIStepper.h:- (void)setDecrementImage:(nullable UIImage *)image forState:(UIControlState)state NS_AVAILABLE_IOS(6_0) UI_APPEARANCE_SELECTOR;
./UIStepper.h:- (nullable UIImage *)decrementImageForState:(UIControlState)state NS_AVAILABLE_IOS(6_0) UI_APPEARANCE_SELECTOR;
./UISwitch.h:@property(nullable, nonatomic, strong) UIColor *onTintColor NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
./UISwitch.h:@property(nullable, nonatomic, strong) UIColor *thumbTintColor NS_AVAILABLE_IOS(6_0) UI_APPEARANCE_SELECTOR;
./UISwitch.h:@property(nullable, nonatomic, strong) UIImage *onImage NS_AVAILABLE_IOS(6_0) UI_APPEARANCE_SELECTOR;
./UISwitch.h:@property(nullable, nonatomic, strong) UIImage *offImage NS_AVAILABLE_IOS(6_0) UI_APPEARANCE_SELECTOR;
./UITabBar.h:@property(nullable, nonatomic, strong) UIColor *barTintColor NS_AVAILABLE_IOS(7_0) UI_APPEARANCE_SELECTOR;  // default is nil
./UITabBar.h:@property (nonatomic, readwrite, copy, nullable) UIColor *unselectedItemTintColor NS_AVAILABLE_IOS(10_0) UI_APPEARANCE_SELECTOR;
./UITabBar.h:@property(nullable, nonatomic, strong) UIColor *selectedImageTintColor NS_DEPRECATED_IOS(5_0,8_0,"Use tintColor") UI_APPEARANCE_SELECTOR __TVOS_PROHIBITED;
./UITabBar.h:@property(nullable, nonatomic, strong) UIImage *backgroundImage NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
./UITabBar.h:@property(nullable, nonatomic, strong) UIImage *selectionIndicatorImage NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
./UITabBar.h:@property(nullable, nonatomic, strong) UIImage *shadowImage NS_AVAILABLE_IOS(6_0) UI_APPEARANCE_SELECTOR;
./UITabBar.h:@property(nonatomic) UITabBarItemPositioning itemPositioning NS_AVAILABLE_IOS(7_0) UI_APPEARANCE_SELECTOR __TVOS_PROHIBITED;
./UITabBar.h:@property(nonatomic) CGFloat itemWidth NS_AVAILABLE_IOS(7_0) UI_APPEARANCE_SELECTOR;
./UITabBar.h:@property(nonatomic) CGFloat itemSpacing NS_AVAILABLE_IOS(7_0) UI_APPEARANCE_SELECTOR;
./UITabBar.h:@property(nonatomic) UIBarStyle barStyle NS_AVAILABLE_IOS(7_0) UI_APPEARANCE_SELECTOR __TVOS_PROHIBITED;
./UITabBarItem.h:@property (nonatomic, readwrite, assign) UIOffset titlePositionAdjustment NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
./UITabBarItem.h:@property (nonatomic, readwrite, copy, nullable) UIColor *badgeColor NS_AVAILABLE_IOS(10_0) UI_APPEARANCE_SELECTOR;
./UITabBarItem.h:- (void)setBadgeTextAttributes:(nullable NSDictionary<NSAttributedStringKey,id> *)textAttributes forState:(UIControlState)state NS_AVAILABLE_IOS(10_0) UI_APPEARANCE_SELECTOR;
./UITabBarItem.h:- (nullable NSDictionary<NSAttributedStringKey,id> *)badgeTextAttributesForState:(UIControlState)state NS_AVAILABLE_IOS(10_0) UI_APPEARANCE_SELECTOR;
./UITableView.h:@property (nonatomic) UIEdgeInsets separatorInset NS_AVAILABLE_IOS(7_0) UI_APPEARANCE_SELECTOR; // allows customization of the frame of cell separators; see also the separatorInsetReference property. Use UITableViewAutomaticDimension for the automatic inset for that edge.
./UITableView.h:@property (nonatomic, strong, nullable) UIColor *sectionIndexColor NS_AVAILABLE_IOS(6_0) UI_APPEARANCE_SELECTOR;                   // color used for text of the section index
./UITableView.h:@property (nonatomic, strong, nullable) UIColor *sectionIndexBackgroundColor NS_AVAILABLE_IOS(7_0) UI_APPEARANCE_SELECTOR;         // the background color of the section index while not being touched
./UITableView.h:@property (nonatomic, strong, nullable) UIColor *sectionIndexTrackingBackgroundColor NS_AVAILABLE_IOS(6_0) UI_APPEARANCE_SELECTOR; // the background color of the section index while it is being touched
./UITableView.h:@property (nonatomic, strong, nullable) UIColor *separatorColor UI_APPEARANCE_SELECTOR __TVOS_PROHIBITED; // default is the standard separator gray
./UITableView.h:@property (nonatomic, copy, nullable) UIVisualEffect *separatorEffect NS_AVAILABLE_IOS(8_0) UI_APPEARANCE_SELECTOR __TVOS_PROHIBITED; // effect to apply to table separators
./UITableViewCell.h:@property (nonatomic) UIEdgeInsets                    separatorInset NS_AVAILABLE_IOS(7_0) UI_APPEARANCE_SELECTOR __TVOS_PROHIBITED; // allows customization of the separator frame
./UITableViewCell.h:@property (nonatomic) UITableViewCellFocusStyle       focusStyle NS_AVAILABLE_IOS(9_0) UI_APPEARANCE_SELECTOR;
./UIToolbar.h:@property(nonatomic) UIBarStyle barStyle UI_APPEARANCE_SELECTOR __TVOS_PROHIBITED; // default is UIBarStyleDefault
./UIToolbar.h:@property(nonatomic,assign,getter=isTranslucent) BOOL translucent NS_AVAILABLE_IOS(3_0) UI_APPEARANCE_SELECTOR; // Default is NO on iOS 6 and earlier. Always YES if barStyle is set to UIBarStyleBlackTranslucent
./UIToolbar.h:@property(nullable, nonatomic, strong) UIColor *barTintColor NS_AVAILABLE_IOS(7_0) UI_APPEARANCE_SELECTOR;  // default is nil
./UIToolbar.h:- (void)setBackgroundImage:(nullable UIImage *)backgroundImage forToolbarPosition:(UIBarPosition)topOrBottom barMetrics:(UIBarMetrics)barMetrics NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
./UIToolbar.h:- (nullable UIImage *)backgroundImageForToolbarPosition:(UIBarPosition)topOrBottom barMetrics:(UIBarMetrics)barMetrics NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
./UIToolbar.h:- (void)setShadowImage:(nullable UIImage *)shadowImage forToolbarPosition:(UIBarPosition)topOrBottom NS_AVAILABLE_IOS(6_0) UI_APPEARANCE_SELECTOR;
./UIToolbar.h:- (nullable UIImage *)shadowImageForToolbarPosition:(UIBarPosition)topOrBottom NS_AVAILABLE_IOS(6_0) UI_APPEARANCE_SELECTOR;
./UIView.h:@property(nullable, nonatomic,copy) UIColor *backgroundColor UI_APPEARANCE_SELECTOR; // default is nil. Can be useful with the appearance proxy on custom UIView subclasses.
    
```