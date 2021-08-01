<?xml version = "1.0" encoding = "UTF-8"?>
<xsl:stylesheet version = "1.0"
   xmlns:xsl = "http://www.w3.org/1999/XSL/Transform">
    <xsl:template match = "/">
        <html lang="en">
            <head>
                <title>Analyze XML</title>
                <meta charset="utf-8"/>
                <meta name="viewport" content="width=device-width, initial-scale=1"/>
                <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous"/>
                <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
                <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"></script>
                <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>
                <script src="https://raw.githubusercontent.com/mar1boroman/mar1boroman.github.io/main/exportCSV.js"></script>
                <script>
                    $(document).ready(function () {
                    $("#searchItem").on("keyup", function () {
                        enableSearch($(this), "XMLTable");
                    });

                    $("#exportBtn").click(function () {
                        exportHTMLTableToCSV();
                    });
                    });
                </script>
            </head>

            <body style="padding:50px">

                <!-- Setting up the export button -->

                <!-- <button type="button" class="btn btn-primary" style="position: fixed; bottom: 25px; right: 50px">Export as CSV</button> -->


                <!-- Setting up the navbar. Pure Bootstrap & HTML -->
                <nav class="navbar navbar-light bg-light fixed-top">

                    <!-- Setting up the pages -->
                    <ul class="nav">
                        <li>
                            <a class="navbar-brand">XML Table</a>
                        </li>
                        <li class="nav-item">
                            <a data-toggle="tab" class="nav-link active" aria-current="page" href="#Home">Home</a>
                        </li>
                        <li class="nav-item">
                            <a data-toggle="tab" class="nav-link" href="#About">About</a>
                        </li>

                    </ul>

                    <!-- Setting up the export button and search-->
                    <button id="exportBtn" class="btn btn-outline-success ml-auto mr-sm-2">Export as CSV</button>

                    <form class="form-inline my-2 my-lg-0">
                        <input class="form-control mr-sm-2" id="searchItem" type="search" placeholder="Search" aria-label="Search"/>
                    </form>
                </nav>


                <!-- About page. Pure Bootstrap & HTML -->
                <div class="tab-content">
                    <div id="About" class="tab-pane" role="tabpanel">
                        <div class="jumbotron">
                            <h1>XML Table</h1>
                            <p>
                                Your XML document has been formatted into 5 Columns
                            </p>
                            <ul>
                                <li>Parent UID : This Column links back to the Parent Object's Unique ID for a given row</li>
                                <li>Generated UID : This Column represents the selected row's Unique ID</li>
                                <li>Parent Name : This Column links back to the Parent Object's Name for a given row</li>
                                <li>Object Name : Node's name or Attribute's name for a given node</li>
                                <li>Object Value : Node's value or Attribute's value for a given node</li>
                                <li>XPATH : The XPATH to current element</li>
                            </ul>
                            <h4>Search Functionality</h4>
                            <p>
                                The Search box will perform a case-insensitive search on the XML Table.
                                You can also use the UID columns for a specific search
                            </p>
                        </div>
                        <p class="text-center">
                        Made with ♥️
                        Contribute to this <a class="text-reset" href="#">project</a>
                        </p>
                    </div>


                    <!-- Table header and invoke recursive template using XSLT apply-templates -->
                    <div id="Home" class="tab-pane active" role="tabpanel">

                        <div class="table-responsive">
                            <table id="XMLTable" class="table table-condensed table-hover">
                                <thead class="thead-dark">
                                    <tr>
                                        <th>Parent UID</th>
                                        <th>Generated UID</th>
                                        <th>Parent Name</th>
                                        <th>Object Name</th>
                                        <th>Object Value</th>
                                        <th>XPATH</th>
                                    </tr>
                                </thead>
                                <tbody id="XMLTable">
                                    <xsl:apply-templates select="*"/>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="*">

        <!-- Select all the attributes for the selected element -->

        <xsl:for-each select="@*">
            <tr>
                <td style="word-wrap: break-word;min-width: 160px;max-width: 160px;">
                    <a href="#{generate-id(parent::node())}">
                        <xsl:value-of select="generate-id(parent::node())"/>
                    </a>
                </td>
                <td style="word-wrap: break-word;min-width: 160px;max-width: 160px;">
                    <a name="{generate-id(current())}">
                        <xsl:value-of select="generate-id(current())"/>
                    </a>
                </td>
                <td style="word-wrap: break-word;min-width: 160px;max-width: 160px;">
                    <xsl:value-of select="name(parent::node())"/>
                </td>
                <td style="word-wrap: break-word;min-width: 160px;max-width: 160px;">
                    <span class="badge badge-pill badge-primary mr-sm-2">Attribute</span>
                    <xsl:value-of select="name()"/>
                </td>
                <td style="word-wrap: break-word;min-width: 160px;max-width: 160px;">
                    <xsl:value-of select="."/>
                </td>
                <td style="word-wrap: break-word;min-width: 160px;max-width: 160px;">
                    <xsl:for-each select="ancestor::*">
                        <xsl:value-of select="concat(name(),'/')"/>
                    </xsl:for-each>@                    <xsl:value-of select="name()"/>
                </td>
            </tr>
        </xsl:for-each>

        <!-- Select the actual element and display the content -->

        <xsl:for-each select="*">
            <tr>
                <td style="word-wrap: break-word;min-width: 160px;max-width: 160px;">
                    <a href="#{generate-id(parent::node())}">
                        <xsl:value-of select="generate-id(parent::node())"/>
                    </a>
                </td>
                <td style="word-wrap: break-word;min-width: 160px;max-width: 160px;">
                    <a name="{generate-id(current())}">
                        <xsl:value-of select="generate-id(current())"/>
                    </a>
                </td>
                <td style="word-wrap: break-word;min-width: 160px;max-width: 160px;">
                    <xsl:value-of select="name(parent::node())"/>
                </td>
                <td style="word-wrap: break-word;min-width: 160px;max-width: 160px;">
                    <span class="badge badge-pill badge-success mr-sm-2">Element</span>
                    <xsl:value-of select="name()"/>
                </td>
                <td style="word-wrap: break-word;min-width: 160px;max-width: 160px;">
                    <xsl:value-of select="."/>
                </td>
                <td style="word-wrap: break-word;min-width: 160px;max-width: 160px;">
                    <xsl:for-each select="ancestor::*">
                        <xsl:value-of select="concat(name(),'/')"/>
                    </xsl:for-each>
                    <xsl:value-of select="name()"/>
                </td>
            </tr>
        </xsl:for-each>


        <xsl:apply-templates select="*"/>

    </xsl:template>

</xsl:stylesheet>
