# QQbot-RepeaterBreaker
基于Newbe.Mahua.Framework开发的QQ机器人，可以检测QQ群中的复读行为并禁言相关的群成员
Newbe.Mahua.Framework项目地址：https://github.com/newbe36524/Newbe.Mahua.Framework
感谢Newbe编写的这个SDK和相应的教程！

# 主要功能
顾名思义，Repeater Breaker是专门针对QQ群中的复读现象开发的检测机器人，是各位群主治理复读机的辅助工具

# 使用方法
运行build.bat可以生成用于不同机器人平台的插件，让相应的QQ机器人加载插件即可使用，详情参考Newbe的技术教程http://www.newbe.pro/docs/mahua/2018/06/10/Begin-First-Plugin-With-Mahua-In-v1.9.html
建议一个机器人只接管一个QQ群，现在还没有添加同时管理多个群的功能（如果一个机器人在多个QQ群中，不同QQ群的消息会打断复读计数）

# 功能设置
为了满足各种不同的检测和禁言需求，本机器人允许调整一些参数
添加运行有Repeater Breaker的QQ为好友，向其发送特定消息即可改变这些参数
repeatTime=X：禁言所需的复读次数，建议使用3-10内的整数
banTime=X：实施禁言的时间，单位分钟
modeSet=X：调整执行模式，可以只禁言最后一个复读机、随机禁言一个复读机和禁言所有复读机

# TODO
尝试缩短处理消息接收事件的延迟
探明消息撤回对复读计数的影响
优化随机禁言功能
