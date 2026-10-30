<#-- Fabric 1.20.1：该全局触发器在 Fabric API 0.92.12 中没有等价事件；1.21.8 参考实现是用 mixin 触发 Event，本阶段按计划不引入 mixin。
     这里生成可编译的空实现（不注册任何回调，过程体不会被执行），待后续 mixin 立项后补全。
     文档：MIGRATION-PLAN-V2.md §2 P0-C「第 3 类：需要 mixin 或明确不支持」。 -->
public ${name}Procedure() {
	// Unsupported on Fabric 1.20.1 without mixins - see MIGRATION-PLAN-V2.md
}
