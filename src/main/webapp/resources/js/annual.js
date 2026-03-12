	/*
		초기 변수 설정
	*/
	let chart;
	let currentChartType = 'gen';	// 초기 차트 타입 설정 (발전량 현황)
	let selectedRegions = [];
	let allRegions = [];
	let isFilterOpen = false;
	
	
	/*
		데이터 가공 함수
	*/
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
	
	// 데이터 최대 월 계산
	function getMaxMonth(data) {
		var maxMonth = 0;
		
		data.forEach(item => {
			if (item.month > maxMonth) {
				maxMonth = item.month;
			}
		});
		return maxMonth || 12; // 데이터 없으면 12월까지
	}
	
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
	
	// 버튼 클릭 핸들러 (발전량/발전소 전환)
	function handleBtnClick(type, element) {
		$(element).addClass('active').siblings().removeClass('active');
		currentChartType = type;
		
		if (type === 'gen') {
			$('#detailToggleBtn').show();
		} else {
			$('#detailToggleBtn').hide();
			closeFilterPanel();
			selectedRegions = [];
		}
		
		updateChart();
	}
	
	// 연도 변경
	$('#yearSel').on('change', function() {
	    const year = $(this).val();
	    
	    $.ajax({
	        url: '/getYearData',
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
	            
	            allRegions = Object.keys(genBySido);
	            
	            if (isFilterOpen) {
					createCheckboxes();
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
	
	
	/*
		필터 패널 함수
	*/
	// 상세보기 토글 클릭
	$('#detailToggleBtn').on('click', function() {
		if (isFilterOpen) {
			closeFilterPanel();
		} else {
			openFilterPanel();
		}
	});
	
	// 필터 패널 열기
	function openFilterPanel() {
		isFilterOpen = true;
		$('#filterPanel').addClass('active');
		$('#detailToggleBtn').addClass('active');
		createCheckboxes();
		updateSelectAllButton();
	}
	
	// 필터 패널 닫기
	function closeFilterPanel() {
		isFilterOpen = false;
		$('#filterPanel').removeClass('active');
		$('#detailToggleBtn').removeClass('active');
	}
	
	// 체크박스 생성
	function createCheckboxes() {
		const container = $('#checkboxGrid');
		container.empty();
		
		// 현재 선택된 지역이 없으면 전체 체크 상태
		const shouldCheckAll = selectedRegions.length === 0;
		
		allRegions.forEach(function(region) {
			const isChecked = shouldCheckAll || selectedRegions.includes(region);
			
			const checkboxHtml = 
				'<div class="checkboxItem">' +
					'<input type="checkbox" id="region_' + region + '" value="' + region + '"' + 
					(isChecked ? ' checked' : '') + '>' +
					'<label for="region_' + region + '">' + region + '</label>' +
				'</div>';
			
			container.append(checkboxHtml);
		});
		
		$('#checkboxGrid input[type="checkbox"]').on('change', function() {
			updateSelectAllButton();
		});
	}
	
	// 전체 선택/해제
	function updateSelectAllButton() {
		const totalCheckboxes = $('#checkboxGrid input[type="checkbox"]').length;
		const checkedCheckboxes = $('#checkboxGrid input[type="checkbox"]:checked').length;
		
		// 모든 체크박스가 체크되어 있으면 "전체 해제"로 변경
		if (checkedCheckboxes === totalCheckboxes) {
			$('#selectAllBtn').text('전체 해제').data('action', 'uncheck');
		} else {
			// 그 외의 경우는 "전체 선택"으로 표시
			$('#selectAllBtn').text('전체 선택').data('action', 'check');
		}
	}
	
	// 검색 버튼 (선택된 지역으로 차트 업데이트)
	$('#applyFilterBtn').on('click', function() {
		// 체크된 지역 수집
		selectedRegions = [];
		$('#checkboxGrid input[type="checkbox"]:checked').each(function() {
			selectedRegions.push($(this).val());
		});
		
		// 아무것도 선택 안 했으면 경고
		if (selectedRegions.length === 0) {
			alert('최소 1개 이상의 지역을 선택해주세요.');
			return;
		}
		
		// 차트 및 테이블 업데이트
		updateChart();
	});
	
	// 닫기 버튼
	$('#closeFilterBtn').on('click', function() {
		closeFilterPanel();
	});
	
	// 전체 선택
	$('#selectAllBtn').on('click', function() {
		const action = $(this).data('action');
		
		if (action === 'check') {
			$('#checkboxGrid input[type="checkbox"]').prop('checked', true);
		} else {
			$('#checkboxGrid input[type="checkbox"]').prop('checked', false);
		}
		
		updateSelectAllButton();
	});
	
	
	/*
		차트 함수
	*/
	// 월별 발전량 현황 데이터 생성
	function createGenData(dataBySido) {
		const regionsToShow = selectedRegions.length > 0 ? 
				selectedRegions : Object.keys(dataBySido);
		
		return {
			labels: Array.from({length: maxGenMonth}, (_, i) => (i + 1) + '월'),
			datasets: regionsToShow.map((sido, index) => {
				const sidoData = dataBySido[sido] || [];
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
	
	// 연간 발전소 현황 데이터 생성
	function createPlantData(dataBySido) {
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
	                backgroundColor: 'rgba(149, 192, 254, 1)',
	                borderColor: 'rgb(149, 192, 254)',
	                borderWidth: 2,
	                yAxisID: 'y',
	                order: 2
	            },
	            {
	                type: 'line',
	                label: '발전소 용량',
	                data: capData,
	                borderColor: 'rgba(255, 95, 0, 0.6)',
	                backgroundColor: 'rgba(255, 95, 0, 0.6)',
	                borderWidth: 3,
	                tension: 0.4,
	                fill: false,
	                pointRadius: 3,
	                pointHoverRadius: 5,
	                pointBackgroundColor: 'rgba(230, 86, 0.5)',
	                pointBorderColor: 'rgba(230, 86, 0.5)',
	                pointBorderWidth: 2,
	                yAxisID: 'y1',
	                order: 1
	            }
	        ]
	    };
	}
	
	// 월별 발전량 차트 옵션 
	function getGenChartOptions(year) {
		return {
			responsive: true,
			maintainAspectRatio: false,
			plugins: {
				legend: {
					display: true,
					position: 'bottom',
					onClick: (e) => e.stopPropagation(),
					labels: {
						font: { size: 18, family: 'PretendardGOV-SemiBold', color: '#333333' },
						usePointStyle: true,
						padding: 20
					}
				},
				tooltip: {
					enabled: true,
	                backgroundColor: 'rgba(0, 0, 0, 0.8)',
	                padding: 15, 
	                titleFont: { 
	                    size: 18,
	                    family: 'PretendardGOV-Bold' 
	                },
	                bodyFont: { 
	                    size: 16, 
	                    family: 'PretendardGOV-Regular' 
	                },
	                cornerRadius: 10, 
	                displayColors: true, 
	                boxWidth: 12,
	                boxHeight: 12, 
	                boxPadding: 10,
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
				x: {
					ticks: {
	                    font: {
	                        size: 18,
	                        family: 'PretendardGOV-Regular',
	                    },
	                    color: '#333333',
	                    padding: 10
	                }
				},
				y: {
					beginAtZero: true,
					title: { display: true, text: '발전량 (MWh)', font: { size: 18, family: 'PretendardGOV-Regular', color: '#333333' } },
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
	
	// 연간 발전소 차트 옵션
	function getPlantChartOptions(year) {
		return {
			responsive: true,
		    maintainAspectRatio: false,
		    plugins: {
		        legend: {
		            display: true,
		            position: 'bottom',
		            onClick: (e) => e.stopPropagation(),
		            labels: {
		                font: { size: 18, family: 'PretendardGOV-SemiBold' },
		                usePointStyle: true,
		                padding: 20
		            }
		        },
		        tooltip: {
		        	enabled: true,
	                backgroundColor: 'rgba(0, 0, 0, 0.8)',
	                padding: 15, 
	                titleFont: { 
	                    size: 18,
	                    family: 'PretendardGOV-Bold' 
	                },
	                bodyFont: { 
	                    size: 16, 
	                    family: 'PretendardGOV-Regular' 
	                },
	                cornerRadius: 10, 
	                displayColors: true, 
	                boxWidth: 12,
	                boxHeight: 12, 
	                boxPadding: 10,
		            callbacks: {
		            	title: function(context) {
	                        const index = context[0].dataIndex;
	                        return plantStatYearData[index].sidoFull; 
	                    },
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
		            },
		            ticks: {
	                    font: {
	                        size: 18,
	                        family: 'PretendardGOV-SemiBold',
	                    },
	                    color: '#333333',
	                    padding: 10
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
		                font: { size: 18, family: 'PretendardGOV-Regular', color: '#333333' },
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
		                font: { size: 18, family: 'PretendardGOV-Regular', color: '#333333' },
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
	
	// 차트 업데이트
	function updateChart() {
		const selectedYear = $('#yearSel').val();
	    
	    if (currentChartType === 'gen') {
	        // 발전량 차트
	        chart.data = createGenData(genBySido);
	        chart.options = getGenChartOptions(selectedYear);
	    } else if (currentChartType === 'plant') {
	        // 발전소 차트
	        chart.data = createPlantData(plantBySido);
	        chart.options = getPlantChartOptions(selectedYear);
	    }
	    
	    chart.update('active');
	    updateTable();
	}
	
	
	/*
		테이블 함수
	*/
	// 발전량 테이블 생성
	function createGenTable(year) {
		const regionsToShow = selectedRegions.length > 0 ? 
				selectedRegions : Object.keys(genBySido);
		let totalByMonth = Array(maxGenMonth).fill(0);
		let grandTotal = 0;
		
		let html = '';
		
		// table haed
		html += '<thead>';
		html += '<tr>';
		html += '<th> </th>';
		
		for(var i=0; i < maxGenMonth; i++) {
			html += '<th>' + (i+1) + '월 </th>';
		}
		
		html += '<th>합계</th>';
		
		html += '</tr>';
		html += '</thead>';
		
		// table body 
		html += '<tbody>';
		
		// 시도별 데이터 출력
		regionsToShow.forEach(sido => {
			const sidoData = genBySido[sido];
			const monthlyData = Array(maxGenMonth).fill(0);
			let sidoTotal = 0;
			
			// 월별 데이터 채우기
			sidoData.forEach(item => {
				if (item.month <= maxGenMonth) {
					monthlyData[item.month - 1] = item.fuelPwr;
					totalByMonth[item.month - 1] += item.fuelPwr;
					sidoTotal += item.fuelPwr;
					grandTotal += item.fuelPwr;
				}
			});
			
			// 행 생성
			html += '<tr>';
			html += '<td><strong>' + sido + '</strong></td>';
			
			monthlyData.forEach(val => {
				html += '<td class="number">' + val.toLocaleString() + '</td>';
			});
			
			html += '<td class="number" style="background-color: #f8f9fa; font-weight: bold; color: #333333;">' 
				+ sidoTotal.toLocaleString() + '</td>';
			
			html += '</tr>';
		});
		
		html += '<tr style="background-color: #f8f9fa; font-weight: bold;">';
		html += '<td style="text-align: center; color: #333333;"><strong>합계</strong></td>';
		
		totalByMonth.forEach(function(total) {
			html += '<td class="number" style="color: #333333;">' 
				+ total.toLocaleString() + '</td>';
		});
		
		html += '<td class="number" style="background-color: rgba(149, 192, 254, 0.1); color: #333333; font-weight: bold; font-size: 20px;">' 
			+ grandTotal.toLocaleString() + '</td>';
		
		html += '</tr>';
		
		html += '</tbody>';
		
		return html;
	}
	
	// 발전소 테이블 생성
	function createPlantTable(year) {
		let sidoList = Object.keys(plantBySido);
		let html = '';
		
		let totalCnt = 0;  // 발전소 개수 전체 합계
		let totalCap = 0;  // 발전소 용량 전체 합계
		
		// table head
		html += '<thead>';
		html += '<tr>';
		html += '<th style="width: 100px;"> </th>';
		
		sidoList.forEach(sido => {
			html += '<th style="min-width: 70px;">' + sido + '</th>';
		});
		
		html += '<th style="min-width: 90px; background-color: #f8f9fa;">합계</th>';
		
		html += '</tr>';
		html += '</thead>';
		
		// table body
		html += '<tbody>';
		
		// 발전소 개수 
		html += '<tr>';
		html += '<td style="width: 100px;"><strong> 발전소\n개수\n(개) </strong></td>';
		
		sidoList.forEach(sido => {
			let cnt = plantBySido[sido][0].cnt;
			totalCnt += cnt;
			
			html += '<td class="number" style="min-width: 70px;">' + cnt.toLocaleString() + '</td>';
		});
		
		html += '<td class="number" style="min-width: 90px; background-color: rgba(149, 192, 254, 0.1); font-weight: bold; color: #333333; font-size: 18px;">' 
			+ totalCnt.toLocaleString() + '</td>';
			
		html += '</tr>';
		
		// 발전소 용량
		html += '<tr>';
		html += '<td style="width: 100px;"><strong> 발전소\n용량\n(kW) </strong></td>';
		
		sidoList.forEach(sido => {
			let cap = plantBySido[sido][0].cap;
			totalCap += cap;
			html += '<td class="number style="min-width: 70px;">' + cap.toLocaleString() + '</td>';
		});
		
		html += '<td class="number" style="min-width: 90px; background-color: rgba(149, 192, 254, 0.1); font-weight: bold; color: #333333; font-size: 18px;">' 
			+ totalCap.toLocaleString() + '</td>';
			
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
	
	
	/*
		데이터
	*/
	// 데이터 그룹화 
	let genBySido = groupBySido(genStatMonthData);
	let plantBySido = groupBySido(plantStatYearData);
	let maxGenMonth = getMaxMonth(genStatMonthData);
	
	// 전체 지역 목록 초기화
	allRegions = Object.keys(genBySido);
	
	$(document).ready(function() {
		const ctx = document.getElementById('chart');
		chart = new Chart(ctx, {
			type: 'line',
			data: createGenData(genBySido),
			options: getGenChartOptions($('#yearSel').val())
		});
		
		$('#detailToggleBtn').show();
		
		updateTable();
	});
	
	
	/*
		엑셀 다운로드 함수
	*/
	// 버튼 클릭 이벤트
	$('#downloadExcelBtn').on('click', function() {
		generateExcel();
	});
	
	// 엑셀 파일 생성 및 다운로드
	async function generateExcel() {
		const selectedYear = $('#yearSel').val();
		const chartType = currentChartType === 'gen' ? '발전량' : '발전소';
		
		const workbook = new ExcelJS.Workbook();
	    const sheet = workbook.addWorksheet(`${chartType} 현황`);
	    
	    try {
	        const canvas = document.getElementById('chart');
	        const chartImageBase64 = canvas.toDataURL('image/png');
	
	        const imageId = workbook.addImage({
	            base64: chartImageBase64,
	            extension: 'png',
	        });
	
	        sheet.addImage(imageId, {
	            tl: { col: 1, row: 1 },
	            ext: { width: 800, height: 400 }
	        });
	
	        const startRow = 23;
	        sheet.getRow(startRow).values = [`${selectedYear}년 시도별 ${chartType} 현황`];
	        sheet.getRow(startRow).font = { size: 16, bold: true };
	
	        sheet.getRow(startRow + 1).values = ['생성일시:', getCurrentDateTime()];
	        sheet.getRow(startRow + 2).values = ['대상지역:', selectedRegions.length > 0 ? selectedRegions.join(', ') : '전국'];
	
	        const tableData = currentChartType === 'gen' ? extractGenTableData() : extractPlantTableData();
	
	        tableData.forEach((rowData, index) => {
	            const currentRow = sheet.getRow(startRow + 4 + index);
	            currentRow.values = rowData;
	
	            if (index === 0) {
	                currentRow.font = { bold: true };
	                currentRow.fill = {
	                    type: 'pattern',
	                    pattern: 'solid',
	                    fgColor: { argb: 'FFE7F3FF' }
	                };
	            }
	            
	            currentRow.eachCell((cell) => {
	                cell.border = {
	                    top: { style: 'thin' },
	                    left: { style: 'thin' },
	                    bottom: { style: 'thin' },
	                    right: { style: 'thin' }
	                };
	            });
	        });
	
	        sheet.columns.forEach(column => {
	            column.width = 15;
	        });
	
	        const buffer = await workbook.xlsx.writeBuffer();
	        const fileName = `${selectedYear}년_시도별_${chartType}_현황_${getCurrentDateTime()}.xlsx`;
	        saveAs(new Blob([buffer]), fileName);
	
	
	    } catch (error) {
	        console.error('엑셀 생성 중 오류 발생:', error);
	        alert('엑셀 파일 생성 중 오류가 발생했습니다.');
	    }
	}
	
	// 발전량 테이블 데이터 추출
	function extractGenTableData() {
		const data = [];
		
		const regionsToShow = selectedRegions.length > 0 ? 
			selectedRegions : Object.keys(genBySido);
			
		let totalByMonth = Array(maxGenMonth).fill(0);
		let grandTotal = 0;
		
		const headerRow = ['시도'];
		for (let i = 1; i <= maxGenMonth; i++) {
			headerRow.push(`${i}월`);
		}
		headerRow.push('합계');
		data.push(headerRow);
		
		regionsToShow.forEach(function(sido) {
			const sidoData = genBySido[sido] || [];
			const monthlyData = Array(maxGenMonth).fill(0);
	        let sidoTotal = 0;
			
			sidoData.forEach(item => {
	            if (item.month <= maxGenMonth) {
	                monthlyData[item.month - 1] = item.fuelPwr;
	                totalByMonth[item.month - 1] += item.fuelPwr;
	                sidoTotal += item.fuelPwr;
	                grandTotal += item.fuelPwr;
	            }
			});
			
			const row = [sido];
	        monthlyData.forEach(val => row.push(val));
	        row.push(sidoTotal);
	        
	        data.push(row);
		});
		
		const totalRow = ['합계'];
	    totalByMonth.forEach(total => {
	        totalRow.push(total);
	    });
	    totalRow.push(grandTotal);
	    
	    data.push(totalRow);
		
		return data;
	}
	
	// 발전소 테이블 데이터 추출
	function extractPlantTableData() {
		const data = [];
		const sidoList = Object.keys(plantBySido);
		
		const headerRow = ['구분'].concat(sidoList);
		data.push(headerRow);
		
		const cntRow = ['발전소 개수 (개)'];
		sidoList.forEach(function(sido) {
			cntRow.push(plantBySido[sido][0].cnt);
		});
		data.push(cntRow);
		
		const capRow = ['발전소 용량 (kW)'];
		sidoList.forEach(function(sido) {
			capRow.push(plantBySido[sido][0].cap);
		});
		data.push(capRow);
		
		let totalCnt = 0;
		let totalCap = 0;
		sidoList.forEach(function(sido) {
			totalCnt += plantBySido[sido][0].cnt;
			totalCap += plantBySido[sido][0].cap;
		});
		
		data.push([]);
		data.push(['전국 합계', '']);
		data.push(['총 발전소 개수', totalCnt + '개']);
		data.push(['총 발전소 용량', totalCap + 'kW']);
		
		return data;
	}
	
	// 열 너비 자동 설정 함수
	function setColumnWidths(data) {
		const colWidths = [];
		
		// 각 열의 최대 문자 길이 계산
		if (data.length > 0) {
			const numCols = data[0].length;
			
			for (let col = 0; col < numCols; col++) {
				let maxWidth = 10;
				
				data.forEach(function(row) {
					if (row[col]) {
						const cellLength = String(row[col]).length;
						if (cellLength > maxWidth) {
							maxWidth = cellLength;
						}
					}
				});
				
				colWidths.push({ wch: maxWidth + 2 });
			}
		}
		
		return colWidths;
	}
	
	// 현재 날짜/시간 문자열 생성
	function getCurrentDateTime() {
		const now = new Date();
		const year = now.getFullYear();
		const month = String(now.getMonth() + 1).padStart(2, '0');
		const day = String(now.getDate()).padStart(2, '0');
		
		return `${year}${month}${day}`;
	}
