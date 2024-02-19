package com.web.spring.vo;
// com.web.spring.vo.Approval
import java.util.Date;

public class Approval {
	private int approval_key; // 결제 primary Key
	private int task_key; // 업무 키
	private String project_key; // 프로젝트 키
	private int member_key; // 요청보낸 맴버 키
	private String file_key; // 함께 업로드 한 파일 정보
	private Date request_date; // 요청일
	private Date completion_date; //  결재 완료일
	private String status; //  결재 상태
	private String detail; // 업무보고 설명
	private Task task;

	public Approval(int approval_key, int task_key, String project_key, int member_key, String file_key, Date request_date, Date completion_date, String status, String detail, Task task) {
		this.approval_key = approval_key;
		this.task_key = task_key;
		this.project_key = project_key;
		this.member_key = member_key;
		this.file_key = file_key;
		this.request_date = request_date;
		this.completion_date = completion_date;
		this.status = status;
		this.detail = detail;
		this.task = task;
	}

	public Task getTask() {
		return task;
	}

	public void setTask(Task task) {
		this.task = task;
	}

	public Approval() {
	}


	public int getApproval_key() {
		return approval_key;
	}

	public void setApproval_key(int approval_key) {
		this.approval_key = approval_key;
	}

	public int getTask_key() {
		return task_key;
	}

	public void setTask_key(int task_key) {
		this.task_key = task_key;
	}

	public String getProject_key() {
		return project_key;
	}

	public void setProject_key(String project_key) {
		this.project_key = project_key;
	}

	public int getMember_key() {
		return member_key;
	}

	public void setMember_key(int member_key) {
		this.member_key = member_key;
	}

	public String getFile_key() {
		return file_key;
	}

	public void setFile_key(String file_key) {
		this.file_key = file_key;
	}

	public Date getRequest_date() {
		return request_date;
	}

	public void setRequest_date(Date request_date) {
		this.request_date = request_date;
	}

	public Date getCompletion_date() {
		return completion_date;
	}

	public void setCompletion_date(Date completion_date) {
		this.completion_date = completion_date;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getDetail() {
		return detail;
	}

	public void setDetail(String detail) {
		this.detail = detail;
	}
}