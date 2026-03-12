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
	
	/*
	 * 주간 현황 페이지 (홈 및 지도 대시보드)
	 */
	@GetMapping("/")
	public String main(StatusDTO statusDTO, HttpSession session, Model model) {
		Map<String, Object> statusData = statusService.getWeekStatusData(statusDTO);
		
		model.addAllAttributes(statusData);
		model.addAttribute("currentPage", "weekStatus");
		return "main";
	}
	
	@GetMapping("/getDistrictData")
	@ResponseBody
	public Map<String, Object> getDistrictData(StatusDTO statusDTO) {
		return statusService.getDistrictData(statusDTO);
	}
	

	/*
	 * 연간 현황 페이지 (홈 및 지도 대시보드)
	 */
	@GetMapping("/annual")
	public String annualStatus(StatusDTO statusDTO, HttpSession session, Model model) {
		Map<String, Object> statusData = statusService.getAnnualStatusData(statusDTO);
		
		model.addAllAttributes(statusData);
		model.addAttribute("currentPage", "annualStatus");
		return "annual";
	}
	
	
	@GetMapping("/getYearData")
	@ResponseBody
	public Map<String, Object> getYearData(StatusDTO statusDTO) {
		return statusService.getAnnualStatusData(statusDTO);
	}
	
	/*
	 * 발전량 예측 페이지
	 */
	@GetMapping("/predict")
	public String predict (HttpSession session, Model model) { 
		model.addAttribute("currentPage", "predict");
		return "predict";
	}
	
	/*
	 * 발전소 입지선정 페이지
	 */
	@GetMapping("/geography")
	public String geography (HttpSession session, Model model) { 
		model.addAttribute("currentPage", "geography");
		return "geography";
	}
}
