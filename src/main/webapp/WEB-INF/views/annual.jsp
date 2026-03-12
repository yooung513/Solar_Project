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
	<script src="${pageContext.request.contextPath}/resources/js/chart.umd.min.js"></script>
	<script src="${pageContext.request.contextPath}/resources/js/index.umd.min.js"></script>
	<script src="${pageContext.request.contextPath}/resources/js/exceljs.min.js"></script>
	<script src="${pageContext.request.contextPath}/resources/js/FileSaver.min.js"></script>
	<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/annual.css?after">
</head>

<style>
	
</style>

<body>
	<div id="app">
		<header>
			<%@ include file="common/header.jsp" %>
		</header>
		
		<main>
		<div class="container">
			<div class="colored-box"> </div>
			
			<div class="itemContainer">
				<div class="buttonContainer">
					<div class="buttonWrapper">
						<button class="genBtn active" onclick="handleBtnClick('gen', this)"> 월 별 발전량 현황 </button>
						<button class="plantBtn" onclick="handleBtnClick('plant', this)"> 연도별 발전소 현황 </button>
					</div>
				</div>
				
				<div class="selectContainer">
					<div class="selectWrapper">
						<div class="yearControls">
							<select id="yearSel" class="yearSel">
								<c:forEach begin="1" end="5" var="i">
									<c:set var="year" value="${currentYear - i }"></c:set>
									<option value="${year }" ${year == currentYear-1 ? 'selected' : '' }>
										${year }년
									</option>
								</c:forEach>
							</select>
						</div>
						
						<button id="detailToggleBtn" class="detailToggleBtn" style="display: none;">
							<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
								<path stroke-linecap="round" stroke-linejoin="round" 
								d="m21 21-5.197-5.197m0 0A7.5 7.5 0 1 0 5.196 5.196a7.5 7.5 0 0 0 10.607 10.607ZM10.5 7.5v6m3-3h-6" />
							</svg>
							<span>지역별 상세보기</span>
							<span class="arrow">▼</span>
						</button>
					</div>
					
					<div class="filterPanel" id="filterPanel">
						<div class="filterContent">
							<div class="filterHeader">
								<span>표시할 지역 선택</span>
								<button class="selectAllBtn" id="selectAllBtn">전체 선택</button>
							</div>
							
							<div class="checkboxGrid" id="checkboxGrid"></div>
							
							<div class="filterButtons">
								<button class="filterBtn close" id="closeFilterBtn">닫기</button>
								<button class="filterBtn apply" id="applyFilterBtn">검색</button>
							</div>
						</div>
					</div>
				</div>
				
				<div class="chartContainer">
					<canvas class="chart" id="chart"></canvas>
				</div>
				
				<div class="downloadSection">
					<button class="downloadBtn" id="downloadExcelBtn">
						<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="size-6">
		  					<path stroke-linecap="round" stroke-linejoin="round" d="M19.5 14.25v-2.625a3.375 3.375 0 0 0-3.375-3.375h-1.5A1.125 1.125 0 0 1 13.5 7.125v-1.5a3.375 3.375 0 0 0-3.375-3.375H8.25m.75 12 3 3m0 0 3-3m-3 3v-6m-1.5-9H5.625c-.621 0-1.125.504-1.125 1.125v17.25c0 .621.504 1.125 1.125 1.125h12.75c.621 0 1.125-.504 1.125-1.125V11.25a9 9 0 0 0-9-9Z" />
						</svg>
						<span>엑셀 다운로드</span>
					</button>
				</div>
				
				<div class="tableContainer">
					<div class="tableWrapper">
						<div class="tableTitle" id="tableTitle"></div>
						<table class="dataTable" id="dataTable"></table>
					</div>
				</div>
			</div>
		</div>
		</main>
	</div>
	
	<script>
		// 발전량 월간 현황 데이터
		const genStatMonthData = [
			<c:forEach var="gen" items="${genStatMonthList}" varStatus="status">
				{
					sido: '${gen.sidoDispName}',
					month: ${gen.month},
					fuelPwr: ${gen.fuelPwr}
				}
				<c:if test="${!status.last}">,</c:if>
			</c:forEach>
		];
	
		// 발전소 연간 현황 데이터
		const plantStatYearData = [
			<c:forEach var="plant" items="${plantStatYearList}" varStatus="status">
				{
					
					sido: '${plant.sidoDispName}',
					sidoFull: '${plant.sidoName}',
					cnt: ${plant.plantCnt},
					cap: ${plant.plantCap}
				}
				<c:if test="${!status.last}">,</c:if>
			</c:forEach>
		];
	</script>
	<script src="${pageContext.request.contextPath}/resources/js/annual.js"></script>
</body>
</html>