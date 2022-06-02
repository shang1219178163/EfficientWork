 



### 基本语法

JavaScript严格区分大小写



#### 数据类型和变量

JavaScript在设计时，有两种比较运算符：

第一种是==比较，它会自动转换数据类型再比较，很多时候，会得到非常诡异的结果；

第二种是===比较，它不会自动转换数据类型，如果数据类型不一致，返回false，如果一致，再比较。

由于JavaScript这个设计缺陷，不要使用 == 比较，始终坚持使用 === 比较。

另一个例外是NaN这个特殊的Number与所有其他值都不相等，包括它自己：

NaN === NaN; // false

唯一能判断NaN的方法是通过isNaN()函数：

isNaN(NaN); // true



最后要注意浮点数的相等比较：

1 / 3 === (1 - 2 / 3); // false

这不是JavaScript的设计缺陷。浮点数在运算过程中会产生误差，因为计算机无法精确表示无限循环小数。要比较两个浮点数是否相等，只能计算它们之差的绝对值，看是否小于某个阈值：

Math.abs(1 / 3 - (1 - 2 / 3)) < 0.0000001; // true

大多数情况下，我们都应该用null。undefined仅仅在判断函数参数是否传递的情况下有用。



#### 对象

JavaScript的对象是一组由键-值组成的无序集合

JavaScript对象的键都是字符串类型，值可以是任意数据类型。

启用strict模式的方法是在JavaScript代码的第一行写上：

'use strict';



#### 字符串

s.substring(0, 5); // 从索引0开始到5（不包括5），返回'hello'

s.substring(7); // 从索引7开始到结束，返回'world



#### 数组

注意到slice()的起止参数包括开始索引，不包括结束索引。

如果不给slice()传递任何参数，它就会从头到尾截取所有元素。利用这一点，我们可以很容易地复制一个Array：

push()向Array的末尾添加若干元素，pop()则把Array的最后一个元素删除掉：

arr.pop(); // 空数组继续pop不会报错，而是返回undefined



unshift和shift

如果要往Array的头部添加若干元素，使用unshift()方法，shift()方法则把Array的第一个元素删掉：



splice()方法是修改Array的万能方法，它可以从指定的索引开始删除若干元素，然后再从该位置添加若干元素：

arr.splice(2, 3, 'Google', 'Facebook'); // 返回删除的元素 ['Yahoo', 'AOL', 'Excite']



concat()方法把当前的Array和另一个Array连接起来，并返回一个新的Array：



#### 对象

JavaScript的对象是一种无序的集合数据类型，它由若干键值对组成。

JavaScript规定，访问不存在的属性不报错，而是返回undefined



#### Map和Set

JavaScript的默认对象表示方式{}可以视为其他语言中的Map或Dictionary的数据结构，即一组键值对。

Map是一组键值对的结构，具有极快的查找速度。



要创建一个Set，需要提供一个Array作为输入，或者直接创建一个空Set：

var s1 = new Set(); // 空Set

var s2 = new Set([1, 2, 3]); // 含1, 2, 3



iterable

具有iterable类型的集合可以通过新的for ... of循环来遍历。

for ... of循环是ES6引入的新的语法，请测试你的浏览器是否支持：

'use strict';

var a = [1, 2, 3];

for (var x of a) {

}

alert('你的浏览器支持for ... of');



for ... in循环由于历史遗留问题，它遍历的实际上是对象的属性名称。一个Array数组实际上也是一个对象，它的每个元素的索引被视为一个属性。

更好的方式是直接使用iterable内置的forEach方法，它接收一个函数，每次迭代就自动回调该函数。



#### 函数定义和调用

JavaScript还有一个免费赠送的关键字arguments，它只在函数内部起作用，并且永远指向当前函数的调用者传入的所有参数。arguments类似Array但它不是一个Array：

我们在函数内部定义变量时，请严格遵守在函数内部首先申明所有变量这一规则。最常见的做法是用一个var申明函数内部用到的所有变量：



全局变量会绑定到window上，不同的JavaScript文件如果使用了相同的全局变量，或者定义了相同名字的顶层函数，都会造成命名冲突，并且很难被发现。

减少冲突的一个方法是把自己的所有变量和函数全部绑定到一个全局变量中。

如果以对象的方法形式调用，比如xiaoming.age()，该函数的this指向被调用的对象，也就是xiaoming，这是符合我们预期的。



要保证this指向正确，必须用obj.xxx()的形式调用！

要指定函数的this指向哪个对象，可以用函数本身的apply方法，它接收两个参数，第一个参数就是需要绑定的this变量，第二个参数是Array，表示函数本身的参数。

getAge.apply(xiaoming, []); // 25, this指向xiaoming, 参数为空



#### 高阶函数

高阶函数英文叫Higher-order function。

JavaScript的函数其实都指向某个变量。既然变量可以指向函数，函数的参数能接收变量，那么一个函数就可以接收另一个函数作为参数，这种函数就称之为高阶函数。



Array的sort()方法默认把所有元素先转换为String再排序



#### 闭包

返回闭包时牢记的一点就是：返回函数不要引用任何循环变量，或者后续会发生变化的变量。

理论上讲，创建一个匿名函数并立刻执行可以这么写：

function (x) { return x * x } (3);

但是由于JavaScript语法解析的问题，会报SyntaxError错误，因此需要用括号把整个函数定义括起来：



(function (x) { return x * x }) (3);

通常，一个立即执行的匿名函数可以把函数体拆开，一般这么写：

(function (x) {

​    return x * x;

})(3);



换句话说，闭包就是携带状态的函数，并且它的状态可以完全对外隐藏起来。



#### generator

generator（生成器）是ES6标准引入的新的数据类型。一个generator看上去像一个函数，但可以返回多次。

函数在执行过程中，如果没有遇到return语句（函数末尾如果没有return，就是隐含的return undefined;），控制权无法交回被调用的代码。

function* foo(x) {

​    yield x + 1;

​    yield x + 2;

​    return x + 3;

}

generator和函数不同的是，generator由function*定义（注意多出的*号），并且，除了return语句，还可以用yield返回多次。

function* fib(max) {

​    var t,

​        a = 0,

​        b = 1,

​        n = 1;

​    while (n < max) {

​        yield a;

​        t = a + b;

​        a = b;

​        b = t;

​        n ++;

​    }

​    return a;

}

直接调用一个generator和调用函数不一样，fib(5)仅仅是创建了一个generator对象，还没有去执行它。

调用generator对象有两个方法，一是不断地调用generator对象的next()方法：



第二个方法是直接用for ... of循环迭代generator对象，这种方式不需要我们自己判断done：

for (var x of fib(5)) {

​    console.log(x); // 依次输出0, 1, 1, 2, 3

}

因为generator可以在执行过程中多次返回，所以它看上去就像一个可以记住执行状态的函数，利用这一点，写一个generator就可以实现需要用面向对象才能实现的功能。

generator还有另一个巨大的好处，就是把异步回调代码变成同步代码。



#### 标准对象

在JavaScript的世界里，一切都是对象。为了区分对象的类型，我们用typeof操作符获取对象的类型，它总是返回一个字符串：

typeof 123; // 'number'

typeof NaN; // 'number'

typeof 'str'; // 'string'

typeof true; // 'boolean'

typeof undefined; // 'undefined'

typeof Math.abs; // 'function'

typeof null; // 'object'

typeof []; // 'object'

typeof {}; // 'object



虽然包装对象看上去和原来的值一模一样，显示出来也是一模一样，但他们的类型已经变为object了！所以，包装对象和原始值用===比较会返回false



var b2 = Boolean('false'); // true! 'false'字符串转换结果为true！因为它是非空字符串！

不要使用new Number()、new Boolean()、new String()创建包装对象；

用parseInt()或parseFloat()来转换任意类型到number；

用String()来转换任意类型到string，或者直接调用某个对象的toString()方法；

通常不必把任意类型转换为boolean再判断，因为可以直接写if (myVar) {...}；

typeof操作符可以判断出number、boolean、string、function和undefined；

判断Array要使用Array.isArray(arr)；

判断null请使用myVar === null；

判断某个全局变量是否存在用typeof window.myVar === 'undefined'；

函数内部判断某个变量是否存在用typeof myVar === 'undefined'。



#### Date

在JavaScript中，Date对象用来表示日期和时间。

你可能观察到了一个非常非常坑爹的地方，就是JavaScript的月份范围用整数表示是0~11，0表示一月，1表示二月……，所以要表示6月，我们传入的是5！



#### 面向对象编程

类和实例是大多数面向对象编程语言的基本概念。

JavaScript不区分类和实例的概念，而是通过原型（prototype）来实现面向对象编程。

var Student = {

​    name: 'Robot',

​    height: 1.2,

​    run: function () {

​        console.log(this.name + ' is running...');

​    }

};

var xiaoming = {

​    name: '小明'

};

xiaoming.__proto__ = Student;

JavaScript的原型链和Java的Class区别就在，它没有Class的概念，所有对象都是实例，所谓继承关系不过是把一个对象的原型指向另一个对象而已。

Object.create()方法可以传入一个原型对象，并创建一个基于该原型的新对象，但是新对象什么属性都没有

// 原型对象:

var Student = {

​    name: 'Robot',

​    height: 1.2,

​    run: function () {

​        console.log(this.name + ' is running...');

​    }

};



function createStudent(name) {

​    // 基于Student原型创建一个新对象:

​    var s = Object.create(Student);

​    // 初始化新对象:

​    s.name = name;

​    return s;

}

var xiaoming = createStudent('小明');

xiaoming.run(); // 小明 is running...

xiaoming.__proto__ === Student; // true



#### 创建对象

JavaScript对每个创建的对象都会设置一个原型，指向它的原型对象。

当我们用obj.xxx访问一个对象的属性时，JavaScript引擎先在当前对象上查找该属性，如果没有找到，就到其原型对象上找，如果还没有找到，就一直上溯到Object.prototype对象，最后，如果还没有找到，就只能返回undefined。

function Student(name) {

​    this.name = name;

​    this.hello = function () {

​        alert('Hello, ' + this.name + '!');

​    }

}

注意，如果不写new，这就是一个普通函数，它返回undefined。但是，如果写了new，它就变成了一个构造函数，它绑定的this指向新创建的对象，并默认返回this，也就是说，不需要在最后写return this;。

调用构造函数千万不要忘记写new。为了区分普通函数和构造函数，按照约定，构造函数首字母应当大写，而普通函数首字母应当小写

function Student(props) {

​    this.name = props.name || '匿名'; // 默认值为'匿名'

​    this.grade = props.grade || 1; // 默认值为1

}

Student.prototype.hello = function () {

​    alert('Hello, ' + this.name + '!');

};

function createStudent(props) {

​    return new Student(props || {})

}



#### 原型继承

继承的本质是扩展一个已有的Class，并生成新的Subclass。

function inherits(Child, Parent) {

​    var F = function () {};

​    F.prototype = Parent.prototype;

​    Child.prototype = new F();

​    Child.prototype.constructor = Child;

}

// 实现原型继承链:

inherits(PrimaryStudent, Student);

JavaScript的原型继承实现方式就是：定义新的构造函数，并在内部用call()调用希望继承的构造函数，并绑定this；借助中间函数F实现原型链继承，最好通过封装的inherits函数完成；继续在新的构造函数的原型上定义新方法。



#### 浏览器对象

window

window对象不但充当全局作用域，而且表示浏览器窗口。

window对象有innerWidth和innerHeight属性，可以获取浏览器窗口的内部宽度和高度。内部宽高是指除去菜单栏、工具栏、边框等占位元素后，用于显示网页的净宽高。



navigator对象表示浏览器的信息，最常用的属性包括：

navigator.appName：浏览器名称；

navigator.appVersion：浏览器版本；

navigator.language：浏览器设置的语言；

navigator.platform：操作系统类型；

navigator.userAgent：浏览器设定的User-Agent字符串。



用document对象提供的getElementById()和getElementsByTagName()可以按ID获得一个DOM节点和按Tag名称获得一组DOM节点：

document对象还有一个cookie属性，可以获取当前页面的Cookie。



任何情况，你都不应该使用history这个对象了。



#### 操作文件

HTML5的File API提供了File和FileReader两个主要对象，可以获得文件信息并读取文件。



#### AJAX

Asynchronous JavaScript and XML，意思就是用JavaScript执行异步网络请求。



如果浏览器支持HTML5，那么就可以一劳永逸地使用新的跨域策略：CORS了。

CORS全称Cross-Origin Resource Sharing，是HTML5规范定义的如何跨域访问资源。



#### Canvas

Canvas是HTML5新增的组件，它就像一块幕布，可以用JavaScript在上面绘制各种图表、动画等。

在使用Canvas前，用canvas.getContext来测试浏览器是否支持Canvas：

var canvas = document.getElementById('test-canvas');

if (canvas.getContext) {

​    alert('你的浏览器支持Canvas!');

} else {

​    alert('你的浏览器不支持Canvas!');

}

getContext('2d')方法让我们拿到一个CanvasRenderingContext2D对象，所有的绘图操作都需要通过这个对象完成。

var ctx = canvas.getContext('2d');

如果需要绘制3D怎么办？HTML5还有一个WebGL规范，允许在Canvas中绘制3D图形：

gl = canvas.getContext("webgl");



#### 使用jQuery

$是著名的jQuery符号。实际上，jQuery把所有功能全部封装在一个全局变量jQuery中，而$也是一个合法的变量名，它是变量jQuery的别名：

window.jQuery; // jQuery(selector, context)

window.$; // jQuery(selector, context)

$ === jQuery; // true

typeof($); // 'function



$; // jQuery(selector, context)

jQuery.noConflict();

$; // undefined

jQuery; // jQuery(selector, context)



#### 事件

由于不同的浏览器绑定事件的代码都不太一样，所以用jQuery来写代码，就屏蔽了不同浏览器的差异，我们总是编写相同的代码。

click: 鼠标单击时触发； dblclick：鼠标双击时触发； mouseenter：鼠标进入时触发； mouseleave：鼠标移出时触发； mousemove：鼠标在DOM内部移动时触发； 



#### 键盘事件

键盘事件仅作用在当前焦点的DOM上，

keydown：键盘按下时触发； keyup：键盘松开时触发； keypress：按一次键后触发。

focus：当DOM获得焦点时触发； blur：当DOM失去焦点时触发；

change：内容改变时触发；

其中，ready仅作用于document对象。由于ready事件在DOM完成初始化后触发，且只触发一次，所以非常适合用来写其他的初始化代码。

$(document).ready(function () {

​    // on('submit', function)也可以简化:

​    $('#testForm).submit(function () {

​        alert('submit!');

​    });

});

甚至还可以再简化为：

$(function () {

​    // init...

});

上面的这种写法最为常见。如果你遇到$(function () {...})的形式，牢记这是document对象的ready事件处理函数。

有些事件，如mousemove和keypress，我们需要获取鼠标位置和按键的值，否则监听这些事件就没什么意义了。所有事件都会传入Event对象作为参数，

$(function () {

​    $('#testMouseMoveDiv').mousemove(function (e) {

​        $('#testMouseMoveSpan').text('pageX = ' + e.pageX + ', pageY = ' + e.pageY);

​    });

});

取消绑定: 一个已被绑定的事件可以解除绑定，通过off('click', function)实现：



事件触发条件

一个需要注意的问题是，事件的触发总是由用户操作引发的。

var input = $('#test-input');

input.change(function () {

​    console.log('changed...');

});



#### 动画

show / hide

直接以无参数形式调用show()和hide()，会显示和隐藏DOM元素。但是，只要传递一个时间参数进去，就变成了动画



slideUp / slideDown

你可能已经看出来了，show()和hide()是从左上角逐渐展开或收缩的，而slideUp()和slideDown()则是在垂直方向逐渐展开或收缩的。

slideUp()把一个可见的DOM元素收起来，效果跟拉上窗帘似的，slideDown()相反，而slideToggle()则根据元素是否可见来决定下一步动作：

var div = $('#test-slide');

div.slideUp(3000); // 在3秒钟内逐渐向上消失



fadeIn()和fadeOut()的动画效果是淡入淡出，也就是通过不断设置DOM元素的opacity属性来实现，



此外，jQuery也没有实现对background-color的动画效果，用animate()设置background-color也没有效果。这种情况下可以使用CSS3的transition实现动画效果。



#### 扩展

编写jQuery插件

给jQuery对象绑定一个新方法是通过扩展$.fn对象实现的。让我们来编写第一个扩展——highlight1()：

$.fn.highlight1 = function () {

​    // this已绑定为当前jQuery对象:

​    this.css('backgroundColor', '#fffceb').css('color', '#d85030');

​    return this;

}

jQuery在加载时，会把自身绑定到唯一的全局变量$上，underscore与其类似，会把自身绑定到唯一的全局变量_上，这也是为啥它的名字叫underscore的原因。



Collections

underscore为集合类对象提供了一致的接口。集合类是指Array和Object，



Arrays

range()让你快速生成一个序列，不再需要用for循环实现了：



// 从0开始小于30，步长5:

_.range(0, 30, 5); // [0, 5, 10, 15, 20, 25]

Objects



allKeys()除了object自身的key，还包含从原型链继承下来的：

和keys()类似，values()返回object自身但不包含原型链继承的所有值：

mapObject()就是针对object的map版本：

underscore提供了把对象包装成能进行链式调用的方法，就是chain()函数：



#### 安装Node.js和npm

npm其实是Node.js的包管理工具（package manager）。

为了编写可维护的代码，我们把很多函数分组，分别放到不同的文件里，这样，每个文件包含的代码就相对较少，很多编程语言都采用这种组织代码的方式。在Node环境中，一个.js文件就称之为一个模块（module）。

一个模块想要对外暴露变量（函数也是变量），可以用module.exports = variable;，一个模块要引用其他模块暴露的变量，用var ref = require('module_name');就拿到了引用模块的变量。

要在模块中对外输出变量，用：

module.exports = variable;

输出的变量可以是任意对象、函数、数组等等。



要引入其他模块输出的对象，用：

var foo = require('other_module');

引入的对象具体是什么，取决于引入模块输出的对象。



#### 基本模块

在Node.js环境中，也有唯一的全局对象，但不叫window，而叫global，这个对象的属性和方法也和浏览器环境的window不同。

process也是Node.js提供的一个对象，它代表当前Node.js进程。

Node.js内置的fs模块就是文件系统模块，负责读写文件。

和所有其它JavaScript模块不同的是，fs模块同时提供了异步和同步的方法。



#### 异步读文件

var fs = require('fs');

fs.readFile('sample.txt', 'utf-8', function (err, data) {

​    if (err) {

​        console.log(err);

​    } else {

​        console.log(data);

​    }

});

请注意，sample.txt文件必须在当前目录下，且文件编码为utf-8

如果我们要获取文件大小，创建时间等信息，可以使用fs.stat()，它返回一个Stat对象，能告诉我们文件或目录的详细信息：

由于Node环境执行的JavaScript代码是服务器端代码，所以，绝大部分需要在服务器运行期反复执行业务逻辑的代码，必须使用异步代码



stream是Node.js提供的又一个仅在服务区端可用的模块，目的是支持流这种数据结构。



什么是流？流是一种抽象的数据结构。

这个流是从键盘输入到应用程序，实际上它还对应着一个名字：标准输入流（stdin）。

就像可以把两个水管串成一个更长的水管一样，两个流也可以串起来。一个Readable流和一个Writable流串起来后，所有的数据自动从Readable流进入Writable流，这种操作叫pipe。

在Node.js中，Readable流有一个pipe()方法，就是用来干这件事的。