# AIWriteX 云端部署（Docker）
# 构建 & 启动：
#   docker compose up -d --build
# 之后浏览器访问 http://服务器IP:8000

FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PYTHONIOENCODING=utf-8 \
    PIP_NO_CACHE_DIR=1

# Pillow / lxml 等包需要的系统库
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libjpeg-dev \
    zlib1g-dev \
    libpng-dev \
    libfreetype6-dev \
    curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# 先装依赖（利用 Docker 层缓存）
COPY requirements.txt .
RUN pip install --upgrade pip && \
    pip install -r requirements.txt

# 再拷代码
COPY . .

# 数据目录（output 文章 / logs 日志 / knowledge 知识库 / config 配置）
VOLUME ["/app/output", "/app/logs", "/app/knowledge", "/app/src/ai_write_x/config"]

EXPOSE 8000

HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -fsS http://127.0.0.1:8000/health || exit 1

# 直接启动 FastAPI 服务（不需要 PyWebView 桌面壳）
CMD ["uvicorn", "src.ai_write_x.web.app:app", "--host", "0.0.0.0", "--port", "8000", "--workers", "1"]
