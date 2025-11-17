/**
 * Created on 2025/9/19
 */
package ohos_app_cangjie_entry

import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
import ohos.router.Router
import encoding.json.*
import ohos.ark_interop.JSValue
import std.collection.HashSet

@Component
class CulturalItemListView {
    // 1. 定义一个输入属性，用于接收要展示的数据列表
    // 父组件（例如 index.cj）在创建这个视图时，必须给它传递一个 Array<CulturalItem>
    @State
    var items: Array<CulturalItem>  = []
    // 新增：接收主页传来的收藏ID集合，用于判断当前条目是否已收藏
    @State
    var favoriteItemIds: HashSet<Int64> = HashSet<Int64>() // from EntryView



    func build() {
        // 2. 使用 List 和 ForEach 构建动态列表
        List(space: 10) {
            ForEach(
                this.items,
                itemGeneratorFunc: { item: CulturalItem, index: Int64 =>
                    ListItem() {

                        // 3. 为每个列表项设计一个“图片在左，文字在右”的布局
                        Row() {
                            // 左侧图片
                            Image(item.imagePath)
                                .size(width: 80.vp, height: 80.vp)
                                .borderRadius(8.vp)
                                .objectFit(ImageFit.Cover) // 确保图片不变形地填满区域

                            // 右侧文字区域
                            Column() {
                                Text(item.title)
                                    .fontSize(18.fp)
                                    .fontWeight(FontWeight.Bold)

                                Text(item.era)
                                    .fontSize(14.fp)
                                    .fontColor(Color.GRAY)
                                    .margin(top: 5.vp)

                                Text(item.shortDescription)
                                    .fontSize(15.fp)
                                    .fontColor(0x333333)
                                    .margin(top: 8.vp)
                            }
                            .alignItems(HorizontalAlign.Start) // 文字列左对齐
                            .padding(left: 12.vp)
                        }
                        .width(100.percent)
                        .padding(10.vp)
                        .backgroundColor(Color.WHITE)
                        .borderRadius(12.vp)
                    }
                    // 在这里添加点击事件
                    .onClick({ evt =>
                        // 1. 将 CulturalItem 对象打包成 JsonObject
                        var params = JsonObject()
                        params.put("id", JsonInt(item.id))
                        params.put("title", JsonString(item.title))
                        params.put("category", JsonInt(item.category.toInt())) // 枚举转为整数传递
                        params.put("era", JsonString(item.era))
                        params.put("shortDescription", JsonString(item.shortDescription))
                        params.put("longDescription", JsonString(item.longDescription))
                        params.put("imagePath", JsonString(item.imagePath))

                        // 新增：传递当前条目的初始收藏状态
                        params.put("initialIsFavorite", JsonBool(this.favoriteItemIds.contains(item.id)))

                        // 2. 使用 Router.push 跳转到详情页
                        Router.push(url: "CulturalItemDetailPage", params: params)
                    })
                },
                keyGeneratorFunc: { item: CulturalItem, index: Int64 =>
                    return item.id.toString()
                }
            )
        }
        .width(95.percent)
    }
}