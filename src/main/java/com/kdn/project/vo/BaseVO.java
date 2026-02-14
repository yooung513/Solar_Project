package com.kdn.project.vo;

import java.time.LocalDateTime;

import com.fasterxml.jackson.annotation.JsonIgnore;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public abstract class BaseVO {
	
	@JsonIgnore 
	private LocalDateTime createdAt;
	protected String sidoName;
	
	public String getSidoDispName() {
		if(this.sidoName == null || this.sidoName.isEmpty()) return "";
		
		if(this.sidoName.length() == 4) {
			return String.valueOf(this.sidoName.charAt(0)) + String.valueOf(this.sidoName.charAt(2));		
		}
		
		return this.sidoName.substring(0, 2);
	}
}
