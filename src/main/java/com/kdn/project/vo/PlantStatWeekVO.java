package com.kdn.project.vo;

import java.time.LocalDate;

import com.fasterxml.jackson.annotation.JsonIgnore;

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
	
	@JsonIgnore
	private LocalDate statDate;
	
	private int plantCnt;
	private long plantCap;
	private long fuelPwr;
	
}
