+++
title = "navicat无限试用"
author = ["vinurs"]
summary = "navicat无限试用"
date = 2021-03-03
expiryDate = 2999-01-01
lastmod = 2100-12-21T00:00:00+00:00
tags = ["navicat", "weixin-mp"]
draft = false
from = "orgmode"
+++

在mac上面目前我用的最舒服的数据库连接工具就是navicat了，无奈太贵了，暂时买不起正版。

<!--more-->

最新的破解版有个无法保存密码的缺陷，这是不能忍受的，后来发现每次卸载完了以后重新安装都可以重新试用，因此我就想他是根据什么来判断的呢？经过了几次尝试终于找出来了。


## 重置试用时间 {#重置试用时间}

navicat的试用时间是14天，通过下面的办法每次试用期到了以后然后进行修改就可以继续试用了，一个月弄两次，还是挺划算的

1.  删除注册表

    ```sh
    open ~/Library/Preferences/com.prect.NavicatPremium15.plist
    ```

    可以看到注册表里面有下面的字段，直接删除标红部分的内容

    {{< figure src="/ox-hugo/_20210303_102425screenshot.png" width="100%" >}}

2.  删除隐藏文件

    ```sh
    cd ~/Library/Application\ Support/PremiumSoft\ CyberTech/Navicat\ CC/Navicat\ Premium/
    ls -a
    # ls这个文件里面的隐藏文件，然后删除
    rm -rf .2F2BC7C7BDECBE678625ECBFE554EF07
    ```

    **注意** 这里的隐藏文件名可能不一样，反正删除掉下面的类似隐藏文件名就可以了。


## 更新历史 {#更新历史}


### 2021/03/03 {#2021-03-03}

-   初稿
