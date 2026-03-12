	/*
		데이터 생성 및 초기 설정
	*/
	let mapChart;
	let currentView = 'region';	// region || district
	let districtStatData = [];


	/*
		인포 박스 생성
	*/
	// 인포 박스 업데이트 - Region
	function updateRegionInfo(upperLawdcode) {
		let data;
		
		if (upperLawdcode === '00') {
			data = {
				name: '전국',
				cnt: plantStatWeekTotal.cnt,
				cap: plantStatWeekTotal.cap,
				fuelPwr: plantStatWeekTotal.fuelPwr
			};
		} else {
			const findData = plantStatWeekData.find(p => p.lawdCode.substring(0, 2) === upperLawdcode.substring(0, 2));
			data = {
				name: (findData ? findData.sidoName : '지역'),
				cnt: findData ? findData.cnt : 0,
				cap: findData ? findData.cap : 0,
				fuelPwr: findData ? findData.fuelPwr : 0
			};
		}
		
		$('#regionTitle').text(data.name);                   
		$('#regionPlantCnt').text(data.cnt.toLocaleString());
		$('#regionPlantCap').text(data.cap.toLocaleString());
		$('#regionGenPwr').text(data.fuelPwr.toLocaleString());
	}
	
	// 인포 박스 업데이트 - District
	function updateDistrictInfo(data) {
		if(!data) return; 
		
		const title = (data.sggName && data.sggName !== 'null') ? data.sggName
				: (data.sgg && data.sgg !== 'null') ? data.sgg 
				: data.sidoName; 
		
		$('#districtTitle').text(title);
		$('#districtPlantCnt').text((data.cnt ?? data.plantCnt ?? 0).toLocaleString());
		$('#districtPlantCap').text((data.cap ?? data.plantCap ?? 0).toLocaleString());
		$('#districtGenPwr').text((data.fuelPwr ?? 0).toLocaleString());	
	}
	
	
	/*
		지도 차트
	*/
	// 지도 차트 초기화
	function initMap() {
		districtStatData = [];
		currentView = 'region'
		$('#backBtn').hide();
		
		showLoading();
		
		let initData = plantStatWeekData.find(p => p.lawdCode === '11');
		updateRegionInfo('00');
		updateDistrictInfo(initData);
		
		$.ajax({
			url: contextPath + '/resources/geojson/00_korea.geo.json',
			type: 'GET',
			dataType: 'json',
			cache: true,
			success: function(geoJson) {
				createMapChart(geoJson, '00', plantStatWeekData);
				hideLoading();
			},
			error: function() {
				alert('지도 데이터를 불러오는데 실패했습니다.');
			}
		});
	}
	
	// 지도 커스텀 범례 플러그인
	const customLegendPlugin = {
	    id: 'customLegend',
	    afterDraw(chart) {
	        const ctx = chart.ctx;
	        const chartArea = chart.chartArea;
	        
	        const dataset = chart.data.datasets[0].data;
	        const maxValue = Math.max.apply(null, dataset.map( d => d.value || 0 ));
	        
	        const legendWidth = 300;
	        const legendHeight = 20;
	        const x = chartArea.right - legendWidth - 60;
	        const y = chartArea.bottom - 100;
	        
	        ctx.save();

	        // 범례 제목
	        ctx.font = '20px PretendardGOV-SemiBold';
	        ctx.fillStyle = '#333333';
	        ctx.textAlign = 'left';
	        ctx.fillText('발전량 현황 (MWh)', x, y - 8);

	        // 그라디언트 바
	        const gradient = ctx.createLinearGradient(x, 0, x + legendWidth, 0);
	        gradient.addColorStop(0, 'rgba(13, 110, 253, 0.2)');
	        gradient.addColorStop(1, 'rgba(13, 110, 253, 1.0)');
	        ctx.fillStyle = gradient;
	        ctx.fillRect(x, y, legendWidth, legendHeight);

	        // 테두리
	        ctx.strokeStyle = '#f5f1dc';
	        ctx.lineWidth = 1;
	        ctx.strokeRect(x, y, legendWidth, legendHeight);

	        // 구간 tick
	        const dataCount = dataset.length;
    		const steps = dataCount <= 1 ? 1 : 2;
    		
	        for (let i = 0; i <= steps; i++) {
	            const ratio = i / steps;
	            const tickX = x + legendWidth * ratio;
	            const tickValue = Math.round(maxValue * ratio);

	            if (i === 0) ctx.textAlign = 'left';
	            else if (i === steps) ctx.textAlign = 'right';
	            else ctx.textAlign = 'center';
	            
	            ctx.font = '15px PretendardGOV-Regular';
	            ctx.fillStyle = '#555555';
	            ctx.fillText(tickValue.toLocaleString(), tickX, y + legendHeight + 18);
	        }
	        
	        ctx.restore();
	    }
	};
	
	// 지도 크기 설정
	const paddingMap = {
		'00': 0,      // 전국                                                                                                                         // 전국
      	'11': { top: 150, bottom: 150, left: 80,  right: 150 },     // 서울
        '26': { top: 100, bottom: 100, left: 100, right: 150 },     // 부산
        '27': { top: 100, bottom: 100, left: 100, right: 150 },     // 대구
        '28': { top: 100, bottom: 150, left: 100, right: 100 },     // 인천
        '29': { top: 180, bottom: 180, left: 180, right: 180 },     // 광주
        '30': { top: 150, bottom: 150, left: 100, right: 100 },     // 대전
        '31': { top: 180, bottom: 180, left: 100, right: 180 },     // 울산
        '36': { top: 180, bottom: 180, left: 100, right: 100 },     // 세종
        '41': { top: 100, bottom: 100, left: 100, right: 200 },     // 경기
        '51': { top: 100, bottom: 180, left: 100, right: 150 },     // 강원
        '43': { top: 130, bottom: 130, left: 100, right: 100 },     // 충북
        '44': { top: 130, bottom: 150, left: 100, right: 150 },     // 충남
        '52': { top: 150, bottom: 180, left: 150, right: 200 },     // 전북
        '46': { top: 100, bottom: 100, left: 100, right: 200 },     // 전남
        '47': { top: 100, bottom: 150, left: 100, right: 180 },     // 경북
        '48': { top: 100, bottom: 100, left: 100, right: 100 },     // 경남
        '50': { top: 100, bottom: 100, left: 200, right: 200 },     // 제주		
	}         
	
	// 지도 차트 생성
	function createMapChart(geoJson, upperLawdCode, statData) {
		const ctx = document.getElementById('mapChart');
		
		if(mapChart) mapChart.destroy();
		
		// 발전소 데이터 찾기
		function findPlantData(lawdCode) {
			const data = statData.find(item => item.lawdCode.toString() === lawdCode.toString());
			
			return data || {sido: '오류', sgg: '오류', cnt: 0, cap: 0, fuelPwr: 0};
		}
		
		const mapData = geoJson.features.map(feature => { 
			const lawdCode = feature.properties.lawd_code;
			const plantData = findPlantData(lawdCode);
			
			return {
				feature: feature,
				lawdCode: lawdCode,
				sido: plantData.sido,
				value: plantData.fuelPwr
			};
		});	
		
		const maxValue = Math.max.apply(null, mapData.map(d => d.value));
		const currentPadding = paddingMap[upperLawdCode.substring(0, 2)] || 0;
		mapChart = new Chart(ctx, {
			type: 'choropleth',
			plugins: [customLegendPlugin],   // 범례 플러그인
			data: {
				labels: mapData.map(d => d.feature.properties.sido_name || d.feature.properties.sgg_name),
				datasets: [{
					label: '발전량 현황',
					data: mapData,
					outline: geoJson.features,
					backgroundColor: function(context) {
						if (!context.raw) return 'rgba(13, 110, 253, 0.3)';		// 데이터가 없는 경우 
						
						const value = context.raw.value;
						const ratio = value / maxValue;
						const opacity = 0.2 + (ratio * 0.8);
						
						return 'rgba(13, 110, 253, ' + opacity + ')';
					},
					borderColor: '#ffffff',
					borderWidth: 2,
					hoverBackgroundColor: 'rgba(255, 95, 0, 0.8)',
					hoverBorderColor: '#e65600',
					hoverBorderWidth: 2
				}]
			},
			options: {
				responsive: true,
				maintainAspectRatio: false,
				showOutline: true,
				showGraticule: false,
				plugins: {
					legend: {
						display: false
					},
					tooltip: {
						enabled: true,
						backgroundColor: 'rgba(0, 0, 0, 0.8)',
						titleFont: { size: 18, family: 'PretendardGOV-SemiBold' },
						bodyFont: { size: 16, family: 'PretendardGOV-Regular' },
						padding: 15,
						boxPadding: 5,
						callbacks: {
							title: function(context) {
								const lawdCode = context[0].raw.feature.properties.lawd_code;
								const data = findPlantData(lawdCode);
								
								return data.sido || data.sggName;
							},
							label: function(context) {
								const lawdCode = context.raw.feature.properties.lawd_code;
								const data = findPlantData(lawdCode);
								return [
									'발전소: ' + (data.cnt ?? data.plantCnt ?? 0).toLocaleString() + '개',
									'용량: ' + (data.cap ?? data.plantCap ?? 0).toLocaleString() + 'kW',
									'발전량: ' + (data.fuelPwr ?? 0).toLocaleString() + 'MWh'
								];
							}
						}
					}
				},
				scales: {
					projection: {
						axis: 'x',
						projection: 'mercator',
						fit: true,
						padding: currentPadding
					},
					color: {
						axis: 'x',
						display: false,
					}
				},
				layout: {
					padding: {
						top: 10,
						bottom: 10,
						right: 10,
						left: 10
					}
				},
				onClick: function(event, elements) {
					if (elements.length > 0 && upperLawdCode === '00') {	// 전국일때만 onClick 가능
						const index = elements[0].index;
						const lawdCode = mapData[index].lawdCode;
						
						loadDistrictData(lawdCode);
					}
				},
				onHover: function(event, elements) {
					const click = (elements.length > 0 && upperLawdCode === '00');
					event.native.target.style.cursor = click ? 'pointer' : 'default';
					
					if (elements.length > 0) {
						const lawdCode = mapData[elements[0].index].lawdCode;
						const data = findPlantData(lawdCode);
						
						updateDistrictInfo(data);
					}
				}
			}
		});
	}
	
	// 구 단위 데이터 호출
	function loadDistrictData(lawdCode) {
		const upperLawdCode = lawdCode.toString();
		
		showLoading(); 
		
		$.ajax({
			url: '/getDistrictData',
			type: 'GET',
			data: { upperLawdCode : upperLawdCode }, 
			dataType: 'json',
			success: function(response) {
				
				currentView = 'district';
				$('#backBtn').show();
				
				districtStatData = response.plantStatWeekList;
				
				updateRegionInfo(upperLawdCode);
				updateDistrictInfo(districtStatData[0]);
				
				createMapChart(response, upperLawdCode, districtStatData);
				hideLoading();
			},
			error: function() {
				alert('시군구 데이터를 불러오는데 실패했습니다.');
			}
		});
	}
	
	
	/*
		로딩 함수
	*/
	// 로딩 표시
	function showLoading() {
	    $('#mapLoading').addClass('active');
	    $('#mapChart').css('opacity', '0.3');
	}
	
	// 로딩 숨김
	function hideLoading() {
	    $('#mapLoading').removeClass('active');
	    $('#mapChart').css('opacity', '1');
	}

	$(document).ready(function() {
		initMap();
		
		$('#backBtn').on('click', initMap);
		
		$('a[href="/"]').on('click', function(e) {
	        e.preventDefault();
	        initMap();
	    });
	});
