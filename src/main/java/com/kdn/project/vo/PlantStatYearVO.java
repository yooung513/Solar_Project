package com.kdn.project.vo;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@AllArgsConstructor
public class PlantStatYearVO extends BaseVO {
	
	private String psyId;
	private String lawdCode;
	private int year;
	private int plantCnt;
	private long plantCap;
	
}
