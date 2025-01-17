package com.web.spring.chat.service;

import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.web.spring.admin.dao.AdProjectDao;
import com.web.spring.chat.dao.ChatDao;
import com.web.spring.member.dao.MemberDao;
import com.web.spring.vo.Chat;
import com.web.spring.vo.ChatList;
import com.web.spring.vo.Member;
import com.web.spring.vo.Team;

@Service
public class ChatService {
	@Autowired(required = false)
	private ChatDao dao;
	
	@Autowired(required = false)
	private MemberDao memDao;
	
	@Autowired(required = false)
	private AdProjectDao projectDao;
	
	// 채팅 초기 화면
	public HashMap<List<String>, String> chatHome(int memKey) {
		List<ChatList> chatList = new ArrayList<>();
		
		chatList = dao.getChatList(memKey);
		
		// [test, test2, test3] / 마지막말
		HashMap<List<String>, String> chatMemMap = new LinkedHashMap();
		
		for (ChatList chat : chatList) {
			if (chat.getChat_category() != null) {
				Team team = projectDao.teamInfo(chat.getChat_category());
				if (team != null) {
					String teamName = team.getTeam_name();
					List<String> teamNameList = new ArrayList<>();
					teamNameList.add("팀 " + teamName);
					chatMemMap.put(teamNameList, chat.getLast_message());
				}
				
			} else {
				List<String> memberNameList = new ArrayList<>();
				for (int memberKey : dao.getChatMemList(memKey, chat.getChatlist_key())){
					 // memDao.getMeber(memberKey));
					memberNameList.add(memDao.getMeber(memberKey).getMember_name());
				}
				chatMemMap.put(memberNameList, chat.getLast_message());
			}
		}
		
		return chatMemMap;
	}
	
	public List<ChatList> getChatList(int memKey) {
		List<ChatList> chatList = dao.getChatList(memKey);
		
		return chatList;
	}
	
	public List<Chat> getChat(int listKey) {
		List<Chat> chatList = dao.getChat(listKey);
		
		return chatList;
	}
	
	public String insertChats(List<Chat> chatList) {
		int num = 0;
		for (Chat chat : chatList) {
			num += dao.insertChat(chat);
			dao.updateLastMessage(chat);
		}
		
		return num + "건 db저장 완료";
	}
	
	// 채팅방 만들기
	public String createChatRoom(List<Integer> memList) {
		dao.createChatRoomUser();
		for (int mem : memList) {
			dao.createChatMem(mem);
		}
		
		return "채팅방생성 완료";
	}
	
	// 전체 맴버 검색 및 리스트 출력
	public List<Member> schMem(String member_name, int member_key) {
		if (member_name == null)
			member_name = "";
		return dao.schMem(member_name, member_key);
	}

}
