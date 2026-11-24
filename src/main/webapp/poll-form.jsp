<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:set var="editing" value="${not empty poll}"/>
<!doctype html>
<html lang="id">
<head>
  <jsp:include page="includes/head.jsp">
    <jsp:param name="title" value="${editing ? 'Edit polling' : 'Buat polling'}"/>
  </jsp:include>
</head>
<body>
  <jsp:include page="includes/navbar.jsp"/>

  <main class="page-main">
    <div class="container" style="max-width: 720px;">

      <div class="page-head">
        <div>
          <h1 class="h3">${editing ? 'Edit polling' : 'Buat polling baru'}</h1>
          <p>
            ${editing
              ? 'Ubah pertanyaan, deadline, atau status polling.'
              : 'Tulis pertanyaan dan minimal dua opsi jawaban.'}
          </p>
        </div>
      </div>

      <div class="form-panel">
        <form method="post" action="${ctx}/polls">
          <input type="hidden" name="action" value="${editing ? 'update' : 'create'}">
          <c:if test="${editing}">
            <input type="hidden" name="id" value="${poll.id}">
          </c:if>

          <label class="form-label" for="question">Pertanyaan</label>
          <input class="form-control mb-3" id="question" name="question" maxlength="255"
                 value="<c:out value='${poll.question}'/>" required>

          <label class="form-label" for="description">Deskripsi</label>
          <textarea class="form-control mb-3" id="description" name="description"
                    rows="3"><c:out value="${poll.description}"/></textarea>

          <label class="form-label" for="deadline">Deadline</label>
          <input class="form-control mb-3" type="date" id="deadline" name="deadline"
                 value="<c:out value='${poll.deadline}'/>" required>

          <c:choose>
            <c:when test="${!editing}">
              <label class="form-label">Opsi jawaban</label>
              <input class="form-control mb-2" name="options" maxlength="255" placeholder="Opsi 1" required>
              <input class="form-control mb-2" name="options" maxlength="255" placeholder="Opsi 2" required>
              <input class="form-control mb-2" name="options" maxlength="255" placeholder="Opsi 3 (opsional)">
              <input class="form-control mb-3" name="options" maxlength="255" placeholder="Opsi 4 (opsional)">
            </c:when>

            <c:otherwise>
              <div class="form-check mb-2">
                <input class="form-check-input" type="checkbox" name="active" id="active"
                       ${poll.active ? 'checked' : ''}>
                <label class="form-check-label" for="active">Polling aktif</label>
              </div>
              <p class="poll-meta mb-3">
                Opsi jawaban tidak bisa diubah setelah polling dibuat, supaya hasil suara tetap sesuai.
              </p>
            </c:otherwise>
          </c:choose>

          <div class="d-flex flex-wrap gap-2">
            <button type="submit" class="btn btn-primary">
              ${editing ? 'Simpan perubahan' : 'Buat polling'}
            </button>
            <a class="btn btn-outline-secondary" href="${ctx}/polls">Batal</a>
          </div>
        </form>
      </div>

    </div>
  </main>

  <jsp:include page="includes/footer.jsp"/>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>