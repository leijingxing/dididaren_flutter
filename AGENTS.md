# Repository Guidelines

## 项目结构与模块组织
这是一个 Flutter 应用。源码位于 `lib/`，按功能与分层组织：
`lib/features/<feature>/{presentation,domain,data,application}`。路由定义在
`lib/app_router.dart`，生成代码在 `lib/app_router.gr.dart`。测试在 `test/`
（例如 `test/widget_test.dart`）。如果新增资源文件，请放在 `assets/` 并在
`pubspec.yaml` 中声明。

## 构建、测试与开发命令
- `flutter pub get`：安装依赖。
- `flutter run`：在设备或模拟器上运行。
- `flutter analyze`：按 `analysis_options.yaml` 进行静态分析。
- `flutter test`：运行单元/组件测试。
- 代码生成（AutoRoute/Freezed/JSON/Riverpod）：  
  `flutter pub run build_runner build --delete-conflicting-outputs`。

## 编码风格与命名规范
遵循 Dart/Flutter 习惯用法，启用 `flutter_lints`。缩进为 2 空格。类名使用
`UpperCamelCase`，文件名使用 `lower_snake_case.dart`。功能相关代码放在对应
feature 目录；跨功能复用放入 `lib/core` 或 `lib/shared`。

## 测试规范
测试使用 `flutter_test`。新增测试放在 `test/`，文件名为 `*_test.dart`。
使用 `flutter test` 运行全部测试，覆盖重点放在新增逻辑或回归修复上。

## 提交与 PR 规范
近期提交符合 Conventional Commits：`type(scope): summary`
（如 `refactor(home): ...`、`style(ui): ...`），建议沿用该格式。
PR 请包含：
- 变更内容与原因的简要说明。
- 关联的 issue（如有）。
- UI 变更的截图或录屏。

## 架构说明
状态管理使用 Riverpod。优先在 `lib/features/<feature>/application` 中定义
feature 内的 provider。导航使用 AutoRoute，除非必要，避免直接使用
`Navigator`。
