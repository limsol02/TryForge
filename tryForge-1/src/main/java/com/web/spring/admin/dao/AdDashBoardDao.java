package com.web.spring.admin.dao;

import com.web.spring.vo.Task;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface AdDashBoardDao {
    // 프로젝트 별 진척도(프로젝트 명 / 프로젝트 진척도 둘다 표시)
    List<Task> projectProgress();
    // 가용인원
    int totTeamMember();
    int totMember();
    // 올해 프로젝트 수주 totOngoingPJ / totCompletePJ / totWaitingPJ
    int totOngoingPJ();
    int totCompletePJ();
    int totWaitingPJ();
    // 프로젝트 별로 구분하여 담당자별 업무 진척도
    List<Task> taskProgressBypeople(@Param("project_key")String project_key);
    // 리스크 총 갯수(프로젝트 별)
    int riskTot(@Param("title")String title);
    // 리스크 발생 건수 (프로젝트별)
    int risk01Tot(@Param("title")String title);
    // 리스크 처리 완료 갯수(프로젝트 별)
    int risk02Tot(@Param("title")String title);
}
