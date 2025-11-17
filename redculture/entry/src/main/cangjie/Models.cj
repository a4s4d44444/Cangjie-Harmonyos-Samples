/**
 * Created on 2025/9/18
 */
package ohos_app_cangjie_entry
import serialization.serialization.*

// 1. 定义一个枚举，用于表示文化展品的分类
public enum CulturalCategory {
    | RevolutionarySite // 革命圣地 (对应整数 0)
    | HeroicFigure      // 英雄人物 (对应整数 1)
    | HistoricalEvent   // 历史事件 (对应整数 2)

    // 新增：将枚举转换为 Int32
    public func toInt(): Int64 {
        match (this) {
            case CulturalCategory.RevolutionarySite => return 0
            case CulturalCategory.HeroicFigure => return 1
            case CulturalCategory.HistoricalEvent => return 2
        }
    }

    // 新增：从 Int32 转换为枚举
    public static func fromInt(value: Int64): CulturalCategory {
        match (value) {
            case 0 => return CulturalCategory.RevolutionarySite
            case 1 => return CulturalCategory.HeroicFigure
            case 2 => return CulturalCategory.HistoricalEvent
            case _ => return CulturalCategory.RevolutionarySite // 默认值或错误处理
        }
    }
}

// 2. 定义核心的数据类：文化展品 (CulturalItem)
public class CulturalItem <: Serializable<CulturalItem> {
    let id: Int64
    let title: String
    let category: CulturalCategory
    let era: String // 所属年代
    let shortDescription: String // 简短描述，用于列表页
    let longDescription: String  // 详细介绍，用于详情页
    let imagePath: String        // 图片资源路径

    public init(
        id!: Int64,
        title!: String,
        category!: CulturalCategory,
        era!: String,
        shortDescription!: String,
        longDescription!: String,
        imagePath!: String
    ) {
        this.id = id; this.title = title; this.category = category; this.era = era;
        this.shortDescription = shortDescription; this.longDescription = longDescription;
        this.imagePath = imagePath;
    }

    // 实现 serialize 方法，将对象转换为 DataModel
    public func serialize(): DataModel {
        return DataModelStruct()
            .add(field<Int64>("id", this.id))
            .add(field<String>("title", this.title))
            .add(field<Int64>("category", this.category.toInt())) // 枚举序列化为整数
            .add(field<String>("era", this.era))
            .add(field<String>("shortDescription", this.shortDescription))
            .add(field<String>("longDescription", this.longDescription))
            .add(field<String>("imagePath", this.imagePath))
    }

    // 实现 deserialize 方法，从 DataModel 创建对象
    public static func deserialize(dm: DataModel): CulturalItem {
        let dms = match (dm) {
            case data: DataModelStruct => data
            case _ => throw Exception("DataModel is not a Struct")
        }

        let id = Int64.deserialize(dms.get("id"))
        let title = String.deserialize(dms.get("title"))
        let categoryInt = Int64.deserialize(dms.get("category"))
        let era = String.deserialize(dms.get("era"))
        let shortDescription = String.deserialize(dms.get("shortDescription"))
        let longDescription = String.deserialize(dms.get("longDescription"))
        let imagePath = String.deserialize(dms.get("imagePath"))

        let category = CulturalCategory.fromInt(categoryInt) // 整数反序列化为枚举

        return CulturalItem(
            id: id,
            title: title,
            category: category,
            era: era,
            shortDescription: shortDescription,
            longDescription: longDescription,
            imagePath: imagePath
        )
    }
}