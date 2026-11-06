# 工具脚本

## build-plugin.ps1

构建 2026.3 插件，并持久化构建序号。

```powershell
pwsh -File .\tools\build-plugin.ps1
```

- 使用工作区根目录的 `jdk-25`（回退到 `MCreatorEAP2026344621/jdk`）。
- 使用 `caches/gradle` 作为 `GRADLE_USER_HOME`。
- 使用 `reference_resources/gradle-9.8.0-bin.zip` 作为 Gradle 发行包。
- 每次调用都会消耗一个构建序号，构建失败也消耗；新序号写回 `gradle.properties`。
- 产物：`build/generator-fabric-1.20.1.zip`。

## smoke-test.ps1

用 2026.3 的 headless GenHarness 重新生成工作区。

```powershell
pwsh -File .\tools\smoke-test.ps1 -Workspace ..\test-workspace\testmod
```

可选参数：

- `-PluginZip`：默认 `build/generator-fabric-1.20.1.zip`。
- `-MCreatorPath`：默认工作区根目录的 `MCreatorEAP2026344621`。
- `-HarnessDir` / `-AppDir`：默认 `_verify/harness-2026.3`、`_verify/app-2026.3`。
- `-GradleCacheJson`：默认 `_verify/gradle-cache.json`。

脚本用工作区 `caches/smoke/` 隔离插件目录和 MCreator 用户目录，不写入 `%USERPROFILE%\.mcreator`。

## 测试环境说明

插件 ZIP 是自包含的；`tools/` 只负责构建和验证。headless harness、MCreator app 类、1.20.1 mapped classpath 属于测试环境，不进入插件 ZIP，也不属于插件源码。
