    
    
    🚀 1️⃣ 创建项目 + 虚拟环境
    mkdir ai-demo && cd ai-demo
    python3 -m venv .venv
    激活环境：
    source .venv/bin/activate
    👉 成功标志：
    (.venv) your-name@...
    
    📦 2️⃣ 安装依赖（OpenAI SDK）
    pip install --upgrade openai python-dotenv
    
    🔐 3️⃣ 配置 API Key（推荐 .env 方式）
    创建 .env 文件：
    touch .env
    写入：
    OPENAI_API_KEY=你的key
    👉 安全且不会污染全局环境
    
    🧪 4️⃣ 写第一个 AI Demo
    创建 main.py：
    from openai import OpenAI
    from dotenv import load_dotenv
    
    # 加载环境变量
    load_dotenv()
    
    client = OpenAI()
    
    def chat():
        print("🤖 AI 已启动（输入 exit 退出）")
        while True:
            user_input = input("\n你: ")
            if user_input.lower() == "exit":
                break
    
            resp = client.chat.completions.create(
                model="gpt-4o-mini",
                messages=[
                    {"role": "system", "content": "你是一个资深软件工程师"},
                    {"role": "user", "content": user_input}
                ]
            )
    
            print("\nAI:", resp.choices[0].message.content)
    
    if __name__ == "__main__":
        chat()
    
    ▶️ 5️⃣ 运行
    python main.py
    你会看到：
    🤖 AI 已启动（输入 exit 退出）
    
    你:
    👉 已经是一个完整的 CLI AI 聊天工具了
    
    ⚡ 6️⃣ 升级（流式输出，更像 ChatGPT）
    替换核心调用：
    stream = client.chat.completions.create(
        model="gpt-4o-mini",
        messages=[{"role": "user", "content": user_input}],
        stream=True
    )
    
    print("\nAI:", end=" ")
    for chunk in stream:
        print(chunk.choices[0].delta.content or "", end="")
    print()
    
    📁 7️⃣ 推荐项目结构（工程化）
    ai-demo/
    ├── .venv/
    ├── .env
    ├── main.py
    └── requirements.txt
    生成依赖：
    pip freeze > requirements.txt
    
    ⚠️ 常见问题（你大概率会遇到）
    ❌ python 不存在
    👉 用 python3 或 alias
    
    ❌ ModuleNotFoundError
    👉 没激活虚拟环境
    
    ❌ API 报错
    👉 检查 .env 是否正确加载
    
    ❌ 没输出
    👉 检查 key 是否有效
    
    🎯 一句话总结
    你现在已经拥有：AI 应用开发最小闭环（环境 + SDK + Demo）
    
    🚀 下一步建议（很关键）
    你可以选一个我带你做：
    1️⃣ Flutter + AI Chat（强烈推荐你）
    	•	流式输出
    	•	Markdown 渲染
    	•	聊天 UI
    2️⃣ RAG 知识库（企业最常用）
    	•	本地文档问答
    	•	向量检索（核心技能）
    3️⃣ Agent（进阶）
    	•	自动调用 API
    	•	多步骤任务
    
    直接说👇 👉 “做 Flutter AI” 或 “做 RAG”
    我给你上**可上线级代码模板（不是 demo）**🔥
