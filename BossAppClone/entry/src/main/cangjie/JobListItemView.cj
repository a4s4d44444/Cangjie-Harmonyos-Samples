/**
 * Created on 2025/9/11
 */
package ohos_app_cangjie_entry
//此处没有文档，网上找到答案
internal import ohos.base.*
internal import ohos.component.*
internal import ohos.state_manage.*
import ohos.state_macro_manage.*




@Component
class JobListItemView {

    // 这个组件需要接收一个 JobPosting 对象作为数据源
    let job: JobPosting

    func build(){
        // 使用 Column 垂直排列内容
        Column() {
            // 第一行：职位名称 和 薪资
            Row() {
                Text(this.job.title)
                    .fontSize(18.fp)
                    .fontWeight(FontWeight.Bold)
                Blank() // 空白填充，将薪资推到最右侧
                Text(this.job.salaryRange)
                    .fontSize(17.fp)
                    .fontColor(Color.RED)
            }
            .width(100.percent)

            // 第二行：公司名称 和 地点
            Row() {
                Text(this.job.companyName)
                    .fontSize(14.fp)
                    .fontColor(Color.GRAY)
                Text(this.job.city)
                    .fontSize(14.fp)
                    .fontColor(Color.GRAY)
                    .margin(left: 10.vp)
            }
            .width(100.percent)
            .margin(top: 8.vp)

            // 分割线
            Divider()
                .margin(top: 15.vp, bottom: 10.vp)

            // 第三行：招聘者信息
            Row() {
                Image(this.job.recruiterAvatarPath)
                    .size(width: 30.vp, height: 30.vp)
                    .borderRadius(15.vp) // 设置为圆形

                Text(this.job.recruiterName)
                    .fontSize(14.fp)
                    .margin(left: 8.vp)
            }
            .width(100.percent)
        }
        .width(100.percent)
        .padding(15.vp) // 给整个卡片一些内边距
        .backgroundColor(Color.WHITE)
        .borderRadius(12.vp)
    }

}
