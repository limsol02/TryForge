package com.web.spring.task.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.web.spring.gantt.dao.GanttDao;
import com.web.spring.task.dao.TaskDao;
import com.web.spring.vo.Risk;
import com.web.spring.vo.Task;

@Service
public class TaskService {
    @Autowired(required = false)
    private TaskDao dao;
    @Autowired(required = false)
    private GanttDao ganttdao;

    // 업무 출력(jsp에서 요청상태 확인)
    public List<Task> getTask() {
        return dao.getTask();
    }

    //새 업무 확인
    public String uptConfirm(int id) {
        return dao.uptConfirm(id) > 0 ? "업무 확인 완료" : "업무 확인 에러";
    }

    // 해당 업무 디테일
    public Task taskDetail(int id) {
        return ganttdao.taskDetail(id);
    }

	// 해당 업무 리스크 등록
	public String insertRisk(Risk ins){
		return dao.insertRisk(ins)>0?"리스크 등록 성공":"리스크 등록 에러";
	}
}
