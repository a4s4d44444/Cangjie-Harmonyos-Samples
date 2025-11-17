/**
 * Created on 2025/9/19
 */
package ohos_app_cangjie_entry

import ohos.base.*
import ohos.component.*
import ohos.state_macro_manage.*
import ohos.router.Router
import encoding.json.*

@Entry // 标记这个组件是一个页面入口
@Component
class CulturalItemDetailPage {
    // 1. 定义一个 @State 变量来存储当前页面的文化条目数据
    // 我们会从 Router.getParamsObject() 中解析数据并赋值给它
    @State
    var item: CulturalItem = CulturalItem(
        id: 0,
        title: "加载中...",
        category: CulturalCategory.RevolutionarySite, // 默认值
        era: "",
        shortDescription: "",
        longDescription: "正在加载详细信息，请稍候...",
        imagePath: ""
    )

    // 新增：当前条目的收藏状态
    @State var isFavorite: Bool = false

    // 2. aboutToAppear 生命周期函数：用于接收并解析路由参数
    protected open func aboutToAppear() {
        let params = Router.getParamsObject() // 获取路由传递的参数
        if (params.size() > 0) {
            // 解析从路由参数中传过来的各个字段
            let id = params.get("id").getOrThrow().asInt().getValue()
            let title = params.get("title").getOrThrow().asString().getValue()
            let categoryInt = params.get("category").getOrThrow().asInt().getValue() // 枚举可能以整数形式传递
            let era = params.get("era").getOrThrow().asString().getValue()
            let shortDescription = params.get("shortDescription").getOrThrow().asString().getValue()
            let longDescription = params.get("longDescription").getOrThrow().asString().getValue()
            let imagePath = params.get("imagePath").getOrThrow().asString().getValue()

            // 使用 fromInt() 静态方法将整数转换回枚举类型
            let category: CulturalCategory = CulturalCategory.fromInt(categoryInt)

//            // 将整数转换回枚举类型
//            let category: CulturalCategory = match (categoryInt) {
//                case 0 => CulturalCategory.RevolutionarySite
//                case 1 => CulturalCategory.HeroicFigure
//                case 2 => CulturalCategory.HistoricalEvent
//                case _ => CulturalCategory.RevolutionarySite // 默认值
//            }

            // 更新 @State 变量，触发UI刷新
            this.item = CulturalItem(
                id: id,
                title: title,
                category: category,
                era: era,
                shortDescription: shortDescription,
                longDescription: longDescription,
                imagePath: imagePath
            )

            // 新增：从路由参数中获取初始收藏状态
            let initialIsFavorite = params.get("initialIsFavorite").getOrThrow().asBool().getValue()
            this.isFavorite = initialIsFavorite
        }
    }

    // 3. build 函数：构建详情页的UI布局
    func build() {
        Column() {
            // 顶部标题栏
            Row() {
                Button("< 返回")
                    .onClick({ evt =>
                        var returnParams = JsonObject()
                        returnParams.put("id", JsonInt(this.item.id))
                        returnParams.put("isFavorite", JsonBool(this.isFavorite))
                        Router.back(url: "EntryView", params: returnParams)
                    }) // 点击返回按钮
                Text(this.item.title)
                    .fontSize(22.fp)
                    .fontWeight(FontWeight.Bold)
                    .layoutWeight(1) // 占据剩余空间
                    .textAlign(TextAlign.Center)
                // 新增：收藏按钮
                Button(if (this.isFavorite) { "⭐ 已收藏" } else { "☆ 收藏" })
                    .backgroundColor(if (this.isFavorite) { Color(0xE0CB2C) } else { Color(0xF0F0F0) })
                    .fontColor(if (this.isFavorite) { Color.BLACK } else { Color.GRAY })
                    .fontSize(16.fp)
                    .height(40.vp)
                    .padding(left: 10.vp,right: 10.vp)
                    .borderRadius(20.vp)
                    .onClick({ evt =>
                        this.isFavorite = !this.isFavorite // 切换收藏状态
                    })
            }
            .width(100.percent)
            .height(56.vp)
            .padding(right: 10.vp, left: 10.vp)
            .backgroundColor(Color.WHITE)
            .alignItems(VerticalAlign.Center)

            Scroll() { // 使用 Scroll 组件包裹内容，防止内容溢出
                Column() {
                    // 详情图片
                    Image(this.item.imagePath)
                        .width(100.percent)
                        .height(200.vp)
                        .objectFit(ImageFit.Cover)
                        .margin(bottom: 15.vp)

                    // 标题和年代
                    Text(this.item.title)
                        .fontSize(26.fp)
                        .fontWeight(FontWeight.Bold)
                        .margin(bottom: 5.vp)
                        .textAlign(TextAlign.Start)

                    Text(this.item.era)
                        .fontSize(16.fp)
                        .fontColor(Color.GRAY)
                        .margin(bottom: 15.vp)
                        .textAlign(TextAlign.Start)

                    // 详细介绍
                    Text(this.item.longDescription)
                        .fontSize(18.fp)
                        .fontColor(0x333333)
                        .lineHeight(24.fp) // 行高
                        .textAlign(TextAlign.Start)
                        .padding(bottom: 20.vp) // 底部留白
                }
                .width(95.percent)
                .alignItems(HorizontalAlign.Start) // 内容左对齐
                .padding(top: 15.vp,right: 10.vp,bottom: 15.vp,left:10.vp)
            }
            .width(100.percent)
            .layoutWeight(1) // Scroll 占据剩余空间
        }
        .width(100.percent)
        .height(100.percent)
        .backgroundColor(0xF1F3F5)
        .alignItems(HorizontalAlign.Center)
    }
}