package com.kdn.project.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import com.kdn.project.dto.StatusDTO;
import com.kdn.project.mapper.StatusMapper;
import com.kdn.project.vo.GenStatMonthVO;
import com.kdn.project.vo.LawdCodeVO;
import com.kdn.project.vo.PlantStatWeekTotalVO;
import com.kdn.project.vo.PlantStatWeekVO;
import com.kdn.project.vo.PlantStatYearVO;

@Service
public class StatusServiceImpl implements StatusService{
	
	@Autowired
	private StatusMapper statusMapper;
	
	/*
	 * 메인 페이지 데이터 조회
	 */
	@Override
	public Map<String, Object> getStatusData(StatusDTO statusDTO) {
		Map<String, Object> result = new HashMap<>();
		
		try {
			String upperLawdCode = StringUtils.hasText(statusDTO.getUpperLawdCode())
									? statusDTO.getUpperLawdCode() : "00";
			
			int year = statusDTO.getYearData();
			
			// 1. 법정동 코드 
			List<LawdCodeVO> lawdCodeList = selectLawdList(upperLawdCode);
			result.put("lawdCodeList", lawdCodeList);
			
			// 2. 주간 발전소 및 발전량 정보 현황
			List<PlantStatWeekVO> plantStatWeekList = selectPlantStatWeekList(upperLawdCode);
			result.put("plantStatWeekList", plantStatWeekList);
			
			// 3. 주간 발전소 및 발전량 정보 총합
			PlantStatWeekTotalVO plantStatWeekTotal = selectPlantStatWeekTotal(upperLawdCode);
			result.put("plantStatWeekTotal", plantStatWeekTotal);
			
			// 4. 발전량 월간 현황
			List<GenStatMonthVO> genStatMonthList = selectGenStatMonthList(year);
			result.put("genStatMonthList", genStatMonthList);
			
			// 5. 발전소 연간 현황
			List<PlantStatYearVO> plantStatYearList = selectPlantStatYearList(year);
			result.put("plantStatYearList", plantStatYearList); 
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	@Override
	public List<LawdCodeVO> selectLawdList(String upperLawdCode) {
		List<LawdCodeVO> lawdCodeList = statusMapper.selectLawdList(upperLawdCode);
		return lawdCodeList;
	}

	@Override
	public List<PlantStatWeekVO> selectPlantStatWeekList(String upperLawdCode) {
		List<PlantStatWeekVO> plantStatWeekList = statusMapper.selectPlantStatWeekList(upperLawdCode);
		return plantStatWeekList;
	}

	@Override
	public PlantStatWeekTotalVO selectPlantStatWeekTotal(String upperLawdCode) {
		PlantStatWeekTotalVO plantStatWeekTotal = statusMapper.selectPlantStatWeekTotal(upperLawdCode);
		return plantStatWeekTotal;
	}

	@Override
	public List<GenStatMonthVO> selectGenStatMonthList(int year) {
		List<GenStatMonthVO> genStatMonthList = statusMapper.selectGenStatMonthList(year);
		return genStatMonthList;
	}

	@Override
	public List<PlantStatYearVO> selectPlantStatYearList(int year) {
		List<PlantStatYearVO> plantStatYearList = statusMapper.selectPlantStatYearList(year);
		return plantStatYearList;
	}



}
