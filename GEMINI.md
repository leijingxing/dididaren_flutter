# Gemini 全局规则 (滴滴达人项目)

## 项目概览
**滴滴达人 (Dididaren)** 是一个基于 Flutter 的同城即时体力服务对接平台（类似于数字版的“棒棒军”）。它连接了需要搬运、跑腿或一般体力劳动的用户（雇主）与附近的劳动者（达人）。

**当前阶段 (第一阶段):**
- 专注于 UI/UX 流程和雇主/达人角色的切换。
- **模拟数据 (Mock Data)**: 没有真实的后端或地图 SDK。所有数据均在本地模拟。
- **目标**: 完成具有模拟订单生命周期的功能原型。

## 技术栈与架构
- **框架**: Flutter (Dart)
- **状态管理**: [Riverpod](https://riverpod.dev/) (启用代码生成).
- **导航/路由**: [AutoRoute](https://pub.dev/packages/auto_route).
- **模型**: [Freezed](https://pub.dev/packages/freezed) & [JsonSerializable](https://pub.dev/packages/json_serializable).
- **风格**: Material 3 Design.
- **架构**: **Feature-First** (按功能模块分层).

## 目录结构
项目遵循 Feature-First (功能优先) 架构：

```text
lib/
├── core/                     # 全局工具, 主题, 常量
├── features/                 # 功能模块
│   ├── auth/                 # 认证与角色选择
│   ├── home/                 # 首页 (雇主/达人 视图)
│   ├── order/                # 订单管理 (创建, 列表, 详情)
│   └── [feature_name]/       # 标准结构:
│       ├── presentation/     # UI层: Widgets, Pages, Controllers
│       ├── application/      # 逻辑层: Services, Notifiers (Providers)
│       ├── domain/           # 实体层: Models, Enums
│       └── data/             # 数据层: Repositories, DTOs, Mock Sources
└── shared/                   # 跨模块共享逻辑
```

## 关键开发命令

### 1. 代码生成 (至关重要)
由于本项目使用了 Riverpod Generator, AutoRoute 和 Freezed，修改带注解的文件后**必须**运行 build runner。

*   **监听模式 (开发时推荐):**
    ```bash
    dart run build_runner watch -d
    ```
*   **单次构建:**
    ```bash
    dart run build_runner build -d
    ```

### 2. 运行应用
```bash
flutter run
```

### 3. 代码检查与格式化
```bash
flutter analyze
dart format .
```

## 开发规范

### 编码风格
- **语言**: 注释和业务逻辑解释使用 **中文** (参考 `DESIGN_DOC.md` 和现有源码)。
- **UI 逻辑**: 保持 Widget 简单 (Dumb)。将业务逻辑移至 Riverpod Notifiers/Providers。
- **导航**: 所有页面跳转使用 `context.router` (AutoRoute)。
- **文件命名**: 蛇形命名法 snake_case (例如: `client_home_view.dart`)。

### 模拟策略 (Mocking)
- 不要假设后端存在。
- 在各功能的 `data` 层创建 Mock Repository。
- 在 UI 交互中使用 `Future.delayed` 模拟网络延迟。

### UI 组件
- **提取组件**: 将大型 build 方法拆分为更小、可复用的 Widget (例如放入 `lib/features/home/presentation/widgets/`)。
- **Material 3**: 使用 `Theme.of(context)` 获取符合 Material 3 规范的颜色和样式。