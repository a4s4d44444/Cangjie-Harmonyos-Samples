/**
 * Created on 2025/9/11
 */
package ohos_app_cangjie_entry
import ohos.state_macro_manage.*
import ohos.base.*



let mockJobList: Array<JobPosting> = [
    JobPosting(
        id: 1,
        title: "高级仓颉UI工程师",
        companyName: "未来科技",
        city: "深圳·南山区",
        salaryRange: "30-50k·16薪",
        description: "负责下一代操作系统核心应用的UI界面开发，要求精通仓颉语言及ArkUI框架，对用户体验有极致追求。",
        recruiterName: "林女士",
        recruiterAvatarPath: "resource://app/media/avatar_1.png"
    ),
    JobPosting(
        id: 2,
        title: "鸿蒙内核开发专家",
        companyName: "先锋智能",
        city: "北京·海淀区",
        salaryRange: "40-60k·18薪",
        description: "深入研究鸿蒙内核，负责系统性能优化和新特性研发。需要有扎实的C/C++基础和操作系统底层知识。",
        recruiterName: "张先生",
        recruiterAvatarPath: "resource://app/media/avatar_2.png"
    ),
    JobPosting(
        id: 3,
        title: "产品经理（AI方向）",
        companyName: "智慧互联",
        city: "上海·浦东新区",
        salaryRange: "25-45k",
        description: "设计和规划基于鸿蒙生态的AI产品，深度参与从概念到落地的全过程，需要对市场有敏锐的洞察力。",
        recruiterName: "王经理",
        recruiterAvatarPath: "resource://app/media/avatar_3.png"
    )
]