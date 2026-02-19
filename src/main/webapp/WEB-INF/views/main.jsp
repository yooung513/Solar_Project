<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.time.LocalDate" %>

<c:set var="currentYear" value="<%= LocalDate.now().getYear() %>" />    

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>KDN 태양광 발전</title>
	<script src="${pageContext.request.contextPath}/resources/js/jquery-3.7.1.js"></script>
	<script src="${pageContext.request.contextPath}/resources/js/chart.umd.min.js"></script>
	<script src="${pageContext.request.contextPath}/resources/js/index.umd.min.js"></script>
</head>

<style>
	/* 전기안전체 */
	@font-face {	
		font-family: 'Electrical-Safety-Regular';	
		src: url('/resources/fonts/Electrical-Safety-Regular.woff') format('woff');
	    font-weight: normal;
	    font-display: swap;
	}
	
	@font-face {	
		font-family: 'Electrical-Safety-Bold';	
		src: url('/resources/fonts/Electrical-Safety-Bold.woff') format('woff');
	    font-weight: normal;
	    font-display: swap;
	}
	
	/* 한돋움체 */
	@font-face {	
		font-family: 'KhnpHandot-Bold';	
		src: url('/resources/fonts/KhnpHandot_B.woff') format('woff');
	    font-weight: normal;
	    font-display: swap;
	}
	
	@font-face {	
		font-family: 'KhnpHandot-Regular';	
		src: url('/resources/fonts/KhnpHandot_R.woff') format('woff');
	    font-weight: normal;
	    font-display: swap;
	}
	
	.container {
		margin: 0;
		padding: 0;
		box-sizing: border-box;
	}
	
	.mapContainer {
		width: 1800px;
		height: 800px;
		background-color: #95c0fe;
		position: relative;
	} 
	
	.mapWrapper {
		position: absolute;
		width: 1050px;
		height: 700px;
		background-color: blue;
		margin: 50px;
	}
	
	.infoWrapper {
		position: absolute;
		width: 600px;
		height: 700px;
		background-color: blue;
		left: 1100px;
		margin: 50px;
	}
	
	.detailContainer {
		position: relative;
		width: 1800px;
	}
	
	.controlWrapper {
		position: absolute;
		top: 50px;
		left: 50px;
		right: 50px;
		bottom: 50px;
		height: 80px;	
		z-index: 10;
		
		display: flex;
		justify-content: space-between;
		align-items: center;
		gap: 20px;
	}
	
	.buttonWrapper {
		width: 500px;
		height: 60px;
		
		display: flex;
		gap: 0;
		border-radius: 50px;
		overflow: hidden;
		box-shadow: 0 4px 15px rgba(0, 0, 0, 0.3);
	}
	
	.genBtn, .plantBtn {
		flex: 1;
		height: 100%;
		border: none;
		margin: 0;
		padding: 0;
		outline: none;
		font-family: Electrical-Safety-Regular;
		font-size: 30px;
		background-color: #ffffff;
		color: #0d6efd;
		cursor: pointer;
		
		position: relative;
		z-index: 1;
		transition: all 0.8s ease;
		overflow: hidden;
	}
	
	.genBtn.active, .plantBtn.active {
		font-family: 'Electrical-Safety-Bold'; 
		background-color: #0d6efd;
		color: #ffffff;
		cursor: default;
		z-index: 2;
	}
	
	.genBtn:after, .plantBtn:after {
		position: absolute;
		content: "";
		width: 0;
		height: 100%;
		top: 0;
		right: 0;
		z-index: -1;
		background-color: #0d6efd;
		transition: all 0.8s ease;
	}
	
	.genBtn:not(.active):hover, .plantBtn:not(.active):hover {
		color: #ffffff;
	}
	
	.genBtn:not(.active):hover:after, .plantBtn:not(.active):hover:after {
		left: 0;
		width: 100%;
	}
	
	.selectWrapper {
		display: flex;
		align-items: center;
		gap: 15px;
		font-family: 'KhnpHandot-Regular';
		font-size: 24px;
	}
	
	.selectWrapper label {
		font-family: 'KhnpHandot-Bold';
		font-size: 24px;
		color: #0d6efd;
	}
	
	.yearSel {
		padding: 10px 20px;
		font-family: 'KhnpHandot-Regular';
		font-size: 22px;
		border: 2px solid #0d6efd;
		border-radius: 8px;
		background-color: #ffffff;
		color: #0d6efd;
		cursor: pointer;
		transition: all 0.3s ease;
		outline: none;
	}
	
	.yearSel:hover {
		background-color: #0d6efd;
		color: #ffffff;
	}
	
	.yearSel:focus {
		border-color: #0d6efd;
		box-shadow: 0 0 0 3px rgba(13, 110, 253, 0.25);
	}
	
	.chartWrapper {
		position: relative;
		top: 50px;
		width: 1800px;
		height: 1000px;
		
		display: flex;
		justify-content: center;
		align-items: center;
	}
	
	.chart{
		max-width: 90%;
		max-height: 85%;
	}
	
	.tableWrapper {
		position: relative;
		width: 1800px;
		padding: 50px;
		box-sizing: border-box;
	}
	
	.tableContainer {
		width: 100%;
		min-width: 1200px;
		background-color: #ffffff;
		border-radius: 10px;
		box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
		overflow: hidden;
	}
	
	.tableTitle {
		font-family: 'KhnpHandot-Regular';
		font-size: 24px;
		padding: 20px 30px;
		background-color: #0d6efd;
		color: #ffffff;
		text-align: center;
	}
	
	.dataTable {
		width: 100%;
		border-collapse: collapse;
		font-family: 'KhnpHandot-Regular';
	}
	
	.dataTable thead {
		background-color: #f8f9fa;
	}
	
	.dataTable th, .dataTable td:first-child {
		padding: 15px;
		text-align: center;
		font-family: 'KhnpHandot-Regular';
		font-size: 20px;
		border-bottom: 2px solid #dee2e6;
		color: #495057;
	}
	
	.dataTable td:first-child strong {
		display: block;
		white-space: pre-line;
		line-height: 1.4;
	}
	
	.dataTable td {
		padding: 12px 15px;
		text-align: center;
		border-bottom: 1px solid #dee2e6;
		font-size: 18px;
	}
	
	.dataTable tbody tr:hover {
		background-color: #f8f9fa;
	}
	
	.dataTable tbody tr:last-child td {
		border-bottom: none;
	}
	
	.plantTable {
		font-size: 14px;
	}
	
	.plantTable th {
		padding: 10px 5px;
		font-size: 18px;
		white-space: nowrap;
	}
	
	.plantTable td {
		padding: 8px 5px;
		font-size: 16px;
	}
	
	.plantTable td:first-child {
		min-width: 80px; 
		font-size: 18px;
	}
	
	.plantTable td:first-child strong {
		font-size: 18px;
		line-height: 1.3;
	}
	
	.number {
		text-align: right;
		font-family: 'KhnpHandot-Regular';
	}
	
	.total-row {
		background-color: #e7f3ff;
		font-family: 'KhnpHandot-Bold';
	}
	
	.total-row td {
		font-weight: bold;
		color: #0d6efd;
	}
</style>

<body>
	<div id="app">
		<header>
			<%@ include file="common/header.jsp" %>
		</header>
		
		<main>
			<div class="container">
				<div class="mapContainer">
					<div class="mapWrapper">
						<canvas id="mapChart"></canvas>
					</div>
						
					<div class="infoWrapper">
						<div id="regionInfo">
					        <h3 id="regionName">전국</h3>
					        <div id="regionStats">
					            <p>발전소 개수: <span id="plantCnt">-</span>개</p>
					            <p>발전 용량: <span id="plantCap">-</span>kW</p>
					            <p>발전량: <span id="genPwr">-</span>MWh</p>
					        </div>
					    </div>
					</div>
				</div>
				
				<div class="detailContainer">
					<div class="controlWrapper">
						<div class="buttonWrapper">
							<button class="genBtn active" onclick="handleBtnClick('gen', this)"> 발전량 현황 </button>
							<button class="plantBtn" onclick="handleBtnClick('plant', this)"> 발전소 현황 </button>
						</div>
						
						<div class="selectWrapper">
							<label for="yearSel"> 조회 년도 </label>
							<select id="yearSel" class="yearSel">
								<c:forEach begin="1" end="5" var="i">
									<c:set var="year" value="${currentYear - i }"></c:set>
									<option value="${year }" ${year == currentYear-1 ? 'selected' : '' }>
										${year }년
									</option>
								</c:forEach>
							</select>
						</div>
					</div>
						
					<div class="chartWrapper">
						<canvas id="chart" class="chart"></canvas>
					</div>
					
					<div class="tableWrapper">
						<div class="tableContainer">
							<div class="tableTitle" id="tableTitle">
							</div>
							<table class="dataTable" id="dataTable">
							</table>
						</div>
					</div>
				</div>
			</div>
		</main>
	</div>
	
	<script>
		var currentChartType = 'gen'; // 초기 차트 타입
		// 코드 매핑
		const CODE_TO_SIDO = {
			"11": "서울", "26": "부산", "27": "대구", "28": "인천",
			"29": "광주", "30": "대전", "31": "울산", "36": "세종",
			"41": "경기", "42": "강원", "43": "충북", "44": "충남",
			"45": "전북", "46": "전남", "47": "경북", "48": "경남",
			"50": "제주"
		};
		
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
					cnt: ${plant.plantCnt},
					cap: ${plant.plantCap}
				}
				<c:if test="${!status.last}">,</c:if>
			</c:forEach>
		];
	
		// 시도별 데이터 그룹화
		function groupBySido(data) {
			const result = {};
			data.forEach(item => {
				if(!result[item.sido]) {
					result[item.sido] = [];
				}
				
				result[item.sido].push(item);
			});
			
			return result; 
		}
		
		var genBySido = groupBySido(genStatMonthData);
		var plantBySido = groupBySido(plantStatYearData);
		
		// 최대 월 계산 (실제 최대 월 계산)
		function getMaxMonth(data) {
			var maxMonth = 0;
			
			data.forEach(item => {
				if (item.month > maxMonth) {
					maxMonth = item.month;
				}
			});
			return maxMonth || 12; // 데이터 없으면 12월까지
		}
	
		var maxGenMonth = getMaxMonth(genStatMonthData);
		
		// Chart.js 색상
		function getRandomColor(index) {
			const colors = [
				'rgb(255, 99, 132)', 'rgb(54, 162, 235)', 'rgb(255, 206, 86)',
				'rgb(75, 192, 192)', 'rgb(153, 102, 255)', 'rgb(255, 159, 64)',
				'rgb(46, 204, 113)', 'rgb(231, 76, 60)', 'rgb(52, 152, 219)',
				'rgb(241, 196, 15)', 'rgb(26, 188, 156)', 'rgb(155, 89, 182)',
				'rgb(52, 73, 94)', 'rgb(230, 126, 34)', 'rgb(149, 165, 166)',
				'rgb(22, 160, 133)', 'rgb(211, 84, 0)'
			];
			return colors[index % colors.length];
		}
	
		// 지도 차트 초기화
		function initMap() {
			$.getJSON('${pageContext.request.contextPath}/resources/geojson/korea.geojson', function(geoJson) {
				createMapChart(geoJson);
			}).fail(function() {
				console.error('GeoJSON 파일을 불러올 수 없습니다.');
				alert('지도 데이터를 불러오는데 실패했습니다.');
			});
		}
		
		// 지도 차트 생성
		function createMapChart(geoJson) {
			const ctx = document.getElementById('mapChart');
		}
		
		// 발전량 차트 데이터 생성
		function createGenChartData(dataBySido) {
			return {
				labels: Array.from({length: maxGenMonth}, (_, i) => (i + 1) + '월'),
				datasets: Object.keys(dataBySido).map((sido, index) => {
					const sidoData = dataBySido[sido];
					const monthlyData = Array(maxGenMonth).fill(0);
					sidoData.forEach(item => {
						if (item.month <= maxGenMonth) {
							monthlyData[item.month - 1] = item.fuelPwr;
						}
					});
					
					const color = getRandomColor(index);
					return {
						label: sido,
						data: monthlyData,
						borderColor: color,
						backgroundColor: color.replace('rgb', 'rgba').replace(')', ', 0.1)'),
						tension: 0.4,
						fill: false,
						pointRadius: 4,
						pointHoverRadius: 6
					};
				})
			};
		}
				
		// 발전소 차트 데이터 생성
		function createPlantChartData(dataBySido) {
		    const sidoList = Object.keys(dataBySido);
		    const cntData = [];
		    const capData = [];
		    
		    sidoList.forEach(sido => {
		        const sidoData = dataBySido[sido][0];
		        cntData.push(sidoData.cnt);
		        capData.push(sidoData.cap);
		    });
		    
		    return {
		        labels: sidoList,
		        datasets: [
		            {
		                type: 'bar',
		                label: '발전소 개수',
		                data: cntData,
		                backgroundColor: 'rgba(54, 162, 235, 0.6)',
		                borderColor: 'rgb(54, 162, 235)',
		                borderWidth: 2,
		                yAxisID: 'y',
		                order: 2
		            },
		            {
		                type: 'line',
		                label: '발전소 용량',
		                data: capData,
		                borderColor: 'rgb(255, 99, 132)',
		                backgroundColor: 'rgba(255, 99, 132, 0.1)',
		                borderWidth: 3,
		                tension: 0.4,
		                fill: false,
		                pointRadius: 6,
		                pointHoverRadius: 8,
		                pointBackgroundColor: 'rgb(255, 99, 132)',
		                pointBorderColor: '#fff',
		                pointBorderWidth: 2,
		                yAxisID: 'y1',
		                order: 1
		            }
		        ]
		    };
		}

		// 발전량 차트 옵션 설정
		function getGenChartOptions(year) {
			return {
				responsive: true,
				maintainAspectRatio: false,
				plugins: {
					title: {
						display: true,
						text: year + '년 시도별 발전량 현황',
						font: { size: 30, family: 'KhnpHandot-Regular' }
					},
					legend: {
						display: true,
						position: 'bottom',
						labels: {
							font: { size: 16, family: 'KhnpHandot-Regular' },
							usePointStyle: true,
							padding: 20
						}
					},
					tooltip: {
						callbacks: {
							label: function(context) {
								var label = context.dataset.label || '';
								label += ': ' + context.parsed.y.toLocaleString() + ' MWh';
								return label;
							}
						}
					}
				},
				scales: {
					y: {
						beginAtZero: true,
						title: { display: true, text: '발전량 (MWh)', font: { size: 18, family: 'KhnpHandot-Regular' } },
						ticks: {
							callback: function(value) {
								return value.toLocaleString();
							}
						}
					}
				},
				interaction: {
					mode: 'index',
					intersect: false
				}
			};
		}
		
		// 발전소 차트 옵션 설정
		function getPlantChartOptions(year) {
			return {
				responsive: true,
			    maintainAspectRatio: false,
			    plugins: {
			        title: {
			            display: true,
			            text: year + '년 시도별 신규 발전소 설치 현황',
			            font: { size: 30, family: 'KhnpHandot-Regular' }
			        },
			        legend: {
			            display: true,
			            position: 'bottom',
			            labels: {
			                font: { size: 16, family: 'KhnpHandot-Regular' },
			                usePointStyle: true,
			                padding: 20
			            }
			        },
			        tooltip: {
			            callbacks: {
			                label: function(context) {
			                    var label = context.dataset.label || '';
			                    if (context.dataset.type === 'bar') {
			                        label += ': ' + context.parsed.y.toLocaleString() + '개';
			                    } else {
			                        label += ': ' + context.parsed.y.toLocaleString() + ' kW';
			                    }
			                    return label;
			                }
			            }
			        }
			    },
			    scales: {
			        x: {
			            grid: {
			                display: false
			            }
			        },
			        y: {
			            type: 'linear',
			            display: true,
			            position: 'left',
			            beginAtZero: true,
			            title: { 
			                display: true, 
			                text: '발전소 개수 (개)', 
			                font: { size: 18, family: 'KhnpHandot-Regular' },
			            },
			            ticks: {
			                callback: function(value) {
			                    return value.toLocaleString();
			                },
			            },
			            grid: {
			                color: 'rgba(54, 162, 235, 0.1)'
			            }
			        },
			        y1: {
			            type: 'linear',
			            display: true,
			            position: 'right',
			            beginAtZero: true,
			            title: { 
			                display: true, 
			                text: '발전소 용량 (kW)', 
			                font: { size: 18, family: 'KhnpHandot-Regular' },
			            },
			            ticks: {
			                callback: function(value) {
			                    return value.toLocaleString();
			                },
			            },
			            grid: {
			                drawOnChartArea: false
			            }
			        }
			    },
			    interaction: {
			        mode: 'index',
			        intersect: false
			    }
			};
		}
				
		// Chart 인스턴스 생성
		const ctx = document.getElementById('chart');
		var chart = new Chart(ctx, {
			type: 'line',
			data: createGenChartData(genBySido),
			options: getGenChartOptions($('#yearSel').val())
		});
		
		
		// 버튼 클릭 핸들러 (발전량/발전소 전환)
		function handleBtnClick(type, element) {
			$(element).addClass('active').siblings().removeClass('active');
			currentChartType = type;
			
			updateChart();
		}

		// 연도 변경
		$('#yearSel').on('change', function() {
		    const year = $(this).val();
		    
		    $.ajax({
		        url: '/getYearData',  // 컨트롤러 URL
		        type: 'GET',
		        data: { year: year },
		        dataType: 'json',
		        success: function(response) {
		            // 발전량 데이터 업데이트
		            if (response.genStatMonthList) {
		                const genData = response.genStatMonthList.map(gen => ({
		                    sido: gen.sidoDispName,
		                    month: gen.month,
		                    fuelPwr: gen.fuelPwr
		                }));
		                genBySido = groupBySido(genData);
		                maxGenMonth = getMaxMonth(genData);
		            }
		            
		            // 발전소 데이터 업데이트
		            if (response.plantStatYearList) {
		                const plantData = response.plantStatYearList.map(plant => ({
		                    sido: plant.sidoDispName,
		                    cnt: plant.plantCnt,
		                    cap: plant.plantCap
		                }));
		                plantBySido = groupBySido(plantData);
		            }
		            
		            // 차트 업데이트
		            updateChart();
		        },
		        error: function(xhr, status, error) {
		            console.error('데이터 로드 실패:', error);
		            alert('데이터를 불러오는데 실패했습니다.');
		        }
		    });
		});
		
		// 차트 업데이트
		function updateChart() {
			const selectedYear = $('#yearSel').val();
		    
		    if (currentChartType === 'gen') {
		        // 발전량 차트
		        chart.data = createGenChartData(genBySido);
		        chart.options = getGenChartOptions(selectedYear);
		    } else if (currentChartType === 'plant') {
		        // 발전소 차트
		        chart.data = createPlantChartData(plantBySido);
		        chart.options = getPlantChartOptions(selectedYear);
		    }
		    
		    chart.update('active');
		    updateTable();
		}
		
		// 발전량 테이블 생성
		function createGenTable(year) {
			var html = '';
			
			// table haed
			html += '<thead>';
			html += '<tr>';
			html += '<th> </th>';
			
			for(var i=0; i < maxGenMonth; i++) {
				html += '<th>' + (i+1) + '월 </th>';
			}
			
			html += '</tr>';
			html += '</thead>';
			
			// table body 
			html += '<tbody>';
			
			// 시도별 데이터 출력
			Object.keys(genBySido).forEach(sido => {
				const sidoData = genBySido[sido];
				const monthlyData = Array(maxGenMonth).fill(0);
				
				// 월별 데이터 채우기
				sidoData.forEach(item => {
					if (item.month <= maxGenMonth) {
						monthlyData[item.month - 1] = item.fuelPwr;
					}
				});
				
				// 행 생성
				html += '<tr>';
				html += '<td><strong>' + sido + '</strong></td>';
				
				monthlyData.forEach(val => {
					html += '<td class="number">' + val.toLocaleString() + '</td>';
				});
				
				html += '</tr>';
			});
			
			html += '</tbody>';
			
			return html;
		}
		
		// 발전소 테이블 생성
		function createPlantTable(year) {
			var sidoList = Object.keys(plantBySido);
			var html = '';
			
			// table head
			html += '<thead>';
			html += '<tr>';
			html += '<th style="width: 100px;"> </th>';
			
			sidoList.forEach(sido => {
				html += '<th style="min-width: 70px;">' + sido + '</th>';
			});
			
			html += '</tr>';
			html += '</thead>';
			
			// table body
			html += '<tbody>';
			
			// 발전소 개수 
			html += '<tr>';
			html += '<td style="width: 100px;"><strong> 발전소\n개수\n(개) </strong></td>';
			
			sidoList.forEach(sido => {
				var cnt = plantBySido[sido][0].cnt;
				html += '<td class="number" style="min-width: 70px;">' + cnt.toLocaleString() + '</td>';
			});
			html += '</tr>';
			
			// 발전소 용량
			html += '<tr>';
			html += '<td style="width: 100px;"><strong> 발전소\n용량\n(kW) </strong></td>';
			
			sidoList.forEach(sido => {
				var cap = plantBySido[sido][0].cap;
				html += '<td class="number style="min-width: 70px;">' + cap.toLocaleString() + '</td>';
			});
			html += '</tr>';
			
			html += '</tbody>';
			
			return html;
		}

		
		// 테이블 업데이트
		function updateTable() {
			const selectedYear = $('#yearSel').val();
			const tableTitle = $('#tableTitle');
			const dataTable = $('#dataTable');
			
			if (currentChartType === 'gen') {
				tableTitle.text(selectedYear + '년 시도별 발전량 현황 (MWh)');
				dataTable.html(createGenTable(selectedYear));
			} else if (currentChartType === 'plant') {
				tableTitle.text(selectedYear + '년 시도별 신규 발전소 설치 현황');
				dataTable.addClass('plantTable');
				dataTable.html(createPlantTable(selectedYear));
			}
		}

		$(document).ready(function() {
			updateTable();
		});
	</script>
</body>
</html>