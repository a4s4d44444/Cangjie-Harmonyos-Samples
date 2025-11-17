/**
 * Created on 2025/9/11
 */
package ohos_app_cangjie_entry
import ohos.base.CJResource
import serialization.serialization.Serializable
import serialization.serialization.DataModel
import serialization.serialization.DataModelStruct
import serialization.serialization.field


public class JobPosting<: Serializable<JobPosting> {
    var id: Int64 = 0
    var title: String = ""
    var companyName: String = ""
    var city: String = ""
    var salaryRange: String = ""
    var description: String = ""
    var recruiterName: String = ""
    var recruiterAvatarPath: String = ""
    public init() {} // 提供一个无参构造函数
    public init(
        id!: Int64,
        title!: String,
        companyName!: String,
        city!: String,
        salaryRange!: String,
        description!: String,
        recruiterName!: String,
        recruiterAvatarPath!: String
    ) {
        this.id = id
        this.title = title
        this.companyName = companyName
        this.city = city
        this.salaryRange = salaryRange
        this.description = description
        this.recruiterName = recruiterName
        this.recruiterAvatarPath = recruiterAvatarPath
    }

    // 在这里添加静态函数
    public static func empty(): JobPosting {
        return JobPosting(
            id: -1,
            title: "加载中...",
            companyName: "",
            city: "",
            salaryRange: "",
            description: "",
            recruiterName: "",
            recruiterAvatarPath: ""
        )
    }

    // 实现 serialize 方法，将对象转换为 DataModel
    public func serialize(): DataModel {
        return DataModelStruct()
            .add(field<Int64>("id", this.id))
            .add(field<String>("title", this.title))
            .add(field<String>("companyName", this.companyName))
            .add(field<String>("city", this.city))
            .add(field<String>("salaryRange", this.salaryRange))
            .add(field<String>("description", this.description))
            .add(field<String>("recruiterName", this.recruiterName))
            .add(field<String>("recruiterAvatarPath", this.recruiterAvatarPath))
    }

    // 实现 deserialize 方法，从 DataModel 创建对象
    public static func deserialize(dm: DataModel): JobPosting {
        let dms = match (dm) {
            case data: DataModelStruct => data
            case _ => throw Exception("DataModel is not a Struct")
        }
        let result = JobPosting()
        result.id = Int64.deserialize(dms.get("id"))
        result.title = String.deserialize(dms.get("title"))
        result.companyName = String.deserialize(dms.get("companyName"))
        result.city = String.deserialize(dms.get("city"))
        result.salaryRange = String.deserialize(dms.get("salaryRange"))
        result.description = String.deserialize(dms.get("description"))
        result.recruiterName = String.deserialize(dms.get("recruiterName"))
        result.recruiterAvatarPath = String.deserialize(dms.get("recruiterAvatarPath"))
        return result
    }
}