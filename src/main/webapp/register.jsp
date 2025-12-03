<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, com.vote.dao.DBConnection" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Inscription | Système De Gestion De Vote En Ligne</title>
    <%@ include file="includes/head.jsp" %>
</head>
<body class="d-flex flex-column" style="min-height: 100vh;">
<%@ include file="includes/navbar.jsp" %>
<div class="container d-flex flex-grow-1 justify-content-center align-items-center py-5">

    <div class="card auth-card glass-card text-light p-5 animate-fade-in">
        <h2 class="text-center fw-bold mb-4 text-warning">
            <i class="fas fa-user-plus me-2"></i> Créer un compte
        </h2>

        <% if(request.getAttribute("error") != null) { %>
            <div class="alert alert-danger alert-custom mb-4" role="alert">
                <i class="fas fa-exclamation-triangle me-2"></i> **Erreur :** <%= request.getAttribute("error") %>
            </div>
        <% } %>
        
        <form action="registerServlet" method="post"> 
            <div class="mb-3">
                <div class="input-group">
                    <span class="input-group-text bg-transparent border-end-0 text-white-50"><i class="fas fa-signature"></i></span>
                    <input type="text" name="nom" class="form-control" placeholder="Nom" required>
                </div>
            </div>
            <div class="mb-3">
                <div class="input-group">
                    <span class="input-group-text bg-transparent border-end-0 text-white-50"><i class="fas fa-signature"></i></span>
                    <input type="text" name="prenom" class="form-control" placeholder="Prénom" required>
                </div>
            </div>
            <div class="mb-3">
                <div class="input-group">
                    <span class="input-group-text bg-transparent border-end-0 text-white-50"><i class="fas fa-envelope"></i></span>
                    <input type="email" name="email" class="form-control" placeholder="nom@exemple.com" required>
                </div>
            </div>
            <div class="mb-4">
                <div class="input-group">
                    <span class="input-group-text bg-transparent border-end-0 text-white-50"><i class="fas fa-lock"></i></span>
                    <input type="password" name="password" class="form-control" placeholder="Mot de passe" required>
                </div>
            </div>
            
            <button type="submit" class="btn btn-custom w-100 btn-lg shadow-lg">S'inscrire</button>
            
            <p class="mt-4 text-center text-white-75">
                Déjà inscrit ? <a href="login.jsp" class="text-warning fw-bold text-decoration-none hover-underline">Se connecter</a>
            </p>
        </form>
    </div>
</div>
<%@ include file="includes/footer.jsp" %>
</body>
</html>