<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output method="html" version="5.0" encoding="UTF-8" indent="yes"/>
    <xsl:strip-space elements="*" />

    <xsl:template match="/">
        <html lang="en">
            <head>
                <!-- Meta tags -->
                <meta name="viewport" content="width=device-width, initial-scale=1"/>
                <!-- Include Bootstrap JS,Bootstrap CSS, JQuery and Font Awesome libraries -->
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous"/>
                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
                <script src="https://code.jquery.com/jquery-3.6.0.min.js" integrity="sha256-/xUj+3OJU5yExlq6GSYGSHk7tPXikynS7ogEvDej/m4=" crossorigin="anonymous"></script>
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css"/>


                <!-- Including custome JS & CSS code -->
                <script type="text/javascript" src="js/xml-tables.js" crossorigin="anonymous"></script>
                <link rel="stylesheet" href="css/xml-tables.css" crossorigin="anonymous"/>
            </head>
            <body>

                <!-- Setting up the navigation bar [Bootstrap template]-->
                <div id="navigation-bar" class="fixed-top">
                    <nav class="nav navbar navbar-light bg-info">
                        <div class="container-fluid">
                            <a class="navbar-brand ms-3">XML Tables</a>
                            <form class="d-flex">
                                <div class="input-group">
                                    <div class="input-group-text" id="search-input-icon">
                                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-search" viewBox="0 0 16 16">
                                            <path d="M11.742 10.344a6.5 6.5 0 1 0-1.397 1.398h-.001c.03.04.062.078.098.115l3.85 3.85a1 1 0 0 0 1.415-1.414l-3.85-3.85a1.007 1.007 0 0 0-.115-.1zM12 6.5a5.5 5.5 0 1 1-11 0 5.5 5.5 0 0 1 11 0z"/>
                                        </svg>
                                    </div>
                                    <input id="search-input" class="form-control me-2" type="search" placeholder="Search"/>
                                </div>
                                <button id="btn-export-json" class="btn btn-success ms-auto me-2 text-nowrap">Export to JSON</button>
                                <button id="btn-export-csv" class="btn btn-success ms-auto me-2 text-nowrap">Export to CSV</button>
                            </form>
                        </div>
                    </nav>
                </div>


                <div id="xml-table-container" class=" table-responsive container my-5 ">

                    <table id="xml-table" class="table table-sm table-hover">
                        <thead class="table-dark">
                            <tr>
                                <th>Parent UID</th>
                                <th>Object UID</th>
                                <th>Node Type</th>
                                <th>Node Name</th>
                                <th>Node Value</th>
                                <th>Node Path</th>
                            </tr>
                        </thead>
                        <tbody>

                            <xsl:call-template name="generate-row"/>

                        </tbody>
                    </table>

                </div>

            </body>
        </html>
    </xsl:template>




    <xsl:template name="generate-row" match="@*|node()" mode="build-table">

        <!-- Load Column variables -->
        <xsl:variable name="parent-uid">
            <xsl:value-of select ="generate-id(parent::node())"/>
        </xsl:variable>
        <xsl:variable name="object-uid">
            <xsl:value-of select ="generate-id()"/>
        </xsl:variable>
        <xsl:variable name="get-node-type">
            <xsl:call-template name="node-type"/>
        </xsl:variable>
        <xsl:variable name="get-node-name">
            <xsl:call-template name="node-name"/>
        </xsl:variable>
        <xsl:variable name="get-node-value">
            <xsl:call-template name="node-value"/>
        </xsl:variable>
        <xsl:variable name="get-node-path">
            <xsl:call-template name="node-path"/>
        </xsl:variable>

        <!-- Populate HTML table with a single row -->

        <tr>
            <td class="parent-uid">
                <a href="#{$parent-uid}">
                    <xsl:value-of select ="$parent-uid"/>
                </a>
            </td>
            <td class="object-uid">
                <xsl:value-of select ="$object-uid"/>
            </td>
            <td class="node-type text-end">
                <div class="node-type-badge ">
                    <xsl:value-of select ="$get-node-type"/>
                </div>
            </td>
            <td class="node-name">
                <xsl:value-of select ="$get-node-name"/>
            </td>
            <td class="node-value">
                <xsl:value-of select ="$get-node-value"/>
            </td>
            <td class="node-path">
                <xsl:value-of select ="$get-node-path"/>
            </td>
        </tr>

        <!-- Recursive call to the child nodes with same template -->
        <xsl:apply-templates select="@*|node()" mode="build-table"/>

    </xsl:template>

    <!-- Load the Node Name Column -->
    <xsl:template name="node-name">
        <xsl:choose>
            <xsl:when test="count(.|/)=1">
                #root
            </xsl:when>
            <xsl:when test="self::*">
                <xsl:value-of select ="name()"/>
            </xsl:when>
            <xsl:when test="self::text()">
                #text
            </xsl:when>
            <xsl:when test="self::comment()">
                #comment
            </xsl:when>
            <xsl:when test="self::processing-instruction()">
                <xsl:value-of select ="name()"/>
            </xsl:when>
            <xsl:when test="count(.|../@*)=count(../@*)">
                <xsl:value-of select ="name()"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <!-- Load the Node Type Column -->
    <xsl:template name="node-type">
        <xsl:choose>
            <xsl:when test="count(.|/)=1">
                <xsl:text>Root</xsl:text>
            </xsl:when>
            <xsl:when test="self::*">
                <xsl:text>Element</xsl:text>
                <xsl:if test="substring-before(name(),':')">
                    <xsl:text>:Composite</xsl:text>
                </xsl:if>
            </xsl:when>
            <xsl:when test="self::text()">
                <xsl:text>Text</xsl:text>
            </xsl:when>
            <xsl:when test="self::comment()">
                <xsl:text>Comment</xsl:text>
            </xsl:when>
            <xsl:when test="self::processing-instruction()">
                <xsl:text>Processing Instruction</xsl:text>
            </xsl:when>
            <xsl:when test="count(.|../@*)=count(../@*)">
                <xsl:text>Attribute</xsl:text>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <!-- Load the Node Value Column -->
    <xsl:template name="node-value">
        <xsl:choose>
            <xsl:when test="count(.|/)=1">
                <!-- Root Element -->
                #root
            </xsl:when>
            <xsl:when test="self::*">
                <!-- Element Node -->
                #element
            </xsl:when>
            <xsl:when test="self::text()">
                <!-- Text Node -->
                <xsl:value-of select="." />
            </xsl:when>
            <xsl:when test="self::comment()">
                <!-- Comment Node -->
                <xsl:value-of select="." />
            </xsl:when>
            <xsl:when test="self::processing-instruction()">
                <!-- Processing Instruction Node -->
                <xsl:value-of select="." />
            </xsl:when>
            <xsl:when test="count(.|../@*)=count(../@*)">
                <!-- Attribute Node -->
                <xsl:value-of select="." />
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <!-- Load the Node Path Column -->
    <xsl:template name="node-path">
        <xsl:choose>
            <xsl:when test="count(.|/)=1">
                <!-- Root Element -->
                #root
            </xsl:when>
            <xsl:when test="self::*">
                <!-- Element Node -->
                <xsl:call-template name="build-xpath"/>
            </xsl:when>
            <xsl:when test="self::text()">
                <!-- Text Node -->
                <xsl:call-template name="build-xpath"/>
            </xsl:when>
            <xsl:when test="self::comment()">
                <!-- Comment Node -->
                #comment
            </xsl:when>
            <xsl:when test="self::processing-instruction()">
                <!-- Processing Instruction Node -->
                #processing-instruction
            </xsl:when>
            <xsl:when test="count(.|../@*)=count(../@*)">
                <!-- Attribute Node -->
                <xsl:call-template name="build-xpath"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <!-- Build Xpath -->
    <xsl:variable name="vApos">'</xsl:variable>

    <xsl:template name="build-xpath">

        <xsl:if test="self::*">
            <xsl:apply-templates select="ancestor-or-self::*" mode="path"/>
        </xsl:if>

        <xsl:if test="self::text()">
            <xsl:apply-templates select="ancestor-or-self::*" mode="path"/>
            <xsl:value-of select="concat('=',$vApos,.,$vApos)"/>
            <xsl:text>&#xA;</xsl:text>
        </xsl:if>

        <xsl:if test="count(.|../@*)=count(../@*)">
            <xsl:apply-templates select="../ancestor-or-self::*" mode="path"/>
            <xsl:value-of select="concat('[@',name(), '=',$vApos,.,$vApos,']')"/>
            <xsl:text>&#xA;</xsl:text>
        </xsl:if>
    </xsl:template>

    <xsl:template match="*" mode="path">
        <xsl:value-of select="concat('/',name())"/>
        <xsl:variable name="vnumPrecSiblings" select="count(preceding-sibling::*[name()=name(current())])"/>
        <xsl:if test="$vnumPrecSiblings">
            <xsl:value-of select="concat('[', $vnumPrecSiblings +1, ']')"/>
        </xsl:if>
    </xsl:template>



</xsl:stylesheet>