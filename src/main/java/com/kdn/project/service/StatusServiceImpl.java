package com.kdn.project.service;

import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
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
	
	private ObjectMapper objectMapper = new ObjectMapper();
	
	/*
	 * 메인 페이지 데이터 조회
	 */
	@Override
	public Map<String, Object> getWeekStatusData(StatusDTO statusDTO) {
		Map<String, Object> result = new HashMap<>();
		
		try {
			String upperLawdCode = StringUtils.hasText(statusDTO.getUpperLawdCode())
									? statusDTO.getUpperLawdCode() : "00";
			
			// 1. 법정동 코드 
			List<LawdCodeVO> lawdCodeList = selectDistrictGeoJson(upperLawdCode);
			result.put("lawdCodeList", lawdCodeList);
			
			// 2. 주간 발전소 및 발전량 정보 현황
			List<PlantStatWeekVO> plantStatWeekList = selectPlantStatWeekList(upperLawdCode);
			result.put("plantStatWeekList", plantStatWeekList);
			result.put("statDate", plantStatWeekList.get(0).getStatDate()
					.format(DateTimeFormatter.ofPattern("yyyy. MM. dd")));
			
			// 3. 주간 발전소 및 발전량 정보 총합
			PlantStatWeekTotalVO plantStatWeekTotal = selectPlantStatWeekTotal(upperLawdCode);
			result.put("plantStatWeekTotal", plantStatWeekTotal);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	
	/*
	 * 구 단위 데이터 조회
	 */
	@Override
	public Map<String, Object> getDistrictData(StatusDTO statusDTO) {
		Map<String, Object> result = new HashMap<>();
		
		try {
			String upperLawdCode = StringUtils.hasText(statusDTO.getUpperLawdCode())
					? statusDTO.getUpperLawdCode() : "00";
			
			// 1. 지도 데이터
			List<LawdCodeVO> lawdCodeList = selectDistrictGeoJson(upperLawdCode);
			
			List<Map<String, Object>> features = lawdCodeList.stream()
													.filter(lawd -> lawd != null && lawd.getGeoJson() != null)
													.map(lawd -> {
														
				Map<String, Object> feature = new HashMap<>();
				
				try {
					feature.put("type", "Feature");
					
					JsonNode geometryNode = objectMapper.readTree(lawd.getGeoJson());
					feature.put("geometry", geometryNode);
					
				} catch (JsonMappingException e) {
					e.printStackTrace();
				} catch (JsonProcessingException e) {
					e.printStackTrace();
				}
				
				Map<String, Object> properties = new HashMap<>();
				properties.put("lawd_code", lawd.getLawdCode());
				properties.put("sgg_name", lawd.getSggName());
				
				feature.put("properties", properties);
				
				return feature;
			}).collect(Collectors.toList());
			
			result.put("type", "FeatureCollection");
			result.put("features", features);
			
			// 2. 주간 발전소 및 발전량 정보 현황
			List<PlantStatWeekVO> plantStatWeekList = selectPlantStatWeekList(upperLawdCode);
			result.put("plantStatWeekList", plantStatWeekList);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	
	/*
	 * 연간 페이지 데이터 조회
	 */
	@Override
	public Map<String, Object> getAnnualStatusData(StatusDTO statusDTO) {
		Map<String, Object> result = new HashMap<>();
		
		try {
			String upperLawdCode = StringUtils.hasText(statusDTO.getUpperLawdCode())
									? statusDTO.getUpperLawdCode() : "00";
			
			int year = statusDTO.getYearData();
			
			// 1. 법정동 코드 
			List<LawdCodeVO> lawdCodeList = selectLawdList(upperLawdCode);
			result.put("lawdCodeList", lawdCodeList);
			
			// 2. 발전량 월간 현황
			List<GenStatMonthVO> genStatMonthList = selectGenStatMonthList(year);
			result.put("genStatMonthList", genStatMonthList);
			
			// 3. 발전소 연간 현황
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

	@Override
	public List<LawdCodeVO> selectDistrictGeoJson(String upperLawdCode) {
		List<LawdCodeVO> districtGeoJsonList = statusMapper.selectDistrictGeoJson(upperLawdCode);
		return districtGeoJsonList;
	}

}
