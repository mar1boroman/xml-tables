# XML Tables Usage

## Firefox Users

XML Tables is a stylesheet mixed with bootstrap and a bit of vanilla js, which can be added to any XML document to turn it into a queryable dataset.
For Firefox users, this is as simple as adding a `<style/>` tag to the XML document and opening the file in Firefox browser.

Firefox, unlike other browsers, allows the local XML document on your desktop to use XML stylesheet hosted here or even on your local desktop

### Step 1 : Add this stylesheet tag to your XML document
```
    <?xml-stylesheet type = "text/xsl" href = "https://cdn.jsdelivr.net/gh/mar1boroman/xml-tables@latest/xsl/xml-tables.xsl"?>
```

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
```
    java
    -jar <Saxon-Jar-Location>/saxon-he-10.5.jar
    -s:MyFile.XML -xsl:"https://cdn.jsdelivr.net/gh/mar1boroman/xml-tables@latest/xsl/xml-tables.xsl"
    -o:MyOutput.html
```
Open the generated `MyOutput.html` file in any browser available to you.

