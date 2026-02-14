package com.kdn.project.dto;

import java.time.LocalDate;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class StatusDTO {
	
	private String lawdCode;
	private String upperLawdCode;
	private Integer year;
	
	public int getYearData() {
		return (year == null || year == 0)
				? LocalDate.now().getYear()-1 : year; 
	}
}
