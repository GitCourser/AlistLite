#!/bin/bash

repo="GitCourser/AlistLite"
latest=$(curl -s https://api.github.com/repos/$repo/releases/latest)
version=$(echo $latest | jq -r '.tag_name')
# echo $version
# echo alist-${version#v}
wget https://github.com/$repo/archive/refs/tags/$version.tar.gz
wget https://github.com/GitCourser/alist-web/releases/latest/download/dist.tar.gz
tar -zxf $version.tar.gz
tar -zxf dist.tar.gz
rm -rf alist-${version}/public/dist/*
cp dist/index.html alist-${version}/public/dist
cp build.sh alist-${version}
chmod +x alist-${version}/build.sh
rm -rf dist

# Install dependencies
# sudo snap install zig --classic --beta
docker pull crazymax/xgo:latest
go install github.com/crazy-max/xgo@latest
# sudo apt update
# sudo apt install upx
repo="upx/upx"
latest=$(curl -s https://api.github.com/repos/$repo/releases/latest)
version=$(echo $latest | jq -r '.tag_name')
wget https://github.com/$repo/releases/latest/download/upx-${version#v}-amd64_linux.tar.xz
tar -xf upx-${version#v}-amd64_linux.tar.xz
sudo mv upx-${version#v}-amd64_linux/upx /usr/local/bin/
sudo chmod +x /usr/local/bin/upx

# linux-musl-cross
# BASE="https://musl.cc/"
BASE="https://github.com/go-cross/musl-toolchain-archive/releases/latest/download/"
FILES=(x86_64-linux-musl-cross aarch64-linux-musl-cross mipsel-linux-musl-cross)
for i in "${FILES[@]}"; do
  url="${BASE}${i}.tgz"
  curl -L -o "${i}.tgz" "${url}"
  sudo tar xf "${i}.tgz" --strip-components 1 -C /usr/local
  rm -f "${i}.tgz"
done

# build
# build.sh release
# build.sh release android
# build.sh release linux_musl
