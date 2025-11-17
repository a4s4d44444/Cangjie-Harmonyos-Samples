package ohos_app_cangjie_entry

import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
import encoding.json.JsonObject
import encoding.json.JsonInt
import encoding.json.JsonString
import ohos.router.Router
import ohos.hilog.Hilog
import std.collection.ArrayList
import ohos.display.*
import encoding.json.JsonNull


struct WindowRectangle {
    let width: Int64
    let height: Int64

    public init(width: Int64, height: Int64) {
        this.width = width
        this.height = height
    }
}

@Entry
@Component
class EntryView {

    // 1. 设置持久化属性。这行代码会在应用启动时，建立 AppStorage 和本地文件的连接。
    // "allJobsJson" 是我们在本地文件中存储的 Key。
    // "[]" 是默认值，表示如果本地文件没存过，就返回一个空的JSON数组字符串。
    let p = PersistentStorage.persistProp("allJobsJson", "[]")

    // 2. 使用 @StorageLink 链接到 AppStorage 中的 "allJobsJson" 属性。
    // 之后任何对 allJobsJson 变量的修改，都会被 PersistentStorage 自动保存到磁盘。
    @StorageLink["allJobsJson"]
    var allJobsJson: String = "[]"

    // 状态变量分离
    // allJobs 作为原始数据源，加载后不再轻易改变
    @State
    var allJobs: ObservedArrayList<JobPosting> = ObservedArrayList<JobPosting>(mockJobList)
    // displayedJobs 专门用于UI展示，它的内容会根据搜索而改变
    @State
    var displayedJobs: Array<JobPosting> = []

    @State
    var searchKeyword: String = ""

    // 新增一个标志，确保只在首次加载时从存储中读取数据
    var isLoaded: Bool = false

    // 新增：从 allJobsJson 反序列化，加载数据到 allJobs
    func loadJobsFromStorage() {
        let loadedJobs = DataStore.jsonStringToJobs(this.allJobsJson)
        if (loadedJobs.isEmpty()) {
            // 如果存储为空，则加载模拟数据作为初始数据
            this.allJobs = ObservedArrayList<JobPosting>(mockJobList)
            // 第一次加载模拟数据后，立即保存一次
            this.saveJobsToStorage()
        } else {
            this.allJobs = ObservedArrayList<JobPosting>(loadedJobs)
        }
    }

    // 新增：将 allJobs 序列化，保存到 allJobsJson
    func saveJobsToStorage() {
        // 更新 @StorageLink 变量，数据会自动被持久化
        this.allJobsJson = DataStore.jobsToJsonString(this.allJobs.get().toArray())
    }




        //在页面即将显示时，初始化展示列表
    protected open func aboutToAppear() {
        // 5.1. 确保只在应用首次启动时，从磁盘加载一次数据
        if (!this.isLoaded) {
            this.loadJobsFromStorage()
            this.isLoaded = true
        }
        // 初始状态下，展示所有职位
        this.displayedJobs = this.allJobs.get().toArray()

    }
    protected open func onPageShow(){
        // 1. 检查是否有从下一页返回的数据
        let newJobJson = Router.getParamsObject()
        newJobJson.size()
        Hilog.error(0xFF00, "LogExample", "newJobJson:"+newJobJson.toString())
        if(newJobJson.size()>0){
            Hilog.error(0xFF00, "LogExample", "newJobJson2:"+newJobJson.toString())
            // 如果有数据，则解析并添加到 allJobs 列表顶部
            let id = newJobJson.get("id").getOrThrow().asInt().getValue()
            let title = newJobJson.get("title").getOrThrow().asString().getValue()
            let companyName = newJobJson.get("companyName").getOrThrow().asString().getValue()
            let city = newJobJson.get("city").getOrThrow().asString().getValue()
            let salaryRange = newJobJson.get("salaryRange").getOrThrow().asString().getValue()
            let description = newJobJson.get("description").getOrThrow().asString().getValue()
            let recruiterName = newJobJson.get("recruiterName").getOrThrow().asString().getValue()
            let recruiterAvatarPath = newJobJson.get("recruiterAvatarPath").getOrThrow().asString().getValue()

            let newItem = JobPosting(
                id: id, title: title, companyName: companyName, city: city,
                salaryRange: salaryRange, description: description, recruiterName: recruiterName,
                recruiterAvatarPath: recruiterAvatarPath
            )
            this.allJobs.insert(0, newItem)
            //数据变化后，立即保存
            this.saveJobsToStorage()
        }


        // 初始状态下，展示所有职位
        this.displayedJobs = this.allJobs.get().toArray()
    }
    // 3. 搜索逻辑现在直接修改 displayedJobs 状态
    func performSearch(keyword: String) {
        let normalizedKeyword = keyword.trimAscii() // 去掉大小写转换以修复中文搜索
        if (normalizedKeyword.isEmpty()) {
            // 如果关键词为空，重置为显示所有职位
            this.displayedJobs = this.allJobs.get().toArray()
            return
        }

        // 手动过滤 allJobs
        var filteredList = ObservedArrayList<JobPosting>()
        for (index in 0..this.allJobs.size) {
            let item = this.allJobs[index]
            let titleMatch = item.title.contains(normalizedKeyword)
            let companyMatch = item.companyName.contains(normalizedKeyword)
            if (titleMatch || companyMatch) {
                filteredList.append(item)
            }
        }

        // 用过滤后的结果，完整地替换掉 displayedJobs 的内容
        this.displayedJobs = filteredList.get().toArray()
    }

    func build() {
        Stack(){
            Column() {
            // 在这里添加 Search 组件
                Search(value: this.searchKeyword, placeholder: "搜索职位／公司")
                    .onChange({ value: String =>
                        this.performSearch(value)
                    })
                    .width(95.percent)
                    .margin(top: 20.vp, bottom: 10.vp)
                // 在这里构建主页的UI
                List(space: 10) { // space 设置列表项之间的间距
                    ForEach(
                        this.displayedJobs,
                        itemGeneratorFunc: { item: JobPosting, index: Int64 =>
                            ListItem() {
                                // 在这里，我们像使用 Text 或 Button 一样，
                                // 使用我们自己创建的 JobListItemView 组件！
                                JobListItemView(job: item)
                            }
                            .onClick({ evt =>
                                // 1. 创建一个空的 JsonObject
                                var params = JsonObject()
//                                Hilog.error(0xFF00, "LogExample", "message1."+displayedJobs[0].title)
//                                Hilog.error(0xFF00, "LogExample", "message2."+item.title)
//                                Hilog.error(0xFF00, "LogExample", "message3."+this.displayedJobs[index].title)
                                // 2. 将 item 的所有属性打包进 JsonObject
                                params.put("id", JsonInt(item.id))
                                params.put("title", JsonString(item.title))
                                params.put("companyName", JsonString(item.companyName))
                                params.put("city", JsonString(item.city))
                                params.put("salaryRange", JsonString(item.salaryRange))
                                params.put("description", JsonString(item.description))
                                params.put("recruiterName", JsonString(item.recruiterName))
                                params.put("recruiterAvatarPath", JsonString(item.recruiterAvatarPath))

                                // 3. 将这个 JsonObject 作为 params 参数传递
                                Router.push(url: "JobDetailPage", params: params)
                            })
                        },
                        keyGeneratorFunc: { item: JobPosting, index: Int64 =>
                            return item.id.toString()
                        }
                    )
                }
                .width(95.percent) // 设置列表宽度
            }
            .width(100.percent)
            .height(100.percent)
            .backgroundColor(0xF1F3F5) // 给页面一个浅灰色背景
            .alignItems(HorizontalAlign.Center) // 让列表居中

            // 浮动按钮
            Button("+")
                .size(width: 50.vp, height: 50.vp)
                .offset(x: 0, y: 350)
                .fontSize(24.fp)
                .fontColor(Color.WHITE)
                .backgroundColor(0x007DFF)
                .borderRadius(25.vp)
                .onClick({ evt =>
                    Router.push(url: "PostJobPage")
                })
        }
        .width(100.percent) // 确保 Stack 自身是全屏的
        .height(100.percent)
    }
}
