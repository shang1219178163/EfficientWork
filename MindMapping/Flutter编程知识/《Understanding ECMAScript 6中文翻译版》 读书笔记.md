# Understanding ECMAScript 6中文翻译

### 第一章 块级绑定
```
1. 使用 var 关键字声明的变量，无论其实际声明位置在何处，都会被视为声明于所在函数的顶部（如果声明不在任意函数内，则视为在全局作用域的顶部）。这就是所谓的变量提升（ hoisting ）。

2. 块级声明也就是让所声明的变量在指定块的作用域外无法被访问。

3. let 声明的语法与 var 的语法一致。大体上可以直接用 let 代替 var 进行变量声明，但会将变量的作用域限制在当前代码块中。 const 声明的变量会被认为是常量（ constant ），值在被设置完成后就不允许再被更改。

4. const 常量声明与 let 声明一样，都是块级声明。const 声明会阻止对于变量绑定与变量自身值的修改，这意味着它并不会阻止对变量成员的修改。

5. 暂时性死区, 经常被用于描述 let 或 const 声明的变量为何在声明位置之前无法被访问。

6. 在常规的 for 循环中，你可以在初始化时使用 const ，但循环会在试图改变该变量的值时抛出错误。另一方面， const 变量在 for-in 或 for-of 循环中使用时，与 let 变量效果相同。

7. 当在全局作用域上使用 var 时，它会创建一个新的全局变量，并成为全局对象（在浏览器中是 window ）的一个属性。这意味着使用 var 可能会无意中覆盖一个已有的全局属性，若你不想在全局对象上创建属性，使用 let 与 const 会更安全。

8. 块级绑定新的最佳实践

在 ES6 的开发阶段，被广泛认可的变量声明方式是：默认情况下应当使用 let 来代替 var 。对于多数 JS 开发者来说， let 的行为方式正是 var 本应有的方式，因此直接用 let 替代 var 更符合逻辑。在这种情况下，需要受到保护的变量再使用 const 。
一种替代方案变得更为流行：在默认情况下使用 const ，仅当明确变量值需要被更改的情况下才使用 let 。
```

### 第二章 字符串与正则表达式
```
1. 在 ES6 之前， JS 的字符串以 16 位字符编码（ UCS-2 ）为基础。每个 16 位序列都是一个码元（ code unit ），用于表示一个字符。字符串所有的属性与方法都基于 16 位的码元，例如 length 属性与 charAt() 方法。

2. Unicode 的明确目标是给世界上每一个字符提供全局唯一标识符, 这些全球唯一标识符被称为码点（ code points ），就是从 0 开始的数字。通过 codePointAt() 与 String.fromCodePoint() 在码点和字符之间转换。

3. 在 UTF-16 中的第一个 216 码点表示单个 16 位码元，这个范围被称为多语言基本平面（ Basic Multilingual Plane ， BMP ）。任何超出该范围的码点都不能用单个 16 位码元表示，而是会落在扩展平面（ supplementary planes ）内。 
UTF-16 引入了代理对（ surrogate pairs ）来解决这个问题，允许使用两个 16 位码元来表示单个码点。这意味着字符串内的任意单个字符都可以用一个码元（共 16 位）或两个码元（共 32 位）来表示，前者对应基本平面字符，而后者对应扩展平面字符。

5. ES6 为全面支持 UTF-16 而新增的方法之一是 codePointAt() ，它可以在给定字符串中按位置提取 Unicode 码点。该方法接受的是码元位置而非字符位置，并返回一个整数值。

6. ES6 给字符串提供了 normalize() 方法，以支持 Unicode 标准形式。当进行字符串比较时，必须将它们标准化为同一种形式。

7. 正则表达式假定单个字符使用一个 16 位的码元来表示。 ES6 为正则表达式定义了用于处理 Unicode 的 u 标志。当一个正则表达式设置了 u 标志时，它的工作模式将切换到针对字符而非码元。
  console.log(/^.$/u.test(text));     // true
  var result = text.match(/[\s\S]/gu);
此例调用了 match() 方法来检查 text 中的空白字符与非空白字符（使用 [\s\S] 以确保该模式能匹配换行符），所用的正则表达式启用了全局与 Unicode 特性。

7. includes() 方法，若文本存在于字符串中，会返回 true ，否则返回 false ；
startsWith() 方法，若文本出现在字符串起始处，返回 true ，否则返回 false ；
endsWith() 方法，若文本出现在字符串结尾处，返回 true ，否则返回 false 。

ES6 还为字符串添加了一个 repeat() 方法，它接受一个参数作为字符串的重复次数，返回一个将初始字符串重复指定次数的新字符串。

8. // indent 使用了一定数量的空格
var indent = " ".repeat(4),
    indentLevel = 0;

// 每当需要增加缩进
var newIndent = indent.repeat(++indentLevel);

y 标志影响正则表达式搜索时的粘连（ sticky ）属性，它表示在字符串中检索匹配的字符时，应当从正则表达式的 lastIndex 属性值的位置开始。如果在该位置没有匹配成功，那么正则表达式将停止检索。

9. ES6 的模板字面量（ template literal ）提供了创建领域专用语言的语法, 领域专用语言（ domain-specific language ， DSL ）是被设计用于特定有限目的的编程语言，与 JavaScript 这样通用目的语言相反。
本方案通过语法糖扩展了 ECMAScript 的语法，允许语言库提供 DSL 以便生成、查询并操纵来自于其它语言的内容，并且能够对 XSS 、 SQL 注入等注入攻击免疫，或具有抗性。
模板字面量的最简单语法，是使用反引号（ `  ）来包裹普通字符串, 模板字面量让多行字符串更易创建，因为它不需要特殊的语法。只需在想要的位置包含换行即可，它会包含在结果字符串中。

替换位由起始的 ${ 与结束的 } 来界定，之间允许放入任意的 JS 表达式。

模板字面量真实威力其实来源于标签化模板。模板标签（ template tag ）能对模板字面量进行转换并返回最终的字符串值
```

### 第三章 函数
```
1. function makeRequest(url, timeout, callback) {
    timeout = (typeof timeout !== "undefined") ? timeout : 2000;

2. ES6 能更容易地为参数提供默认值
function makeRequest(url, timeout = 2000, callback = function() {}) {

这种行为引出了另一种有趣的能力：可以将前面的参数作为后面参数的默认值，
function add(first, second = first) {

引用其他参数来为参数进行默认赋值时，仅允许引用前方的参数，因此前面的参数不能向后访问

3. 剩余参数/可变参数
剩余参数（ rest parameter ）由三个点（ ... ）与一个紧跟着的具名参数指定，它是包含传递给函数的其余参数的一个数组，由此得名剩余。

Function 构造器允许你动态创建一个新函数

var add = new Function("first", "second", "return first + second");

var add = new Function("first", "second = first",
        "return first + second");

4. 扩展运算符
ES6 的扩展运算符令这种情况变得简单。无须调用 apply() ，你可以在该数组前添加 ... 并直接将其传递给 Math.max() ，就像使用剩余参数那样。 JS 引擎将会将该数组分割为独立参数并把它们传递进去：

console.log(Math.max(...values));           // 100

getter 与 setter 函数都必须用 Object.getOwnPropertyDescriptor() 来检索

函数名称还有另外两个特殊情况。使用 bind() 创建的函数会在名称属性值之前带有 "bound" 前缀；而使用 Function 构造器创建的函数，其名称属性为 "anonymous

var doSomething = function() {
    // ...
};

console.log(doSomething.bind().name);   // "bound doSomething"
console.log((new Function()).name);     // "anonymous

5. JS 为函数提供了两个不同的内部方法： [[Call]] 与 [[Construct]] 。当未使用 new 进行函数调用时， [[Call]] 方法会被执行，运行的是代码中的函数体。
当使用 new 进行函数调用时， [[Construct]] 方法则会被执行，负责创建一个被称为新目标的新对象，并且将该新目标作为 this 去执行函数体。拥有 [[Construct]] 方法的函数被称为构造器。
切记并非所有函数都拥有 [[Construct]] 方法，因此不是所有函数都可以用 new 去调用。

1. 元属性指的是非对象（例如 new 运算符）上的属性，并提供关联目标的附加信息。当函数的 [[Construct]] 方法被调用时， new 运算符的作用目标会填入 new.target 元属性，
此时函数体内部的 this 值是新创建的对象实例，而 new.target 的值正是该实例的构造器。而若 [[Call]] 被执行， new.target 的值将会是 undefined 。

通过检查 new.target 这个新的元属性是否被定义，就能让你安全地判断函数被调用时是否使用了 new 。

function Person(name) {
    if (typeof new.target !== "undefined") {
        this.name = name;   // 使用 new
    } else {
        throw new Error("You must use new with Person.")
    }
}

所有的浏览器却都支持该语法。可惜每个浏览器都有轻微的行为差异，所以最佳实践就是切勿在代码块中声明函数，更好的选择是使用函数表达式。

7. 块级函数与 let 函数表达式相似，在执行流跳出定义所在的代码块之后，函数定义就会被移除。关键区别在于：块级函数会被提升到所在代码块的顶部；而使用 let 的函数表达式则不会
ES6 在非严格模式下同样允许使用块级函数，但行为有细微不同。块级函数的作用域会被提升到所在函数或全局环境的顶部，而不是代码块的顶部。

8. 箭头函数/匿名函数
var getTempItem = id => ({ id: id, name: "Temp" });

// 基本等价于：
var getTempItem = function(id) {

    return {
        id: id,
        name: "Temp"
    };
};
将对象字面量包裹在括号内，标示了括号内是一个字面量而不是函数体。
译注：使用传统函数时， (function(){/*函数体*/})(); 与 (function(){/*函数体*/}()); 这两种方式都是可行的。
但若使用箭头函数，则只有下面的写法是有效的： (() => {/*函数体*/})();

9.  .bind(this)

尾调用（ tail call ）指的是调用函数的语句是另一个函数的最后语句。
扩展运算符是剩余参数的好伙伴
```
### 第四章 扩展的对象功能
```
1. 在 ES5 及更早版本中，对象字面量是简单的键/值对集合。当对象的一个属性名称与本地变量名相同时，可以简单书写名称而省略冒号与值。
避免创建新的全局函数，避免在 Object 对象的原型上添加新方法，而尽量尝试将新方法添加到合适对象上。

1. 在 JS 中当要比较两个值时，你可能会使用相等运算符（ == ）或严格相等运算符（ === ）。为了避免在比较时发生强制类型转换，许多开发者更倾向于使用后者。
但严格相等运算符也并不完全准确，例如，它认为 +0 与 -0 相等，尽管这两者在 JS 引擎中有不同的表示；另外 NaN === NaN 会返回 false ，因此只有用 isNaN() 函数才能正确检测 NaN 。

3. ES6 引入了 Object.is() 方法来弥补严格相等运算符残留的怪异缺陷。此方法接受两个参数，并会在二者类型相同并且值也相等相等时返回 true 。
Object.is() 的结果与 === 运算符是相同的，仅有的例外是：它会认为 +0 与 -0 不相等，而且 NaN 等于 NaN 。
Object.is() 方法对任何值都会执行严格相等比较，在处理特殊的 JS 值时，它成为了 === 的一个更有效更安全的替代品。

4. 混入（ Mixin ）是在 JS 中组合对象时最流行的模式。在一次混入中，一个对象会从另一个对象中接收属性与方法。

5. Object.assign() 方法接受任意数量的源对象，而接收对象会按照源对象在参数中的顺序来依次接收它们的属性。这意味着在接收对象中，后面源对象的属性可能会覆盖前面的
切记 Object.assign() 不能将源对象的访问器属性复制到接收对象中，由于它使用了赋值运算符，源对象的访问器属性就会转变成接收对象的数据属性
Object.assign() 方法让一次性更改单个对象的多个属性变得更加容易，这在使用混入模式时非常有用。 
6. 一般来说，对象的原型会在通过构造器或 Object.create() 方法创建对象时被指定。
ES6 通过添加 Object.setPrototypeOf() 方法而改变了这种假定。此方法允许你修改任意指定对象的原型，它接受两个参数：需要被修改原型的对象，以及将会成为前者原型的对象。
对象原型的实际值被存储在一个内部属性 [[Prototype]] 上， Object.getPrototypeOf() 方法会返回此属性存储的值，而 Object.setPrototypeOf() 方法则能够修改该值。不过，使用 [[Prototype]] 属性的方式还不止这些。

   getGreeting() {
        return Object.getPrototypeOf(this).getGreeting.call(this) + ", hi!";
    }
之后的 call(this) 则能确保正确设置原型方法内部的 this 值。

super 是指向当前对象的原型的一个指针，实际上就是 Object.getPrototypeOf(this) 的值。
getGreeting() {
        // 这相当于上个例子中的：
        // Object.getPrototypeOf(this).getGreeting.call(this)
        return super.getGreeting() + ", hi!";
    }
类似的，你能使用 super 引用来调用对象原型上的任何方法，只要这个引用是位于简写的方法之内。
你能用 super 关键字去调用对象原型上的方法，所调用的方法会被设置好其内部的 this 绑定，以自动使用该 this 值来进行工作。

7. ES6 则正式将方法定义为：一个拥有 [[HomeObject]] 内部属性,且属性指向该方法所属的对象的函数。
任何对 super 的引用都会使用 [[HomeObject]] 属性来判断要做什么。
```
### 第五章 解构：更方便的数据访问
```
1. 为了简化提取信息的任务， ES6 新增了解构（ destructuring ），这是将一个数据结构分解为更小的部分的过程。对象解构语法在赋值语句的左侧使用了对象字面量。
当解构赋值表达式的右侧（ = 后面的表达式）的计算结果为 null 或 undefined 时，会抛出错误。因为任何读取 null 或 undefined 的属性的企图都会导致运行时错误（ runtime error ）。
let { type, name, value = true } = node;

2. 为空默认值
至此的每个解构赋值示例都使用了对象中的属性名作为本地变量的名称
let { type: localType, name: localName = "bar" } = node;

3. 数组解构
数组解构时，解构作用在数组内部的位置上，而不是作用在对象的属性名上
[ firstColor, secondColor ] = colors;

4. ES6 中互换变量值：[ a, b ] = [ b, a ];

5.
let colors = [ "red", "green", "blue" ];
let [ firstColor, ...restColors ] = colors;
console.log(firstColor);        // "red"
console.log(restColors.length); // 2
console.log(restColors[0]);     // "green"
console.log(restColors[1]);     // "blue

6. 尽管 concat() 方法的本意是合并两个数组，但若不使用任何参数来调用此方法，就会获得原数组的一个克隆品。
```

### 第六章 符号与符号属性
```
暂无
```
### 第七章 Set与Map
```
1. JS 长期以来都只存在一种集合类型，也就是数组类型。

2. Set 是不包含重复值的列表。一般不会像对待数组那样来访问 Set 中的某个项，更常见的操作是在 Set 中检查某个值是否存在。 

3. Map 则是键与相对应的值的集合。因此， Map 中的每个项都存储了两块数据，通过指定所需读取的键即可检索对应的值。 Map 常被用作缓存，存储数据以便此后快速检索。

4. ES6 新增了 Set 类型，这是一种无重复值的有序列表。允许对 Set 包含的数据进行快速访问，从而能更有效地追踪离散值。

let set = new Set();
set.add(5);
set.add("5");

console.log(set.size);    // 2

set.delete(5);

console.log(set.has(5));    // false

set.clear();

Set 上的 forEach() 方法
forEach() 方法会被传递一个回调函数，该回调接受三个参数：

Set 中下个位置的值；
与第一个参数相同的值；
目标 Set 自身。

ES6 标准的制定者本可以将 Set 版本 forEach() 方法的回调函数设定为只接受两个参数，但这会让它不同于另外两个版本的方法。
于是他们找到了一种方式让这些回调函数保持参数一致：将 Set 中的每一项同时认定为键与值。这样 Set 版本 forEach() 方法回调函数的前两个参数就始终相同了。

let set = new Set([1, 2]);
set.forEach(function(value, key, ownerSet) {
    console.log(key + " " + value);
    console.log(ownerSet === set);
});

将 Set 转换为数组
let set = new Set([1, 2, 3, 3, 3, 4, 5]),
    array = [...set];

5. Weak Set
由于 Set 类型存储对象引用的方式，它也可以被称为 Strong Set （强引用的 Set ）。
ES6 也引入了 Weak Set ，该类型只允许存储对象弱引用，而不能存储基本类型的值。对象的弱引用在它自己成为该对象的唯一引用时，不会阻止垃圾回收，

创建 Weak Set
Weak Set 使用 WeakSet 构造器来创建，并包含 add() 方法、 has() 方法以及 delete() 方法。

let set = new WeakSet(),

Set 类型之间的关键差异: Weak Set 与正规 Set 之间最大的区别是对象的弱引用。
对于 WeakSet 的实例，若调用 add() 方法时传入了非对象的参数，就会抛出错误， has() 或 delete() 则会在传入了非对象的参数时返回 false ；
Weak Set 不可迭代，因此不能被用于 for-of 循环；
Weak Set 无法暴露出任何迭代器（例如 keys() 与 values() 方法），因此没有任何编程手段可用于判断 Weak Set 的内容；
Weak Set 没有 forEach() 方法；
Weak Set 没有 size 属性。

6. ES6 的 Map 类型是键值对的有序列表，而键和值都可以是任意类型。键的比较使用的是 Object.is()

以下三个方法在 Map 与 Set 上都存在：
has(key) ：判断指定的键是否存在于 Map 中；
delete(key) ：移除 Map 中的键以及对应的值；
clear() ：移除 Map 中所有的键与值。

Map 同样拥有 size 属性，用于指明包含了多少个键值对。

Map 的初始化
let map = new Map([["name", "Nicholas"], ["age", 25]]);

收三个参数的回调函数：
Map 中下个位置的值；
该值所对应的键；
目标 Map 自身。

一个参数是值、第二个参数则是键（数组中的键是数值索引）

7. 对象的私有数据
当然，若你只是想使用非对象的键，那么正规 Map 就是唯一选择。
Map 是有序的键值对，其中的键允许是任何类型。
与 Set 相似，通过调用 Object.is() 方法来判断重复的键，这意味着能将数值 5 与字符串 "5" 作为两个相对独立的键。
```
### 第八章 迭代器与生成器
```
1. 许多编程语言都将迭代数据的方式从使用 for 循环转变到使用迭代器对象， for 循环需要初始化变量以便追踪集合内的位置，而迭代器则以编程方式返回集合中的下一个项。
```

### 第九章 JS的类
```
1. ES6 的类并不与其他语言的类完全相同，所具备的独特性正配合了 JS 的动态本质。

2. JS 在 ES5 及更早版本中都不存在类。与类最接近的是：创建一个构造器，然后将方法指派到该构造器的原型上。这种方式通常被称为创建一个自定义类型。
class PersonClass {

    // 等价于 PersonType 构造器
    constructor(name) {
        this.name = name;
    }

    // 等价于 PersonType.prototype.sayName
    sayName() {
        console.log(this.name);
    }
}

let person = new PersonClass("Nicholas");
person.sayName();   // 输出 "Nicholas

console.log(person instanceof PersonClass);     // true
console.log(person instanceof Object);          // true

console.log(typeof PersonClass);                    // "function"
console.log(typeof PersonClass.prototype.sayName);  // "function

1. 自有属性（ Own properties ）：该属性出现在实例上而不是原型上，只能在类的构造器或方法内部进行创建。在本例中， name 就是一个自有属性。
我建议应在构造器函数内创建所有可能出现的自有属性，这样在类中声明变量就会被限制在单一位置

只有在类的内部，类名才被视为是使用 const 声明的。这意味着你可以在外部重写类名，但不能在类的方法内部这么做。

类与函数相似之处在于都有两种形式：声明与表达式。函数声明与类声明都以适当的关键词为起始（分别是 function 与 class ），随后是标识符（即函数名或类名）。
函数具有一种表达式形式，无须在 function 后面使用标识符；类似的，类也有不需要标识符的表达式形式。类表达式被设计用于变量声明，或可作为参数传递给函数。

4. 基本的类表达式
let PersonClass = class {

具名类表达式
像函数表达式那样，你也可以为类表达式命名。为此需要在 class 关键字后添加标识符，就像这样：
let PersonClass = class PersonClass2 {

在编程中，能被当作值来使用的就称为一等公民（ first-class citizen ），意味着它能作为参数传给函数、能作为函数返回值、能用来给变量赋值。 JS 的函数就是一等公民（它们有时又被称为一等函数），这是 JS 的独特之处。
ES6 延续了传统，让类同样成为一等公民。
    // 等价于 PersonType.create
    static create(name) {
        return new PersonClass(name);
    }

类让继承工作变得更轻易，使用熟悉的 extends 关键字来指定当前类所需要继承的函数，即可。生成的类的原型会被自动调整，而你还能调用 super() 方法来访问基类的构造器。
class Square extends Rectangle {
        super(length, length);

7. Symbol.species 属性
继承内置对象会带来一个有趣特性，任意能返回内置对象实例的方法，在派生类上却会自动返回派生类的实例。
```
### 第十章 增强的数组功能
```
1. 
items = new Array(1, 2);
let items = Array.of(1, 2);

在 JS 中将非数组对象转换为真正的数组总是很麻烦。

2. 映射转换
如果你想实行进一步的数组转换，可以向 Array.from() 方法传递一个映射用的函数作为第二个参数。
    return Array.from(arguments, (value) => value + 1);

如果映射函数需要在对象上工作，你可以手动传递第三个参数给 Array.from() 方法，从而指定映射函数内部的 this 值。
    return Array.from(arguments, helper.add, helper);

3. find() 与 findIndex() 方法是为了让开发者能够处理包含任意值的数组，而 fill() 与 copyWithin() 方法则是受到了类型化数组（ typed arrays ）的启发。类型化数组是在 ES6 中引入的，只允许包含数值类型的值。

4. ES5 增加了 indexOf() 与 lastIndexOf() 方法
find() 与 findIndex() 方法均接受两个参数：一个回调函数、一个可选值用于指定回调函数内部的 this 。该回调函数可接收三个参数：数组的某个元素、该元素对应的索引位置、以及该数组自身，这与 map() 和 forEach() 方法的回调函数所用的参数一致。
在给定的元素满足你定义的条件时，回调函数应当返回 true ，而 find() 与 findIndex() 方法均会在回调函数第一次返回 true 时停止查找。
二者唯一的区别是： find() 方法会返回匹配的值，而 findIndex() 方法则会返回匹配位置的索引。

5. fill() 方法能使用特定值填充数组中的一个或多个元素。当只使用一个参数的时候，该方法会用该参数的值填充整个数组，
let numbers = [1, 2, 3, 4];
numbers.fill(1, 2);
console.log(numbers.toString());    // 1,2,1,1
numbers.fill(0, 1, 3);
console.log(numbers.toString());    // 1,0,0,1

1. 当进行 numbers.fill(1,2) 调用时，第二个参数 2 指定从数组索引值为 2 的元素（即数组的第 3 个元素）开始填充，而此时没有指定第三个参数，因此结束位置默认为 numbers 数组的长度，意味着该数组的最后两个元素会被填充为 1 。
而 numbers.fill(0, 1, 3) 调用则将该数组索引值为 1 与 2 的元素填充为 0 。在调用 fill() 方法时指定第二个和第三个参数，允许一次性填充数组中多个元素，避免改写整个数组。

let numbers = [1, 2, 3, 4];
// 从索引 2 的位置开始粘贴
// 从数组索引 0 的位置开始复制数据
numbers.copyWithin(2, 0);

console.log(numbers.toString());    // 1,2,1,2

7. 类型化数组是有特殊用途的数组，被设计用来处理数值类型数据, 而类型化数组则允许存储并操作八种不同的数值类型：
8 位有符号整数（int8）
8 位无符号整数（uint8）
16 位有符号整数（int16）
16 位无符号整数（uint16）
32 位有符号整数（int32）
32 位无符号整数（uint32）
32 位浮点数（float32）
64 位浮点数（float64）

8. 数组缓冲区（array buffer）是内存中包含一定数量字节的区域，而所有的类型化数组都基于数组缓冲区。创建数组缓冲区类似于在 C 语言中使用 malloc() 来分配内存，而不需要指定这块内存包含什么。
let buffer = new ArrayBuffer(10);   // 分配了 10 个字节
数组缓冲区总是保持创建时指定的字节数，你可以修改其内部的数据，但永远不能修改它的容量。

let buffer = new ArrayBuffer(10),
    view = new DataView(buffer);

可以在缓冲区的一个部分上创建视图，只需要指定可选参数——字节偏移量、以及所要包含的字节数。当未提供最后一个参数时，该 DataView 视图会默认包含从偏移位置开始、到缓冲区末尾为止的元素。

let buffer = new ArrayBuffer(10),
    view = new DataView(buffer, 5, 2);      // 包含位置 5 与位置 6 的字节

9. 你可以通过查询以下只读属性来获取视图的信息：
buffer ：该视图所绑定的数组缓冲区；
byteOffset ：传给 DataView 构造器的第二个参数，如果当时提供了的话（默认值为 0）;
byteLength ：传给 DataView 构造器的第三个参数，如果当时提供了的话（默认值为该缓冲区的 byteLength 属性）。

10. 类型化数组即为视图
ES6 的类型化数组实际上也是针对数组缓冲区的特定类型视图，你可以使用这些数组对象来处理特定的数据类型，而不必使用通用的 DataView 对象。一共存在八种特定类型视图，对应着八种数值数据类型，还为处理 uint8 值提供了额外的选择。

与常规数组相同，类型化数组也拥有三个迭代器，它们是 entries() 方法、 keys() 方法与 values() 方法。
最后，所有的类型化数组都包含静态的 of() 与 from() 方法，作用类似于 Array.of() 与 Array.from() 方法。其中的区别是类型化数组的版本会返回类型化数组，而不返回常规数组。

11. 类型化数组与常规数组的区别

二者最重要的区别就是类型化数组并不是常规数组，类型化数组并不是从 Array 对象派生的，使用 Array.isArray() 去检测会返回 false

let ints = new Int16Array([25, 50]);

console.log(ints instanceof Array);     // false
console.log(Array.isArray(ints));       // false

常规数组可以被伸展或是收缩，然而类型化数组却会始终保持自身大小不变。你可以对常规数组一个不存在的索引位置进行赋值，但在类型化数组上这么做则会被忽略。
最后，类型化数组还有两个常规数组所不具备的方法： set() 方法与 subarray() 方法。这两个方法作用相反： set() 方法从其他数组中复制元素到当前的类型化数组，而 subarray() 方法则是将当前类型化数组的一部分提取为新的类型化数组。

set() 方法接受一个数组参数（无论是类型化的还是常规的）、以及一个可选的偏移量参数，后者指示了从什么位置开始插入数据（默认值为 0 ）。

let ints = new Int16Array(4);

ints.set([25, 50]);
ints.set([75, 100], 2);

console.log(ints.toString());   // 25,50,75,100

ES6 延续了 ES5 的工作以便让数组更加有用。新增了两种创建数组的方式： Array.of() 方法、以及 Array.from() 方法，后者可以将可迭代对象或类数组对象转换为正规数组。
```
### 第十一章 Promise与异步编程
```
1. JS 最强大的一方面就是它能极其轻易地处理异步编程。Promise 是异步编程的另一种选择，它的工作方式类似于在其他语言中进行延迟并在将来执行作业。
一个 Promise 指定一些稍后要执行的代码（就像事件与回调函数一样），并且也明确标示了作业的代码是否执行成功。你能以成功处理或失败处理为基准，将 Promise 串联在一起，让代码更易理解、更易调试。

异步编程的背景
代码会被放置在作业队列（ job queue ）中，每当一段代码准备被执行，它就会被添加到作业队列。当 JS 引擎结束当前代码的执行后，事件循环就会执行队列中的下一个作业。
事件循环（ event loop ）是 JS 引擎的一个内部处理进程，能监视代码的执行并管理作业队列。要记住既然是一个队列，作业就会从队列中的第一个开始，依次运行到最后一个。

let button = document.getElementById("my-btn");
button.onclick = function(event) {
    console.log("Clicked");
};

在此代码中， console.log("Clicked") 直到 button 被点击后才会被执行。当 button 被点击，赋值给 onclick 的函数就被添加到作业队列的尾部，并在队列前部所有任务结束之后再执行。
//错误优先（ error-first ）
  if (err) {
        throw err;
    }

但当嵌套过多回调函数时，你可能会迅速察觉陷入了回调地狱（ callback hell ）

2. Promise 基础
Promise 是为异步操作的结果所准备的占位符。函数可以返回一个 Promise，而不必订阅一个事件或向函数传递一个回调参数，就像这样：

// readFile 承诺会在将来某个时间点完成
let promise = readFile("example.txt");

在此代码中， readFile() 实际上并未立即开始读取文件，这将会在稍后发生。此函数会返回一个 Promise 对象以表示异步读取操作，因此你可以在将来再操作它。你能对结果进行操作的确切时刻，完全取决于 Promise 的生命周期是如何进行的。

3. Promise 的生命周期
每个 Promise 都会经历一个短暂的生命周期，初始为进行态（ pending state），这表示异步操作尚未结束。一个进行中的 Promise 也被认为是未处理的（ unsettled ）

一旦异步操作结束， Promise 就会被认为是已处理的（ settled ），并进入两种可能状态之一：
已完成（ fulfilled ）： Promise 的异步操作已成功结束；
已拒绝（ rejected ）： Promise 的异步操作未成功结束，可能是一个错误，或由其他原因导致。

内部的 [[PromiseState]] 属性会被设置为 "pending" 、 "fulfilled" 或 "rejected" ，以反映 Promise 的状态。
该属性并未在 Promise 对象上被暴露出来，因此你无法以编程方式判断 Promise 到底处于哪种状态。不过你可以使用 then() 方法在 Promise 的状态改变时执行一些特定操作。

pending ：进行，表示未结束的 Promise 状态。相关词汇进行态。
fulfilled ：已完成，表示已成功结束的 Promise 状态，可以理解为成功完成。相关词汇完成、被完成、完成态。
rejected ：已拒绝，表示已结束但失败的 Promise 状态。相关词汇拒绝、被拒绝、拒绝态。
resolve ：决议，表示将 Promise 推向成功态，可以理解为决议通过，在 Promise 概念中与完成是近义词。相关词汇决议态、已决议、被决议。
unsettled ：未处理，或者称为未解决，表示 Promise 尚未被完成或拒绝，与挂起是近义词。
settled ：已处理，或者称为已解决，表示 Promise 已被完成或拒绝。注意这与已完成或已决议不同，已处理的状态也可能是拒绝态（已失败）。
fulfillment handler ：完成处理函数，表示 Promise 为完成态时会被调用的函数。
rejection handler ：拒绝处理函数，表示 Promise 为拒绝态时会被[…]

then() 方法在所有的 Promise 上都存在，并且接受两个参数。第一个参数是 Promise 被完成时要调用的函数，与异步操作关联的任何附加数据都会被传入这个完成函数。第二个参数则是 Promise 被拒绝时要调用的函数，与完成函数相似，拒绝函数会被传入与拒绝相关联的任何附加数据。

let promise = readFile("example.txt");

promise.then(function(contents) {
    // 完成
    console.log(contents);
}, function(err) {
    // 拒绝
    console.error(err.message);
});

关于 Promise 需要牢记的只有：若你未提供拒绝处理函数，所有的错误就会静默发生。建议始终附加一个拒绝处理函数，即使该处理程序只是用于打印错误日志。
即使完成或拒绝处理函数在 Promise 已经被处理之后才添加到作业队列，它们仍然会被执行。这允许你随时添加新的完成或拒绝处理函数，并保证它们会被调用。
每次调用 then() 或 catch() 都会创建一个新的作业，它会在 Promise 已处理时被执行。但这些作业最终会进入一个完全为 Promise 保留的作业队列。

创建未处理的 Promise
新的 Promise 使用 Promise 构造器来创建。此构造器接受单个参数：一个被称为执行器（ executor ）的函数，包含初始化 Promise 的代码。该执行器会被传递两个名为 resolve() 与 reject() 的函数作为参数。 
resolve() 函数在执行器成功结束时被调用，用于示意该 Promise 已经准备好被决议（ resolved ），而执行器的操作失败后 reject() 函数则被调用。

  return new Promise(function(resolve, reject) {

要记住执行器会在 readFile() 被调用时立即运行。当 resolve() 或 reject() 在执行器内部被调用时，一个作业被添加到作业队列中，以便处理这个 Promise 。这被称为作业调度（ job scheduling ）
setTimeout() 函数能让你指定一个延迟时间，延迟之后作业才会被添加到队列：
调用 resolve() 触发了一个异步操作。传递给 then() 与 catch() 的函数会异步地被执行，并且它们也被添加到了作业队列（先进队列再执行）。
尽管对 then() 的调用出现在 console.log("Hi!") 代码行之前，它实际上稍后才会执行（与执行器中那行 "Promise" 不同）。这是因为完成处理函数与拒绝处理函数总是会在执行器的操作结束后被添加到作业队列的尾部。
基于 Promise 执行器行为的动态本质， Promise 构造器就是创建未处理的 Promise 的最好方式。

4. Promise.resolve() 方法接受单个参数并会返回一个处于完成态的 Promise 。这意味着没有任何作业调度会发生，并且你需要向 Promise 添加一个或更多的完成处理函数来提取这个参数值。

let promise = Promise.resolve(42);
promise.then(function(value) {
    console.log(value);         // 42
});

你也可以使用 Promise.reject() 方法来创建一个已拒绝的 Promise 。此方法像 Promise.resolve() 一样工作，区别是被创建的 Promise 处于拒绝态

let promise = Promise.reject(42);
promise.catch(function(value) {
    console.log(value);         // 42
});


非 Promise 的 Thenable
Promise.resolve() 与 Promise.reject() 都能接受非 Promise 的 thenable 作为参数。当传入了非 Promise 的 thenable 时，这些方法会创建一个新的 Promise ，此 Promise 会在 then() 函数之后被调用。

let thenable = {
    then: function(resolve, reject) {
        reject(42);
    }
};

如果在执行器内部抛出了错误，那么 Promise 的拒绝处理函数就会被调用。
此处在每个执行器之中存在隐式的 try-catch ，因此错误就被捕捉并传递给了拒绝处理函数。

let promise = new Promise(function(resolve, reject) {
    try {
        throw new Error("Explosion!");
    } catch (ex) {
        reject(ex);
    }
});

promise.catch(function(error) {
    console.log(error.message);     // "Explosion!"
});

5. Node.js 的拒绝处理
在 Node.js 中， process 对象上存在两个关联到 Promise 的拒绝处理的事件：
unhandledRejection ：当一个 Promise 被拒绝、而在事件循环的一个轮次中没有任何拒绝处理函数被调用，该事件就会被触发；
rejectionHandled ：若一个 Promise 被拒绝、并在事件循环的一个轮次之后再有拒绝处理函数被调用，该事件就会被触发。
这两个事件旨在共同帮助识别已被拒绝但未曾被处理 promise。
process.on("unhandledRejection", function(reason, promise) {

浏览器同样能触发两个事件，来帮助识别未处理的拒绝。这两个事件会被 window 对象触发，并完全等效于 Node.js 的相关事件：
unhandledrejection ：当一个 Promise 被拒绝、而在事件循环的一个轮次中没有任何拒绝处理函数被调用，该事件就会被触发；
rejectionHandled ：若一个 Promise 被拒绝、并在事件循环的一个轮次之后再有拒绝处理函数被调用，该事件就会被触发。

Node.js 的实现会传递分离的参数给事件处理函数，而浏览器事件的处理函数则只会接收到包含下列属性的一个对象：
type ： 事件的名称（ "unhandledrejection" 或 "rejectionhandled" ）；
promise ：被拒绝的 Promise 对象；
reason ： Promise 中的拒绝值（拒绝原因）。

为了确保能正确处理任意可能发生的错误，应当始终在 Promise 链尾部添加拒绝处理函数。

在 Promise 链中返回值
Promise 链的另一重要特性是能从一个 Promise 传递数据给下一个 Promise 。

然而有时你会想监视多个 Promise 的进程，以便决定下一步行动。 ES6 提供了能监视多个 Promise 的两个方法： Promise.all() 与 Promise.race() 。

Promise.all() 方法接收单个可迭代对象（如数组）作为参数，并返回一个 Promise 。这个可迭代对象的元素都是 Promise ，只有在它们都完成后，所返回的 Promise 才会被完成。
let p1 = new Promise(function(resolve, reject) {
    resolve(42);
});

let p4 = Promise.all([p1, p2, p3]);
Promise.race() 方法

Promise.race() 提供了监视多个 Promise 的一个稍微不同的方法。此方法也接受一个包含需监视的 Promise 的可迭代对象，并返回一个新的 Promise ，但一旦来源 Promise 中有一个被解决，所返回的 Promise 就会立刻被解决。

6. 继承 Promise
正像其他内置类型，你可将一个 Promise 用作派生类的基类。这允许你自定义变异的 Promise ，在内置 Promise 的基础上扩展功能。

class MyPromise extends Promise {

    // 使用默认构造器
    success(resolve, reject) {
        return this.then(resolve, reject);
    }

    failure(reject) {
        return this.catch(reject);
    }
}

let promise = new MyPromise(function(resolve, reject) {
    resolve(42);
});

promise.success(function(value) {
    console.log(value);             // 42
}).failure(function(value) {
    console.log(value);
});

Promise 被设计用于改善 JS 中的异步编程，与事件及回调函数对比，在异步操作方面为你提供了更多的控制权与组合性。 Promise 调度被添加到 JS 引擎作业队列，以便稍后执行。不过此处有另一个作业队列追踪着 Promise 的完成与拒绝处理函数，以确保准确执行。

Promise 具有三种状态：进行中、已完成、已拒绝。一个 Promise 起始于进行态，并在成功时转为完成态，或在失败时转为拒绝态。在这两种情况下，处理函数都能被添加以便在 Promise 被解决后作出响应。
 then() 方法允许你绑定完成处理函数与拒绝处理函数，而 catch() 方法则只允许你绑定拒绝处理函数。
```
### 第十二章 代理与反射接口
```
1. 可以通过修改 length 属性来变更数组的元素。这种不规范行为就是 ES6 将数组认定为奇异对象的原因。

2. 通过调用 new Proxy() ，你可以创建一个代理，用于替代另一个对象（被称为目标）

代理允许你拦截在目标对象上的底层操作，而这原本是 JS 引擎的内部能力。拦截行为使用了一个能够响应特定操作的函数（被称为陷阱）。

反射接口由 Reflect 对象所代表，是给底层操作提供默认行为的方法的集合，这些操作是能够被代理重写的。每个代理陷阱都有一个对应的反射方法，每个方法都与对应的陷阱函数同名，并且接收的参数也与之一致。

3. 创建一个简单的代理
当你使用 Proxy 构造器来创建一个代理时，需要传递两个参数：目标对象以及一个处理器（handler），后者是定义了一个或多个陷阱函数的对象。
代理对象 proxy 自身其实并没有存储该属性，它只是简单将值转发给 target 对象。同样， proxy.name 与 target.name 的属性值总是相等，因为它们都指向 target.name

使用 set 陷阱函数验证属性值

为此你需要定义 set 陷阱函数来重写设置属性值时的默认行为，该陷阱函数能接受四个参数：
trapTarget ：将接收属性的对象（即代理的目标对象）；
key ：需要写入的属性的键（字符串类型或符号类型）；
value ：将被写入属性的值；
receiver ：操作发生的对象（通常是代理对象）。


对象外形（ Object Shape ）指的是对象已有的属性与方法的集合
trapTarget ：将会被读取属性的对象（即代理的目标对象）；
key ：需要读取的属性的键（字符串类型或符号类型）；
receiver ：操作发生的对象（通常是代理对象）。

你可以使用 get 陷阱函数与 Reflect.get() 方法在目标属性不存在时抛出错误，就像这样：

let proxy = new Proxy({}, {
        get(trapTarget, key, receiver) {
            if (!(key in receiver)) {
                throw new TypeError("Property " + key + " doesn't exist.");
            }

            return Reflect.get(trapTarget, key, receiver);
        }
    });

在本例中， get 陷阱函数拦截了属性读取操作，它使用 in 运算符来判断 receiver 对象上是否已存在对应属性。使用 receiver 而非 trapTarget 去配合 in ，这是因为 receiver 本身就是拥有一个 has 陷阱函数（在下一节介绍）的代理对象，
在此处使用 trapTarget 会跳过 has 陷阱函数，并可能给你一个错误的结果。如果要查找的属性不存在，那么就会抛出错误；否则会执行默认的行为。

4. 使用 has 陷阱函数隐藏属性
in 运算符用于判断指定对象中是否存在某个属性，如果对象的属性名与指定的字符串或符号值相匹配，那么 in 运算符应当返回 true ，无论该属性是对象自身的属性还是其原型的属性。

has 陷阱函数会在使用 in 运算符的情况下被调用，并且会被传入两个参数：
trapTarget ：需要读取属性的对象（即代理的目标对象）；
key ：需要检查的属性的键（字符串类型或符号类型）。

使用 has 陷阱函数以及 Reflect.has() 方法，允许你修改部分属性在接受 in 检测时的行为，但保留其他属性的默认行为。
  if (key === "value") {
            return false;
        } else {
            return Reflect.has(trapTarget, key);
        }

5. deleteProperty 陷阱函数会在使用 delete 运算符去删除对象属性时被调用，并且会被传入两个参数：
trapTarget ：需要删除属性的对象（即代理的目标对象）；
key ：需要删除的属性的键（字符串类型或符号类型）。

 if (key === "value") {
            return false;
        } else {
            return Reflect.deleteProperty(trapTarget, key);
        }

value 属性是不能被删除的，因为该操作被 proxy 对象拦截；而 name 则能如期被删除。这么做允许你在严格模式下保护属性避免其被删除，并且不会抛出错误。

6. setPrototypeOf 陷阱函数接受三个参数：
trapTarget ：需要设置原型的对象（即代理的目标对象）；
proto ：需用被用作原型的对象。

这些陷阱函数受到一些限制。首先， getPrototypeOf 陷阱函数的返回值必须是一个对象或者 null ，其他任何类型的返回值都会引发运行时错误。

其次， setPrototypeOf 必须在操作没有成功的情况下返回 false ，这样会让 Object.setPrototypeOf() 抛出错误；而若 setPrototypeOf 的返回值不是 false ，则 Object.setPrototypeOf() 就会认为操作已成功。

下面这个例子通过返回 null 隐藏了代理对象的原型，并且使得该原型不可被修改：
getPrototypeOf(trapTarget) {
        return null;
    },
    setPrototypeOf(trapTarget, proto) {
        return false;
    }

getPrototypeOf(trapTarget) {
        return Reflect.getPrototypeOf(trapTarget);
    },
    setPrototypeOf(trapTarget, proto) {
        return Reflect.setPrototypeOf(trapTarget, proto);
    }

Reflect.getPrototypeOf() 方法在接收到的参数不是一个对象时会抛出错误，而 Object.getPrototypeOf() 则会在操作之前先将参数值转换为一个对象。


7. 对象可扩展性的陷阱函数
ES5 通过 Object.preventExtensions() 与 Object.isExtensible() 方法给对象增加了可扩展性。而 ES6 则通过 preventExtensions 与 isExtensible 陷阱函数允许代理拦截对于底层对象的方法调用。
这两个陷阱函数都接受名为 trapTarget 的单个参数，此参数代表方法在哪个对象上被调用。isExtensible 陷阱函数必须返回一个布尔值用于表明目标对象是否可被扩展，而 preventExtensions 陷阱函数也需要返回一个布尔值，用于表明操作是否已成功。

同时也存在 Reflect.preventExtensions() 与 Reflect.isExtensible() 方法，用于实现默认的行为。这两个方法都返回布尔值，因此它们可以在对应的陷阱函数内直接使用。
 isExtensible(trapTarget) {
        return Reflect.isExtensible(trapTarget);
    },
    preventExtensions(trapTarget) {
        return Reflect.preventExtensions(trapTarget);
    }

defineProperty 陷阱函数接受下列三个参数：
trapTarget ：需要被定义属性的对象（即代理的目标对象）；
key ：属性的键（字符串类型或符号类型）；
descriptor ：为该属性准备的描述符对象。

defineProperty 陷阱函数要求你在操作成功时返回 true ，否则返回 false 。 getOwnPropertyDescriptor 陷阱函数则只接受 trapTarget 与 key 这两个参数，并会返回对应的描述符。

 defineProperty(trapTarget, key, descriptor) {
        return Reflect.defineProperty(trapTarget, key, descriptor);
    },
    getOwnPropertyDescriptor(trapTarget, key) {
        return Reflect.getOwnPropertyDescriptor(trapTarget, key);
    }

defineProperty(trapTarget, key, descriptor) {

        if (typeof key === "symbol") {
            return false;
        }

        return Reflect.defineProperty(trapTarget, key, descriptor);
    }

ownKeys 代理陷阱拦截了内部方法 [[OwnPropertyKeys]] ，并允许你返回一个数组用于重写该行为。返回的这个数组会被用于四个方法： Object.keys() 方法、 Object.getOwnPropertyNames() 方法、 Object.getOwnPropertySymbols() 方法与 Object.assign() 方法，其中 Object.assign() 方法会使用该数组来决定哪些属性会被复制。

8. 使用 apply 与 construct 陷阱函数的函数代理
在所有的代理陷阱中，只有 apply 与 construct 要求代理目标对象必须是一个函数。

函数拥有两个内部方法： [[Call]] 与 [[Construct]] ，前者会在函数被直接调用时执行，而后者会在函数被使用 new 运算符调用时执行。 apply 与 construct 陷阱函数对应着这两个内部方法，并允许你对其进行重写。当不使用 new 去调用一个函数时， apply 陷阱函数会接收到下列三个参数（ Reflect.apply() 也会接收这些参数）：
trapTarget ：被执行的函数（即代理的目标对象）；
thisArg ：调用过程中函数内部的 this 值；
argumentsList ：被传递给函数的参数数组。

当使用 new 去执行函数时， construct 陷阱函数会被调用并接收到下列两个参数：
trapTarget ：被执行的函数（即代理的目标对象）；
argumentsList ：被传递给函数的参数数组。

Reflect.construct() 方法同样会接收到这两个参数，还会收到可选的第三参数 newTarget ，如果提供了此参数，则它就指定了函数内部的 new.target 值。

apply 与 construct 陷阱函数结合起来就完全控制了任意的代理目标对象函数的行为。

  apply: function(trapTarget, thisArg, argumentList) {
            return Reflect.apply(trapTarget, thisArg, argumentList);
        },
        construct: function(trapTarget, argumentList) {
            return Reflect.construct(trapTarget, argumentList);
        }

 instanceof 运算符使用了原型链来进行推断，而原型链查找并没有受到这个代理的影响，因此 proxy 对象与 target 对象对于 JS 引擎来说就有同一个原型。

调用构造器而无须使用 new

在使用 new 运算符调用函数时，这个属性就是对该函数的一个引用。这意味着你可以使用 new.target 来判断函数被调用时是否使用了 new 

    if (typeof new.target === "undefined") {
            return Reflect.construct(trapTarget, argumentsList);

9. 重写抽象基础类的构造器

你可以进一步指定 Reflect.construct() 的第三个参数，用于给 new.target 赋值。
在抽象基础类的构造器中， new.target 被要求不能是构造器自身

 construct: function(trapTarget, argumentList) {
            return Reflect.construct(trapTarget, argumentList, function() {});
        }

  apply: function(trapTarget, thisArg, argumentList) {
            return new trapTarget(...argumentList);
        }

你可以使用 Proxy.revocable() 方法来创建一个可被撤销的代理，该方法接受的参数与 Proxy 构造器的相同：一个目标对象、一个代理处理器，而返回值是包含下列属性的一个对象：
proxy ：可被撤销的代理对象；
revoke ：用于撤销代理的函数。


10. 检测数组的索引
必须始终牢记：对于数组来说，为整数属性赋值是一种特殊情况，不同于对非整数的键的处理。

在减少长度属性时移除元素

创建一个使用代理的类的最简单方式，就是照常定义一个类但从构造器中返回一个代理。

当内部方法 [[Get]] 被调用以读取属性时，该操作首先会查找对象的自有属性；如果指定名称的属性没有找到，则会继续在对象的原型上进行属性查找；这个流程会一直持续到没有原型可供查找为止。

得益于这个流程，若你设置了一个 get 代理陷阱，则只有在对象不存在指定名称的自有属性时，该陷阱函数才会在对象的原型上被调用。当所访问的属性无法保证存在时，你可以使用 get 陷阱函数来阻止预期外的行为。

 get(trapTarget, key, receiver) {
        throw new ReferenceError(`${key} doesn't exist`);
    }

内部方法 [[Set]] 同样会查找对象的自有属性，并在必要时继续对该对象的原型进行查找。当你对一个对象属性进行赋值时，如果指定名称的自有属性存在，值就会被赋在该属性上；而若该自有属性不存在，则会继续检查对象的原型。
微妙之处在于：尽管赋值操作在原型上继续进行，但默认情况下它会在对象实例（而非原型）上创建一个新的属性用于赋值，无论同名属性是否存在于原型上。

10. 在原型上使用 has 陷阱函数
has 陷阱函数只在原型链查找触及原型对象的时候才会被调用。当使用代理作为原型时，这只会在指定名称的自有属性不存在时发生。
由于类的 prototype 属性是不可写入的，因此不能直接修改类，将代理用作它的原型。

反射接口也是在 ES6 中引入的，允许开发者为每个代理陷阱实现默认的行为。每个代理陷阱在 ES6 的另一个新特性 Reflect 对象上都有一个同名的对应方法。将代理陷阱与反射接口方法结合使用，就可以在特定条件下让一些操作有不同的表现，有别于默认的内置行为。

可被撤销的代理是一种特殊的代理，可以使用 revoke() 函数去有效禁用。 revoke() 函数终结了代理的所有功能，因此在它被调用之后，所有与代理属性交互的意图都会导致抛出错误。

尽管直接使用代理是最有力的使用方式，但你也可以把代理用作其他对象的原型。但只有很少的代理陷阱能在作为原型的代理上被有效使用，包括 get 、 set 与 has 这几个，这方面的用例也因此变得十分有限。


### 第十三章 用模块封装代码
1. 模块（ Modules ）是使用不同方式加载的 JS 文件（与 JS 原先的脚本加载方式相对）。这种不同模式很有必要，因为它与脚本（ script ）有大大不同的语义：

模块代码自动运行在严格模式下，并且没有任何办法跳出严格模式；
在模块的顶级作用域创建的变量，不会被自动添加到共享的全局作用域，它们只会在模块顶级作用域的内部存在；
模块顶级作用域的 this 值为 undefined ；
模块不允许在代码中使用 HTML 风格的注释（这是 JS 来自于早期浏览器的历史遗留特性）；
对于需要让模块外部代码访问的内容，模块必须导出它们；
允许模块从其他模块导入绑定。

你可以使用 export 关键字将已发布代码部分公开给其他模块。最简单方法就是将 export 放置在任意变量、函数或类声明之前，从模块中将它们公开出去
export var color = "red";
export let name = "Nicholas";
export const magicNumber = 7;

// 导出函数
export function sum(num1, num2) {
    return num1 + num1;
}

// 导出类
export class Rectangle {
    constructor(length, width) {
        this.length = length;
        this.width = width;
    }
}

每个被导出的函数或类都有名称，这是因为导出的函数声明与类声明必须要有名称。

一旦你有了包含导出的模块，就能在其他模块内使用 import 关键字来访问已被导出的功能。 import 语句有两个部分，一是需要导入的标识符，二是需导入的标识符的来源模块。此处是导入语句的基本形式：

import { identifier1, identifier2 } from "./example.js";
// 多个导入
import { sum, multiply, magicNumber } from "./example.js";
import * as example from "./example.js";

这种导入格式被称为命名空间导入（ namespace import ），这是因为该 example 对象并不存在于 example.js 文件中，而是作为一个命名空间对象被创建使用，其中包含了 example.js 的所有导出成员。

function sum(num1, num2) {
    return num1 + num2;
}
export { sum as add };

此处的 sum() 函数被作为 add() 导出，前者是本地名称（ local name ），后者则是导出名称（ exported name ）。这意味着当另一个模块要导入此函数时，它必须改用 add 这个名称：
import { add } from "./example.js";

若你想将来自另一个模块的所有值完全导出，可以使用星号（ * ）模式：
export * from "./example.js";

2. 无绑定的导入
诸如 Array 与 Object 之类的内置对象的共享定义在模块内部是可访问的，并且对于这些对象的修改会反映到其他模块中。

// 没有导出与导入的模块
Array.prototype.pushAll = function(items) {

    // items 必须是一个数组
    if (!Array.isArray(items)) {
        throw new TypeError("Argument must be an array.");
    }

    // 使用内置的 push() 与扩展运算符
    return this.push(...items);
};

这是一个有效的模块，尽管此处没有任何导出与导入。此代码可以作为模块或脚本来使用。由于它没有导出任何东西，你可以使用简化的导入语法来执行此模块的代码，而无须导入任何绑定：
import "./example.js";

let colors = ["red", "green", "blue"];
let items = [];

items.pushAll(colors);

3. 在 Web 浏览器中使用模块
<script> 元素能够执行内联脚本，也能加载在 src 中指定的文件。为了支持模块，添加了 "module" 值作为 type 的选项。将 type 设置为 "module" ，就告诉浏览器要将内联代码或是指定文件中的代码当作模块，而不是当作脚本。
<script type="module" src="module.js"></script>
<script type="module">
浏览器模块说明符方案

例如 "./example.js" 。浏览器要求模块说明符应当为下列格式之一：

以 / 为起始，表示从根目录开始解析；
以 ./ 为起始，表示从当前目录开始解析；
以 ../ 为起始，表示从父级目录开始解析；
URL 格式。

ES6 为 JS 语言添加了模块，作为打包与封装功能的方式。模块的行为异于脚本，它们不会用自身顶级作用域的变量、函数或类去修改全局作用域，而模块的 this 值为 undefined 。为了实现这些行为，模块在被加载时使用了一种不同的方式。

你必须将模块中需要向外提供的任何功能都导出，变量、函数与类都可以，并且每个模块允许存在一个默认导出。在导出之后，另一个模块就能导入该模块所导出的一个或多个名称了。这些导入的名称就像是被 const 所定义的，会被当作块级绑定，并且不允在同一模块内重复声明。

由于模块必须用与脚本不同的方式运行，浏览器就引入了 <script type="module"> ，以表示资源文件或内联代码需要作为模块来执行。使用 <script type="module"> 加载的模块文件会默认应用 defer 属性。一旦包含模块的页面文档完全被解析，模块就会按照它们在文档中的出现顺序依次执行。
```