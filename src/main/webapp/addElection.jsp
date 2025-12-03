<%@ page import="java.sql.*, com.vote.dao.DBConnection" %>
<%
    if(session.getAttribute("userId") == null || !"admin".equals(session.getAttribute("userRole"))){
        response.sendRedirect("login.jsp");
        return;
    }
    String userName = (String) session.getAttribute("userName");
%>

<!DOCTYPE html>
<html>
<head>

    <meta charset="UTF-8">
    <title>Ajouter Élection - Admin</title>
    <%@ include file="includes/head.jsp" %>
</head>
<body class="d-flex flex-column form-container">
<%@ include file="includes/navbar.jsp" %>

<div class="container mt-5 pt-3 d-flex flex-grow-1 justify-content-center align-items-center">
    
    <div class="card auth-card glass-card text-light">
        <h2 class="text-center fw-bold mb-0 p-3" style="background-color: rgba(13, 110, 253, 0.7); border-radius: 15px 15px 0 0;">
             <i class="bi bi-calendar-plus me-2"></i> Ajouter une Nouvelle Élection
        </h2>
        <div class="card-body p-4">

            <% if(request.getAttribute("error") != null){ %>
                <div class="alert alert-danger alert-custom" role="alert"><i class="bi bi-x-circle-fill"></i> **Erreur :** <%= request.getAttribute("error") %></div>
            <% } %>
            <% if(request.getAttribute("success") != null){ %>
                <div class="alert alert-success alert-custom" role="alert"><i class="bi bi-check-circle-fill"></i> **Succès :** <%= request.getAttribute("success") %></div>
            <% } %>

            <form action="addElectionServlet" method="post">
                <div class="mb-3">
                    <label class="form-label text-warning fw-bold">Titre de l'élection</label>
                    <input type="text" name="titre" class="form-control" placeholder="Ex: Élection du Bureau 2024" required>
                </div>
                <div class="mb-3">
                    <label class="form-label text-warning fw-bold">Description</label>
                    <textarea name="description" class="form-control" rows="3" placeholder="Détails de l'élection et règles..."></textarea>
                </div>
                
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label text-warning fw-bold">Date de Début</label>
                        <input type="date" name="date_debut" class="form-control" required>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label text-warning fw-bold">Date de Fin</label>
                        <input type="date" name="date_fin" class="form-control" required>
                    </div>
                </div>

                <div class="d-flex justify-content-between mt-4">
                    <a href="admin_dashboard.jsp" class="btn btn-outline-custom">
                        <i class="bi bi-arrow-left"></i> Retour
                    </a>
                    <button type="submit" class="btn btn-primary btn-lg">
                        <i class="bi bi-send-fill"></i> Créer l'élection
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>
<%@ include file="includes/footer.jsp" %>
</body>
</html>