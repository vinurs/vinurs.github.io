+++
title = "用orgmode写blog"
author = ["vinurs"]
date = 2020-02-14
expiryDate = 2999-01-01
lastmod = 2021-01-03T10:11:10+08:00
draft = false
from = "orgmode"
+++

orgmode号称emacs下面的大杀器，emacs本来就是一个杀手级的应用，配上了orgmode真的是越用越爽。

<!--more-->


## 新建文章 {#新建文章}

因为hugo目前渲染得比较好的还是md文件，因此我们通过ox-hugo来将org文件转成md文件，而且ox-hugo还能自动将文章导成md

目前组织文章的方式有两种:

-   一个文件就是一篇文章
-   一系列的文章放在一个文件里面，每一个一级标题就是一个文章

第一种其实就是第二种的一个特例，因此我选用了第二种来管理我的文章。

我建立了一个模板:

```org
# -*- mode: org; -*-
#+HUGO_BASE_DIR: ~/sys-cfg/github/vinurs.github.io/
#+HUGO_SECTION: ../content/post/example


* 新的文章
  :PROPERTIES:
  :EXPORT_TITLE: 文章标题
  :EXPORT_DESCRIPTION: 这个是用来写blog的示例
  :EXPORT_AUTHOR: vinurs
  :EXPORT_EMAIL: <haiyuan.vinurs@gmail.com>
  :EXPORT_DATE: 2020-02-14
  :EXPORT_STARTUP: content
  :EXPORT_HUGO_CATEGORIES:
  :EXPORT_HUGO_TAGS:
  :EXPORT_HUGO_DRAFT: true
  :EXPORT_FILE_NAME: example
  :EXPORT_HUGO_AUTO_SET_LASTMOD: t
  :EXPORT_HUGO_EXPIRYDATE: 2999-01-01
  :EXPORT_HUGO_FRONT_MATTER_KEY_REPLACE: description>summary
  :EXPORT_HUGO_CUSTOM_FRONT_MATTER:
  :END:

  这里是概要部分

  #+hugo: more


  正文内容部分
  This getsll created iln ~<HUGO_BASE_DIR>/content/articles/~. As the
  ~EXPORT_HUGO_SECTION~ property is not set, the ~#+hugo_section~
  keyword value applies.
  laa11

  ** 更新历史
  + 2019-12-18
    + 初稿
```

每次只要copy这个文件然后进行修改里面的内容就可以了:

-   `HUGO_BASE_DIR` ox-hugo导出的md文件的基目录
-   `HUGO_SECTION` ox-hugo导出的文章相对与HUO\_BASE\_DIR的目录
-   `:EXPORT_DATE:` 文章发布的日期
-   `:EXPORT_FILE_NAME:` 导出的文件名称
-   `#+HUGO_SECTION:` 导出的文件的目录
-   `更新历史`


### 模板自动化 {#模板自动化}

hugo有个archetypes功能，因此为了避免每次不必要的复制，我在 `archetypes` 下面新建了一个 `default.org` ，这样每次就可以自动化完成一些需要手动修改的内容。

例如每次我只需要执行 `hugo new test.org` 就可以了，接着把这个文件移动到对应的目录下面，然后再修改对应的内容就可以了:

-   `:EXPORT_FILE_NAME:` 导出的文件名称
-   `:EXPORT_TITLE:` 文章的标题
-   `:EXPORT_DESCRIPTION` 描述
-   `#+HUGO_SECTION:` 导出的文件的目录
-   `更新历史`


### 通过yasnippet来进行补全 {#通过yasnippet来进行补全}

yasnippet是emacs里面的补全神器，我用的是doom-emacs的配置，因此在 `~/.doom.d/snippets/org-mode` 里面新增了一个 `__org-directory-template.org` 文件


## 发布文章 {#发布文章}

每次我新建文章的时候，里面的 `:EXPORT_HUGO_DRAFT:` 的部分都是设置成了 `false` ，因此如果想发布文章，那么把这里改成 `true` 。

此外，我的文章是单独管理的，org文件没有放在github.io的仓库下面，因此每次我是保存到仓库目录下面，有些是我的draft文件，所以我不想把这些draft文件发布出去，因此我在仓库下面写了一个脚本每次只提交不是draft的文件。


## 图片管理 {#图片管理}

用orgmode来写文章最大的一个问题就是如何来管理图片，如何方便地插入图片。

我们写blog的时候大部分的操作是这样的:

-   截图插入
-   从网络上copy一个图片插入
-   从本地目录选择一张图片插入

无论怎么操作，最后我们都希望每一个文章相关的图片都在这个文章相应的目录里面，这样便于以后进行管理。

另外，我的写文章的目录跟最后发布的目录不在同一个地方，最后用ox-hugo生成对应的md文件的时候我希望对应的图片也要能copy过去。

好在在orgmode里面有个[org-download](https://github.com/abo-abo/org-download)的插件可以做到这一点:

-   网络上的图片可以使用: org-download-yank
-   本地的图片直接拖拽就可以
-   需要截屏的时候使用: org-download-screenshot

不过我现在一般做法都是先把图片准备好了然后保存到本地，然后直接拖拽到orgmode的buffer里面来。


## 重新生成md文件 {#重新生成md文件}

目前我是通过ox-hugo来自动将org文件转成md文件，有时候我们将所有的文件重新生成一遍，这时候不需要重新一篇篇文章打开然后导出，ox-hugo里面提供了类似的方法。

将ox-hugo clone下来，然后修改里面的Makefile文件就可以了:

```sh
git clone --recurse-submodules -j8 https://github.com/kaushalmodi/ox-hugo
```

修改的内容如下:

```diff
diff --git a/Makefile b/Makefile
index fc36596..0c4903e 100644
--- a/Makefile
+++ b/Makefile
@@ -70,10 +70,10 @@ TEST_ENABLED=0
OX_HUGO_TEST_DIR=$(shell pwd)/test

# Base directory for the Hugo example site
-OX_HUGO_TEST_SITE_DIR=$(OX_HUGO_TEST_DIR)/site
+OX_HUGO_TEST_SITE_DIR=~/system-configuration/github/vinurs.github.io

# Directory containing Org files for the test site
-OX_HUGO_TEST_ORG_DIR=$(OX_HUGO_TEST_SITE_DIR)/content-org
+OX_HUGO_TEST_ORG_DIR=~/system-configuration/pdms
```

OX\_HUGO\_TEST\_SITE\_DIR就是我们的github.io的目录，OX\_HUGO\_TEST\_ORG\_DIR是我们存放org文件的目录，然后进入ox-hugo目录，执行make md就可以重新生成。


## 更新历史 {#更新历史}

-   2020-04-25
    -   增加了如何一次性将org文件导出成md

-   2020-04-19
    -   增加了如何用orgmode来管理图片

-   2020-02-14
    -   初稿
