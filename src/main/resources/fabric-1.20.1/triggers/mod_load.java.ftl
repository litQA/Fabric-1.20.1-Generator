<#include "procedures.java.ftl">
public ${name}Procedure() {
	// Fabric 1.20.1: 模组加载即初始化阶段，构造时直接执行一次
	execute();
}
