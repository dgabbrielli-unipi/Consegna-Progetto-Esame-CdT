function evidenzia(categoria) {
    // Cerca tutti gli elementi con la classe della categoria scelta
    var elementi = document.querySelectorAll('.entita.' + categoria);
    // Aggiunge o rimuove la classe 'attiva' per mostrare il colore
    elementi.forEach(function(el) {
        el.classList.toggle('attiva');
    });
}