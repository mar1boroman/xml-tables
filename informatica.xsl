<?xml version = "1.0" encoding = "UTF-8"?>
<xsl:stylesheet version = "1.0" xmlns:xsl = "http://www.w3.org/1999/XSL/Transform">   
   <xsl:template match = "/">
   <html> 
         <body> 
            <h2>Informatica Pretty Print</h2> 
               <xsl:for-each select="POWERMART/REPOSITORY/FOLDER"> 
                  
                        <xsl:value-of select = "@NAME"/> 
                    
               </xsl:for-each> 
					
         </body> 
      </html> 
   </xsl:template>  
</xsl:stylesheet>