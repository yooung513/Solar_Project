<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.time.LocalDate" %>

<c:set var="currentYear" value="<%= LocalDate.now().getYear() %>" />    

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>KDN 태양광 발전소 현황 플랫폼</title>
	<script src="${pageContext.request.contextPath}/resources/js/jquery-3.7.1.js"></script>
	
	<script src="${pageContext.request.contextPath}/resources/js/chart.umd.min_4.4.js"></script> 
	<script src="${pageContext.request.contextPath}/resources/js/index.umd.min_4.3.js"></script>
	<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/main.css?after">
</head>

<body>
	<div id="app">
		<header>
			<%@ include file="common/header.jsp" %>
		</header>
		
		<main>
		<div class="container">
			<div class="colored-box"></div>
			
			<div class="mapContainer">
				<div class="infoPanel">
					<div class="infoHeader">
						<h3 class="infoBoxHeader"> 태양광 발전소 주간 현황 </h3>
						
						<div class="weekDate" id="weekDateDisplay">
							<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.8" stroke="currentColor" style="width: 23px; height: 23px; vertical-align: middle; margin-right: 4px;">
							  <path stroke-linecap="round" stroke-linejoin="round" d="M12 9v3.75m-9.303 3.376c-.866 1.5.217 3.374 1.948 3.374h14.71c1.73 0 2.813-1.874 1.948-3.374L13.949 3.378c-.866-1.5-3.032-1.5-3.898 0L2.697 16.126ZM12 15.75h.007v.008H12v-.008Z" />
							</svg>
							${statDate} 기준 데이터 입니다.
						</div>
					</div>
					
					<div class="regionInfo" id="regionInfo">
				        <h2 id="regionTitle"> 전국 주간 현황 </h2>
				        <div class="stat-container">
					        <div id="statRow">
					            <span class="label"> 발전소 개수 : </span>
					            <div class="value-group">
						            <span class="value" id="regionPlantCnt"> - </span>
						            <span class="label"> 개 </span>
					            </div> 
					        </div>
					        <div id="statRow">
					            <span class="label"> 발전 용량 : </span>
					            <div class="value-group">
						            <span class="value" id="regionPlantCap"> - </span>
						            <span class="label"> kW </span>
					            </div> 
					        </div>
					        <div id="statRow">
					            <span class="label"> 발전량 : </span>
					            <div class="value-group">
						            <span class="value" id="regionGenPwr"> - </span>
						            <span class="label"> MWh </span>
					            </div> 
					        </div>
				    	</div>
				    </div>
				    
				    <div class="districtInfo" id="districtInfo">
				        <h2 id="districtTitle"> 전국 주간 현황 </h2>
				        <div class="stat-container">
					        <div id="statRow">
					            <span class="label"> 발전소 개수 : </span>
					            <div class="value-group">
						            <span class="value" id="districtPlantCnt"> - </span>
						            <span class="label"> 개 </span>
					            </div> 
					        </div>
					        <div id="statRow">
					            <span class="label"> 발전 용량 : </span>
					            <div class="value-group">
						            <span class="value" id="districtPlantCap"> - </span>
						            <span class="label"> kW </span>
					           	</div> 
					        </div>
					        <div id="statRow">
					            <span class="label"> 발전량 : </span>
					            <div class="value-group">
						            <span class="value" id="districtGenPwr"> - </span>
						            <span class="label"> MWh </span>
					            </div> 
					        </div>
				        </div>
				    </div>
				</div>
				
				<div class="mapWrapper">
					<button class="backBtn" id="backBtn">
						← 돌아가기
					</button>
					
					<div class="mapLoading" id="mapLoading">
						<div class="spinner"></div>
						<span class="spinnerText"> 지도 불러오는 중 </span>
					</div>
					
					<canvas id="mapChart"></canvas>
				</div>
			</div>
		</div>
		</main>
	</div>
	
	<script>
		// 발전소 전국 주간 현황 데이터 
		const plantStatWeekTotal = {
			cnt: ${plantStatWeekTotal.totalPlantCnt},
			cap: ${plantStatWeekTotal.totalPlantCap},
			fuelPwr: ${plantStatWeekTotal.totalFuelPwr}
		};
		
		// 발전소 주간 현황 데이터
		const plantStatWeekData = [
			<c:forEach var="plant" items="${plantStatWeekList}" varStatus="status">
			{
				lawdCode: '${plant.lawdCode}',
				sido: '${plant.sidoDispName}',
				sidoName: '${plant.sidoName}',
				sgg: '${plant.sggName}',
				cnt: ${plant.plantCnt},
				cap: ${plant.plantCap},
				fuelPwr: ${plant.fuelPwr}
			}
			<c:if test="${!status.last}">,</c:if>
		</c:forEach>
		];
		
		const contextPath = '${pageContext.request.contextPath}';
	</script>
	<script src="${pageContext.request.contextPath}/resources/js/main.js"></script>
</body>
</html>