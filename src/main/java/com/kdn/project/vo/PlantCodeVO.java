package com.kdn.project.vo;

import java.math.BigDecimal;
import java.time.LocalDate;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@AllArgsConstructor
public class PlantCodeVO extends BaseVO {

	private String plantCode;
	private String plantCop;
	private String plantName;
	private String lawdCode;
	private String address;
	private Long plantCap;
	private LocalDate compDate;
	private BigDecimal latitude;
	private BigDecimal longitude;
	private String useFlag;
	private String remarks;
	
}
