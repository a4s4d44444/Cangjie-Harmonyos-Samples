package ohos_app_cangjie_entry

internal import ohos.base.*
internal import ohos.component.*
internal import ohos.state_manage.*
import ohos.state_macro_manage.*
import ohos.component.*
import std.collection.ArrayList
import std.collection.HashSet
import ohos.router.Router
import ohos.hilog.Hilog

@Entry
@Component
class EntryView {

    // 1. 持久化设置：存储收藏的 CulturalItem 的 ID 列表
    let p = PersistentStorage.persistProp("favoriteItemIdsJson", "[]")
    @StorageLink["favoriteItemIdsJson"]
    var favoriteItemIdsJson: String = "[]"


    // 1. 定义一个 @State 变量来控制当前选中的 Tab 索引
    @State
    var selectedTabIdx: Int32 = 0 // 默认选中第一个 Tab (革命圣地)

    // 2. 将模拟数据引入，以便后续使用
    // 注意：这里的 allCulturalItems 暂时直接使用 mockCulturalItems，
    // 后续会替换为从持久化存储加载的数据
    var allCulturalItems: Array<CulturalItem> = mockCulturalItems

    var controller: TabsController = TabsController()

    // 新增三个 @State 变量，用于存放分类后的列表
    @State
    var revolutionarySites: Array<CulturalItem> = []
    @State
    var heroicFigures: Array<CulturalItem> = []
    @State
    var historicalEvents: Array<CulturalItem> = []

    // 新增：存储所有收藏的 CulturalItem 对象
    @State
    var favoriteItems: Array<CulturalItem> = []
    // 新增：存储收藏的 CulturalItem ID 集合，方便快速查找是否已收藏
    @State
    var favoriteItemIds: HashSet<Int64> = HashSet<Int64>()

    @State
    var aaa: String = "1"


    // 辅助函数：更新收藏列表（将 ID 转换为完整 CulturalItem 对象）
    func updateFavoriteItemsList() {
        var tempFavorites = ArrayList<CulturalItem>()
        for (item in this.allCulturalItems) {
            if (this.favoriteItemIds.contains(item.id)) {
                tempFavorites.append(item)
            }
        }
        this.favoriteItems = tempFavorites.toArray()
        aaa += "1"
        Hilog.error(0xFF00, "LogExample", "favoriteItems："+favoriteItems.size.toString())
    }

    // 新增 aboutToAppear 生命周期函数
    protected open func aboutToAppear(){

        // 首次加载时，从持久化存储中读取收藏ID列表
        let loadedIds = DataStore.jsonStringToFavoriteIds(this.favoriteItemIdsJson)
        for (id in loadedIds) {
            this.favoriteItemIds.put(id)
        }
        // 临时的列表变量
        var sites = ArrayList<CulturalItem>()
        var figures = ArrayList<CulturalItem>()
        var events = ArrayList<CulturalItem>()

        // 遍历所有模拟数据
        for (item in this.allCulturalItems) {
            match (item.category) {
                case CulturalCategory.RevolutionarySite => sites.append(item)
                case CulturalCategory.HeroicFigure => figures.append(item)
                case CulturalCategory.HistoricalEvent => events.append(item)
            }
        }

        // 将分类好的数据赋值给 @State 变量，这将触发UI更新
        this.revolutionarySites = sites.toArray()
        this.heroicFigures = figures.toArray()
        this.historicalEvents = events.toArray()
    }

    protected open func onPageShow(){
        // 每次页面显示时，都检查是否有从详情页返回的收藏状态更新
        let params = Router.getParamsObject()
        if (params.size() > 0) {
            let itemId = params.get("id").getOrThrow().asInt().getValue()
            let isFavorite = params.get("isFavorite").getOrThrow().asBool().getValue()

            if (isFavorite) {
                this.favoriteItemIds.put(itemId)
            } else {
                this.favoriteItemIds.remove(itemId)
            }

            // 更新持久化存储
            this.favoriteItemIdsJson = DataStore.favoriteIdsToJsonString(this.favoriteItemIds.toArray())
        }
        Hilog.error(0xFF00, "LogExample", "onPageShow")
        // 每次 aboutToAppear 结束时，都根据最新的 favoriteItemIds 更新 favoriteItems 列表
        this.updateFavoriteItemsList()
    }

    // 3. build 函数：构建 Tabs 页面结构
    func build() {
        Column() {
            Text("红色文化数字展示平台")
                .fontSize(28.fp)
                .fontWeight(FontWeight.Bold)
                .margin(top: 20.vp, bottom: 20.vp)

            Tabs(BarPosition.Start, this.controller) {
                // 第一个 Tab：革命圣地
                TabContent() {
                    // 将占位 Text 替换为我们的自定义列表组件
                    CulturalItemListView(items: this.revolutionarySites, favoriteItemIds: this.favoriteItemIds)
                }
                .tabBar("革命圣地")

                // 第二个 Tab：英雄人物
                TabContent() {
                    // 传入英雄人物列表
                    CulturalItemListView(items: this.heroicFigures, favoriteItemIds: this.favoriteItemIds)
                }
                .tabBar("英雄人物")

                // 第三个 Tab：历史事件
                TabContent() {
                    // 传入历史事件列表
                    CulturalItemListView(items: this.historicalEvents, favoriteItemIds: this.favoriteItemIds)
                }
                .tabBar("历史事件")

                // 新增：我的收藏标签页
                TabContent() {
                    CulturalItemListView(items: this.favoriteItems, favoriteItemIds: this.favoriteItemIds)
//                    Text(aaa)
                }
                .tabBar("我的收藏")

            }
            .barMode(BarMode.Fixed) // 固定模式，Tab 不可滚动
            .barWidth(100.percent)
            .barHeight(50.vp)
            .onChange({ index: Int32 =>
                this.selectedTabIdx = index // 更新选中索引
                // 当切换到收藏页或从收藏页切走时，刷新收藏列表，确保数据最新
                this.updateFavoriteItemsList()

            })
            .width(100.percent)
            .height(100.percent)
        }
        .width(100.percent)
        .height(100.percent)
        .backgroundColor(0xF1F3F5)
        .alignItems(HorizontalAlign.Center)
    }
}
