<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
  <title>Accueil | Système de Gestion de vote en ligne sécurisé</title>
  <%@ include file="includes/head.jsp" %>
</head>
<body>

  <%@ include file="includes/navbar.jsp" %>
  
  <div style="padding-top: 70px;"> 

  <section class="d-flex flex-column justify-content-center align-items-center text-center text-light" style="min-height: calc(100vh - 70px);">
   
    <div class="container-fluid py-5 px-4 glass-card animate-fade-in mt-5" style="max-width: 1200px;">
 
        
      <div class="row align-items-center g-4">
          
          <div class="col-md-7 text-center">
              <h1 class="display-5 fw-bold mb-3 text-warning">Exprimez votre voix en toute sécurité</h1>
              <p class="lead mb-4 text-white-75">Fiabilité, Anonymat, Simplicité. Votez pour l'avenir en toute confiance.</p>
              
              <a href="login.jsp" class="btn btn-custom btn-lg px-5 py-3 shadow-lg me-3">Commencer à voter</a>
              <a href="results.jsp" class="btn btn-outline-custom btn-lg px-5 py-3 shadow-lg">Voir les résultats</a>
          </div>
          
          <div class="col-md-5 d-none d-md-block">
              <i class="fas fa-vote-yea display-1 text-info opacity-75"></i>
          </div>
      </div>
      
    </div>
  </section>

  <section class="features py-5 text-center text-light">
    <div class="container">
      <h2 class="fw-bold mb-5 text-warning">Pourquoi choisir Vote En Ligne ?</h2>
      <div class="row g-4">
        
        <div class="col-md-4">
          <div class="card p-4 h-100">
            <i class="fas fa-shield-alt fa-3x mb-3 text-info"></i> 
            <h4 class="mt-2">Sécurité Avancée</h4>
            <p class="text-white-50">Vos données et vos votes sont protégés par un chiffrement de haut niveau .</p>
          </div>
        </div>
        <div class="col-md-4">
          <div class="card p-4 h-100">
            <i class="fas fa-bolt fa-3x mb-3 text-info"></i>
            <h4 class="mt-2">Rapidité Optimale</h4>
            <p class="text-white-50">Un processus de vote optimisé, accessible en quelques secondes sur tous vos appareils.</p>
          </div>
        </div>
        <div class="col-md-4">
          <div class="card p-4 h-100">
            <i class="fas fa-chart-bar fa-3x mb-3 text-info"></i>
            <h4 class="mt-2">Transparence</h4>
            <p class="text-white-50">Comptage des voix instantané et auditable pour des résultats clairs et incontestables.</p>
          </div>
        </div>
      </div>
    </div>
  </section>

  </div> <%@ include file="includes/footer.jsp" %>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>