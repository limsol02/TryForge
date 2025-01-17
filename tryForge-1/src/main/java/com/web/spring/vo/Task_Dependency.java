package com.web.spring.vo;

public class Task_Dependency {
	private String id;
	private int source;
	private int target;
	private String type;
	private String project_key;

	public Task_Dependency(String id, int source, int target, String type, String project_key) {
		this.id = id;
		this.source = source;
		this.target = target;
		this.type = type;
		this.project_key = project_key;
	}

	public String getProject_key() {
		return project_key;
	}

	public void setProject_key(String project_key) {
		this.project_key = project_key;
	}

	public Task_Dependency() {
		// TODO Auto-generated constructor stub
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public int getSource() {
		return source;
	}
	public void setSource(int source) {
		this.source = source;
	}
	public int getTarget() {
		return target;
	}
	public void setTarget(int target) {
		this.target = target;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
}
