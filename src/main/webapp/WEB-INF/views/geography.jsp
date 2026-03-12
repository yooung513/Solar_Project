<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>KDN 태양광 발전소 현황 플랫폼</title>
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
	.container {
        width: 1900px;
        margin: 0 auto;
    }

    .status-title {
        text-align: center;
        margin-top: 100px;
        font-family: 'KhnpHandot-Bold', sans-serif;
        font-size: 32px;
    }
</style>

<body>
	<div id="app">
		<header>
			<%@ include file="common/header.jsp" %>
		</header>
		
		<main>
			<div class="container">
				<h3 class="status-title"> 페이지 개발 중 입니다. </h3>
			</div>
		</main>
	</div>
</body>
</html>