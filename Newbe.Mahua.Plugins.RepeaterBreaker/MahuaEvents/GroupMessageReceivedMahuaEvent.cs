using Newbe.Mahua.MahuaEvents;
using System;
using System.Linq;

namespace Newbe.Mahua.Plugins.RepeaterBreaker.MahuaEvents
{
    public static class Common
    {
        //存储全局静态变量
        public static int repeatTime = 0;   //复读次数，初值为0
        public static string msg = "000";   //截获群消息用于复读行为检测
        public static int repeatExecuate = 5;   //检测复读次数，可通过私戳消息自定义
        public static System.Collections.Generic.List<string> repeaterList = new System.Collections.Generic.List<string>();   //参与复读的复读机名单
        public static int execuateTime = 1;   //禁言时间
        public static int execuateMode = 0;   //执行模式
    }
    /// <summary>
    /// 群消息接收事件
    /// </summary>
    public class GroupMessageReceivedMahuaEvent
        : IGroupMessageReceivedMahuaEvent
    {
        private readonly IMahuaApi _mahuaApi;

        public GroupMessageReceivedMahuaEvent(
            IMahuaApi mahuaApi)
        {
            _mahuaApi = mahuaApi;
        }

        public void ProcessGroupMessage(GroupMessageReceivedContext context)
        {
            
            //throw new NotImplementedException();

            //复读计数器计数，连续两个消息内容相同，计数器+1并将发言的群成员加入复读机成员名单，反之重置计数器和名单
            if (Newbe.Mahua.Plugins.RepeaterBreaker.MahuaEvents.Common.msg == context.Message)
            {
                Newbe.Mahua.Plugins.RepeaterBreaker.MahuaEvents.Common.repeatTime++;
                Newbe.Mahua.Plugins.RepeaterBreaker.MahuaEvents.Common.repeaterList.Add(context.FromQq);
            }
            else
            {
                Newbe.Mahua.Plugins.RepeaterBreaker.MahuaEvents.Common.msg = context.Message;
                Newbe.Mahua.Plugins.RepeaterBreaker.MahuaEvents.Common.repeaterList.Clear();
                Newbe.Mahua.Plugins.RepeaterBreaker.MahuaEvents.Common.repeatTime = 0;
            }

            //复读事件触发，根据执行模式进行禁言操作
            if (Newbe.Mahua.Plugins.RepeaterBreaker.MahuaEvents.Common.repeatTime == Newbe.Mahua.Plugins.RepeaterBreaker.MahuaEvents.Common.repeatExecuate)
            {
                //正常禁言：禁言最后一个发言的复读机
                if (Newbe.Mahua.Plugins.RepeaterBreaker.MahuaEvents.Common.execuateMode==0)
                {
                    _mahuaApi.BanGroupMember(context.FromGroup, context.FromQq, TimeSpan.FromMinutes(Newbe.Mahua.Plugins.RepeaterBreaker.MahuaEvents.Common.execuateTime));
                }

                //随机禁言：从复读机名单中随机选择一个禁言
                if (Newbe.Mahua.Plugins.RepeaterBreaker.MahuaEvents.Common.execuateMode == 1)
                {
                    Random ran = new Random();
                    int RandKey = ran.Next(0, Newbe.Mahua.Plugins.RepeaterBreaker.MahuaEvents.Common.repeaterList.Count()-1);
                    _mahuaApi.BanGroupMember(context.FromGroup, Newbe.Mahua.Plugins.RepeaterBreaker.MahuaEvents.Common.repeaterList[RandKey], TimeSpan.FromMinutes(Newbe.Mahua.Plugins.RepeaterBreaker.MahuaEvents.Common.execuateTime));
                }

                //强力禁言：禁言在复读机名单中的额所有人
                if(Newbe.Mahua.Plugins.RepeaterBreaker.MahuaEvents.Common.execuateMode==2)
                {
                    for(int k=0; k<=Newbe.Mahua.Plugins.RepeaterBreaker.MahuaEvents.Common.repeaterList.Count; k++)
                    {
                        _mahuaApi.BanGroupMember(context.FromGroup, Newbe.Mahua.Plugins.RepeaterBreaker.MahuaEvents.Common.repeaterList[k], TimeSpan.FromMinutes(Newbe.Mahua.Plugins.RepeaterBreaker.MahuaEvents.Common.execuateTime));
                    }
                }

                //重置计数器和复读机名单
                Newbe.Mahua.Plugins.RepeaterBreaker.MahuaEvents.Common.repeatTime = 0;
                Newbe.Mahua.Plugins.RepeaterBreaker.MahuaEvents.Common.repeaterList.Clear();
            }
           
            // 不要忘记在MahuaModule中注册
            }
    }
}
