package com.kdn.project.vo;

import java.time.LocalDateTime;

import com.fasterxml.jackson.annotation.JsonIgnore;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@AllArgsConstructor
public class LawdCodeVO extends BaseVO {
	
	private String lawdCode;
	private String sggName;
	private String umdName;
	private String riName;
	private String upperLawdCode;
	private String useFlag;
	private String geoJson;
	
	@JsonIgnore
	private LocalDateTime updatedAt;
	
}
