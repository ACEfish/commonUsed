1. 线程与进程的区别和联系?

	答案: 进程和线程都是由操作系统所体会的程序运行的基本 单元，系统利用该基本单元实现系统对应用的并发性。
	
	进程和线程的主要差别在于它们是不同的操作系统资源 管理方式。进程有独立的地址空间，一个进程崩溃后，在保护模式下不会对其它进程产生影响，而线程只是一个进程中的不同执行路径。线程有自己的堆栈和局部变 量，但线程之间没有单独的地址空间，一个线程死掉就等于整个进程死掉，所以多进程的程序要比多线程的程序健壮，但在进程切换时，耗费资源较大，效率要差一 些。但对于一些要求同时进行并且又要共享某些变量的并发操作，只能用线程，不能用进程。
	
2. ios平台怎么做数据的持久化?coredata和sqlite有无必然联系？coredata是一个关系型数据库吗？

	答案：iOS中可以有四种持久化数据的方式： 属性列表、对象归档、SQLite3和Core Data；core data可以使你以图形界面的方式快速的定义app的数据模型，同时在你的代码中容易获取到它。
	
	core data提供了基础结构去处理常用的功能，例如保存，恢复，撤销和重做，允许你在app中继续创建新的任务。在使用core data的时候，你不用安装额外的数据库系统，因为core data使用内置的sqlite数据库。core data将你app的模型层放入到一组定义在内存中的数据对象。core data会追踪这些对象的改变，同时可以根据需要做相反的改变，例如用户执行撤销命令。当core data在对你app数据的改变进行保存的时候，core data会把这些数据归档，并永久性保存。
	
	mac os x中sqlite库，它是一个轻量级功能强大的关系数据引擎，也很容易嵌入到应用程序。可以在多个平台使用，sqlite是一个轻量级的嵌入式sql数据库编程。与core data框架不同的是，sqlite是使用程序式的，sql的主要的API来直接操作数据表。Core Data不是一个关系型数据库，也不是关系型数据库管理系统(RDBMS)。虽然Core Dta支持SQLite作为一种存储类型，但它不能使用任意的SQLite数据库。Core Data在使用的过程种自己创建这个数据库。Core Data支持对一、对多的关系。
3. 定时器和线程的区别
	答案：定时器：可以执行多次，默认在主线程。
	线程：只能执行一次。
4. HTTP协议的特点，关于Http请求get和post的区别？
	答案：HTTP是超文本传输协议(HyperText Transfer Protocol -- HTTP)是一个设计来使客户端和服务器顺利进行通讯的协议。
HTTP在客户端和服务器之间以request-response protocol（请求-回复协议）工作。
 
	GET - 从指定的服务器中获取数据
	POST - 提交数据给指定的服务器处理
 
	GET方法：
	使用GET方法时，查询字符串（键值对）被附加在URL地址后面一起发送到服务器：

	/test/demo_form.jsp?name1=value1&name2=value2
	
	特点：
	
	GET请求能够被缓存
	
	GET请求会保存在浏览器的浏览记录中
	
	以GET请求的URL能够保存为浏览器书签
	
	GET请求有长度限制
	
	GET请求主要用以获取数据

	POST方法：
	
	使用POST方法时，查询字符串在POST信息中单独存在，和HTTP请求一起发送到服务器：
	
	POST /test/demo_form.jsp HTTP/1.1
	
	Host: w3schools.com

	name1=value1&name2=value2

	特点：
	
	POST请求不能被缓存下来
	
	POST请求不会保存在浏览器浏览记录中
	
	以POST请求的URL无法保存为浏览器书签

	POST请求没有长度限制

	GET和POST的区别：
 	
 	```
 	
 	区别项				GET				POST
点击返回/刷新按钮	  没有影响	数据会重新发送（浏览器将会提示用户“数据被从新提交”）
添加书签				可以			不可以
缓存					可以			不可以
编码类型(Encoding type)	application/x-www-form-urlencoded;		application/x-www-form-urlencoded or multipart/form-data. 请为二进制数据使用multipart编码
历史记录				有				没有
长度限制				有				没有
数据类型限制	只允许ASCII字符类型;		没有限制，允许二进制数据
安全性		查询字符串会显示在地址栏的URL中，不安全，请不要使用GET请求提交敏感数据;		因为数据不会显示在地址栏中，也不会缓存下来或保存在浏览记录中，所以看POST求情比GET请求安全，但也不是最安全的方式。如需要传送敏感数据，请使用加密方式传输。
可见性		查询字符串显示在地址栏的URL中，可见;	查询字符串不会显示在地址栏中，不可见
	```
其他HTTP请求方式

	```
方式				描述
HEAD	与GET请求类似，不同在与服务器只返回HTTP头部信息，没有页面内容
PUT			上传指定URL的描述
DELETE		删除指定资源
OPTIONS		返回服务器支持的HTTP方法
CONNECT		转换为透明TCP/IP隧道的连接请求
	```
	
5. NSUserDefaults的理解

	答案：NSUserDefaults类提供了一个与默认系统进行交互的编程接口。NSUserDefaults对象是用来保存，恢复应用程序相关的偏好设置，配置数据等等。默认系统允许应用程序自定义它的行为去迎合用户的喜好。你可以在程序运行的时候从用户默认的数据库中读取程序的设置。同时NSUserDefaults的缓存避免了在每次读取数据时候都打开用户默认数据库的操作。可以通过调用synchronize方法来使内存中的缓存与用户默认系统进行同步。
	
	NSUserDefaults类提供了非常方便的方法来获取常用的类型，例如floats,doubles,intergers,Booleans,URLs。所以一个NSUserDefaults的对象必须是属性表，这也就是说我们可以存储NSData,NSString,NSNUmber,NSDate,NSArray,NSDictionary这些实例。如果你想存储其他类型的对象，你要将其归档并创建一个NSData来实现存储。
从NSUserDefaults返回的值是不可改变的，即便是你在存储的时候使用的是可变的值。例如你使用mutable string做为“MyStringDefault”的值，当你做使用stringForKey:方法获取的值，这个值仍然是不可变的。
NSUserDefaults是单例，同时也是线程安全的

6. SDWebImage的原理

	答案：调用类的方法：1.从内存（字典）中找图片（当这个图片在本次使用程序的过程中已经被加载过），找到直接使用。2.从沙盒中找（当图片在之前使用程序的过程中被加载过），找到使用，缓存到内存中。3.从网上获取，使用，缓存到内存，缓存到沙盒。
	
7. TCP的三次握手

	答案：

	第一次握手：建立连接时，客户端发送syn包（syn=j）到服务器，并进入SYN_SENT状态，等待服务器确认；SYN：同步序列编号（Synchronize Sequence Numbers）。

	第二次握手：服务器收到syn包，必须确认客户的SYN（ack=j+1），同时自己也发送一个SYN包（syn=k），即SYN+ACK包，此时服务器进入SYN_RECV状态；

	第三次握手：客户端收到服务器的SYN+ACK包，向服务器发送确认包ACK(ack=k+1），此包发送完毕，客户端和服务器进入ESTABLISHED（TCP连接成功）状态，完成三次握手。
	
8. 如何进行真机调试？

	答案：1.首先需要用“钥匙串”创建一个钥匙（key）.
	     2.将钥匙串上传到官网，获取iOS Develpment 证书。
	     3.创建app ID也就是我们应用程序中的Boundle ID。
	     4.添加Device ID 也就是UDID。
	     5.通过勾选前面所创建的证书：app ID 、Device ID.
	     6.生成mobileprovision文件。
	     7.先决条件--》你需要一个账号 99$
	     
	
9. App发布上线流程

	答案：1.通过http://ituesconnect.apple.com添加应用信息。
	     2.下载安装发布证书。
	     3.选择发布证书，使用Archive编译发布包。用Xcode将代码（发布包）上传到服务器。
	     4.等待审核通过。
	
10. 如何生成IPA

	答案：菜单栏Product->Arichive
	
11. 如何进行网络推送

	答案：--  一种是Apple自己提供的通知服务（APNS服务器）、一种是用第三方推送机制。
	
	--  首先应用发送通知;系统弹出提示框询问用户是否允许，当用户允许后向苹果服务器（APNS）请求device Token,并由苹果服务器哦发送给自己的应用；自己的应用将Device Token发送给自己的服务器；自己的服务器想要发送网络推送时将device Token以及想要推送的信息发送给苹果服务器，苹果服务器将信发送给应用。
	
	--  推送信息内容->总容量不超过256个字节。
	
	--  iOS SDK本身提供的APNS服务器推送，它可以直接推送给目标用户并根据您的方式弹出提示。优点：不论应用死否开启，都会发送到手机端。缺点：消息推送的机制是苹果服务端控制，个别时候可能会有延迟，因为苹果服务器也会有队列来处理所有的消息请求。
    
    --  第三方推送机制，普遍使用Socket机制来实现的，它几乎可以达到即时的发送到目标用户端，适用于即时通信类应用。优点：它几乎是实时的，主要取决于它心跳包的节奏。缺点：因为iOS系统的限制，应用不能长时间的后台的运行，所以在应用关闭的情况下这种推送机制不可用。

12. ASIHttpRequest、AFNetWorking之间的区别

	答案：-- ASIHttpRequest功能很强大，主要是在MRC下实现的，是对系统CFNetwork API进行了封装，支持HTTP协议的CFHTTP。配置比较复杂，并且ASI框架默认不会帮你监听网络改变，如果需要让ASI帮你监听网络状态改变，需要动手开始这个功能。
	     
	   --  AFNetworking构建于NSURLConnection,NSOperation,以及其他熟悉的Foundation技术之上。拥有良好的架构，丰富的API,以及模块化构建方式，所以使用起来非常轻松。它基于NSOperation封装的，AFURLConnnectionOperation的子类。
	    
	   --  更新状态：ASIHttp2012年10月份，已经停止更新；AFNetworking持续更新中，目前已更新至2.3.1版。
	   
	   --  介绍：ASI直接操作对象ASIHttpRequest，是一个实现了NSCoping协议的NSOperation子类：ASIHttpRequest直接操作对象的AFHttpClient,是一个实现了NSCoding和NSCoping协议的NSObject子类。
	  
	   -- 同步请求：ASI是直接通过调用一个starSynchronous方法，ASIHttpRequest默认没有封装同步请求，如果开发者需要使用同步请求，则需要重写getPath:paramenters:success:failures方法，对AFHttpRequestOperation进行同步处理。
	  
	   -- 性能对比：AFNetworking请求优先于ASIHttpRequest
	
	
13. 对沙盒的理解

	答案：-- 1、每个iOS应用都被限制在“沙盒”中，“沙盒”相当于一个加了仅主人可见权限的文件夹，就是应用程序在安装过程中，系统为每个单独的应用程序生成它的主目录和一些关键的子目录->文件夹，苹果对沙盒有以下几条限制。
	
	--（1）应用程序可以在自己的沙盒里运作，但是不能访问任何其他的应用程序的沙盒。
	
	--（2）应用程序间不能共享数据，沙盒里地文件不能被复制到其他应用程序文件夹中，也不能把其他应用文件夹中的文件复制到沙盒里。
	
	--（3）苹果禁止任何读、写沙盒以外的文件，禁止应用程序将内容写到沙盒以外的文件夹中。
	
	--（4）沙盒根目录里有三个文件夹：
	Documents,一般应该把应用程序的数据文件存到这个文件夹里，用于存储用户数据或其他应该定期备份的信息。
	
	Library,下有两个文件夹，Caches存储应用程序再次启动所需的信息，Preferences包含应用程序偏好设置文件，不过不要在这里修改偏好设置。
	
	temp，存放临时文件，即应用程序再次启动不需要的文件。
	
	2.获取沙盒路径
	
	（1）获取沙盒根目录的方法，有以下几种：用NSHomeDirectory获取。
	
	（2）获取Document路径 NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES)。
	
	
14. NSThread,NSOperation,GCD

	答案：NSThread,NSOperation,GCD是iOS中使用多线程的三种方式之一。他们各有优点。抽象层次从低到高，抽象度越高的使用越简单。
	
	NSThread，缺点：需要自己维护线程的生命周期和线程的同步和互斥，但是这些都需要耗费系统的资源。优点：比其他两个更轻。
	
	NSOperation，优点：不需要自己管理线程的生命周期和线程的同步和互斥等。只是需要关注自己的业务逻辑处理，需要和NSOperationQueue一起使用。
	
	GCD，是Apple开发的一个多核编程解决方法，优点：比前面两者更高效更强大。
	
15. xib、storyboard、手动写代码

	答案：xib（interface buider），方便对界面进行编辑。可以在窗口上面直接添加各种视图，优点：直接看到界面的效果，操作简单。缺点：不方便对试图进行动态控制，不灵活。
	
	手动编写代码，继承（主要是UIView，UIViewController），优点：可以对试图进行定制，灵活控制方便。缺点：不能马上看到效果，复杂。
	
	storyboard（故事板在iOS6加入）。优点：可以看到界面效果，能同时进行多个界面的交互，高效快速。缺点：不能进行界面的定制，确有灵活性。
	
	xib和storyboard主要用于界面中的元素位置固定和清楚里边有哪些元素。但是如果需要动态变化界面还是手动编写代码比较好，一般还是各种方式混合使用。
	
16. NSRunLoop 和 NSOperationQueue
 
	答案：NSRunLoop是所有要监视的输入源和定时源以及要通知的注册观察者的集合，用来处理诸如鼠标，键盘事件等的输入源。每一个线程拥有自己的RunLoop有系统自动创建。你不应该自己去创建，只能获取。一般不会用NSRunLoop，因为它不是线程安全的。一般都用CFRunLoop，这个是线程安全的，是一种消息处理模式，我们一般不用进行处理。
	NSOperationQueue时一个管理NSOperation的队列。我们会把NSOperation放入queue进行管理。
	
17. opengl和quatarz 2d

	答案：上面2种方式是进行图形绘制使用到的技术。
	quatarz 2d 是Apple提供的基于Core graphic的绘制基本图形工具库。操作简单方便，能够满足大部分需要。只是适用于2D图形的绘制。
	opengl，是一个跨平台的图形开发库。适用于2D和3D图形的绘制。功能强大但是复杂。	
	
18. iOS应用的调试技巧

	答案：
	
	1.如遇到crash，分析崩溃（symbolicatedrash工具的适用）保留崩溃版本的.dSYM文件。
	
	2.在 XCode 中进入断点管理窗口；然后点击右下方的+，增加新的 Exception Breakpoint。
	
	3.如遇到EXC_BAD_ACCESS，打开Scheme选项选择EditScheme。然后按图勾上Enable Zombie Objects和Malloc Stack那两项。
	
	4.有效的日志管理，NSLog和加入一些开源的日志管理框架。
	
	5.程序断点debug模式。
	
19. 请解释一下Handoff是什么，并简述它是如何实现iOS、Mac/网页应用互通的。
20. iCloud包含了哪些技术与服务？
21. iOS扩展是指？能否列举一些热门或常见的范例？
22. HealthKit是什么？
23. HomeKit是什么？
24. Apple Pay是什么？能否描述一下如何在应用中使用Apple Pay？
25. 请解释一下iOS应用沙盒机制。
26. VoiceOver是什么？请举例解释一下iOS中的辅助功能（Accessibility）。开发者如何使用这些功能？
27. iOS应用是如何实现后台多任务处理（Multitasking）的？
28. Game Center针对iOS游戏有哪些功能？
29. iBeacons是什么？
30. Cocoa/Cocoa Touch是什么？
31. 请概括一下Core Audio，Core Data以及Core Location各是什么。它们对iOS应用有何意义？
32. 请描述SpriteKit和SceneKit的作用。
33. Metal是什么？
34. 响应链（Responder Chain）是什么？它是如何发挥作用的？
35. 按钮和其他控制方式对哪些操作做出回应？
36. AppDelegate扮演着什么样的角色？
37. 请解释一下NSUserDefaults。就你而言，你会如何在磁盘中对数组对象进行序列化？
38. 你会如何储存用户的认证信息？
39. 请问何为Keychain服务？
40. 为什么移动设备上的缓存和压缩是不可或缺的？
41. 请解释一下~/Documents，~/Library和~/tmp。 iOS中的~属于什么目录？
42. AirPlay是如何运行的？换做是你，你会如何通过编程提高应用的实用性以及演示效果？
43. 传感器，IO以及WiFi、拨号等连接方式如何在iOS平台上运作？它们有何利用价值？请扼要地谈谈你的观点。
44. iPad 2，iPad mini 1-3，iPad Retina，iPad Air 2，iPhone 5、5S、6以及6+在硬件性能方面有何差异？这对注重性能的应用有何限制？
	
45. scoket连接和Http连接的区别
46. XML数据的解析方式，各有什么不同，JSON解析有哪些框架？
47. 添加手势的方式
48. 应用程序的生命周期和状态
49. 关于RunLoop

	答案：下面罗列调用主线程的run loop的各种方式，读者可以加深理解：
	
	```
	
	[[NSRunLoop mainRunLoop] run]; //主线程永远等待，但让出主线程时间片
	
	[[NSRunLoop mainRunLoop] runUntilDate:[NSDate distantFuture]]; //等同上面调用

	[[NSRunLoop mainRunLoop] runUntilDate:[NSDate date]]; //立即返回

	[[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:10.0]]; //主线程等待，但让出主线程时间片，然后过10秒后返回

	[[NSRunLoop mainRunLoop] runMode:NSDefaultRunLoopMode beforeDate: [NSDate distantFuture]]; //主线程等待，但让出主线程时间片；有事件到达就返回，比如点击UI等。

	[[NSRunLoop mainRunLoop] runMode:NSDefaultRunLoopMode beforeDate: [NSDate date]]; //立即返回

	[[NSRunLoop mainRunLoop] runMode:NSDefaultRunLoopMode beforeDate: [NSDate dateWithTimeIntervalSinceNow:10.0]]; //主线程等待，但让出主线程时间片；有事件到达就返回，如果没有则过10秒返回。```

50. NSNotification、block、delegate和KVO的区别

	答案：代理是一种回调机制，且是一对一的关系，而通知是一对多的关系，一个中对象向所有的观察者提供变更通知（KVO是被观察者向观察者直接发送通知，这是通知和KVO的区别）
	
	效率肯定是delegate比 NSNotification高。
	
	delegate和block一般是用于对象1对1的通信交互。
	
	delegate：delegate需要定义协议方法，代理对象实现协议方法，并且需要建立代理关系才能实现通信。
	
	block：block更加简洁，不需要定义繁琐的协议方法，但是如果通信时间比较多的话，建议用delegate。
	
	通知（NSNotification）：通知主要用于一对多情况下通信，通信对象之间不需要建立关系！
	
	和delegate一样，KVO和NSNotification的作用也是类与类之间的通信，与delegate不同的是：1.这两个都是负责发出通知，剩下的事情就不管了，所以没有返回值：2，代理是一种回调机制，且是一对一的关系，而且通知是一对多的关系，一个中心对象向所有的观察者提供变更通知。KVO是被观察者向观察者直接发送通知，这是通知和KVO的区别。

51. 多线程编程

	答案：1.NSThread:当需要进行一些时间的操作时，会把耗时间的操作放到分线程中。线程同步：多个线程同时访问一个数据会出问题。（1）NSLock （2）线程同步块@synchronized（self）{}
	
	2.NSOperationQueue操作队列（不需要考虑线程同步的问题）。编码的重点都放在main里边。1.NSInvocationOperation􏰚BSBlockOperation。2.自定义Operation。
	
	创建一个操作，绑定相应地方法，当把操作添加到操作队列中时，操作绑定的方法就会自动执行了。当把操作添加到操作队列中时，默认会调用main方法。
	
	3.GCD(Grand Central Dispatch )宏大的中央调度。（1).串行队列 （2）并发队列（3）主线程队列。
	
	同步和异步：同步和异步是相对于另外一个任务而言的，同步指的是第一个任务不执行完，不会开始第二个，异步是不管第一个有没有执行完，都会开始第二个。
	
	串行和并发：串行和并发是相对于多个任务而言的，串行指的是多个任务按照一定的顺序执行，并发指的是多个任务同时进行。
	
	代码是在分先程中执行;在主线程队列中刷新UI.	
