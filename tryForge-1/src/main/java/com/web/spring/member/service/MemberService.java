package com.web.spring.member.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

import com.web.spring.file.dao.FileDao;
import com.web.spring.member.dao.MemberDao;
import com.web.spring.vo.FileStorage;
import com.web.spring.vo.InviteMember;
import com.web.spring.vo.MailSender;
import com.web.spring.vo.Member;
import com.web.spring.vo.Project;
import com.web.spring.vo.RoleRequest;

import jakarta.mail.MessagingException;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import jakarta.mail.internet.MimeMessage.RecipientType;

@Service
public class MemberService {

	@Autowired(required = false)
	private MemberDao memberDao;
	@Autowired(required = false)
	private JavaMailSender sender;
	@Autowired(required = false)
	private FileDao fileDao;

	// 로그인
	public Member loginMember(Member member) {
		return memberDao.loginMember(member);
	}
	
	// 회원가입
	public boolean registerMember(Member member) {
		int result = memberDao.registerMember(member);
		
		if (result > 0) {
			// 회원가입 성공했을때 가입여부 true로 바꾸기
			memberDao.updateInviteMember(member.getMember_email());
			
			return true;
		} else {
			return false;
		}
		
	}
	
	// 아이디 중복 체크
	public boolean checkId(String id) {
		if (id != null && memberDao.checkId(id) > 0) {
			return false;
		} else {
			return true;
		}
	}
	
	// 이메일 초대되어 있는지 체크 여부
	public boolean checkEmail(String email) {
		if (email != null) {
			InviteMember invite = memberDao.checkEmail(email);
			if (invite != null && !invite.isJoined()) {
				return true;
			} else {
				return false;
			}
		} else {
			return false;			
		}
	}
	
	// 본인이 소속되어있는 프로젝트 출력
	public Project getUserProject(Member member) {
		
		return memberDao.getUserProject(member.getMember_key());
	}
	
	// 본인이 소속되어있는 프로젝트 출력
	public List<Project> getUserProjectList(Member member) {
		
		return memberDao.getUserProjectList(member.getMember_key());
	}
	
	// 초대 목록 
	public List<InviteMember> inviteMemberList() {
		
		return memberDao.getInviteMemberList();
	}
	
	// 유저key로 유저 찾기
	public Member getMember(int memberKey) {
		return memberDao.getMeber(memberKey);
	}
	
	// 유저id로 유저 찾기
	public Member getMemberToId(String memberId) {
		return memberDao.getMeberToId(memberId);
	}
	
	// 메일 발송
	public String sendMail(MailSender email, Member sendMem) {
		String msg = "";
		
		MimeMessage mmsg = sender.createMimeMessage();
		
		try {
			mmsg.setSubject(email.getTitle());
			mmsg.setRecipient(RecipientType.TO, new InternetAddress(email.getReceiver()));
			mmsg.setText(email.getContent());

			memberDao.inviteMember(new Member(sendMem.getMember_key(), email.getReceiver()));
			sender.send(mmsg);
			msg = "메일 발송 성공";
		} catch (MessagingException e) {
			System.out.println("메시지 전송에러 발송 : " + e.getMessage());
			msg = "메일 발송 에러 발생 : " + e.getMessage();
		} catch (Exception e) {
			System.out.println("기타 에러 : " + e.getMessage());
			msg = "기타 에러 발생 : " + e.getMessage();
		}
		
		return msg;
	}
	
	// 비밀번호 확인
	public boolean chkPwd(String memKey, String pwd) {
		if (memberDao.checkPwd(memKey, pwd) > 0) {
			return true;
		} else {
			return false;
		}
	}
	
	// 유저정보 수정
	public boolean changeUserInfo(String name, String id, String memKey) {
		if (memberDao.changeUserInfo(name, id, memKey) > 0) {
			return true;
		} else {
			return false;
		}
	}
	
	// 비번 수정
	public boolean changePwd(String memKey, String pwd) {
		if (memberDao.changePwd(memKey, pwd) > 0) {
			return true;
		} else {
			return false;
		}
	}
	
	// 권한 요청
	public boolean requestRole(String member_id, String comment) {
		Member member = memberDao.getMeberToId(member_id);
		
		int requestNum = memberDao.requestRole(member.getMember_key(), comment);
		
		if (requestNum > 0) {
			return true;
		}
		
		return false;
	}
	
	// 권한요청 리스트 출력
	public List<RoleRequest> getRequestRoleList(int member_key) {
		
		return memberDao.getRequestRoleList(member_key);
	}
	
	// 권한요청 키로 출력
	public RoleRequest getRequestRole(int requestKey) {
		return memberDao.getRequestRole(requestKey);
	}
	
	public String searchId(String email) {
		Member member = memberDao.getIdToEmail(email);
		String msg;
		if (member != null) {
			MimeMessage mmsg = sender.createMimeMessage();
			
			try {
				mmsg.setSubject("TryForge 아이디 찾기");
				mmsg.setRecipient(RecipientType.TO, new InternetAddress(email));
				mmsg.setText(member.getMember_name() + "님의 아이디는 " + member.getMember_id()
						+ "입니다!\n바로 로그인해보세요.\n\nhttp://211.63.89.67:1111/login");

				sender.send(mmsg);
				msg = "메일 발송 성공";
			} catch (MessagingException e) {
				System.out.println("메시지 전송에러 발송 : " + e.getMessage());
				msg = "메일 발송 에러 발생 : " + e.getMessage();
			} catch (Exception e) {
				System.out.println("기타 에러 : " + e.getMessage());
				msg = "기타 에러 발생 : " + e.getMessage();
			}
		} else {
			msg = "가입안됨";
		}
		
		return msg;
	}
	
	public String searchPwd(String email, String memberId) {
		Member member = memberDao.getIdToEmail(email);
		
		String msg = "";
		
		if(member != null && !member.getMember_id().equals(memberId)) {
			msg = "아이디";
			return msg;
		}
		
		if (member != null) {
			MimeMessage mmsg = sender.createMimeMessage();
			
			try {
				mmsg.setSubject("TryForge 비밀번호 찾기");
				mmsg.setRecipient(RecipientType.TO, new InternetAddress(email));
				mmsg.setText(member.getMember_name() + "님의 비밀번호는 " + member.getMember_pwd()
						+ "입니다!\n바로 로그인해보세요.\n\nhttp://211.63.89.67:1111/login");

				sender.send(mmsg);
				msg = "메일 발송 성공";
			} catch (MessagingException e) {
				System.out.println("메시지 전송에러 발송 : " + e.getMessage());
				msg = "메일 발송 에러 발생 : " + e.getMessage();
			} catch (Exception e) {
				System.out.println("기타 에러 : " + e.getMessage());
				msg = "기타 에러 발생 : " + e.getMessage();
			}
		} else if(member == null) {	
			msg ="이메일";
		} 
		
		return msg;
	}
	
	// 마이페이지 프로필사진 불러오기
	public String getProfile(int memberKey) {
		FileStorage file = fileDao.getProfile(memberKey);
		if (file != null) {
			System.out.println(file.getFile_key() + "." + file.getFtype());
			return file.getFile_key() + "." + file.getFtype();
		}	
		return "";
	}
}