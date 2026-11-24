<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!doctype html>
<html lang="id">
<head>
  <jsp:include page="includes/head.jsp">
    <jsp:param name="title" value="Masuk"/>
  </jsp:include>
</head>
<body>
  <jsp:include page="includes/navbar.jsp"/>

  <main class="page-main">
    <div class="container">
      <div class="auth-wrap">
        <div class="auth-card form-panel">
          <h1 class="h3 mb-1">Masuk</h1>
          <p class="poll-meta mb-4">Gunakan akun UKM Genshin untuk ikut polling.</p>

          <c:if test="${not empty error}">
            <div class="alert alert-danger" role="alert">
              <c:out value="${error}"/>
            </div>
          </c:if>

          <form method="post" action="${ctx}/login">
            <label class="form-label" for="email">Email</label>
            <input class="form-control mb-3" type="email" id="email" name="email"
                   autocomplete="username" autofocus required>

            <label class="form-label" for="password">Password</label>
            <input class="form-control mb-4" type="password" id="password" name="password"
                   autocomplete="current-password" required>

            <button type="submit" class="btn btn-primary w-100">Masuk</button>
          </form>
        </div>
      </div>
    </div>
  </main>

  <jsp:include page="includes/footer.jsp"/>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>