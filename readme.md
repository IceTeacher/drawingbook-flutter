# DrawingBook

## 项目简介

DrawingBook 是一个基于 Flutter 构建的跨平台绘本阅读与管理应用，提供绘本查找、书单浏览、故事音频播放等功能。

本项目由原 HarmonyOS NEXT 版本迁移至 Flutter，当前已完成首页、找书单和听故事等核心页面，并保留绘本详情、书单详情、分类、榜单及个人中心等页面的路由入口，后续将继续完成迁移。

Flutter 版本项目地址：[IceTeacher/drawingbook-flutter](https://github.com/IceTeacher/drawingbook-flutter)

## 技术栈

- **Flutter / Dart**：跨平台 UI 与业务开发
- **flutter_bloc**：状态管理
- **Dio**：网络请求
- **go_router**：声明式路由
- **just_audio**：音频播放
- **just_audio_media_kit / media_kit**：桌面端音频能力支持
- **Material 3**：应用主题与基础组件

## 项目架构

项目采用按功能模块拆分的结构，并将公共能力、业务模块与复用组件分离：

```text
lib/
├── core/
│   ├── network/          # 网络请求封装
│   └── router/           # 全局路由与底部导航
├── features/
│   ├── home/             # 首页
│   │   ├── bloc/
│   │   ├── data/
│   │   └── view/
│   ├── book_lists/       # 找书单
│   │   ├── bloc/
│   │   ├── data/
│   │   └── view/
│   └── audio_books/      # 听故事
│       ├── bloc/
│       ├── data/
│       └── view/
├── shared/
│   ├── models/           # 通用数据模型
│   └── widgets/          # 公共组件
└── main.dart             # 应用入口
```

主要设计包括：

1. **功能模块化**：以 `features` 为单位组织首页、书单、听故事等业务模块。
2. **BLoC 状态管理**：每个核心模块通过 Event、State 和 Bloc 管理页面状态与业务流程。
3. **Repository 数据层**：页面不直接处理网络请求，由 Repository 负责调用接口并转换数据。
4. **统一网络层**：使用 Dio 封装 API 请求。
5. **声明式路由**：使用 go_router 管理底部导航与详情页跳转。
6. **公共组件复用**：搜索框、绘本卡片、书单卡片、网络图片、加载与错误状态等统一放在 `shared/widgets` 中复用。
7. **跨平台音频播放**：使用 just_audio，并通过 media_kit 相关组件补充桌面平台音频支持。

## 项目预览

<img src="./readme/1.png" alt="首页" style="zoom: 25%;" />

<img src="./readme/2.png" alt="找书单" style="zoom: 25%;" />

<img src="./readme/3.png" alt="听故事" style="zoom: 25%;" />

<img src="./readme/4.png" alt="书籍详情" style="zoom: 25%;" />

## 页面描述

### 1. 首页（HomePage）

首页用于聚合绘本发现内容，目前包含：

- 搜索框
- 好书速递横向列表
- 绘本分类入口
- 达人书单
- 热门榜单
- 达人精选绘本列表
- 列表滚动加载
- 绘本、书单、分类和榜单页面跳转

页面数据由 `HomeBloc` 管理，并通过 `HomeRepository` 获取。

### 2. 找书单（FindBookListPage）

书单发现页面目前包含：

- 搜索框
- 书单列表
- 下拉浏览与滚动加载
- 点击书单跳转至书单详情页

页面数据由 `BookListBloc` 和 `BookListRepository` 管理。

### 3. 听故事（AudioBooksPage）

故事音频页面目前包含：

- 搜索框
- 国语 / 英语切换
- 故事音频列表
- 连续播放
- 底部音频播放器
- 播放 / 暂停与播放进度控制
- 列表滚动加载
- 点击条目跳转至绘本详情页

页面状态与音频播放流程由 `AudioBookBloc` 管理。

### 4. 个人中心

底部导航已保留“我”的入口，目前为迁移占位页面，后续将继续补充登录、用户资料等功能。

### 5. 绘本详情

已配置 `/book/:id` 路由，目前为迁移占位页面。

后续计划恢复原版本中的封面、标题、作者、标签、评分、故事音频、简介、评论及相关推荐等内容。

### 6. 书单详情

已配置 `/book-list/:id` 路由，目前为迁移占位页面。

后续计划恢复书单信息、绘本列表、达人推荐、评论及相关推荐等内容。

### 7. 分类

已配置 `/category/:id` 路由，目前为迁移占位页面。

### 8. 排行榜

已配置 `/rank/:id` 路由，目前为迁移占位页面。

## 运行项目

确保本地已安装 Flutter SDK，然后执行：

```bash
flutter pub get
flutter run
```

项目当前包含 Android、iOS、Web、Windows、macOS 和 Linux 平台目录，可根据 Flutter 本地开发环境选择目标平台运行。
