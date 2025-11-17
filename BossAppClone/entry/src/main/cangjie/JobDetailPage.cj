/**
 * Created on 2025/9/12
 */
package ohos_app_cangjie_entry

import ohos.base.*
import ohos.component.*
import ohos.state_macro_manage.*
import ohos.router.Router
import encoding.json.JsonString
import ohos.ark_interop_helper.getJSContext

@Entry // 新的页面也需要 @Entry 注解
@Component
class JobDetailPage {
    // 这个页面需要接收一个 JobPosting 对象
    // 注意：我们将学习如何通过 Router 传递这个对象
    @State
    var job: JobPosting = JobPosting.empty()
    protected override func aboutToAppear() {
        // 1. 使用 getParamsObject() 获取 JsonObject
        let jobJson = Router.getParamsObject()

        // 2. 从 JsonObject 中解析出各个字段
        //    注意使用 .asString() 等方法转换类型
        let id = jobJson.get("id").getOrThrow().asInt().getValue()
        let title = jobJson.get("title").getOrThrow().asString().getValue()
        let companyName = jobJson.get("companyName").getOrThrow().asString().getValue()
        let city = jobJson.get("city").getOrThrow().asString().getValue()
        let salaryRange = jobJson.get("salaryRange").getOrThrow().asString().getValue()
        let description = jobJson.get("description").getOrThrow().asString().getValue()
        let recruiterName = jobJson.get("recruiterName").getOrThrow().asString().getValue()
        let recruiterAvatarPath = jobJson.get("recruiterAvatarPath").getOrThrow().asString().getValue()


        // 3. 使用解析出的数据，重新构建一个 JobPosting 对象
        this.job = JobPosting(
            id: id,
            title: title,
            companyName: companyName,
            city: city,
            salaryRange: salaryRange,
            description: description,
            recruiterName: recruiterName,
            recruiterAvatarPath: recruiterAvatarPath
        )
    }
    func getLoadingVisibility(): Visibility {
        return if (this.job.id == -1) { Visibility.Visible } else { Visibility.Hidden }
    }

    func getDetailsVisibility(): Visibility {
        return if (this.job.id != -1) { Visibility.Visible } else { Visibility.Hidden }
    }

    func build() {
        // 使用 Stack 将两个视图叠在一起
        Stack() {
            // “加载中” 视图
            Text(this.job.title)
                .fontSize(20.fp)
                .visibility(this.getLoadingVisibility())

            // “职位详情” 视图
            Column() {
                Text(this.job.title).fontSize(24.fp).fontWeight(FontWeight.Bold)
                Text(this.job.salaryRange).fontSize(20.fp).fontColor(Color.RED).margin(top: 10.vp)
                Divider().margin(20.vp)
                Image(this.job.recruiterAvatarPath).size(width: 50.vp, height: 50.vp).borderRadius(25.vp)
                Text(this.job.recruiterName).margin(top: 8.vp)
                Text("职位详情").fontSize(18.fp).fontWeight(FontWeight.Bold).margin(top: 20.vp)
                Text(this.job.description).fontSize(16.fp).textAlign(TextAlign.Start).margin(top: 10.vp)
            }
            .alignItems(HorizontalAlign.Start)
            .visibility(this.getDetailsVisibility())
        }
        .padding(15.vp)
        .width(100.percent)
        .height(100.percent)
    }
}