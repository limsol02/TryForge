package com.web.spring.file.controller;

import com.web.spring.vo.FileStorage;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
// 다운로드 버튼 누르면 fname을 download.do? 로 보내서 처리 예정.
@Controller
public class DownloadController {
	@RequestMapping("download")
	public String download(@RequestParam("fname") String fname, @RequestParam("originfname") String originfname, Model d) {
		d.addAttribute("downloadFile", fname);
		d.addAttribute("originFileName", originfname);
		return "downloadViewer";
	}
}