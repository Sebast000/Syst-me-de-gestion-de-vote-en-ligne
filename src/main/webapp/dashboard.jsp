<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, com.vote.dao.DBConnection" %>
<%
    // Vérification de sécurité (essentiel)
    if(session.getAttribute("userId") == null){
        response.sendRedirect("login.jsp"); // Redirection vers la page de connexion
        return;
    }
    String userName = (String) session.getAttribute("userName");
    String userRole = (String) session.getAttribute("userRole");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Tableau de Bord | Système de Vote</title>
    <%@ include file="includes/head.jsp" %>
</head>
<body class="d-flex flex-column" style="min-height: 100vh;">
<%@ include file="includes/navbar.jsp" %>

<!-- BLOC DE DIAGNOSTIC TEMPORAIRE (Aide à détecter la perte de session) -->
<%
    String diagnosticMessage = "Session ID : " + session.getId() + " | Nouvelle session ? " + session.isNew();
%>
<div class="container mt-2 text-white-50 text-end">
    <small>(Diagnostic) <%= diagnosticMessage %></small>
</div>
<!-- FIN DU BLOC DE DIAGNOSTIC -->


<!-- BLOC DE GESTION DES MESSAGES DE SUCCÈS (PRISE EN CHARGE REQUEST & SESSION) -->
<%
    // Tente de récupérer le message d'abord dans la REQUEST (pour le Forward)
    String voteSuccess = (String) request.getAttribute("voteSuccess");
    
    // Si la request est vide (car c'était un Redirect), on vérifie la SESSION
    if (voteSuccess == null) {
        voteSuccess = (String) session.getAttribute("voteSuccess");
        
        // Si on l'a trouvé dans la SESSION, on le supprime immédiatement
        if (voteSuccess != null) {
            session.removeAttribute("voteSuccess");
        }
    }

    if (voteSuccess != null) {
%>
        <div class="container mt-4">
            <div class="alert alert-success alert-dismissible fade show shadow-lg border-left-success" role="alert">
                <i class="bi bi-check-circle-fill me-2"></i> 
                <strong>Succès!</strong> <%= voteSuccess %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </div>
<%
    }
%>
<!-- FIN DU BLOC DE GESTION DES MESSAGES -->

<div class="container mt-5 pt-3 flex-grow-1">
    
    <!-- Alerte d'accueil plus stylée et lisible -->
    <div class="alert bg-white text-dark border-left-info shadow-sm p-4" role="alert">
        <h4 class="alert-heading fw-bold"><i class="bi bi-stars me-2"></i> Bienvenue, <%= userName %> !</h4>
        <p class="mb-0">Votre rôle : <strong class="text-primary"><%= userRole.toUpperCase() %></strong>. Participez aux élections en toute confiance.</p>
    </div>

    <div class="row mt-5 justify-content-center">
        
        <!-- Carte : Voter -->
        <div class="col-md-4 mb-4">
            <div class="card shadow-lg h-100 border-primary glass-card">
                <div class="card-body text-center text-light">
                    <i class="bi bi-ui-checks-grid display-4 text-primary mb-3"></i>
                    <h5 class="card-title mt-3 fw-bold">Voter</h5>
                    <p class="card-text text-white-50">Participez aux élections en cours et exprimez votre choix de manière sécurisée.</p>
                    <a href="vote.jsp" class="btn btn-custom w-100 mt-3 btn-lg">
                        <i class="bi bi-pencil-square"></i> Accéder au Vote
                    </a>
                </div>
            </div>
        </div>
        
        <!-- Carte : Résultats -->
        <div class="col-md-4 mb-4">
            <div class="card shadow-lg h-100 border-info glass-card">
                <div class="card-body text-center text-light">
                    <i class="bi bi-bar-chart-fill display-4 text-info mb-3"></i>
                    <h5 class="card-title mt-3 fw-bold">Résultats</h5>
                    <p class="card-text text-white-50">Consultez les résultats officiels des élections clôturées.</p>
                    <a href="results" class="btn btn-outline-custom w-100 mt-3 btn-lg">
                        <i class="bi bi-eye"></i> Voir les Résultats
                    </a>
                </div>
            </div>
        </div>

        <% if ("admin".equals(userRole)) { %>
            <!-- Carte : Gestion Admin (Affichée uniquement pour l'Admin) -->
            <div class="col-md-4 mb-4">
                <div class="card shadow-lg h-100 border-warning glass-card">
                    <div class="card-body text-center text-light">
                        <i class="bi bi-tools display-4 text-warning mb-3"></i>
                        <h5 class="card-title mt-3 fw-bold">Gestion Administateur</h5>
                        <p class="card-text text-white-50">Accédez aux outils pour créer des élections et gérer les candidats.</p>
                        <a href="admin_dashboard.jsp" class="btn btn-warning w-100 mt-3 text-dark btn-lg">
                            <i class="bi bi-gear"></i> Tableau de Bord Administrateur
                        </a>
                    </div>
                </div>
            </div>
        <% } %>

    </div>
</div>

<%@ include file="includes/footer.jsp" %>
</body>
</html>