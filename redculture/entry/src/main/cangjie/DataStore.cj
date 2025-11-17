/**
 * Created on 2025/9/19
 */
package ohos_app_cangjie_entry

import std.io.ByteArrayStream
import encoding.json.*
import serialization.serialization.*
import std.collection.ArrayList

class DataStore {
    // 将 Array<Int64> (收藏ID列表) 转换为 JSON String
    public static func favoriteIdsToJsonString(ids: Array<Int64>): String {
        var jsonValues = ArrayList<JsonValue>()
        for (id in ids) {
            jsonValues.append(JsonInt(id))
        }
        let jsonArray = JsonArray(jsonValues)
        return jsonArray.toString()
    }

    // 将 JSON String 转换为 Array<Int64> (收藏ID列表)
    public static func jsonStringToFavoriteIds(jsonStr: String): Array<Int64> {
        if (jsonStr.size <= 2) { // 检查是否是空数组 "[]" 或无效字符串
            return []
        }

        let jsonValue = JsonValue.fromStr(jsonStr)
        let jsonArray = (jsonValue as JsonArray).getOrThrow() // 确保是 JsonArray

        var ids = ArrayList<Int64>()
        for (i in 0..jsonArray.size()) {
            let jsonVal = jsonArray[i]
            let id = jsonVal.asInt().getValue() // 确保是 JsonInt
            ids.append(id)
        }
        return ids.toArray()
    }
}