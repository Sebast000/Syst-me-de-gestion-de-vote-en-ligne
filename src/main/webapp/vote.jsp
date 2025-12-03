<%@ page import="java.sql.*, com.vote.dao.DBConnection" %>
<%
    // Vérification de sécurité
    if(session.getAttribute("userId") == null){
        response.sendRedirect("login.jsp");
        return;
    }
    // Récupération de l'ID utilisateur pour les requêtes SQL
    String userIdStr = String.valueOf(session.getAttribute("userId"));
    String userName = (String) session.getAttribute("userName"); 
%>

<!DOCTYPE html>
<html>
<head>

    <meta charset="UTF-8">
    <title>Voter | Systéme De Gestion De Vote En Ligne</title>
    <%@ include file="includes/head.jsp" %>
</head>
<body class="d-flex flex-column" style="min-height: 100vh;">
<%@ include file="includes/navbar.jsp" %>

<div class="container mt-5 pt-3 flex-grow-1">
    <h2 class="mb-4 fw-bolder text-warning text-center"><i class="bi bi-check2-square me-2"></i> Élections Actives</h2>
    <p class="lead text-center text-light">Sélectionnez un seul candidat par élection et validez votre choix.</p>
    
    <% 
        // Affichage des erreurs renvoyées par le VoteServlet
        if (request.getAttribute("error") != null) { 
    %>
        <div class="alert alert-danger shadow-lg border-left-danger mt-4 bg-white text-dark" role="alert">
            <i class="bi bi-x-octagon-fill me-2"></i> **Erreur lors du vote :** <%= request.getAttribute("error") %>
        </div>
    <% 
        } 
    %>

    <%
        try (Connection con = DBConnection.getConnection()) { 
            Statement stmt = con.createStatement();
            
            // Requête pour trouver les élections actives
            ResultSet rsElections = stmt.executeQuery(
                "SELECT * FROM elections WHERE date_fin >= CURDATE() ORDER BY date_debut ASC"
            );
            
            boolean electionsFound = false;

            while(rsElections.next()) {
                electionsFound = true;
                int idElection = rsElections.getInt("id_election");
                String titre = rsElections.getString("titre");
                String description = rsElections.getString("description");

                // Vérifier si l'utilisateur a déjà voté pour cette élection
                boolean hasVoted = false;
                try (PreparedStatement psVoted = con.prepareStatement(
                        "SELECT 1 FROM votes WHERE id_utilisateur=? AND id_election=?"
                )) {
                    psVoted.setString(1, userIdStr);    
                    psVoted.setInt(2, idElection);
                    
                    try (ResultSet rsVoted = psVoted.executeQuery()) {
                        if(rsVoted.next()){
                            hasVoted = true;
                        }
                    }
                }
    %>
        <div class="card mb-5 p-4 shadow-lg glass-card border-primary">
            <div class="card-header bg-primary text-white fw-bold fs-4 rounded-top-3 p-3">
                <%= titre %>
            </div>
            <div class="card-body">
                <p class="card-text text-white-50"><%= description %></p>

                <% if(hasVoted) { %>
                    <div class="alert alert-success border-left-success shadow-sm mt-3" role="alert">
                        <i class="bi bi-check-circle-fill me-2"></i> **Vous avez déjà voté pour cette élection.** Votre vote est enregistré.
                    </div>
                <% } else { %>
                    <h5 class="mt-3 mb-4 text-warning fw-bold">Choisissez votre candidat (Un seul choix possible) :</h5>
                    
                    <form action="${pageContext.request.contextPath}/voteServlet" method="post" class="vote-form" data-id-election="<%= idElection %>">    
                        <input type="hidden" name="id_election" value="<%= idElection %>">
                        <input type="hidden" name="id_candidat_selected" id="hidden_candidat_<%= idElection %>" required>
                        
                        <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4 candidate-row">
                        <%
                            try (PreparedStatement psC = con.prepareStatement("SELECT id_candidat, nom, parti FROM candidats WHERE id_election=?")) {
                                psC.setInt(1, idElection);
                                try (ResultSet rsCandidats = psC.executeQuery()) {
                                    
                                    while(rsCandidats.next()) {
                                        int idCandidat = rsCandidats.getInt("id_candidat");
                                        String nomCandidat = rsCandidats.getString("nom");
                                        String parti = rsCandidats.getString("parti");
                        %>
                            <div class="col">
                                <div class="card candidate-card glass-card p-4 shadow-sm h-100"    
                                            data-candidate-id="<%= idCandidat %>"    
                                            onclick="selectCandidate(this, <%= idElection %>, <%= idCandidat %>)">
                                    <div class="d-flex flex-column text-center">
                                        <i class="bi bi-person-badge-fill display-5 text-warning mb-2"></i>
                                        <label class="fw-bolder fs-5 text-light" for="candidat_<%= idCandidat %>">
                                            <%= nomCandidat %>
                                        </label>
                                        <p class="mb-0 text-info small"><%= parti %></p>
                                    </div>
                                </div>
                            </div>
                        <% 
                                    }
                                }
                            }
                        %>
                        </div>
                        
                        <div class="d-flex justify-content-center mt-5">
                            <button type="submit" class="btn btn-custom btn-lg px-5">
                                <i class="bi bi-box-arrow-in-right"></i> Valider mon Vote
                            </button>
                        </div>
                    </form>
                <% } %>
            </div>
        </div>
    <%  } // Fin du while(rsElections.next())
        
        if (!electionsFound) { %>
            <div class="alert alert-info shadow-lg border-left-info mt-4 bg-white text-dark" role="alert">
                <i class="bi bi-info-circle-fill me-2"></i> Aucune élection active n'est actuellement disponible. Veuillez revenir plus tard.
            </div>
        <% }
        
        } catch(Exception e){
            out.println("<div class='alert alert-danger shadow-sm mt-4 bg-white text-dark'><i class='bi bi-x-octagon-fill me-2'></i> Erreur de base de données (Chargement des élections) : " + e.getMessage() + "</div>");
        }
    %>

    <div class="text-center mt-5 mb-5">
        <a href="dashboard.jsp" class="btn btn-outline-custom btn-lg">
            <i class="bi bi-arrow-left-circle"></i> Retour au tableau de bord
        </a>
    </div>
</div>

<script>
    function selectCandidate(card, idElection, candidateId) {
        const row = card.closest('.candidate-row');
        const cards = row.querySelectorAll('.candidate-card');

        cards.forEach(c => {
            c.classList.remove('selected', 'border-success', 'border-warning');
            c.style.backgroundColor = 'rgba(255, 255, 255, 0.1)'; 
        });

        card.classList.add('selected', 'border-success');
        card.style.backgroundColor = 'rgba(25, 135, 84, 0.2)'; 

        const hiddenInput = document.getElementById('hidden_candidat_' + idElection);
        if (hiddenInput) {
            hiddenInput.value = candidateId;
        }
    }

    document.querySelectorAll('.vote-form').forEach(form => {
        form.addEventListener('submit', function(event) {
            const idElection = this.getAttribute('data-id-election');
            const hiddenInput = document.getElementById('hidden_candidat_' + idElection);

            if (!hiddenInput || !hiddenInput.value) {
                event.preventDefault(); 
                alert("Veuillez sélectionner un candidat avant de soumettre votre vote."); 
            }
        });
    });
</script>
<%@ include file="includes/footer.jsp" %>
</body>
</html>