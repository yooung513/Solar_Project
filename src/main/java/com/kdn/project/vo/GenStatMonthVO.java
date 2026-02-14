package com.kdn.project.vo;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class GenStatMonthVO extends BaseVO {

	private String gsmId;
	private String lawdCode;
	private int year;
	private int month;
	private long fuelPwr;
	
}
