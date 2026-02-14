<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Header</title>
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

	* {
		margin: 0;
		padding: 0;
		box-sizing: border-box;
	}
	
	.headerContainer {
		height: 100px;
		margin: 0 auto;
		padding: 10px 20px;
		position: relative;
	}
	
	.navbar {
		height: 100%;
		position: relative;
		display: flex;
		align-items: flex-start;
	}
	
	.logo {
		height: 80px; 
		width: auto;
		margin-right: 50px;
	}
	
	.nav-menu {
		display: flex;
		list-style: none;
		align-items: flex-end;
		gap: 80px;
		position: absolute;
		bottom: 10px;
		left: 500px;
	}
	
	.nav-menu li {
		position: relative;
	    display: flex;
	    align-items: flex-end;
	    justify-content: center;
    	width: 250px;
	}
	
	.nav-menu li + li::before {
	    content: "|";
	    position: absolute;
	    left: -40px;
	    font-size: 30px;
	    color: #333;
	    
	    font-family: 'Electrical-Safety-Regular';
	    transform: translateX(-50%);
	    font-size: 30px;
	    color: #333;
	    font-family: 'Electrical-Safety-Regular';
	    line-height: 1;
	}
		
	.nav-menu a {
		font-family: 'Electrical-Safety-Regular';	
		text-decoration: none;
		color: #333;
		font-size: 30px;
		transition: color 0.3s;
		line-height: 1;
	}
	
	.nav-menu a:hover {
		color: #0d6efd;
	}
	
	.nav-menu a.active {
		font-family: 'Electrical-Safety-Bold';
		font-size: 34px;
		color: #0d6efd;
	}
	
</style>

<body>
	<div class="headerContainer">
		<nav class="navbar">
		    <a href="/">
				<img class="logo" src="${pageContext.request.contextPath}/resources/images/collaboration.png" alt="Logo" />
			</a>
		    
		    <ul class="nav-menu">
		      <li><a class="${currentPage == 'status' ? 'active' : ''}" href="/"> 태양광 발전소 현황 </a></li>
		      <li><a class="${currentPage == 'predict' ? 'active' : ''}" href="/predict"> 태양광 발전 예측 </a></li>
		    </ul>
		</nav>
	</div>
</body>
</html>