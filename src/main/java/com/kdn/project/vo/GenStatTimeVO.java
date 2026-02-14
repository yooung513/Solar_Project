package com.kdn.project.vo;

import java.time.LocalDateTime;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@AllArgsConstructor
public class GenStatTimeVO extends BaseVO {
	
	private String gstId;
	private String lawdCode;
	private String plantCode;
	private LocalDateTime StatDatetime;
	private long fuelPwr;
	private String predicFlag;

}
