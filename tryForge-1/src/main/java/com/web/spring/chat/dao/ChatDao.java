package com.web.spring.chat.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.web.spring.vo.Chat;
import com.web.spring.vo.ChatList;

@Mapper
public interface ChatDao {
	// 채팅 리스트 가져오기
	List<ChatList> getChatList(@Param("memKey") int memberKey);
	
	List<Integer> getChatMemList(@Param("memKey") int memberKey, @Param("listKey") int listKey);

	List<Chat> getChat(@Param("listKey") int listKey);
	
	int insertChat(Chat chat);
	
	int updateLastMessage(Chat chat);
	
	// 프로젝트 생성시 채팅방 만드는것
	int createChatRoom();
	
	int createChatMem(int member_key);
}
