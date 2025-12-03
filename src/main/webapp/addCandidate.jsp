<%@ page import="java.sql.*, com.vote.dao.DBConnection" %>
<%
    // Vérification de sécurité renforcée
    if(session.getAttribute("userId") == null || !"admin".equals(session.getAttribute("userRole"))){
        response.sendRedirect("login.jsp"); // Redirection vers la page de connexion
        return;
    }
    String userName = (String) session.getAttribute("userName");
%>

<!DOCTYPE html>
<html>
<head>

    <meta charset="UTF-8">
    <title>Ajouter Candidat - Admin</title>
    <%@ include file="includes/head.jsp" %>
</head>
<!-- La classe d-flex et form-container pour centrer la carte -->
<body class="d-flex flex-column form-container"> 
<%@ include file="includes/navbar.jsp" %>

<div class="container mt-5 pt-3 d-flex flex-grow-1 justify-content-center align-items-center">
    
    <!-- Utilisation de glass-card et de classes bg/text appropriées -->
    <div class="card auth-card glass-card text-light">
        <h2 class="text-center fw-bold mb-0 p-3" style="background-color: rgba(25, 135, 84, 0.7); border-radius: 15px 15px 0 0;">
            <i class="bi bi-person-plus me-2"></i> Ajouter un Candidat
        </h2>
        <div class="card-body p-4">

            <% if(request.getAttribute("error") != null){ %>
                <div class="alert alert-danger alert-custom" role="alert"><i class="bi bi-x-circle-fill"></i> **Erreur :** <%= request.getAttribute("error") %></div>
            <% } %>
            <% if(request.getAttribute("success") != null){ %>
                <div class="alert alert-success alert-custom" role="alert"><i class="bi bi-check-circle-fill"></i> **Succès :** <%= request.getAttribute("success") %></div>
            <% } %>

            <form action="addCandidateServlet" method="post">
                <div class="mb-3">
                    <label class="form-label text-warning fw-bold">Nom du candidat</label>
                    <input type="text" name="nom" class="form-control" placeholder="Nom complet du candidat" required>
                </div>
                <div class="mb-3">
                    <label class="form-label text-warning fw-bold">Parti / Affiliation</label>
                    <input type="text" name="parti" class="form-control" placeholder="Ex: Indépendant, Parti des Jeunes" required>
                </div>
                <div class="mb-4">
                    <label class="form-label text-warning fw-bold">Élection Ciblée</label>
                    <select name="id_election" class="form-select" required>
                        <option value="">-- Sélectionnez une élection --</option>
                        <%
                            Connection con = null;
                            try {
                                con = DBConnection.getConnection();
                                Statement stmt = con.createStatement();
                                ResultSet rs = stmt.executeQuery("SELECT id_election, titre FROM elections WHERE date_fin >= CURDATE()"); // Afficher seulement les élections actives
                                while(rs.next()){
                        %>
                            <option value="<%= rs.getInt("id_election") %>"><%= rs.getString("titre") %></option>
                        <%  }
                            } catch(Exception e){
                                out.println("<option value='' disabled>Erreur de chargement: " + e.getMessage() + "</option>");
                            } finally {
                                if (con != null) try { con.close(); } catch(SQLException ignored) {}
                            }
                        %>
                    </select>
                </div>
                
                <div class="d-flex justify-content-between mt-4">
                    <a href="admin_dashboard.jsp" class="btn btn-outline-custom">
                        <i class="bi bi-arrow-left"></i> Retour
                    </a>
                    <button type="submit" class="btn btn-success btn-lg">
                        <i class="bi bi-person-plus-fill"></i> Ajouter le candidat
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>
<%@ include file="includes/footer.jsp" %>
</body>
</html>