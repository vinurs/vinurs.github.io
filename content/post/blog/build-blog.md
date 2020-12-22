+++
title = "搭建个人blog"
date = 2020-12-22
expiryDate = 2999-01-01
lastmod = 2020-12-22T11:08:18+08:00
draft = false
from = "orgmode"
+++

一直想写一个blog来记录自己的人生点点滴滴，之前一直忙于工作，最近稍微空闲下来了，于是开始着手这个事情。

<!--more-->


## 为什么要搭建blog {#为什么要搭建blog}

1.  对自己已经掌握的知识进行系统性地梳理
2.  分享，也许自己总结的知识正是别人需要的
3.  记录自己的点滴


## HUGO {#hugo}

HUGO是一个静态网站生成软件，用GO语言写成，据说是目前最快的静态blog生成工具了；当然了，不仅仅是因为它快，用过Emacs的人都比较喜欢用orgmode来写文档，那么我写blog当然也想用能够支持Emacs orgmode的了，hugo现在已经提供了对Emacs orgmode的native支持；不过后来发现hugo对Emacs orgmode还不能完全支持，不过还好还有[ox-hugo](<https://github.com/kaushalmodi/ox-hugo>)，可以用来完美地将orgmode转成hugo支持的markdown格式的，很赞。


### 初始化blog {#初始化blog}


#### 安装hugo {#安装hugo}

我用的是macOS，安装起来很简单

```shell
brew install hugo
```


#### 新建blog {#新建blog}

```shell
hugo new site blog
```

该命令会新建一个blog目录，并且初始化这个目录，站点所有的东西都会在这个目录下面。


#### 选择主题 {#选择主题}

去[hugo thems](https://themes.gohugo.io/)上面挑选一个喜欢的theme，然后安装，我选择的是even，由于考虑到我后面可能会修改这个主题，因此我选择的是fork了这个主题，然后将这个主题clone到themes目录下面

```shell
cd blog/
git clone https://github.com/vinurs/hugo-theme-even.git themes/even
```

拷贝even主题下面的exampleSite里面的内容到blog目录下面

```shell
cp -rf themes/even/exampleSite/* ./
```

在blog目录下面生成站点

```shell
# 生成站点
hugo
# 本地预览
hugo server
```

这样本地可以通过 <http://localhost:1313/> 这个来进行访问了，这样一个blog的雏形就搭建好了。

执行 `hugo` 以后会在blog/public下面生成可以发布的站点，后面我们只要把 `public` 下面的内容放到github上面去就可以了。


## GITHUB PAGE {#github-page}

由于我自己从事软件开发，因此我选择了大部分程序员的方式，通过 `github page` 来进行搭建。


### 发布 {#发布}

在github上面新建一个 `用户.github.io` 的仓库，clone到本地，然后将我们上面的 `public` 里面的内容copy到这个仓库下面就可以了，最后再push到远程仓库。

```shell
git clone https://github.com/vinurs/vinurs.github.io.git
cp -rf blog/public/* vinurs.github.io/
cd blog
git add .
git ci -m "init the website"
git push
```

这时候我们就可以通过 <https://vinurs.github.io> 来进行访问了。


### 自动化发布──github-actions {#自动化发布-github-actions}

按照上面的发布过程，我们每次更新了文章以后都要执行上面一系列的操作，然后才能更新站点。

那么有没有一种方法能够自动执行上面的过程呢？这样我们就只需要关注写文章本身就可以了，答案就是 `github actions` 。

github page读取的是github.io的master分支，因此我们建立了一个source分支，clone到本地，删除掉里面的内容，然后将刚才blog目录下面的内容copy过去

```shell
git clone --branch=source https://github.com/vinurs/vinurs.github.io.git
cp -rf blog/* vinurs.github.io
```

themes/even我们是作为主题来单独维护的，因此作为一个submodule增加进去

```shell
cd vinurs.github.io
git submodule add  https://github.com/vinurs/hugo-theme-even.git themes/even
```

public、resources里面的内容不需要提交，这个是每次自动生成的，我们增加了.gitignore文件。


#### ACTIONS\_DEPLOY\_KEY {#actions-deploy-key}

想通过github来自动发布我们需要建立 `ACTIONS_DEPLOY_KEY`

生成一对 `ssh key`

```shell
ssh-keygen -t rsa -b 4096 -C "$(git config user.email)" -f gh-pages -N ""
```

将会得到两个文件：gh-pages.pub（公钥） 和 gh-pages（私钥），用文本编辑器打开可以看到文件的内容。
在 `vinurs.github.io` 项目主页中，找到 Repository Settings -> Secrets -> 添加这个私钥的内容并命名为 ACTIONS\_DEPLOY\_KEY

在 `vinurs.github.io` 项目主页中，找到 Repository Settings -> Deploy Keys -> 添加这个公钥的内容，并勾选 Allow write access


#### 增加github workflows {#增加github-workflows}

参照这里的配置说明：<https://github.com/peaceiris/actions-hugo>

在项目的根目录下面新建对应的目录以及文件:

```sh
  mkdir -p .github/workflows/
  touch .github/workflows/main.yml
```

main.yml里面的文件内容如下:

```yml
name: github pages

on:
  push:
    branches:
    - source

jobs:
  build-deploy:
    runs-on: ubuntu-18.04

    steps:
    - uses: actions/checkout@master
    - name: Checkout submodules
      shell: bash
      run: |
        auth_header="$(git config --local --get http.https://github.com/.extraheader)"
        git submodule sync --recursive
        git -c "http.extraheader=$auth_header" -c protocol.version=2 submodule update --init --force --recursive --depth=1

    - name: Setup Hugo
      uses: peaceiris/actions-hugo@v2
      with:
        hugo-version: 'latest'
        extended: true

    - name: Build
      run: hugo --gc --minify --cleanDestinationDir

    - name: Deploy
      uses: peaceiris/actions-gh-pages@v3
      with:
        deploy_key: ${{ secrets.ACTIONS_DEPLOY_KEY }}
        publish_dir: ./public
        publish_branch: master  # deploying branch
```

然后将刚才的内容推送到source分支上面去就可以了，我们可以通过 <https://github.com/vinurs/vinurs.github.io/actions> 这个页面来查看这个action执行的结果，一般是没什么问题的，有问题的话就google解决一下就可以，基本不会出现什么问题。


### 绑定自己的域名 {#绑定自己的域名}

github域名设定就是在根目录下面建一个CNAME文件，在hugo里面，我们只需要将原来的CNAME文件存放到static目录下面即可。


## EVEN配置 {#even配置}

参考[Even配置](https://github.com/olOwOlo/hugo-theme-even/blob/master/README-zh.md)进行配置


### merge主题 {#merge主题}

因为考虑到以后我会对Even做一些修改，因此我fork了这个项目，上面clone的也是我自己的github上面的地址，后面定期对这个主题进行merge就可以了。

```sh
git remote add upstream https://github.com/olOwOlo/hugo-theme-even.git
git fetch upstream
git merge upstream/master
```

如果有冲突，那么就手动解决冲突问题，这个冲突一般都好解决，一般改动量不会很大。


### 编译主题 {#编译主题}

如果你更改了 _src_ 目录下的任意文件，你需要重新编译它们。
,#+BEGIN\_SRC sh
  cd ./themes/even/

yarn install

  yarn build
\#+END\_SRC
在这一步的时候，最好把主题目录下面的node\_modules以及yarn.lock删除掉，要不然编译很可能会报一些莫名其妙的错误。


## 更新历史 {#更新历史}

-   2020-12-22
    -   初稿
