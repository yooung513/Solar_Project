<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>KDN 태양광 발전소 현황 플랫폼</title>
	<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/header.css?after">
</head>

<body>
	<div class="headerContainer">
		<nav class="navbar">
		    <a href="/">
				<img class="logo" src="${pageContext.request.contextPath}/resources/images/collaboration.png" alt="Logo" />
			</a>
		    
		    <ul class="nav-menu">
		      <li><a class="${currentPage == 'weekStatus' 	? 'active' : ''}" href="/"> 			태양광 발전소 주간 현황 </a></li>
		      <li><a class="${currentPage == 'annualStatus' ? 'active' : ''}" href="/annual"> 		태양광 발전소 연간 현황 </a></li>
		      <li><a class="${currentPage == 'predict' 		? 'active' : ''}" href="/predict"> 		태양광 발전 예측 </a></li>
		      <li><a class="${currentPage == 'geography' 	? 'active' : ''}" href="/geography"> 	태양광 발전소 종합 지도 </a></li>
		    </ul>
		</nav>
	</div>
</body>
</html>