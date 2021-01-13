+++
title = "用orgmode写blog"
author = ["vinurs"]
date = 2020-02-14
expiryDate = 2999-01-01
lastmod = 2021-01-14T04:59:06+08:00
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

增加下面的配置函数，这个自动补全只对我用来记笔记的org文件才自动补全

```emacs-lisp
;; 在org-directory下面的文件使用的org文件不一样
(set-file-template! "\\.org$"
  :when '+org-file-in-org-directory-p
  ;; :when +file-templates-in-emacs-dirs-p
  :trigger "__org-directory-template.org" :mode 'org-mode)
```


## 发布文章 {#发布文章}

每次我新建文章的时候，里面的 `:EXPORT_HUGO_DRAFT:` 的部分都是设置成了 `false` ，因此如果想发布文章，那么把这里改成 `true` 。

此外，我的文章是单独管理的，org文件没有放在github.io的仓库下面，因此每次我是保存到仓库目录下面，有些是我的draft文件，所以我不想把这些draft文件发布出去，因此我在仓库下面写了一个脚本每次只提交不是draft的文件。


## 重新生成md文件 {#重新生成md文件}

目前我是通过ox-hugo来自动将org文件转成md文件，有时候我们将所有的文件重新生成一遍，这时候不需要重新一篇篇文章打开然后导出，ox-hugo里面提供了类似的方法。

同样地，为了方便管理，我fork了ox-hugo，将ox-hugo clone下来，然后修改里面的Makefile文件就可以了:

```sh
git clone --recurse-submodules -j8 https://github.com/vinurs/ox-hugo.git
```

修改的内容如下:

```diff
diff --git a/Makefile b/Makefile
index fc36596..45fe850 100644
--- a/Makefile
+++ b/Makefile
@@ -70,10 +70,12 @@ TEST_ENABLED=0
OX_HUGO_TEST_DIR=$(shell pwd)/test

# Base directory for the Hugo example site
-OX_HUGO_TEST_SITE_DIR=$(OX_HUGO_TEST_DIR)/site
+# OX_HUGO_TEST_SITE_DIR=$(OX_HUGO_TEST_DIR)/site
+OX_HUGO_TEST_SITE_DIR=~/sys-cfg/github/vinurs.github.io

# Directory containing Org files for the test site
-OX_HUGO_TEST_ORG_DIR=$(OX_HUGO_TEST_SITE_DIR)/content-org
+# OX_HUGO_TEST_ORG_DIR=$(OX_HUGO_TEST_SITE_DIR)/content-org
+OX_HUGO_TEST_ORG_DIR=~/sys-cfg/github/pkms
# https://stackoverflow.com/a/3774731/1219634
# Note that the use of immediate assignment := rather than recursive
# assignment = is important here: you do not want to be running the
diff --git a/test/setup-ox-hugo.el b/test/setup-ox-hugo.el
index d58f2db..cc57e42 100644
--- a/test/setup-ox-hugo.el
+++ b/test/setup-ox-hugo.el
@@ -198,6 +198,8 @@ Emacs installation.  If Emacs is installed using
)

(require 'org-id)
+(require 'org-attach)
+
(require 'ox-hugo)
(defun org-hugo-export-all-wim-to-md ()
(org-hugo-export-wim-to-md :all-subtrees nil nil :noerror))
@@ -211,6 +213,9 @@ Emacs installation.  If Emacs is installed using
(with-eval-after-load 'org
;; Allow multiple line Org emphasis markup
;; http://emacs.stackexchange.com/a/13828/115
+
+  (setq org-directory "~/sys-cfg/github/pkms/")
+  (setq org-attach-id-dir (expand-file-name ".attach/" org-directory))
(setcar (nthcdr 4 org-emphasis-regexp-components) 20) ;Up to 20 lines, default is just 1
;; Below is needed to apply the modified `org-emphasis-regexp-components'
;; settings from above.
```

OX\_HUGO\_TEST\_SITE\_DIR就是我们的github.io的目录，OX\_HUGO\_TEST\_ORG\_DIR是我们存放org文件的目录，然后进入ox-hugo目录，执行 `make md` 就可以重新生成。


## 更新历史 {#更新历史}

-   2020-04-25
    -   增加了如何一次性将org文件导出成md

-   2020-04-19
    -   增加了如何用orgmode来管理图片

-   2020-02-14
    -   初稿
