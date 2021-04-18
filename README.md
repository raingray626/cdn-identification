# cdn-identification

本项目通过 [cdn](https://github.com/SukkaLab/cdn) 数据进行扩展，识别 CDN。

在日常端口扫描时，需要进行 CDN 识别，避免浪费时间扫描 CDN IP，目前识别有以下方案可以选择：

1. 查询 IP 归属组织
2. 第三方在线服务
3. 域名 CNAME 指向
4. HTTP 响应 Server 字段

最终发现 CNAME 稍微比起其他方案靠谱些。因为国内使用 CDN 产品，会配置时会让你填入要加速的域名和 IP，之后系统给分配一个 CDN 域名，让把自己的域名 CNAME 指向它。


# Usage

下载脚本及离线数据

```
git clone https://github.com/gbbsec/cdn-identification.git
```

当作脚本运行。

检查成功时会回显 `raw_domain,cdn_name`，不存在会返回 `raw_domain,cname_domain,null`。

```
cd cdn-identification && sh cdn_identification.sh valid_domain.txt 

csgo.wanmei.com,网宿 CDN
wulin2.wanmei.com,wanmei.com,null
www.laohu.com,网宿 CDN
www.ledo.wanmei.com,wanmei.com,null
wx.launcher.d.wanmei.com,网宿 CDN
x3g.wanmei.com,wanmei.com,null
xa.games.wanmei.com,网宿 CDN
xajh.wanmei.com,wanmei.com,null
xa.wanmei.com,网宿 CDN
xmhzx.wanmei.com,wanmei.com,null
xmz.wanmei.com,wanmei.com,null
xsgol.wanmei.com,wanmei.com,null
xsg.wanmei.com,wanmei.com,null
yeyou.bbs.wanmei.com,wanmei.com,null
ylz.wanmei.com,网宿 CDN
zero.wanmei.com,wanmei.com,null
zhizuoren.wanmei.com,wanmei.com,null
zhuxian2.wanmei.com,wanmei.com,null
zhuxian3.wanmei.com,wanmei.com,null
...
```

或者加入 `.bash_profile` 像命令一样调用。

```shell
echo -e '\n# CDN 识别\ncdn_identification() {\n    for d in $(sort -u ${1})\n    do\n        check_domain=$(host -t cname $d | grep "is an alias for" | awk "{print $6}" | gawk '\'BEGIN{FS=\".\"\; OFS=\".\"} {print $\(NF-2\),$\(NF-1\)}\'')\n\n        if [[ -z $check_domain ]]; then\n            continue\n\n        fi\n\n        check_status=$(jq -r ".[\"${check_domain}\"].name" ./cdn.json)\n        if [[ $check_status != 'null' ]]; then\n            echo $d,$check_status\n        else\n            echo  "$d,$check_domain,$check_status"\n        fi\n    done\n}' >> $HOME/.bash_profile
```

加载函数到当前环境变量中。

```
. $HOME/.bash_profile
```

运行时给出域名和 cdn.json 数据位置即可。:wink:

```
cdn_identification valid_domain.txt cdn.json

csgo.wanmei.com,网宿 CDN
wulin2.wanmei.com,wanmei.com,null
www.laohu.com,网宿 CDN
www.ledo.wanmei.com,wanmei.com,null
wx.launcher.d.wanmei.com,网宿 CDN
x3g.wanmei.com,wanmei.com,null
xa.games.wanmei.com,网宿 CDN
xajh.wanmei.com,wanmei.com,null
xa.wanmei.com,网宿 CDN
xmhzx.wanmei.com,wanmei.com,null
xmz.wanmei.com,wanmei.com,null
xsgol.wanmei.com,wanmei.com,null
xsg.wanmei.com,wanmei.com,null
yeyou.bbs.wanmei.com,wanmei.com,null
ylz.wanmei.com,网宿 CDN
zero.wanmei.com,wanmei.com,null
zhizuoren.wanmei.com,wanmei.com,null
zhuxian2.wanmei.com,wanmei.com,null
```

# Note

目前 [cdn.json](https://github.com/gbbsec/cdn-identification/blob/main/cdn.json) 还不完整，如果有不在列表内的 CDN 域名欢迎提 ISSUS。
