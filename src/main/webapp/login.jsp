<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <title>Connexion | Système de Gestion de vote en ligne</title>
  <%@ include file="includes/head.jsp" %>
</head>
<body class="d-flex flex-column" style="min-height: 100vh;"> 
<%@ include file="includes/navbar.jsp" %>

<div class="container d-flex flex-grow-1 justify-content-center align-items-center py-5">
  <div class="card text-light auth-card glass-card p-5 animate-fade-in">
    <h2 class="fw-bold mb-4 text-center text-warning"><i class="fas fa-sign-in-alt me-2"></i> Connexion</h2>
    
    <% String error = (String) request.getAttribute("errorMessage");
       if (error != null) { %>
        <div class="alert alert-danger alert-custom mb-4" role="alert">
            <i class="fas fa-exclamation-triangle me-2"></i> <%= error %>
        </div>
    <% } %>

    <form action="loginServlet" method="post">
      <div class="mb-3">
        <div class="input-group">
            <span class="input-group-text bg-transparent border-end-0 text-white-50"><i class="fas fa-envelope"></i></span>
            <input type="email" name="email" class="form-control" placeholder="Adresse email" required>
        </div>
      </div>
      <div class="mb-4">
        <div class="input-group">
            <span class="input-group-text bg-transparent border-end-0 text-white-50"><i class="fas fa-lock"></i></span>
            <input type="password" name="password" class="form-control" placeholder="Mot de passe" required>
        </div>
      </div>
      <button type="submit" class="btn btn-custom w-100 btn-lg shadow-lg">Se connecter</button>
      <p class="mt-4 text-center text-white-75">Pas encore inscrit ? 
          <a href="register.jsp" class="text-warning fw-bold text-decoration-none hover-underline">Créer un compte</a>
      </p>
    </form>
  </div>
</div>
<%@ include file="includes/footer.jsp" %>
</body>
</html>