namespace Newbe.Mahua.Plugins.RepeaterBreaker
{
    /// <summary>
    /// 本插件的基本信息
    /// </summary>
    public class PluginInfo : IPluginInfo
    {
        /// <summary>
        /// 版本号，建议采用 主版本.次版本.修订号 的形式
        /// </summary>
        public string Version { get; set; } = "1.1.0";

        /// <summary>
        /// 插件名称
        /// </summary>

        public string Name { get; set; } = "RepeaterBreaker";

        /// <summary>
        /// 作者名称
        /// </summary>
        public string Author { get; set; } = "Ciniki";

        /// <summary>
        /// 插件Id，用于唯一标识插件产品的Id，至少包含 AAA.BBB.CCC 三个部分
        /// </summary>
        public string Id { get; set; } = "Newbe.Mahua.Plugins.RepeaterBreaker";

        /// <summary>
        /// 插件描述
        /// </summary>
        public string Description { get; set; } = "本着让复读更有意义的原则，该插件可以根据各种条件识别出复读机并将其禁言，让复读紧张又刺激";
    }
}
