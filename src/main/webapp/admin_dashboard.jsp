<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, com.vote.dao.DBConnection" %>
<%
    // Vérification de sécurité renforcée
    if(session.getAttribute("userId") == null || !"admin".equals(session.getAttribute("userRole"))){
        response.sendRedirect("login.jsp"); // Redirection vers la page de connexion
        return;
    }
    String userName = (String) session.getAttribute("userName");
    // String userRole = (String) session.getAttribute("userRole"); // Déjà vérifié comme 'admin'
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Tableau de bord Admin | Gestion du Vote</title>
    <%@ include file="includes/head.jsp" %>
</head>
<body class="d-flex flex-column" style="min-height: 100vh;">
<%@ include file="includes/navbar.jsp" %>

<div class="container mt-5 pt-3 flex-grow-1">

    <!-- BLOC D'AFFICHAGE DES MESSAGES (SUCCÈS/ERREUR) -->
    <%
        // Récupère les attributs passés par le Servlet (via le Forward)
        String successMessage = (String) request.getAttribute("success");
        String errorMessage = (String) request.getAttribute("error");

        if (successMessage != null) {
    %>
        <div class="alert alert-success alert-dismissible fade show shadow-lg mb-4" role="alert">
            <i class="bi bi-check-circle-fill me-2"></i> 
            <strong>Succès :</strong> <%= successMessage %>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    <%
        } else if (errorMessage != null) {
    %>
        <div class="alert alert-danger alert-dismissible fade show shadow-lg mb-4" role="alert">
            <i class="bi bi-x-circle-fill me-2"></i> 
            <strong>Erreur :</strong> <%= errorMessage %>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    <%
        }
    %>
    <!-- FIN DU BLOC MESSAGE -->
    
    <!-- En-tête de la page d'administration -->
    <div class="alert bg-white text-dark border-left-warning shadow-sm p-4" role="alert">
        <h4 class="alert-heading fw-bold"><i class="bi bi-gear-fill me-2 text-warning"></i> Administration du Système de Vote</h4>
        <p class="mb-0">Connecté en tant que <strong class="text-danger">ADMINISTRATEUR (<%= userName %>)</strong>. Gérez les élections et les participants en toute sécurité. 
            <a href="logoutServlet" class="btn btn-danger btn-sm float-end">
                <i class="bi bi-box-arrow-right"></i> Déconnexion
            </a>
        </p>
    </div>

    <div class="row mt-5">
        
        <!-- Carte : Nouvelle Élection -->
        <div class="col-md-4 mb-4">
            <div class="card shadow-lg h-100 border-primary glass-card">
                <div class="card-body text-center text-light">
                    <i class="bi bi-calendar-plus display-4 text-primary mb-3"></i>
                    <h5 class="card-title mt-3 fw-bold">Nouvelle Élection</h5>
                    <p class="card-text text-white-50">Créer et planifier une nouvelle élection dans le système.</p>
                    <a href="addElection.jsp" class="btn btn-custom w-100 mt-3 btn-lg">
                        <i class="bi bi-plus-circle"></i> Ajouter une élection
                    </a>
                </div>
            </div>
        </div>
        
        <!-- Carte : Nouveau Candidat -->
        <div class="col-md-4 mb-4">
            <div class="card shadow-lg h-100 border-success glass-card">
                <div class="card-body text-center text-light">
                    <i class="bi bi-person-plus display-4 text-success mb-3"></i>
                    <h5 class="card-title mt-3 fw-bold">Nouveau Candidat</h5>
                    <p class="card-text text-white-50">Inscrire un nouveau candidat à une élection existante.</p>
                    <a href="addCandidate.jsp" class="btn btn-success w-100 mt-3 btn-lg">
                        <i class="bi bi-person-badge"></i> Ajouter un candidat
                    </a>
                </div>
            </div>
        </div>

        <!-- Carte : Résultats et Statistiques -->
        <div class="col-md-4 mb-4">
            <div class="card shadow-lg h-100 border-info glass-card">
                <div class="card-body text-center text-light">
                    <i class="bi bi-bar-chart display-4 text-info mb-3"></i>
                    <h5 class="card-title mt-3 fw-bold">Résultats</h5>
                    <p class="card-text text-white-50">Analyser les résultats détaillés du scrutin en cours ou clôturés.</p>
                    <a href="results.jsp" class="btn btn-outline-info w-100 mt-3 btn-lg text-light">
                        <i class="bi bi-eye"></i> Voir les résultats
                    </a>
                </div>
            </div>
        </div>

    </div>
</div>

<%@ include file="includes/footer.jsp" %>
</body>
</html>