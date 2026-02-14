package com.kdn.project.controller;

import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.kdn.project.dto.StatusDTO;
import com.kdn.project.service.StatusService;

@Controller
public class StatusController {

	@Autowired
	StatusService statusService;
	
	@GetMapping("/")
	public String main(StatusDTO statusDTO, HttpSession session, Model model) {
		Map<String, Object> statusData = statusService.getStatusData(statusDTO);
		
		model.addAllAttributes(statusData);
		model.addAttribute("currentPage", "status");
		return "main";
	}
	
	@GetMapping("/getYearData")
	@ResponseBody
	public Map<String, Object> getYearData(StatusDTO statusDTO) {
		return statusService.getStatusData(statusDTO);
	}
	
	@GetMapping("/predict")
	public String predict (HttpSession session, Model model) { 
		model.addAttribute("currentPage", "predict");
		return "predict";
	}
}
