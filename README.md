# XML Tables Usage

## About the project

XML Tables is aimed at converting any XML file on your desktop into a Single Page Application, by just adding a single style tag to your XML file.
Internally the XML file uses

* XSLT to convert your XML file into a HTML table
* Bootstrap to add styling to HTML elements
* Javascript
  * Add Searchability using JQuery
  * Add Export Options using JQuery
  * Visualizations
    * 2D Visualization - [D3 Library](https://d3js.org)
    * 3D Visualization - [vasturiano's 3d-force-graph library](https://github.com/vasturiano/3d-force-graph)

The goal of this project is to help data engineers and data scientist to quickly analyze local XML files without the need to install any additional software (if you have Firefox browser, else you would need to download [Saxon-HE](https://www.saxonica.com/html/products/products.html)

Read more and see a demo at [XML Tables](https://mar1boroman.github.io)

## Firefox Users

For Firefox users, this is as simple as adding a `<style/>` tag to the XML document and opening the file in Firefox browser.

Firefox, unlike other browsers, allows the local XML document on your desktop to use XML stylesheet hosted here or even on your local desktop

### One Step Only : Add this stylesheet tag to your XML document

`<?xml-stylesheet type = "text/xsl" href = "https://cdn.jsdelivr.net/gh/mar1boroman/xml-tables@latest/xsl/xml-tables.xsl"?>`

This tag is added after the XML version declaration

`<?xml version="1.0"?>`

Here is an [example](https://raw.githubusercontent.com/mar1boroman/mar1boroman.github.io/main/books.xml)

## Other browsers

Unfortunately, other browsers **do not** allow the XSL stylesheet to be applied to a XML document on your local desktop
(due to various reasons, including but not limited to CORS)

Hence, we transform the XML first & then open the html table generated in any browser.

### Step 1 : Download [Saxon-HE](https://www.saxonica.com/html/products/products.html)

This is a great free open source jar which allows you to perform basic XSLT transformations on your local machine through command line.

[SourceForge](https://sourceforge.net/projects/saxon/files/) download link
(Please refer the [Saxonica](https://www.saxonica.com/html/products/products.html) home page for latest release)

On Linux systems, you can achieve this using`xsltproc`

**Copy saxon-he-_version_.jar file to a suitable location**

### Step 2 : Transform your XML document into HTML

Open the command prompt (Windows) or Terminal(Mac) and use the below command

```bash
java
-jar <Saxon-Jar-Location>/saxon-he-10.5.jar
-s:MyFile.XML -xsl:"https://cdn.jsdelivr.net/gh/mar1boroman/xml-tables@latest/xsl/xml-tables.xsl"
-o:MyOutput.html
```

Open the generated `MyOutput.html` file in any browser available to you.

## Notes

3D Visualization is memory intensive, if your data is large, consider forking the repository & modifying the JS file according to your need.
More info on modifying / using 3D visualization can be found at [vasturiano's 3d-force-graph library](https://github.com/vasturiano/3d-force-graph)

If you found this repo useful, consider leaving a star.