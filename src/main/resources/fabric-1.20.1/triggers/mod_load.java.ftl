<#include "procedures.java.ftl">
public ${name}Procedure() {
	// Fabric 1.20.1: mod construction runs during initialization, so the body executes once at construction time.
	execute();
}
