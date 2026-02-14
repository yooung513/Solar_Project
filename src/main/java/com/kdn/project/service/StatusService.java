package com.kdn.project.service;

import java.util.List;
import java.util.Map;

import com.kdn.project.dto.StatusDTO;
import com.kdn.project.vo.GenStatMonthVO;
import com.kdn.project.vo.LawdCodeVO;
import com.kdn.project.vo.PlantStatWeekTotalVO;
import com.kdn.project.vo.PlantStatWeekVO;
import com.kdn.project.vo.PlantStatYearVO;

public interface StatusService {
	
	Map<String, Object> getStatusData(StatusDTO statusDTO); 
	
	List<LawdCodeVO> selectLawdList(String upperLawdCode);
	
	List<PlantStatWeekVO> selectPlantStatWeekList(String upperLawdCode);
	
	PlantStatWeekTotalVO selectPlantStatWeekTotal(String upperLawdCode);

	List<GenStatMonthVO> selectGenStatMonthList(int year);
	
	List<PlantStatYearVO> selectPlantStatYearList(int year);
}
