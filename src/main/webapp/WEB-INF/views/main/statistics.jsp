<%--
  Created by IntelliJ IDEA.
  User: Polomani
  Date: 04.10.2015
  Time: 10:36
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <title></title>
    <script src="/resources/js/jquery-2.1.3.min.js"></script>
    <script src="/resources/js/jquery.tablesorter.js"></script>
    <script src="/resources/js/table_filter.js"></script>

    <link rel="stylesheet" type="text/css" href="/resources/bootstrap-3.3.2-dist/css/bootstrap-theme.min.css"/>
    <link rel="stylesheet" type="text/css" href="/resources/bootstrap-3.3.2-dist/css/bootstrap.min.css"/>
    <link rel="stylesheet" type="text/css" href="/resources/bootstrap-3.3.2-dist/js/bootstrap.min.js"/>
    <link rel="stylesheet" type="text/css" href="/resources/css/table-filter.css"/>

</head>
<script>
    $(document).ready(function () {
                setTimeout(function () {
                    $("#dev-table").tablesorter({sortList: [
                        [1, 1]
                    ]});
                }, 1000);
            }
    );
</script>
<body>

<table class="table table-hover" id="dev-table">
    <thead>
    <tr>
        <th>Word</th>
        <th>Frequency</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach items="${data}" var="entry">
        <tr>
            <td>${entry.key}</td>
            <td>${entry.value}</td>
        </tr>
    </c:forEach>
    </tbody>
</table>

</body>
</html>
