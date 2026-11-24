<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!doctype html>
<html lang="id">
<head>
  <jsp:include page="includes/head.jsp">
    <jsp:param name="title" value="${empty poll ? 'Polling' : poll.question}"/>
  </jsp:include>
</head>
<body>
  <jsp:include page="includes/navbar.jsp"/>

  <main class="page-main">
    <div class="container" style="max-width: 760px;">

      <c:choose>
        <c:when test="${empty poll}">
          <div class="glass-card empty-state">
            <i class="bi bi-question-circle"></i>
            <p class="mt-2 mb-3">Polling tidak ditemukan. Mungkin sudah dihapus.</p>
            <a class="btn btn-primary" href="${ctx}/polls">Kembali ke daftar</a>
          </div>
        </c:when>

        <c:otherwise>
          <div class="page-head">
            <div>
              <span class="badge rounded-pill ${poll.open ? 'text-bg-success' : 'text-bg-secondary'} mb-2">
                ${poll.open ? 'Open' : 'Closed'}
              </span>
              <h1 class="h3"><c:out value="${poll.question}"/></h1>
              <c:if test="${not empty poll.description}">
                <p><c:out value="${poll.description}"/></p>
              </c:if>
              <p class="poll-meta">
                Ditutup
                <fmt:formatDate value="${poll.deadline}" pattern="d MMMM yyyy"/>
              </p>
            </div>
            <a class="btn btn-outline-secondary" href="${ctx}/polls">
              <i class="bi bi-arrow-left"></i> Semua polling
            </a>
          </div>

          <c:if test="${param.error == '1'}">
            <div class="alert alert-warning" role="alert">
              Suaramu belum tercatat. Pastikan kamu memilih satu opsi, polling masih terbuka,
              dan kamu belum pernah memilih.
            </div>
          </c:if>

          <div class="form-panel">
            <c:choose>

              <%-- Belum memilih dan polling masih terbuka: tampilkan form vote --%>
              <c:when test="${poll.open && !voted}">
                <form method="post" action="${ctx}/polls">
                  <input type="hidden" name="action" value="vote">
                  <input type="hidden" name="pollId" value="${poll.id}">

                  <c:forEach var="o" items="${poll.options}">
                    <label class="option-card d-block mb-2">
                      <input type="radio" name="optionId" value="${o.id}" required>
                      <c:out value="${o.label}"/>
                    </label>
                  </c:forEach>

                  <button type="submit" class="btn btn-primary mt-3">Kirim suara</button>
                </form>
              </c:when>

              <%-- Sudah memilih atau polling ditutup: tampilkan hasil --%>
              <c:otherwise>
                <c:if test="${voted}">
                  <div class="alert alert-success" role="status">
                    Suaramu sudah tercatat. Terima kasih sudah ikut memilih.
                  </div>
                </c:if>
                <c:if test="${!poll.open && !voted}">
                  <div class="alert alert-secondary" role="status">
                    Polling ini sudah ditutup. Berikut hasil akhirnya.
                  </div>
                </c:if>

                <c:forEach var="o" items="${poll.options}">
                  <c:set var="pct" value="${poll.totalVotes == 0 ? 0 : o.total * 100 / poll.totalVotes}"/>
                  <fmt:formatNumber value="${pct}" pattern="0" var="pctInt"/>
                  <div class="mb-3">
                    <div class="d-flex justify-content-between mb-1">
                      <span><c:out value="${o.label}"/></span>
                      <span>${pctInt}% (${o.total})</span>
                    </div>
                    <div class="progress" role="progressbar"
                         aria-valuenow="${pctInt}" aria-valuemin="0" aria-valuemax="100">
                      <div class="progress-bar poll-bar" style="width: ${pctInt}%"></div>
                    </div>
                  </div>
                </c:forEach>

                <p class="poll-meta mb-0">Total ${poll.totalVotes} suara</p>
              </c:otherwise>

            </c:choose>
          </div>
        </c:otherwise>
      </c:choose>

    </div>
  </main>

  <jsp:include page="includes/footer.jsp"/>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>