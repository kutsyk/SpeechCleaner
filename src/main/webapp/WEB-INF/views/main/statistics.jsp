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
</head>
<script>
  $(document).ready(function()
          {
            setTimeout(function() {$("#data").tablesorter({sortList: [[1,1]]});}, 1000);
          }
  );
</script>
<body>

  <table id="data">
    <thead>
    <tr><th>Word</th><th>Frequency</th></tr>
    </thead>
    <tbody>
    <c:forEach items="${data}" var="entry">
     <tr><td>${entry.key}</td><td>${entry.value}</td></tr>
    </c:forEach>
    </tbody>
  </table>

</body>
</html>
