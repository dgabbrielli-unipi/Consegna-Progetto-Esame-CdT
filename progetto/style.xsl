<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" version="2.0">
    
    <xsl:output method="html" encoding="UTF-8" indent="yes"/>
    
    <!-- TEMPLATE GENERALE -->
    <xsl:template match="/">
        <html>
            <head>
                <title>La Farfalla - Edizione Digitale</title>
                <link rel="stylesheet" type="text/css" href="style.css"/>
                <script type="text/javascript" src="script.js"></script>
            </head>
            <body>
                <header>
                    <img src="logo_coverless-chiaro.svg" alt="Logo COVerLeSS"></img>
                    <div class="navbar">
                        <ul>
                            <li><a href="#Farfalla_1877_3_10_ingiroperlitalia.xml" class="active">In giro per l'Italia</a></li>
                            <li><a href="#Farfalla_1877_3_11_recensionefanfaniarlia.xml">Recensione a P. Fanfani e C. Arlia</a></li>
                            <li><a href="#Farfalla_1877_3_5_bibliografia.xml">Bibliografia</a></li>
                        </ul>
                    </div>
                    <div class="bottoni-entita">
                        <button onclick="evidenzia('persona')">Persone</button>
                        <button onclick="evidenzia('luogo')">Luoghi</button>
                        <button onclick="evidenzia('organizzazione')">Organizzazioni</button>
                    </div>
                </header>
                
                <div id="intro">
                    <h1>Codifica di testi a.a. 25/26</h1>
                    <h2>La Farfalla</h2>
                    <p>Fondata a Cagliari da Angelo Sommaruga, con cadenza quindicinale, «La Farfalla» vide la luce il 27 febbraio 1876. Si presentava al pubblico «semplice, pulita, senza fregi e senza fronzoli», quasi del tutto priva di quelle novità grafiche che caratterizzeranno le riviste successive. I maggiori collaboratori furono, oltre Giarelli, autore della maggior parte degli articoli, Ottone Bacaredda, Felice Cameroni, Paolo Valera, Ferdinando Fontana, Cesario Testa, Domenico Milelli, Remigio Zena. Nel 1877 Sommaruga ritornò a Milano, portando con sé la rivista. Il primo numero milanese del 30 settembre uscì con una nuova testata che preannunciava lo stile liberty: un disegno di Tranquillo Cremona che raffigurava una graziosa fanciulla incastonato tra le prime due lettere del titolo. <br/><a href="https://coverless.cnr.it/riviste.html">Per saperne di più.</a></p>
                    <h2>Il progetto</h2>
                    <p>Il progetto è stato realizzato da Daria Gabbrielli (mat. 672094) seguendo le specifiche del modello <a href="https://coverless.cnr.it/index.html">COVerLeSS</a> e lo standard XML-TEI P5. è stata realizzata l'edizione digitale di tre contributi tratti dalla rivista "La Farfalla" del 1877.</p>
                    <ul>
                        <li>Tramite l'header è possibile navigare da un'articolo all'altro in maniera facile e rapida.</li>
                        <li>Cliccando sui bottoni in alto a destra è possibile evidenziare le entità nominate, ovvero i nomi di persona, luoghi e organizzazioni citati nel testo anche in maniera indiretta.</li>
                    </ul>
                </div>
                
                <!-- Legge la lista in lista.xml, apre i file esterni e li processa -->
                <xsl:for-each select="//articolo">
                    <xsl:apply-templates select="document(@href)//tei:TEI"/>
                </xsl:for-each>
                
                <div class="footer">
                    <p>Progetto realizzato per l'esame di <strong>Codifica di testi</strong>, laurea triennale in <strong>Informatica Umanistica</strong> dell'<strong>Università di Pisa</strong></p>
                </div>
            </body>
        </html>
    </xsl:template>
    
    <!-- TEMPLATE PER I SINGOLI ARTICOLI -->
    <xsl:template match="tei:TEI">
        <!-- Assegna come id alla sezione il nome del file xml contenuto nel tag <idno> -->
        <section id="{tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno}">
            <div class="container">
                <!-- Colonna dell'immagine facsimile -->
                <div class="facsimile_column">
                    <xsl:apply-templates select="tei:facsimile"/>
                </div>
                
                <!-- Colonna del testo -->
                <div class="text_column">
                    <xsl:apply-templates select="tei:text/tei:body"/>
                    <div class="note">
                        <xsl:apply-templates select="tei:text/tei:body//tei:note[@type='footnote']" mode="pie-di-pagina"/>
                    </div>
                </div>
            </div>
            
            <hr class="section-divider" style="border: 1px dashed #ae7133; width: 80%; margin: 3rem auto;"/>
        </section>
    </xsl:template>

    <!-- IMMAGINI DEI TESTI -->
    <xsl:template match="tei:facsimile">
        <xsl:for-each select="tei:surface/tei:graphic">
            <img class="facsimile_image" src="{@url}" alt="Pagina dell'articolo"/>
        </xsl:for-each>
    </xsl:template>

    <!-- INTESTAZIONE -->
    <xsl:template match="tei:div[@type='intestazione']">
        <div class="intestazione">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    <!-- GESTIONE TITOLI -->
    <xsl:template match="tei:head[@type='main']">
        <h1 class="titolo">
            <xsl:apply-templates/>
        </h1>
    </xsl:template>
    
    <xsl:template match="tei:head[@type='subtitle']">
        <h2 class="sottotitolo">
            <xsl:apply-templates/>
        </h2>
    </xsl:template>

    <!-- GESTIONE PARAGRAFI E ALLINEAMENTI -->
    <xsl:template match="tei:p">
        <xsl:choose>
            <xsl:when test="@rend='first-line-indented'">
                <p class="p_rientrato"><xsl:apply-templates/></p>
            </xsl:when>
            <xsl:when test="@rend='align-center'">
                <p class="text_center"><xsl:apply-templates/></p>
            </xsl:when>
            <xsl:when test="@rend='align-right'">
                <p class="text_right"><xsl:apply-templates/></p>
            </xsl:when>
            <xsl:otherwise>
                <p class="p_normale"><xsl:apply-templates/></p>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- GESTIONE CITAZIONI -->
    <xsl:template match="tei:q">
        <xsl:choose>
            <xsl:when test="@rend='align-center'">
                <span class="text_center"><xsl:apply-templates/></span>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- GESTIONE ABBREVIAZIONI -->
    <xsl:template match="tei:choice">
        <span class="abbreviazione">
            <xsl:apply-templates select="tei:abbr"/>
        </span>
    </xsl:template>

    <!-- FIRME E CHIUSURE -->
    <xsl:template match="tei:closer | tei:signed">
        <div class="firma">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    <!-- SEPARATORI FARFALLA E LINEE ONDULATE-->
    <xsl:template match="tei:metamark[@function='sectionDivider']">
        <div class="separatore">
            <xsl:choose>
                <xsl:when test="tei:graphic">
                    <img class="fregio_farfalla" src="{tei:graphic/@url}" alt="Fregio tipografico"/>
                </xsl:when>
                
                <xsl:when test="@rend='ondulata'">
                    <span class="linea_ondulata"></span>
                </xsl:when>
                
                <xsl:otherwise>
                    <span class="sectionDivider">
                        <xsl:value-of select="."/>
                    </span>
                </xsl:otherwise>
            </xsl:choose>
        </div>
    </xsl:template>

    <!-- GESTIONE DEL TESTO IN CORSIVO, GRASSETTO, MAIUSCOLO, ECC -->
    <xsl:template match="*[@rend='italic']">
        <span class="corsivo"><xsl:apply-templates/></span>
    </xsl:template>
    
    <xsl:template match="*[@rend='bold']">
        <span class="grassetto"><xsl:apply-templates/></span>
    </xsl:template>
    
    <xsl:template match="*[@rend='uppercase']">
        <span class="maiuscolo"><xsl:apply-templates/></span>
    </xsl:template>
    
    <xsl:template match="*[@rend='smallcaps']">
        <span class="maiuscoletto"><xsl:apply-templates/></span>
    </xsl:template>

    <!-- NOTE A PIÈ DI PAGINA CHE NON VENGONO MOSTRATE NELLA LORO POSIZIONE MA SOLO IN FONDO AL TESTO -->
    <xsl:template match="tei:note[@type='footnote']">
    </xsl:template>
    
    <xsl:template match="tei:note[@type='footnote']" mode="pie-di-pagina">
        <div class="nota_pdp">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    <!-- EVIDENZIAZIONE ENTITÀ NOMINATE -->
    <!-- Persone -->
    <xsl:template match="tei:persName | tei:rs[@type='person'] | tei:name[@type='epithet']">
        <span class="entita persona"><xsl:apply-templates/></span>
    </xsl:template>
    
    <!-- Luoghi -->
    <xsl:template match="tei:placeName | tei:rs[@type='place']">
        <span class="entita luogo"><xsl:apply-templates/></span>
    </xsl:template>
    
    <!-- Organizzazioni -->
    <xsl:template match="tei:orgName | tei:rs[@type='journal'] | tei:rs[@type='publisher'] | tei:rs[@type='academy'] | tei:rs[@type='association']">
        <span class="entita organizzazione"><xsl:apply-templates/></span>
    </xsl:template>

    <!-- ELEMENTI DI STRUTTURA PAGINA VENGONO NASCOSTI -->
    <xsl:template match="tei:pb | tei:cb">
    </xsl:template>

</xsl:stylesheet>
