<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!doctype html>
<html lang="id">
<head>
  <jsp:include page="includes/head.jsp">
    <jsp:param name="title" value="Daftar Polling"/>
  </jsp:include>
</head>
<body>
  <jsp:include page="includes/navbar.jsp"/>

  <main class="page-main">
    <div class="container">

      <div class="page-head">
        <div>
          <h1 class="h3">Polling</h1>
          <p>Suara anggota untuk keputusan UKM</p>
        </div>
        <a class="btn btn-primary" href="${ctx}/polls?action=create">
          <i class="bi bi-plus-lg"></i> Buat polling
        </a>
      </div>

      <c:choose>
        <c:when test="${empty polls}">
          <div class="glass-card empty-state">
            <i class="bi bi-bar-chart-line"></i>
            <p class="mt-2 mb-3">Belum ada polling. Buat yang pertama untuk mulai mengumpulkan suara.</p>
            <a class="btn btn-primary" href="${ctx}/polls?action=create">Buat polling</a>
          </div>
        </c:when>

        <c:otherwise>
          <c:forEach var="p" items="${polls}">
            <div class="card poll-card mb-3">
              <div class="card-body">
                <span class="badge ${p.open ? 'bg-success' : 'bg-secondary'}">
                  ${p.open ? 'Open' : 'Closed'}
                </span>

                <h5 class="mt-2 mb-1"><c:out value="${p.question}"/></h5>
                <p class="poll-meta mb-3">
                  ${p.totalVotes} suara &middot; sampai
                  <fmt:formatDate value="${p.deadline}" pattern="d MMM yyyy"/>
                </p>

                <div class="d-flex flex-wrap gap-2">
                  <a class="btn btn-primary btn-sm" href="${ctx}/polls?action=detail&id=${p.id}">Lihat</a>
                  <a class="btn btn-outline-secondary btn-sm" href="${ctx}/polls?action=edit&id=${p.id}">Edit</a>
                  <form method="post" action="${ctx}/polls" class="m-0"
                        onsubmit="return confirm('Hapus polling ini beserta semua suaranya?')">
                    <input type="hidden" name="action" value="delete">
                    <input type="hidden" name="id" value="${p.id}">
                    <button type="submit" class="btn btn-outline-danger btn-sm">Hapus</button>
                  </form>
                </div>
              </div>
            </div>
          </c:forEach>
        </c:otherwise>
      </c:choose>

    </div>
  </main>

  <jsp:include page="includes/footer.jsp"/>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>