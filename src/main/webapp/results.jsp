<%@ page import="java.sql.*, com.vote.dao.DBConnection" %>
<!DOCTYPE html>
<html>
<head>

    <meta charset="UTF-8">
    <title>Résultats des Élections | Systéme De Gestion De Vote En Ligne</title>
    <%@ include file="includes/head.jsp" %>
</head>
<body class="d-flex flex-column" style="min-height: 100vh;">
<%@ include file="includes/navbar.jsp" %> 

<div class="container mt-5 pt-3 flex-grow-1">
    <h2 class="mb-4 fw-bolder text-warning text-center"><i class="bi bi-bar-chart-line-fill me-2"></i> Résultats des Élections</h2>
    
    <!-- Carte englobant le tableau, sur fond blanc pour la lisibilité des données -->
    <div class="card shadow-lg p-3 bg-white text-dark">
        <p class="lead text-center text-muted mb-4">Aperçu du décompte des votes pour toutes les élections.</p>
        <div class="table-responsive">
            <table class="table table-hover table-striped">
                <thead class="table-dark">
                    <tr>
                        <th>Élection</th>
                        <th>Candidat</th>
                        <th>Parti</th>
                        <th class="text-end">Votes Totaux</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        Connection con = null;
                        try {
                            con = DBConnection.getConnection();
                            Statement stmt = con.createStatement();
                            ResultSet rs = stmt.executeQuery(
                                "SELECT c.nom, c.parti, e.titre, COUNT(v.id_vote) AS votes " +
                                "FROM candidats c " +
                                "JOIN elections e ON c.id_election = e.id_election " +
                                "LEFT JOIN votes v ON c.id_candidat = v.id_candidat " +
                                "GROUP BY c.id_candidat, e.titre, c.nom, c.parti " +
                                "ORDER BY e.titre, votes DESC"
                            );

                            while(rs.next()) {
                    %>
                        <tr>
                            <td><%= rs.getString("titre") %></td>
                            <td><%= rs.getString("nom") %></td>
                            <td><%= rs.getString("parti") %></td>
                            <td class="text-end fw-bold text-primary"><%= rs.getInt("votes") %></td>
                        </tr>
                    <%      }
                        } catch(Exception e) {
                            out.println("<tr><td colspan='4' class='text-danger'>Erreur de base de données : " + e.getMessage() + "</td></tr>");
                        } finally {
                            if (con != null) try { con.close(); } catch(SQLException ignored) {}
                        }
                    %>
                </tbody>
            </table>
        </div>
    </div>

    <div class="text-center mt-5 mb-5">
        <a href="dashboard.jsp" class="btn btn-outline-custom btn-lg">
            <i class="bi bi-arrow-left-circle"></i> Retour au Tableau de bord
        </a>
    </div>
</div>
<%@ include file="includes/footer.jsp" %>
</body>
</html>