package com.kdn.project.mapper;

import java.util.List;

import com.kdn.project.vo.GenStatMonthVO;
import com.kdn.project.vo.LawdCodeVO;
import com.kdn.project.vo.PlantStatWeekTotalVO;
import com.kdn.project.vo.PlantStatWeekVO;
import com.kdn.project.vo.PlantStatYearVO;

public interface StatusMapper {

	List<LawdCodeVO> selectLawdList(String upperLawdCode);
	
	List<LawdCodeVO> selectDistrictGeoJson(String upperLawdCode);
	
	List<PlantStatWeekVO> selectPlantStatWeekList(String upperLawdCode);
	
	PlantStatWeekTotalVO selectPlantStatWeekTotal(String upperLawdCode);
	
	List<GenStatMonthVO> selectGenStatMonthList(int year);
	
	List<PlantStatYearVO> selectPlantStatYearList(int year);
}
