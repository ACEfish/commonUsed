1. Object-C有多继承吗？没有的话用什么代替？	答案：cocoa 中所有的类都是NSObject 的子类，多继承在这里是用protocol 委托代理 来实现的。你不用去考虑繁琐的多继承 ,虚基类的概念.。ood的多态特性 在 obj-c 中通过委托来实现.2. Object-C有私有方法吗？私有变量呢？	答案：objective-c – 类里面的方法只有两种, 静态方法和实例方法. 这似乎就不是完整的面向对象了,按照OO的原则就是一个对象只暴露有用的东西. 如果没有了私有方法的话, 对于一些小范围的代码重用就不那么顺手了. 在类里面声名一个私有方法
	
	````	@interface Controller : NSObject { NSString *something; }	+ (void)thisIsAStaticMethod;	– (void)thisIsAnInstanceMethod;	@end	@interface Controller (private) -	(void)thisIsAPrivateMethod;	@end
	````@private可以用来修饰私有变量在Objective‐C中，所有实例变量默认都是私有的，所有实例方法默认都是公有的。
3.  \#import 和 \#include 的区别是什么？ #import<> 和 #import "" 的区别是什么？

	答案：他们都属于预处理指令。其功能都是包含头文件。但是#import避免了头文件重复包含问题。如果在使用#include的时候，需要加入头文件卫士的预处理指令。#ifndefine #define #endif.如果使用了#import就意味着不需要加入头文件卫士就可以实现不重复包含的功能。
	
	\#import<> 其功能是包含头文件的时候， 首先从系统目录开始查找。主要用法是用于包含系统框架的头文件。
	
	\#import"" 其功能是包含头文件的时候， 首先在工程的当前目录下开始查找， 如果找不到的话就从系统目录开始找， 其主要用法是用于包含自定义的头文件。
4. 对象是什么时候被release的？
	答案：引用计数为0时。
	autorelease实际上只是把对release的调用延迟了，对于每一个Autorelease，系统只是把该Object放入了当前的Autorelease pool中，当该pool被释放时，该pool中的所有Object会被调用Release。对于每一个Runloop， 系统会隐式创建一个Autorelease pool，这样所有的release pool会构成一个象CallStack一样的一个栈式结构，在每一个Runloop结束时，当前栈顶的Autorelease pool会被销毁，这样这个pool里的每个Object（就是autorelease的对象）会被release。那什么是一个Runloop呢？ 一个UI事件，Timer call， delegate call， 都会是一个新的Runloop。
5. obj-c的优缺点	答案：objc优点：

	  1)Cateogies    
	  2) Posing   
	  3) 动态识别  
	  4) 指标计算  
	  5）弹性讯息传递	  
	  6) 不是一个过度复杂的 C 衍生语言 	  
	  7) Objective-C 与 C++ 可混合编程 
	  
	  缺点:    
	  1) 不支援命名空間   
	  2) 不支持运算符重载	  
	  3) 不支持多重继承	  
	  4） 使用动态运行时类型，所有的方法都是函数调用，所以很多编译时优化方法都用不到。（如内联函数等），性能低劣。
	  
6. readwrite，readonly，assign，retain，copy，nonatomic 属性的作用？	答案：@property是 一个属性访问声明，扩号内支持以下几个属性：
	1⃣️getter=getterName，setter=setterName，设置setter与 getter的方法名
	2⃣️readwrite,readonly，设置可供访问级别
	3⃣️assign，setter方法直接赋值，不进行 任何retain操作，为了解决原类型与环循引用问题
	4⃣️retain，setter方法对参数进行release旧值再retain新值，所有 实现都是这个顺序(CC上有相关资料)
	5⃣️copy，setter方法进行Copy操作，与retain处理流程一样，先旧值release，再 Copy出新的对象，retainCount为1。这是为了减少对上下文的依赖而引入的机制。
	6⃣️nonatomic，非原子性访问，不加同步， 多线程并发访问会提高性能。注意，如果不加此属性，则默认是两个访问方法都为原子型事务访问。锁被加到所属对象实例级。
	
7. 什么是Notification？什么时候用delegate，什么时候用Notification？

	答案：观察者模式，controller向defaultNotificationCenter添加自己的notification，其他类注册这个notification就可以收到通知，这些类可以在收到通知时做自己的操作（多观察者默认随机顺序发通知给观察者们，而且每个观察者都要等当前的某个观察者的操作做完才能轮到他来操作，可以用NotificationQueue的方式安排观察者的反应顺序，也可以在添加观察者中设定反映时间，取消观察需要在viewDidUnload跟dealloc中都要注销）。
	
	delegate针对one-to-one关系，并且reciever可以返回值给sender，notification可以针对one-to-one/many/none,reciever无法返回值给sender.所以，delegate用于sender希望接受到reciever的某个功能反馈值，notification用于通知多个object某个事件。8. 类别的作用？继承和类别在实现中有何区别？
	答案：category 可以在不获悉，不改变原来代码的情况下往里面添加新的方法，只能添加，不能删除修改。
	并且如果类别和原来类中的方法产生名称冲突，则类别将覆盖原来的方法，因为类别具有更高的优先级。
	类别主要有3个作用：
	(1)将类的实现分散到多个不同文件或多个不同框架中。
	(2)创建对私有方法的前向引用。
	(3)向对象添加非正式协议。
	继承可以增加，修改或者删除方法，并且可以增加属性。9. 类别和类扩展的区别。
	答案：category和extensions的不同在于 后者可以添加属性。另外后者添加的方法是必须要实现的。extensions可以认为是一个私有的Category。10. 自动释放池是什么？如何工作？
	`答案：`自动释放池是NSAutorelease类的一个实例，当一个对象发送autorelease消息，该对象会自动入池，将会向池中发送一条release消息，释放对象。
11. OC的理解及特性

	`答案：`OC作为一门面向对象语言，自然具有面向对象的语言特性，如：封装、集成、多态。他具有静态语言的特性（如C++），又具有动态语言的效率（动态绑定、动态加载等）。整体来说是一门不错的编程语言。
	
	Objective-C具有相当多的动态特性，表现为三方面：动态类型、动态绑定、动态加载。之所以叫做动态，是因为必须到运行时才会做一些事情。
	
	1⃣️动态类型：及运行时再决定对象的类型。这类动态特性在日常应用中非常常见，简单说就是id类型。实际上静态类型因为其固定性和可预知性而使用的更加广泛。静态类型是强类型而动态类型属于弱类型。运行时决定接受者。
	
	2⃣️动态绑定：基于动态类型，在某个实例对象被确定后，其类型便被确定了。该对象对应的属性和响应的消息也完全被确定，这就是动态绑定。
	
	3⃣️动态加载：根据需求加载所需要的资源，这点很容易理解，对于iOS开发来说，基本就是根据不同的机型做适配。最经典的例子就是在Retina 设备上加载@2x的图片，而在老一些的普通屏设备上加载原图。随着Retina iPad的推出，和之后可能的Retina Mac的出现，这个特性相信会被越来越多的使用。（让程序在运行时添加代码模块以及其他资源。用户可以根据需要加载一些可执行代码和资源，而不是在启动时就加载所有组件，可执行代码中可以包含和程序运行时整合的新类）
	
	
12. OC的消息机制
	
	答案：在Objective-C中，message与方法的真正实现是执行阶段绑定的，而非编译阶段。编译器会将消息发送换成长城对objc_msgSend方法的调用。objc_msgSend方法含两个必要参数：receiver、方法名（即：selector）。如：[receiver message];将被转换为：objc_msgSend(receiver, selector);objc_msgSend方法也能hold住message的参数，如：objc_msgSend(receiver, selector, arg1, arg2, ...)；objc_msgSend方法会坐按照顺序进行以下操作，已完成动态绑定：查找selector所指代的程序（方法的真正实现）。因为不同类对同一方法有不同的实现，所以对方法的真正实现的查找依赖于receiver的类调用该实现，并将一系列参数传递过去将该实现的返回值作为自己的返回值，返回至消息传递的关键是，编译器构建每个类和对象时所采用的数据结构。每个类都包含以下两个必要元素：一个指向父类的指针、一个调度表。该调度表将类的selector与方法的实际内存地址关联起来。每个对象都有一个指向所属类的指针isa。通过该指针，对象可以找到它所属的类，也就找到了其全部父类。
	
13. id声明的对象有什么样的特性？

	答案：id 是一个指向OC对象的指针类型，称其为万能指针。通俗的理解：就是可以指任何OC的对象。当他指向任意对象的时候， 在运行时表现的具体的对象， 这一点说明他具在动态的特点。需要注意的是，在使用id类型的， 不要在id后加＊，因为其本身就是指针类型。
	
14. 手动管理内存的基本原则是什么？使用@property的时候如何避免内存泄漏？

	答案：如果使用了new copy alloc方法创建的对象， 其引用计数器为1.那么我们就需要负责释放这个对象release.
	如果使用retain这样的方法，让对象的引用计数器+1，我们就需要调用release方法释放这个对象。必须保证retain 和 release方法成对出现
	
	如果使用了@property，在手动管理内存的时候，如果在@property声明的时候， 用到retain和copy关键字。那么在初始化对象的时候， 不要使用点语法，直接使用成员变量名字。同时需要复写dealloc方法，在dealloc方法里，需要释放该成员变量。如果是ARC环境， 则需要在dealloc方法里， 将成员变量指向nil
	
15. iOS平台，出现nil ,Nil ,NULL, NSNull ,从字面意思上来看， 他们都表示空，但是他们真正的意思是什么？分别有什么区别？

	__DARWIN_NULL 将常量0,强制转换为void *,其意思是表示一个空的地址。表达含义这个指什么都没有指向。 
	
	```
	#define __DARWIN_NULL ((void *)0)
```
	
	NULL 本质上也是 ((void *)0) 其主要作用，Ｃ语言风格的指针，表示指向空的时候， 使用	NULL。
	
	```
	#ifndef NULL
	#define NULL    __DARWIN_NULL
```

 	Nil用于表示Objective-C类类型(Class) 的值为空的情况
 
	```
	#ifndef Nil
	# if __has_feature(cxx_nullptr)
	#   define Nil nullptr
	# else
	#   define Nil __DARWIN_NULL
	# endif
	#endif
```

	nil 用于表示Objective-C中对象指针表示空值的时候。
	
	```
	#ifndef nil
	# if __has_feature(cxx_nullptr)
	#   define nil nullptr
	# else
	#   define nil __DARWIN_NULL
	# endif
	#endif
	
	```

	NSNull 其本质是一个类类型，它表示语义为空对象。
	
	```
	
	@interface NSNull : NSObject <NSCopying, NSSecureCoding>

	+ (NSNull *)null;

	@end
	```

	** 总结一下：不管是NULL, nil ,还是Nil 它们的本质都是((void*)0),指向一个表示空的地址也就是平时空指针。这样做的意义是，可以根据赋的初始值， 来确定对象的数据类型， 如果是NULL,表示C风格的指针类型， 如果Nil表示Objective-C类类型， 如果是nil.表示Objective-C中对象.NSNull 本身表示类类型的空对象。** 

16. 深拷贝和浅拷贝有什么区别？

	答案：浅拷贝其本质， 仅仅将对象指针复制了一份， 也就是内存还是原来的内存。深拷贝：重新向系统申请了内存，并把原来的数据全部按照深拷贝的方式复制了一份，浅拷贝在手动管理内存的模式下， 相当于引用计数器加	了。他们的主区别就在于深拷贝重新分配了内存， 深拷贝是我们一般情况下理解的复制.
	
17. 在ARC环境下， dealloc方法的主要作用是什么？我在dealloc方法里做什么事情？

	答案：主要作用是：当前对象销毁的时候， 要在dealloc方法销毁此对象依赖的其它对象， 由于ARC环境里，不能调用realeas和dealloc方法，所以根据ARC的特点， 在dealloc方法里，主要是将当前对象依赖其它对象指针设置为nil就可以了。 

