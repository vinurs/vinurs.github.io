+++
title = "利其器─Emacs/orgmode插入图片"
author = ["vinurs"]
summary = "在orgmode里面如何更加方便地插入图片"
date = 2020-10-04
expiryDate = 2999-01-01
lastmod = 2100-12-21T00:00:00+00:00
tags = ["利其器", "Emacs", "OrgMode"]
draft = false
from = "orgmode"
+++

用orgmode来记笔记免不了要插入图片，在用其它的编辑器的时候想插入图片一般都有下面机种途径：

-   截图粘贴
-   复制网址
-   复制图片
-   通过系统文件夹来进行选择
-   直接拖拽

那么在orgmode里面我们是不是也能很方便地进行图片的插入呢？

<!--more-->


## 截图粘贴 {#截图粘贴}

在doom里面，通过 `org-download-screenshot` 就可以进行截图，然后就会自动copy到当前位置。当然了，这个功能其实是[org-download](https://github.com/abo-abo/org-download)提供的。

{{< figure src="/ox-hugo/_20210103_122145screenshot.png" width="100%" >}}

截好的图片会自动存放在 `.attach` 目录下面。

**注意** 不过我一般不用这里的截图方式，我用别的截图方式以后copy到剪切板，然后用下面的[复制网址/复制图片](#复制网址-复制图片)来进行粘贴


## 复制网址/复制图片 {#复制网址-复制图片}

插入一个网络上的图片的时候，我们只需要复制这个图片的网址，然后通过 `org-download-yank` 就可以了，org-download会自动为我们下载这个图片。

但是，其实我们一般不用这么复杂，直接拷贝网络上的图片，然后通过 `org-download-clipboard (SPC m a p)` 来进行粘贴就可以了。

{{< figure src="/ox-hugo/_20210103_122331screenshot.png" width="50%" >}}

不过对于这种插入进来的图片orgmode好像不会显示图片，只会显示成附件，所以我们需要执行一次 `org-display-inline-images` 来进行显示。

所以，这里为了方便起见，写了一个小函数来自动执行这个功能

```emacs-lisp
(defun org-mode-after-save-hook()
  "do sth after save hook in org mode major"
  (when (eq major-mode 'org-mode)
    (progn
      (org-display-inline-images t))))

(add-hook 'after-save-hook 'org-mode-after-save-hook)
```


## 直接拖拽 {#直接拖拽}

{{< figure src="/ox-hugo/_20210103_122352ikyq0erbl2o.jpg" width="50%" >}}

这个功能doom里面也已经为我们集成了，直接打开finder，把图片拖拽进emacs就可以了。

不过这个还是不够方便，最好能直接copy然后在emacs里面粘贴就可以了，这样最方便。


## 更新历史 {#更新历史}


### 2020/10/04 {#2020-10-04}

-   初稿
