## Python requests 库请求方法总结

`requests` 是 Python 中最常用的 HTTP 请求库，以下是所有主要请求方法的详细总结：

### 1. 基本请求方法

| 方法 | HTTP方法 | 用途 | 示例 |
|------|---------------|------|------|
| `requests.get()` | GET | 获取资源 | `requests.get('https://api.example.com/users')` |
| `requests.post()` | POST | 创建资源 | `requests.post('https://api.example.com/users', data={...})` |
| `requests.put()` | PUT | 完整更新资源 | `requests.put('https://api.example.com/users/1', data={...})` |
| `requests.patch()` | PATCH | 部分更新资源 | `requests.patch('https://api.example.com/users/1', data={...})` |
| `requests.delete()` | DELETE | 删除资源 | `requests.delete('https://api.example.com/users/1')` |
| `requests.head()` | HEAD | 获取响应头 | `requests.head('https://api.example.com/users')` |
| `requests.options()` | OPTIONS | 获取支持的请求方法 | `requests.options('https://api.example.com/users')` |

### 2. GET 请求详解

```python
import requests

url = 'https://jsonplaceholder.typicode.com/posts'
# 基本 GET 请求
response = requests.get(url)

# 带参数的 GET 请求（方式一：params 参数）
params = {
    'userId': 1,
    'id': 1
}
response = requests.get(url, params=params)
print(response.url)  # https://jsonplaceholder.typicode.com/posts?userId=1&id=1

# 带参数的 GET 请求（方式二：直接拼接）
response = requests.get('url?userId=1&id=1')

# 带请求头
headers = {
    'User-Agent': 'Mozilla/5.0',
    'Authorization': 'Bearer token123'
}
response = requests.get(url, headers=headers)

# 带超时
response = requests.get(url, timeout=5)  # 5秒超时

# 带认证
response = requests.get(url, auth=('username', 'password'))
```

### 3. POST 请求详解

```python
import requests

url = 'https://httpbin.org/post'
# 表单数据提交 (application/x-www-form-urlencoded)
data = {
    'username': 'john',
    'password': '123456'
}
response = requests.post(url, data=data)

# JSON 数据提交 (application/json)
json_data = {
    'name': 'John Doe',
    'email': 'john@example.com',
    'age': 30
}
response = requests.post(url, json=json_data)

# 文件上传
files = {
    'file': open('document.pdf', 'rb')
}
response = requests.post(url, files=files)

# 同时提交数据和文件
data = {'name': 'John'}
files = {'avatar': open('photo.jpg', 'rb')}
response = requests.post(url, data=data, files=files)

# 多部分表单数据
data = {
    'name': 'John',
    'age': '25'
}
response = requests.post(url, data=data)
```

### 4. PUT 请求（完整更新）

```python
import requests

# PUT 请求通常用于完整更新资源
update_data = {
    'id': 1,
    'name': 'Updated Name',
    'email': 'updated@example.com',
    'age': 35
}
response = requests.put('https://jsonplaceholder.typicode.com/posts/1', json=update_data)

# 或者使用 data 参数
response = requests.put('https://api.example.com/users/1', data={'name': 'New Name'})
```

### 5. PATCH 请求（部分更新）

```python
import requests

# PATCH 只发送需要更新的字段
partial_update = {
    'age': 31  # 只更新年龄
}
response = requests.patch('https://jsonplaceholder.typicode.com/posts/1', json=partial_update)
```

### 6. DELETE 请求

```python
import requests

# 删除资源
response = requests.delete('https://jsonplaceholder.typicode.com/posts/1')

# 带参数的删除
response = requests.delete('https://api.example.com/users/1', params={'hard_delete': True})
```

### 7. 响应处理

```python
import requests

response = requests.get('https://jsonplaceholder.typicode.com/posts/1')

# 获取响应内容
print(response.text)           # 字符串格式
print(response.content)        # 字节格式
print(response.json())         # JSON 格式（自动解析）

# 获取响应状态
print(response.status_code)    # 200, 404, 500 等
print(response.reason)         # 'OK', 'Not Found' 等
print(response.ok)             # True 如果状态码 < 400

# 获取响应头
print(response.headers)        # 所有响应头
print(response.headers['Content-Type'])
print(response.headers.get('content-type'))

# 获取编码
print(response.encoding)       # 响应编码
response.encoding = 'utf-8'    # 手动设置编码

# 获取 Cookies
print(response.cookies)        # 响应中的 cookies
print(response.cookies['session_id'])

# 获取请求信息
print(response.request.url)    # 请求的 URL
print(response.request.headers) # 请求头
print(response.elapsed)        # 请求耗时
```

### 8. 高级功能

```python
import requests
from requests.adapters import HTTPAdapter
from urllib3.util.retry import Retry

# Session 对象（保持会话，复用连接）
session = requests.Session()
session.headers.update({'User-Agent': 'My App'})
session.auth = ('user', 'pass')

# 使用 session 发送多个请求
response1 = session.get('https://httpbin.org/cookies/set/sessioncookie/123456')
response2 = session.get('https://httpbin.org/cookies')
session.close()

# 重试机制
retry_strategy = Retry(
    total=3,  # 总重试次数
    backoff_factor=1,  # 重试间隔
    status_forcelist=[429, 500, 502, 503, 504]  # 需要重试的状态码
)
adapter = HTTPAdapter(max_retries=retry_strategy)
session.mount('http://', adapter)
session.mount('https://', adapter)

# 代理设置
proxies = {
    'http': 'http://10.10.1.10:3128',
    'https': 'http://10.10.1.10:1080'
}
response = requests.get('https://api.example.com', proxies=proxies)

# SSL 证书验证
response = requests.get('https://api.example.com', verify=True)  # 默认验证
response = requests.get('https://api.example.com', verify='/path/to/cert.pem')
response = requests.get('https://api.example.com', verify=False)  # 跳过验证（不推荐）

# 流式下载大文件
response = requests.get('https://example.com/large_file.zip', stream=True)
with open('large_file.zip', 'wb') as f:
    for chunk in response.iter_content(chunk_size=8192):
        f.write(chunk)

# 上传大文件
with open('large_file.zip', 'rb') as f:
    response = requests.post('https://httpbin.org/post', data=f)

# 自定义适配器
class MyAdapter(HTTPAdapter):
    def send(self, request, **kwargs):
        # 自定义发送逻辑
        return super().send(request, **kwargs)
```

### 9. 异常处理

```python
import requests
from requests.exceptions import Timeout, ConnectionError, HTTPError, RequestException

try:
    response = requests.get('https://api.example.com/data', timeout=5)
    response.raise_for_status()  # 如果状态码是 4xx 或 5xx，抛出 HTTPError
except Timeout:
    print("请求超时")
except ConnectionError:
    print("连接错误")
except HTTPError as e:
    print(f"HTTP 错误: {e}")
except RequestException as e:
    print(f"请求异常: {e}")
else:
    print("请求成功")
    data = response.json()
finally:
    print("请求结束")
```

### 10. 实用工具方法

```python
import requests

# 判断状态码
response = requests.get('https://httpbin.org/status/404')
if response.status_code == 200:
    print("成功")
elif response.status_code == 404:
    print("资源不存在")
elif response.status_code == 500:
    print("服务器错误")

# 使用 status_code 的分类
if 200 <= response.status_code < 300:
    print("成功")
elif 400 <= response.status_code < 500:
    print("客户端错误")
elif 500 <= response.status_code < 600:
    print("服务器错误")

# 获取重定向历史
response = requests.get('https://httpbin.org/redirect/3')
print(response.history)  # 重定向历史列表
print(response.url)      # 最终 URL

# 获取请求耗时
response = requests.get('https://httpbin.org/delay/1')
print(f"请求耗时: {response.elapsed.total_seconds()} 秒")
```

### 11. 完整示例：封装一个 API 客户端

```python
import requests
from typing import Dict, Any, Optional

class APIClient:
    def __init__(self, base_url: str, token: Optional[str] = None):
        self.base_url = base_url
        self.session = requests.Session()
        if token:
            self.session.headers.update({'Authorization': f'Bearer {token}'})
    
    def get(self, endpoint: str, params: Optional[Dict] = None) -> Dict[str, Any]:
        url = f"{self.base_url}/{endpoint}"
        response = self.session.get(url, params=params)
        response.raise_for_status()
        return response.json()
    
    def post(self, endpoint: str, data: Optional[Dict] = None, 
             json_data: Optional[Dict] = None) -> Dict[str, Any]:
        url = f"{self.base_url}/{endpoint}"
        response = self.session.post(url, data=data, json=json_data)
        response.raise_for_status()
        return response.json()
    
    def put(self, endpoint: str, data: Dict) -> Dict[str, Any]:
        url = f"{self.base_url}/{endpoint}"
        response = self.session.put(url, json=data)
        response.raise_for_status()
        return response.json()
    
    def delete(self, endpoint: str) -> bool:
        url = f"{self.base_url}/{endpoint}"
        response = self.session.delete(url)
        return response.status_code == 204
    
    def close(self):
        self.session.close()

# 使用示例
client = APIClient('https://jsonplaceholder.typicode.com', token='your_token')
posts = client.get('posts', params={'userId': 1})
new_post = client.post('posts', json_data={'title': 'New Post', 'body': 'Content'})
client.close()
```

### 安装 requests

```bash
# 在虚拟环境中安装
pip install requests

# 或使用 conda
conda install requests
```

这些方法覆盖了 `requests` 库的大部分使用场景，掌握它们可以应对绝大多数 HTTP 请求需求。