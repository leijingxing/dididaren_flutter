# dididaren

一个面向订单场景的 Flutter 应用，包含客户端与工人端的核心页面与订单流程，
使用 Riverpod 进行状态管理、AutoRoute 管理导航，并通过代码生成提升类型安全。

## 功能概览
- 登录与角色入口（客户端/工人端）。
- 订单列表与详情（含工人端进行中订单与状态展示）。
- 客户端订单创建与查看流程。

## 项目结构
源码在 `lib/`，按功能模块组织：
- `lib/features/auth`：登录与角色相关逻辑。
- `lib/features/home`：主页与角色视图。
- `lib/features/order`：订单领域模型、数据层与详情页面。
- `lib/app_router.dart`：路由定义（生成文件：`lib/app_router.gr.dart`）。

## 本地运行
```bash
flutter pub get
flutter run
```

## 代码生成
本项目使用 AutoRoute、Freezed、JSON、Riverpod Generator：
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## 质量规范
```bash
flutter analyze
flutter test
```

## 代码风格与规范
- 使用 `flutter_lints`（见 `analysis_options.yaml`）。
- 缩进 2 空格，文件名 `lower_snake_case.dart`，类名 `UpperCamelCase`。
- 跨功能共享建议放在 `lib/core` 或 `lib/shared`。

## 贡献说明
提交信息建议遵循 Conventional Commits：
`type(scope): summary`（如 `refactor(home): ...`）。
UI 变更请附截图或录屏。
