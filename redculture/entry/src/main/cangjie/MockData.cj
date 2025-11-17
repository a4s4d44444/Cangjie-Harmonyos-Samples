/**
 * Created on 2025/9/18
 */
package ohos_app_cangjie_entry

let mockCulturalItems: Array<CulturalItem> = [
    // --- 革命圣地 ---
    CulturalItem(
        id: 101,
        title: "延安革命根据地",
        category: CulturalCategory.RevolutionarySite,
        era: "1935-1948",
        shortDescription: "中国革命的指导中心和总后方。",
        longDescription: "延安是1935年至1948年中共中央的所在地，被视为中国革命的圣地。在此期间，党中央领导了抗日战争和解放战争，奠定了新中国的基础。",
        imagePath: "resource://app/media/site_yanan.png"
    ),
    CulturalItem(
        id: 102,
        title: "井冈山革命根据地",
        category: CulturalCategory.RevolutionarySite,
        era: "1927-1930",
        shortDescription: "中国第一个农村革命根据地。",
        longDescription: "井冈山革命根据地的建立，开辟了“以农村包围城市、武装夺取政权”的正确革命道路，被誉为“中国革命的摇篮”。",
        imagePath: "resource://app/media/site_jinggangshan.png"
    ),

    // --- 英雄人物 ---
    CulturalItem(
        id: 201,
        title: "雷锋",
        category: CulturalCategory.HeroicFigure,
        era: "1940-1962",
        shortDescription: "伟大的共产主义战士，全心全意为人民服务的楷模。",
        longDescription: "雷锋在他短暂的一生中助人无数，他“毫不利己，专门利人”的崇高品质，激励了一代又一代中国人。雷锋精神成为了中华民族宝贵的精神财富。",
        imagePath: "resource://app/media/figure_leifeng.png"
    ),
    CulturalItem(
        id: 202,
        title: "焦裕禄",
        category: CulturalCategory.HeroicFigure,
        era: "1922-1964",
        shortDescription: "县委书记的榜样，“人民的好干部”。",
        longDescription: "焦裕禄在担任河南兰考县委书记期间，为治理“三害”（内涝、风沙、盐碱）鞠躬尽瘁，死而后已。他“心中装着全体人民，唯独没有他自己”的公仆情怀，至今仍被广为传颂。",
        imagePath: "resource://app/media/figure_jiaoyulu.png"
    ),

    // --- 历史事件 ---
    CulturalItem(
        id: 301,
        title: "红军长征",
        category: CulturalCategory.HistoricalEvent,
        era: "1934-1936",
        shortDescription: "一次伟大的战略转移，播下了革命的火种。",
        longDescription: "长征是人类历史上的伟大奇迹，中国工农红军以无与伦比的英雄气概，克服了重重艰难险阻，完成了伟大的战略转移，为中国革命的胜利奠定了坚实基础。",
        imagePath: "resource://app/media/event_longmarch.png"
    )
]