# Flutter 设计模式实践 - 策略模式

## 一、什么是策略模式？
策略模式是一种行为设计模式，定义了一系列算法，并将每个算法封装起来，使它们可以相互替换。策略模式让算法独立于使用它的客户端而变化，从而减少了算法与应用之间的耦合度。

简单来说，策略模式允许你在运行时根据不同需求选择不同的策略来解决问题。这种模式适用于需要在多个实现之间切换的情况。

策略模式的主要组成部分
Context（上下文）：持有一个策略对象的引用，且可以在运行时更换策略。
Strategy（策略接口）：定义所有具体策略类的公共接口。
ConcreteStrategy（具体策略）：实现策略接口，定义具体的算法。
Client（客户端）：在客户端中使用策略模式，可以在运行时改变具体的策略。

## 二、如何使用
#### 1. 声明
```
/// 化疗药品
class ChemotherapyRegimenDrug {
  ChemotherapyRegimenDrug({
    required this.name,
    required this.dosagePerBSA,
    required this.specification,
    this.recommendedDosage,
    this.recommendedQuantity,
    this.remark,
  });

  // 药品名称
  final String name;
  // 每单位体表面积的推荐剂量
  final double dosagePerBSA;

  /// 药品规格（单位：mg）
  final double specification;

  /// 推荐剂量（单位：mg）3位小数
  final double? recommendedDosage;

  /// 推荐剂数
  final int? recommendedQuantity;

  /// 备注
  final String? remark;

  ChemotherapyRegimenDrug copyWith({
    String? name,
    double? dosagePerBSA,
    double? specification,
    double? recommendedDosage,
    int? recommendedQuantity,
    String? remark,
  }) {
    return ChemotherapyRegimenDrug(
      name: name ?? this.name,
      dosagePerBSA: dosagePerBSA ?? this.dosagePerBSA,
      specification: specification ?? this.specification,
      recommendedDosage: recommendedDosage ?? this.recommendedDosage,
      recommendedQuantity: recommendedQuantity ?? this.recommendedQuantity,
      remark: remark ?? remark,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['dosagePerBSA'] = dosagePerBSA;
    data['specification'] = specification;
    data['recommendedDosage'] = recommendedDosage;
    data['recommendedQuantity'] = recommendedQuantity;
    data['remark'] = remark;
    return data;
  }
}

// 定义方案策略接口
abstract class ChemotherapyRegimenTreatmentStrategy {
  /// 药品组合
  List<ChemotherapyRegimenDrug> get drugs => [];

  /// 计算推荐剂量
  List<ChemotherapyRegimenDrug> calculateDrugDosage({
    required double bsa,
  }) {
    final result = drugs.map((drug) {
      double recommendedDosage = drug.dosagePerBSA * bsa;
      final recommendedDosageNew = double.parse(recommendedDosage.toStringAsFixed(3)); // 3位小数
      int quantity = (recommendedDosageNew / drug.specification).ceil();
      return drug.copyWith(
        recommendedDosage: recommendedDosageNew,
        recommendedQuantity: quantity,
      );
    }).toList();
    return result;
  }
}

// GN方案策略
class GNStrategy extends ChemotherapyRegimenTreatmentStrategy {
  @override
  List<ChemotherapyRegimenDrug> get drugs => [
        ChemotherapyRegimenDrug(name: "吉西他滨", dosagePerBSA: 1000, specification: 200), // 药品规格：0.2g
        ChemotherapyRegimenDrug(name: "吉西他滨", dosagePerBSA: 1000, specification: 1000), // 药品规格：1g
        ChemotherapyRegimenDrug(name: "紫杉醇", dosagePerBSA: 125, specification: 100), // 药品规格：100mg
      ];
}

// FLOFIRINOX方案策略
class FLOFIRINOXStrategy extends ChemotherapyRegimenTreatmentStrategy {
  @override
  List<ChemotherapyRegimenDrug> get drugs => [
        ChemotherapyRegimenDrug(name: "奥沙利铂", dosagePerBSA: 85, specification: 50), // 药品规格：50mg
        ChemotherapyRegimenDrug(name: "伊立替康", dosagePerBSA: 180, specification: 300), // 药品规格：0.3g
        ChemotherapyRegimenDrug(name: "亚叶酸钙", dosagePerBSA: 400, specification: 100), // 药品规格：25mg
        ChemotherapyRegimenDrug(name: "氟尿嘧啶", dosagePerBSA: 400, specification: 250), // 药品规格：10mg，快速注射
      ];
      
  /// 计算推荐剂量
  @override
  List<ChemotherapyRegimenDrug> calculateDrugDosage({
    required double bsa,
  }) {
    final result = drugs.map((drug) {
      double recommendedDosage = drug.dosagePerBSA * bsa;
      final recommendedDosageNew = double.parse(recommendedDosage.toStringAsFixed(3)); // 3位小数
      int quantity = (recommendedDosageNew / drug.specification).ceil();
      return drug.copyWith(
        recommendedDosage: recommendedDosageNew,
        recommendedQuantity: quantity,
        remark: "FLOFIRINOX 计算公式",
      );
    }).toList();
    return result;
  }
}

// FLOFIRINOX方案策略
class MFLOFIRINOXStrategy extends ChemotherapyRegimenTreatmentStrategy {
  @override
  List<ChemotherapyRegimenDrug> get drugs => [
        ChemotherapyRegimenDrug(name: "奥沙利铂", dosagePerBSA: 85, specification: 50), // 药品规格：50mg
        ChemotherapyRegimenDrug(name: "伊立替康", dosagePerBSA: 150, specification: 300), // 药品规格：0.3g
        ChemotherapyRegimenDrug(name: "亚叶酸钙", dosagePerBSA: 400, specification: 100), // 药品规格：25mg
        ChemotherapyRegimenDrug(name: "氟尿嘧啶", dosagePerBSA: 2400, specification: 250), // 药品规格：10mg，快速注射
      ];

  /// 计算推荐剂量
  @override
  List<ChemotherapyRegimenDrug> calculateDrugDosage({
    required double bsa,
  }) {
    final result = drugs.map((drug) {
      double recommendedDosage = drug.dosagePerBSA * bsa;
      final recommendedDosageNew = double.parse(recommendedDosage.toStringAsFixed(3)); // 3位小数
      int quantity = (recommendedDosageNew / drug.specification).ceil();
      return drug.copyWith(
        recommendedDosage: recommendedDosageNew,
        recommendedQuantity: quantity,
        remark: "mFLOFIRINOX 计算公式",
      );
    }).toList();
    return result;
  }
}

// 计算上下文类
class ChemotherapyRegimenTreatmentCalculator {
  ChemotherapyRegimenTreatmentCalculator(this.strategy);

  ChemotherapyRegimenTreatmentStrategy strategy;

  List<ChemotherapyRegimenDrug> calculateDrugDosage({required double bsa}) {
    return strategy.calculateDrugDosage(bsa: bsa);
  }
}

// 体表面积工具类
class BSAUtils {
  static double calculateBSA({required double height, required double weight}) {
    final bsa = 0.0061 * height + 0.0128 * weight - 0.1529;
    debugPrint('BSAUtils 体表面积: $bsa');
    return bsa;
  }
}
```
#### 2、使用示例：
```
  /// 计算所有方案
  void onCaculator() {
    // // 输入患者身高和体重
    // double height = 170.0; // 身高 (cm)
    // double weight = 65.0; // 体重 (kg)

    // // 计算体表面积
    // double bsa = BSAUtils.calculateBSA(height: height, weight: weight);
    // print('体表面积: $bsa');

    // 计算GN方案
    final gNCalculator = ChemotherapyRegimenTreatmentCalculator(GNStrategy());
    final gnDrugs = gNCalculator.calculateDrugDosage(bsa: bsa);
    DLog.d('GN方案: \n${jsonEncode(gnDrugs.map((e) => e.toJson()).toList())}');

    // 计算FLOFIRINOX方案
    final fLOFIRINOXCalculator = ChemotherapyRegimenTreatmentCalculator(FLOFIRINOXStrategy());
    final flofirinoxDrugs = fLOFIRINOXCalculator.calculateDrugDosage(bsa: bsa);
    DLog.d('FLOFIRINOX方案: \n${jsonEncode(flofirinoxDrugs.map((e) => e.toJson()).toList())}');

    final mFLOFIRINOXCalculator = ChemotherapyRegimenTreatmentCalculator(MFLOFIRINOXStrategy());
    final mflofirinoxDrugs = mFLOFIRINOXCalculator.calculateDrugDosage(bsa: bsa);
    DLog.d('mflofirinox 方案: \n${jsonEncode(mflofirinoxDrugs.map((e) => e.toJson()).toList())}');
  }
```
## 三、现代语言进阶
#### 语言特性需要支持：枚举支持自定义方法和属性
```
enum ChemotherapyRegimenTreatmentStrategyEnum {
  GN(name: "GN", desc: "方案GN"),

  FLOFIRINOX(name: "FLOFIRINOX", desc: '方案FLOFIRINOX'),

  mFLOFIRINOX(name: "mFLOFIRINOX", desc: '方案mFLOFIRINOX');

  const ChemotherapyRegimenTreatmentStrategyEnum({
    required this.name,
    required this.desc,
  });

  /// 当前枚举值对应的 name
  final String name;

  /// 当前枚举对应的 描述文字
  final String desc;

  /// 方案集合(因为 enum 子项无法支持声明类常量)
  static Map<ChemotherapyRegimenTreatmentStrategyEnum, ChemotherapyRegimenTreatmentStrategy> get map => {
        GN: GNStrategy(),
        FLOFIRINOX: FLOFIRINOXStrategy(),
        mFLOFIRINOX: MFLOFIRINOXStrategy(),
      };

  /// 计算
  List<ChemotherapyRegimenDrug>? caculator({required double height, required double weight}) {
    final strategy = ChemotherapyRegimenTreatmentStrategyEnum.map[this];
    return strategy?.calculateDrugQuantities(height: height, weight: weight);
  }
}
```
#### 使用示例
```
// strategy 为当前方案枚举类型
final drugs = strategy?.caculator(bsa: bsa) ?? [];
```

## 三、策略模式的优缺点
#### 优点：
算法独立性：将算法和客户端分离，客户端通过策略接口来使用不同的算法。
扩展性好：新增策略时，只需要扩展新的策略类，不需要修改原有代码。
避免了条件语句：可以避免在代码中使用大量的 if-else 或 switch 语句。
#### 缺点：
增加类的数量：每个策略都需要一个独立的类，可能会增加代码的复杂度。
可能需要大量的策略实现：如果应用中有多个不同的算法，策略类的数量也会变得很庞大。

## 总结
策略模式是一种非常有用的设计模式，尤其适用于需要根据不同需求灵活切换算法或行为的场景。它将复杂度分离到各个策略中，即可通过继承链复用上层代码，又可横向无线扩展策略实现，无论是新增策略还是修改bug，都对原有代码影响极少。