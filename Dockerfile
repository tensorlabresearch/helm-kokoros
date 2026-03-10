# syntax=docker/dockerfile:1.7

FROM nvidia/cuda:12.6.3-cudnn-devel-ubuntu24.04 AS builder

ARG RUST_VERSION=1.88.0

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    build-essential \
    pkg-config \
    libssl-dev \
    clang \
    git \
    cmake \
    libsonic-dev \
    libpcaudio-dev \
    && rm -rf /var/lib/apt/lists/*

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs \
    | sh -s -- -y --default-toolchain "${RUST_VERSION}" --profile minimal

ENV PATH="/root/.cargo/bin:${PATH}"
WORKDIR /src

RUN git clone --depth 1 https://github.com/aigentic-net/kokoros.git .
RUN cargo build --release -p koko --features kokoros/cuda

FROM nvidia/cuda:12.6.3-cudnn-runtime-ubuntu24.04 AS runtime

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    libssl3 \
    libsonic0 \
    libpcaudio0 \
    && rm -rf /var/lib/apt/lists/*

RUN useradd --create-home app \
    && mkdir -p /app /models \
    && chown -R app:app /app /models /home/app

COPY --from=builder /src/target/release/koko /usr/local/bin/koko

USER app
WORKDIR /app

EXPOSE 3000

ENTRYPOINT ["/usr/local/bin/koko"]
CMD ["openai", "--ip", "0.0.0.0", "--port", "3000"]
