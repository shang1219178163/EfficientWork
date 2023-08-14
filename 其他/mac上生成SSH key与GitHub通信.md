# mac上生成SSH key与GitHub通信

git config --global user.name "shang1219178163"
git config --global user.email "shang1219178163@gmail.com"
ssh-keygen -t rsa -C "shang1219178163@gmail.com"
ssh-keygen -t rsa -b 4096 -C "shang1219178163@gmail.com"

github_rsa

ssh-add ~/.ssh/github_rsa

eval "$(ssh-agent -s)"

测试new.github.com

ssh -T git@new.github.com
如果报错了，可以使用下面命令查看详细的报错信息

ssh -vT git@new.github.com

---
GitHub多账户及SSH密钥配置

https://www.jianshu.com/p/004dbff1bf34

[解决]git-ssh: connect to host github.com port 22: Connection timed out

https://www.jianshu.com/p/c3aac5024877