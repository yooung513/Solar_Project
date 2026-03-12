package com.kdn.project.vo;

import java.time.LocalDate;

import com.fasterxml.jackson.annotation.JsonFormat;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@AllArgsConstructor
public class PlantStatWeekVO extends BaseVO {

	private String pswId; 
	private String lawdCode;
	private String sggName;
	
	@JsonFormat(pattern = "yyyy. MM. dd")
	private LocalDate statDate;
	
	private int plantCnt;
	private long plantCap;
	private long fuelPwr;
	
}
