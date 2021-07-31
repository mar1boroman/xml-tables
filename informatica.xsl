<?xml version = "1.0" encoding = "UTF-8"?>
<xsl:stylesheet version = "1.0"
   xmlns:xsl = "http://www.w3.org/1999/XSL/Transform">
   <xsl:template match = "/">
      <html lang="en">
         <head>
            <title>PrettifyXML</title>
            <meta charset="utf-8"/>
            <meta name="viewport" content="width=device-width, initial-scale=1"/>
            <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css"/>
            <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
            <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
         </head>
         <body>

            <div class="jumbotron text-center">
               <h1>XML Analysis</h1>
               <p>Prettify your XML!</p>
            </div>
            
            <br/>

            <xsl:value-of select="*">
            



         </body>
      </html>

   </xsl:template>
</xsl:stylesheet>