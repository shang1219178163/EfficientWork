# GCD的基本使用
    //获取自定义串行队列
    self.serialQueue = dispatch_queue_create("com.bin.customSerialQueue", DISPATCH_QUEUE_SERIAL);
    //获取自定义并发队列
    self.concurrentQueue = dispatch_queue_create("com.bin.customConcurrentQueue", DISPATCH_QUEUE_CONCURRENT);
    //获取主队列
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    //获取全局并发队列
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
## 多线程基本概念

对于操作系统来说，一个任务就是一个进程（Process），比如打开一个浏览器就是启动一个浏览器进程，打开一个记事本就启动了一个记事本进程，打开两个记事本就启动了两个记事本进程，打开一个Word就启动了一个Word进程。

有些进程还不止同时干一件事，比如Word，它可以同时进行打字、拼写检查、打印等事情。在一个进程内部，要同时干多件事，就需要同时运行多个“子任务”，我们把进程内的这些“子任务”称为线程（Thread）。

由于每个进程至少要干一件事，所以，一个进程至少有一个线程。当然，像Word这种复杂的进程可以有多个线程，多个线程可以同时执行，多线程的执行方式和多进程是一样的，也是由操作系统在多个线程之间快速切换，让每个线程都短暂地交替运行，看起来就像同时执行一样。当然，真正地同时执行多线程需要多核CPU才可能实现。

## GCD任务
任务就是你要在线程中执行的代码，在GCD中是用Block来定义任务的，是用起来非常灵活便捷。GCD中执行任务的方式有两种：同步执行(sync)与异步执行(async)。

串行和并发

#### 同步执行(sync)
同步执行就是指使用 dispatch_sync 方法将任务同步的添加到队列里，在添加的任务执行结束之前，当前线程会被阻塞，然后会一直等待，直到任务完成。
dispatch_sync添加的任务只能在当前线程执行，不具备开启新线程的能力。

#### 异步执行(async)
异步执行就是指使用 dispatch_async 方法将任务异步的添加到队列里，它不需要等待任务执行结束，不需要做任何等待就能继续执行任务。
dispatch_async 添加的任务可以在新的线程中执行任务，具备开启新线程的能力，但并不一定会开启新线程。

注意：并发队列的并发功能只有在异步（dispatch_async）函数下才有效;

## 六种组合方式
1. 同步执行+并发队列

        dispatch_sync(self.concurrentQueue, ^{
            // 追加任务
            ...
        });
        1).在当前线程中执行任务，不会开启新线程。
        2).它会阻塞当前线程，等待队列中的任务执行结束，才会继续执行下面的代码。
        
2. 同步执行+串行队列

        dispatch_sync(self.serialQueue, ^{
            // 追加任务
            ...
        });
        1).所有的任务都是在主线程（当前线程）中执行的，并且是顺序执行的，没有开启新的线程。
        2).它会阻塞当前线程，等待队列中的任务执行结束，才会继续执行下面的代码。

3. 异步执行+并发队列

        dispatch_async(self.concurrentQueue, ^{
            // 追加任务
            ...
        });
        1).异步执行具备开启新线程的能力，并且并发队列可以开启多个线程，交替执行多个任务。
        2).它并不会阻塞当前线程，并不需要等待追加的任务执行完成。
        
4. 异步执行+串行队列

        dispatch_async(self.serialQueue, ^{
            // 追加任务
            ...
        });
        1).任务在一个新的线程中执行的，在串行队列中异步执行任务，会开启一条新线程，由于队列是串行的，所以任务是按序执行的。
        2).它并不会阻塞当前线程，并不需要等待追加的任务执行完成。

5. 异步执行+主队列

        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        dispatch_async(mainQueue, ^{
            // 追加任务
            ...
        });
        1).在当前线程（主线程）中执行任务。
        2).按序执行任务，执行行完一个任务，再执行下一个任务。
        3).不会阻塞当前线程。

6. 同步执行+主队列

        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        dispatch_sync(mainQueue, ^{
            // 追加任务
            ...
        });
        会直接产生死锁：产生死锁的一个很重要的原因就是主队列是一个串行的队列(主队列中只有一条主线程)
        总结：使用同步方式(dispatch_sync)提交一个任务到一个串行队列时，如果提交这个任务的操作所处的线程，也是处于这个串行队列，就会引起死锁
        

|     总结        | 串行队列                | 并发队列                | 主队列              |
|-------------|---------------------|---------------------|------------------|
| 同步添加(sync)  | 不开辟新线程，在当前线程中串行执行任务 | 不开辟新线程，在当前线程中串行执行任务 | 死锁               |
| 异步添加(async) | 开辟新线程(1条)，串行执行任务    | 开辟新线程(1/n条)，并发执行任务  | 不开辟新线程，在主线程中顺序执行 |
        
## 线程间通信

    //异步添加任务到全局并发队列执行耗时操作
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        //执行耗时任务
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        }
        
        //回到主线程更新UI
        dispatch_sync(dispatch_get_main_queue(), ^{
            //Do something here to update UI
            
        });
    });








