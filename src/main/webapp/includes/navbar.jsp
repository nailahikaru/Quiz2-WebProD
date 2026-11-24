<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%-- Alamat website Laravel. Ganti jika port atau domainnya berbeda. --%>
<c:set var="laravelUrl" value="http://localhost:8000"/>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<nav class="navbar navbar-expand-lg navbar-light shadow-sm fixed-top">
  <div class="container">
    <a class="navbar-brand d-flex align-items-center gap-2" href="${laravelUrl}/">
      <img src="${ctx}/image/logo.webp" alt="Logo UKM Genshin" width="40" height="40" class="align-text-top">
      <span>UKM Genshin <i class="bi bi-stars"></i></span>
    </a>

    <button class="navbar-toggler" type="button" data-bs-toggle="collapse"
            data-bs-target="#navbarNav" aria-controls="navbarNav"
            aria-expanded="false" aria-label="Toggle navigation">
      <span class="navbar-toggler-icon"></span>
    </button>

    <div class="collapse navbar-collapse" id="navbarNav">
      <ul class="navbar-nav ms-auto align-items-lg-center gap-lg-1">
        <li class="nav-item">
          <a class="nav-link" href="${laravelUrl}/">Home</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="${laravelUrl}/profile-ukm">About us</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="${laravelUrl}/profile">Profile</a>
        </li>
        <li class="nav-item">
          <a class="nav-link active" href="${ctx}/polls" aria-current="page">Polling</a>
        </li>

        <c:if test="${not empty sessionScope.userName}">
          <li class="nav-item ms-lg-2">
            <form method="post" action="${ctx}/logout" class="m-0">
              <button type="submit" class="btn-logout">
                <i class="bi bi-box-arrow-right"></i> Keluar
              </button>
            </form>
          </li>
        </c:if>
      </ul>
    </div>
  </div>
</nav>