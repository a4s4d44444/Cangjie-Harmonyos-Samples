/**
 * Created on 2025/9/16
 */
package ohos_app_cangjie_entry

import ohos.base.*
import ohos.component.*
import ohos.state_macro_manage.*
import ohos.router.Router
import encoding.json.*
import ohos.system_date_time.SystemDateTime

@Entry
@Component
class PostJobPage {
    // 1. 为表单的每个输入框创建对应的 @State 变量
    @State var title: String = ""
    @State var companyName: String = ""
    @State var city: String = ""
    @State var salaryRange: String = ""
    @State var description: String = ""
    @State var recruiterName: String = ""

    // 2. 表单提交逻辑
    func submitJob() {
        // 简单验证
        if (this.title.trimAscii().isEmpty() || this.companyName.trimAscii().isEmpty()) {
            // 在实际应用中，这里应该给用户一个提示，例如Toast
            return
        }

        // 使用时间戳创建唯一ID
        let newId = SystemDateTime.getCurrentTime()

        // 将表单数据打包进 JsonObject
        var newJobJson = JsonObject()
        newJobJson.put("id", JsonInt(newId))
        newJobJson.put("title", JsonString(this.title))
        newJobJson.put("companyName", JsonString(this.companyName))
        newJobJson.put("city", JsonString(this.city))
        newJobJson.put("salaryRange", JsonString(this.salaryRange))
        newJobJson.put("description", JsonString(this.description))
        newJobJson.put("recruiterName", JsonString(this.recruiterName))
        // 头像路径暂时使用一个默认值
        newJobJson.put("recruiterAvatarPath", JsonString("resource://app/media/avatar_1.png"))

        // 使用 Router.back() 返回上一页，并通过 params 将新职位数据带回去
        Router.back(url: "EntryView", params: newJobJson)
//        Router.back()
    }

    // 3. 构建表单UI
    func build() {
        Column() {
            Text("发布新职位").fontSize(28.fp).fontWeight(FontWeight.Bold).margin(bottom: 20.vp)

            TextInput(placeholder: "职位名称，如：高级工程师", text: this.title)
                .onChange({ val => this.title = val })

            TextInput(placeholder: "公司名称", text: this.companyName)
                .onChange({ val => this.companyName = val }).margin(top: 15.vp)

            TextInput(placeholder: "所在城市，如：深圳·南山区", text: this.city)
                .onChange({ val => this.city = val }).margin(top: 15.vp)

            TextInput(placeholder: "薪资范围，如：30-50k·16薪", text: this.salaryRange)
                .onChange({ val => this.salaryRange = val }).margin(top: 15.vp)

            // 对于职位描述这种长文本，使用 TextArea 更合适
            TextArea(placeholder: "请输入职位描述和要求...", text: this.description)
                .onChange({ val => this.description = val })
                .height(120.vp).margin(top: 15.vp)

            TextInput(placeholder: "招聘者姓名", text: this.recruiterName)
                .onChange({ val => this.recruiterName = val }).margin(top: 15.vp)

            Blank() // 空白填充，将按钮推到底部

            Button("确认发布")
                .width(100.percent)
                .height(50.vp)
                .onClick({ evt =>
                    this.submitJob()
                })
        }
        .padding(20.vp)
        .width(100.percent)
        .height(100.percent)
    }
}