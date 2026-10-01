# AIWriteX 云端部署说明

## 文件
- `Dockerfile` — 镜像构建（Python 3.11 + FastAPI 服务）
- `docker-compose.yml` — 一键启动
- `.dockerignore` — 构建时排除项

## 部署步骤

1. 把这三个文件放到 AIWriteX 仓库根目录（和 `requirements.txt` 同级）
2. 云服务器上执行：
   ```bash
   docker compose up -d --build
   ```
3. 浏览器访问 `http://服务器IP:8000`，通过 Web 界面配置大模型 API Key、微信公众号凭据等
4. 查看日志：`docker compose logs -f`

## 说明
- 启动的是 FastAPI Web 服务，不需要 PyWebView 桌面环境
- `/health` 接口用于健康检查
- 数据持久化在 `./data/` 下：output（文章）、logs（日志）、knowledge（知识库）、config（配置）
- 内容生成跑在独立子进程，容器内存建议 4G 以上
- 生产环境建议前面加 nginx 做反向代理 + HTTPS
- 开源版 license 模块为空实现，不绑机器码，可放心迁移
