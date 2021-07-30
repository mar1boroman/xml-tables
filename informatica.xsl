<?xml version = "1.0" encoding = "UTF-8"?>
<xsl:stylesheet version = "1.0" xmlns:xsl = "http://www.w3.org/1999/XSL/Transform">   
   <xsl:template match = "/">
      <html lang="en">
         <head>
         <title>Bootstrap Example</title>
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

         

         <div class="container">
            <div class="row">
               <div class="col-sm-4">
                  <h3>Folder name</h3>
                  <xsl:for-each select="POWERMART/REPOSITORY"> 
                           
                     <p><xsl:value-of select = "@NAME"/></p>
                                    
                  </xsl:for-each> 
               </div>
               <div class="col-sm-4">
                  <h3>Repository Name</h3>
                  <xsl:for-each select="POWERMART/REPOSITORY"> 
                           
                     <p><xsl:value-of select = "@NAME"/></p>
                                    
                  </xsl:for-each> 
               </div>
               <div class="col-sm-4">
                  <h3>Mapping Name</h3>        
                  <xsl:for-each select="POWERMART/REPOSITORY/FOLDER/MAPPING"> 
                           
                     <p><xsl:value-of select = "@NAME"/></p>
                                    
                  </xsl:for-each> 
               </div>
            </div>
         </div>

   </body>
   </html>
 
</xsl:template>  
</xsl:stylesheet>