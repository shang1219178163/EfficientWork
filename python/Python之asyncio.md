## Python asyncio 完全总结

`asyncio` 是 Python 的异步 I/O 框架，用于编写并发代码。以下是全面系统的总结：

### 1. 核心概念

| 概念 | 说明 | 创建方式 |
|------|------|----------|
| **协程** | 异步函数 | `async def` |
| **任务** | 封装协程的对象 | `asyncio.create_task()` |
| **Future** | 异步操作的最终结果 | `asyncio.Future()` |
| **事件循环** | 管理和执行异步任务 | `asyncio.get_running_loop()` |

```python
import asyncio

# 协程
async def my_coroutine():
    return "result"

# 任务
async def main():
    task = asyncio.create_task(my_coroutine())
    
    # Future
    future = asyncio.Future()
    future.set_result("done")

asyncio.run(main())
```

### 2. 事件循环管理

| 方法 | 作用 | 适用场景 |
|------|------|----------|
| `asyncio.run()` | 运行协程（推荐） | Python 3.7+ |
| `asyncio.get_event_loop()` | 获取当前事件循环 | 旧代码 |
| `asyncio.new_event_loop()` | 创建新事件循环 | 多线程 |
| `asyncio.get_running_loop()` | 获取运行中的循环 | 协程内部 |

```python
import asyncio

# 方式1：简单运行
asyncio.run(my_coroutine())

# 方式2：手动控制循环
loop = asyncio.new_event_loop()
asyncio.set_event_loop(loop)
try:
    loop.run_until_complete(my_coroutine())
finally:
    loop.close()

# 方式3：获取当前循环
async def check_loop():
    loop = asyncio.get_running_loop()
    print(f"运行在: {loop}")
```

### 3. 并发执行方法

| 方法 | 特点 | 返回值 | 使用场景 |
|------|------|--------|----------|
| `asyncio.gather()` | 所有任务并发，等待全部完成 | 结果列表 | 同时执行多个任务 |
| `asyncio.wait()` | 灵活控制，可设置返回条件 | (done, pending) | 需要精细控制 |
| `asyncio.as_completed()` | 按完成顺序迭代 | 迭代器 | 逐个处理完成的任务 |
| `asyncio.create_task()` | 创建后台任务 | Task对象 | 需要在后台运行 |

```python
import asyncio

async def task(name, delay):
    await asyncio.sleep(delay)
    return f"{name}完成"

async def demo():
    # gather - 等待所有完成
    results = await asyncio.gather(
        task("A", 1),
        task("B", 2),
        task("C", 1.5)
    )
    print(results)  # ['A完成', 'B完成', 'C完成']
    
    # wait - 灵活控制
    tasks = [task("1", 1), task("2", 2)]
    done, pending = await asyncio.wait(
        tasks,
        return_when=asyncio.FIRST_COMPLETED
    )
    
    # as_completed - 按完成顺序
    tasks = [task("X", 3), task("Y", 1)]
    for coro in asyncio.as_completed(tasks):
        result = await coro
        print(f"完成: {result}")  # Y完成先打印
    
    # create_task - 后台任务
    background = asyncio.create_task(task("后台", 2))
    # 继续执行其他代码
    await background  # 等待后台任务

asyncio.run(demo())
```

### 4. 同步原语

| 原语 | 作用 | 适用场景 |
|------|------|----------|
| `Lock` | 互斥锁，保护共享资源 | 防止竞态条件 |
| `Event` | 事件通知 | 等待某个条件发生 |
| `Condition` | 条件变量 | 复杂的线程协调 |
| `Semaphore` | 信号量，限制并发数 | 控制资源访问数量 |
| `BoundedSemaphore` | 有界信号量 | 防止释放超过获取 |
| `Queue` | 异步队列 | 生产-消费者模式 |

```python
import asyncio

# Lock 示例
async def lock_demo():
    lock = asyncio.Lock()
    async with lock:
        # 临界区代码
        pass

# Event 示例
async def event_demo():
    event = asyncio.Event()
    
    async def waiter():
        await event.wait()
        print("收到通知")
    
    async def setter():
        await asyncio.sleep(1)
        event.set()
    
    await asyncio.gather(waiter(), setter())

# Semaphore 示例（限制最多3个并发）
async def semaphore_demo():
    sem = asyncio.Semaphore(3)
    
    async def limited():
        async with sem:
            await asyncio.sleep(1)
    
    await asyncio.gather(*[limited() for _ in range(10)])

# Queue 示例
async def queue_demo():
    queue = asyncio.Queue(maxsize=10)
    
    async def producer():
        for i in range(5):
            await queue.put(i)
            print(f"生产: {i}")
    
    async def consumer():
        while True:
            item = await queue.get()
            if item is None:
                break
            print(f"消费: {item}")
            queue.task_done()
    
    await asyncio.gather(producer(), consumer())

asyncio.run(semaphore_demo())
```

### 5. 超时与取消

| 方法 | 作用 | 异常 |
|------|------|------|
| `asyncio.wait_for()` | 设置超时 | `TimeoutError` |
| `asyncio.wait()` 的 timeout | 等待超时 | 无异常，返回未完成任务 |
| `task.cancel()` | 取消任务 | `CancelledError` |
| `asyncio.shield()` | 保护任务不被取消 | 取消时等待完成 |

```python
import asyncio

async def slow_task():
    await asyncio.sleep(5)
    return "完成"

async def timeout_demo():
    try:
        # 超时控制
        result = await asyncio.wait_for(slow_task(), timeout=2)
    except asyncio.TimeoutError:
        print("超时了")
    
    # 手动取消
    task = asyncio.create_task(slow_task())
    await asyncio.sleep(1)
    task.cancel()
    try:
        await task
    except asyncio.CancelledError:
        print("任务被取消")
    
    # 保护重要任务
    important = asyncio.create_task(slow_task())
    shielded = asyncio.shield(important)
    # 即使父协程被取消，important 仍在运行

asyncio.run(timeout_demo())
```

### 6. 异步上下文管理器

```python
import asyncio
from contextlib import asynccontextmanager

# 方式1：类实现
class AsyncResource:
    async def __aenter__(self):
        print("获取资源")
        await asyncio.sleep(0.5)
        return self
    
    async def __aexit__(self, exc_type, exc_val, exc_tb):
        print("释放资源")
        await asyncio.sleep(0.5)
    
    async def work(self):
        print("工作")

# 方式2：装饰器实现
@asynccontextmanager
async def managed_resource():
    print("获取资源")
    yield "resource"
    print("释放资源")

async def main():
    # 类方式
    async with AsyncResource() as resource:
        await resource.work()
    
    # 装饰器方式
    async with managed_resource() as res:
        print(f"使用 {res}")

asyncio.run(main())
```

### 7. 异步迭代器

```python
import asyncio

# 异步迭代器类
class AsyncCounter:
    def __init__(self, limit):
        self.limit = limit
        self.count = 0
    
    def __aiter__(self):
        return self
    
    async def __anext__(self):
        if self.count >= self.limit:
            raise StopAsyncIteration
        self.count += 1
        await asyncio.sleep(0.5)
        return self.count

# 异步生成器
async def async_generator(limit):
    for i in range(limit):
        await asyncio.sleep(0.5)
        yield i

async def main():
    # 使用异步迭代器
    async for num in AsyncCounter(5):
        print(f"计数: {num}")
    
    # 使用异步生成器
    async for value in async_generator(5):
        print(f"生成: {value}")

asyncio.run(main())
```

### 8. 子进程管理

```python
import asyncio

async def run_command():
    # 执行 shell 命令
    process = await asyncio.create_subprocess_shell(
        'ls -la',
        stdout=asyncio.subprocess.PIPE,
        stderr=asyncio.subprocess.PIPE
    )
    
    stdout, stderr = await process.communicate()
    print(f"输出: {stdout.decode()}")
    
    # 或者逐行读取
    process = await asyncio.create_subprocess_shell(
        'ping -c 3 google.com',
        stdout=asyncio.subprocess.PIPE
    )
    
    async for line in process.stdout:
        print(line.decode().strip())

asyncio.run(run_command())
```

### 9. 流（Streams）

```python
import asyncio

# TCP 客户端
async def tcp_client():
    reader, writer = await asyncio.open_connection('example.com', 80)
    
    writer.write(b'GET / HTTP/1.0\r\nHost: example.com\r\n\r\n')
    await writer.drain()
    
    data = await reader.read(1024)
    print(data.decode())
    
    writer.close()
    await writer.wait_closed()

# TCP 服务器
async def handle_client(reader, writer):
    data = await reader.read(1024)
    writer.write(b'HTTP/1.1 200 OK\r\n\r\nHello')
    await writer.drain()
    writer.close()

async def tcp_server():
    server = await asyncio.start_server(handle_client, '127.0.0.1', 8888)
    async with server:
        await server.serve_forever()

# asyncio.run(tcp_client())
```

### 10. 调试和监控

```python
import asyncio
import logging

# 启用调试模式
async def debug_mode():
    loop = asyncio.get_running_loop()
    loop.set_debug(True)  # 启用调试
    
    # 设置日志级别
    logging.basicConfig(level=logging.DEBUG)
    
    # 检测未 await 的协程
    async def bad():
        return "result"
    
    # 这会触发警告
    bad()  # 忘记 await

# 获取任务状态
async def monitor_tasks():
    # 获取所有任务
    tasks = asyncio.all_tasks()
    current = asyncio.current_task()
    
    for task in tasks:
        print(f"任务: {task.get_name()}")
        print(f"完成: {task.done()}")
        print(f"取消: {task.cancelled()}")
        if task.done() and not task.cancelled():
            try:
                print(f"结果: {task.result()}")
            except Exception as e:
                print(f"异常: {e}")

asyncio.run(debug_mode())
```

### 11. 常见模式和实践

```python
import asyncio
from typing import Optional

# 模式1：超时重试
async def retry_with_timeout(coro, timeout=5, max_retries=3):
    for attempt in range(max_retries):
        try:
            return await asyncio.wait_for(coro, timeout=timeout)
        except (asyncio.TimeoutError, Exception) as e:
            if attempt == max_retries - 1:
                raise
            await asyncio.sleep(2 ** attempt)

# 模式2：限流器
class RateLimiter:
    def __init__(self, rate, per=1):
        self.rate = rate  # 每秒次数
        self.per = per    # 时间窗口
        self.tokens = rate
        self.updated_at = asyncio.get_event_loop().time()
        self.lock = asyncio.Lock()
    
    async def acquire(self):
        async with self.lock:
            now = asyncio.get_event_loop().time()
            time_passed = now - self.updated_at
            self.tokens += time_passed * (self.rate / self.per)
            self.tokens = min(self.rate, self.tokens)
            self.updated_at = now
            
            if self.tokens < 1:
                wait_time = (1 - self.tokens) * (self.per / self.rate)
                await asyncio.sleep(wait_time)
                self.tokens = 1
                self.updated_at = asyncio.get_event_loop().time()
            
            self.tokens -= 1

# 模式3：优雅关闭
async def graceful_shutdown():
    # 获取所有任务
    tasks = [t for t in asyncio.all_tasks() 
             if t is not asyncio.current_task()]
    
    # 给任务完成的时间
    done, pending = await asyncio.wait(tasks, timeout=5)
    
    # 取消剩余任务
    for task in pending:
        task.cancel()
    
    # 等待取消完成
    await asyncio.gather(*pending, return_exceptions=True)

# 模式4：信号量池
class ConnectionPool:
    def __init__(self, max_connections):
        self.semaphore = asyncio.Semaphore(max_connections)
        self.connections = []
    
    async def acquire(self):
        await self.semaphore.acquire()
        if self.connections:
            return self.connections.pop()
        return await self.create_connection()
    
    async def release(self, conn):
        self.connections.append(conn)
        self.semaphore.release()
    
    async def create_connection(self):
        await asyncio.sleep(0.1)
        return "connection"

# 模式5：发布-订阅
class PubSub:
    def __init__(self):
        self.subscribers = []
    
    def subscribe(self):
        queue = asyncio.Queue()
        self.subscribers.append(queue)
        return queue
    
    def unsubscribe(self, queue):
        self.subscribers.remove(queue)
    
    async def publish(self, message):
        for queue in self.subscribers:
            await queue.put(message)
    
    async def consume(self, queue):
        while True:
            message = await queue.get()
            if message is None:
                break
            print(f"收到: {message}")

# asyncio.run(retry_with_timeout(some_coro()))
```

### 12. 常见错误和解决方案

| 错误 | 原因 | 解决方案 |
|------|------|----------|
| `RuntimeError: Event loop is closed` | 循环被关闭后使用 | 使用 `asyncio.run()` |
| `RuntimeError: cannot reuse already awaited coroutine` | 重复 await 协程 | 使用 `create_task()` |
| `asyncio.TimeoutError` | 操作超时 | 增加超时时间或优化代码 |
| `CancelledError` | 任务被取消 | 捕获并适当处理 |
| 协程未运行警告 | 创建协程但未 await | 添加 `await` 或 `create_task()` |

```python
import asyncio

# 错误1：重复 await 协程
async def bad():
    coro = my_coro()
    result1 = await coro
    result2 = await coro  # ❌ 错误！

# 正确做法
async def good():
    task = asyncio.create_task(my_coro())
    result1 = await task
    result2 = await task  # ✅ 可以多次 await task

# 错误2：忘记 await
async def bad2():
    my_coro()  # ❌ 协程未运行，会有警告

async def good2():
    await my_coro()  # ✅

# 错误3：在协程中使用阻塞代码
async def bad3():
    time.sleep(1)  # ❌ 阻塞事件循环

async def good3():
    await asyncio.sleep(1)  # ✅
```

### 13. 性能对比

```python
import asyncio
import time
import threading

# 同步版本
def sync_version():
    time.sleep(1)
    return "sync"

# 异步版本
async def async_version():
    await asyncio.sleep(1)
    return "async"

# 1000个任务的性能对比
async def performance_test():
    # 异步 - 并发
    start = time.time()
    await asyncio.gather(*[async_version() for _ in range(1000)])
    async_time = time.time() - start
    
    # 同步 - 顺序
    start = time.time()
    for _ in range(1000):
        sync_version()
    sync_time = time.time() - start
    
    print(f"异步(并发): {async_time:.2f}秒")
    print(f"同步(顺序): {sync_time:.2f}秒")
    print(f"异步快了 {sync_time/async_time:.0f}倍")

# asyncio.run(performance_test())
```

### 14. 最佳实践总结

```python
# ✅ 推荐做法
async def best_practices():
    # 1. 使用 asyncio.run() 作为主入口
    # 2. 使用 create_task() 管理后台任务
    # 3. 使用 gather() 并发执行
    # 4. 使用 wait_for() 设置超时
    # 5. 使用 Queue 进行协程间通信
    # 6. 使用 Semaphore 控制并发数
    # 7. 捕获 CancelledError 清理资源
    # 8. 使用异步版本的库（aiohttp, aiofiles）
    pass

# ❌ 避免的做法
async def bad_practices():
    # 1. 不要混用同步和异步代码
    # 2. 不要在协程中使用 time.sleep()
    # 3. 不要忘记 await 协程
    # 4. 不要重复 await 同一个协程对象
    # 5. 不要创建大量未管理的任务
    # 6. 不要忽略超时和取消
    pass
```

asyncio 是 Python 异步编程的核心，掌握这些知识可以让你写出高效、可维护的并发代码，特别适合网络应用、Web 框架、爬虫等 IO 密集型场景。