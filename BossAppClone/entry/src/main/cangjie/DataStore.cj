/**
 * Created on 2025/9/18
 */
package ohos_app_cangjie_entry

import std.io.ByteArrayStream
import encoding.json.*
import serialization.serialization.*
import std.collection.ArrayList
import serialization.serialization.DataModel

class DataStore {
    // 将 Array<JobPosting> 转换为 JSON String
    public static func jobsToJsonString(jobs: Array<JobPosting>): String {
        // 1. 手动实现第一个 map：将 Array<JobPosting> 转换为 Array<DataModel>
        var dataModels = ArrayList<DataModel>()
        for (job in jobs) {
            dataModels.append(job.serialize())
        }

        // 2. 手动实现第二个 map：将 Array<DataModel> 转换为 Array<JsonValue>
        var jsonValues = ArrayList<JsonValue>()
        for (dm in dataModels) {
            jsonValues.append(dm.toJson())
        }

        // 后续逻辑不变
        let jsonArray = JsonArray(jsonValues)
        return jsonArray.toString()
    }

    // 将 JSON String 转换为 Array<JobPosting>
    public static func jsonStringToJobs(jsonStr: String): Array<JobPosting> {
        if (jsonStr.size <= 2) {
            return [] // 如果是空数组 "[]" 或无效字符串，返回空列表
        }

        let jsonValue = JsonValue.fromStr(jsonStr)
        let jsonArray = (jsonValue as JsonArray).getOrThrow()

        var jobs = ArrayList<JobPosting>()
        // 使用索引式 for 迴圈來遍歷 JsonArray
        for (i in 0..jsonArray.size()) {
            let jsonVal = jsonArray[i] // 透過索引取得每一個 JsonValue
            let dm = DataModel.fromJson(jsonVal)
            jobs.append(JobPosting.deserialize(dm))
        }
        return jobs.toArray()
    }
}