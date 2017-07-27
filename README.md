GSA Scraper
===========


# How vendors imports data into their database: https://vsc.gsa.gov/marketing/advantageOptions.cfm

## Most important information  
The GSA also has a lot of API's 
.do?
trouble accessing data that is on  :
 SAM  - This API accesses vendor/agency through EDI
 GSAAdvantage/eLibrary - accesses product information through EDI
 
 
 FPDS - reported information by other agencies, technically this information could be invalid
....

 

  
  
  
  
  
#  mostly copy/paste information 

 18F is helping Government Agencies open source their data and create API's with them 

The Government has a lot of API's https://labs.data.gov/dashboard/docs

Dev Notes

Full list of Government Repos
http://gsa.github.io/github-federal-stats/


#### Most likely useful 
www.gsa.gov/e-tools
 https://github.com/mheadd/s70-api
https://gsa.gov/portal/content/104555
https://github.com/presidential-innovation-fellows/gsaAdvPseudoApi
https://github.com/GSA/fssi-file-processor
https://github.com/presidential-innovation-fellows/apps-gov-v2 *Ruby one Rails*
https://github.com/presidential-innovation-fellows/epa_uv_index *Ruby, http*
https://github.com/presidential-innovation-fellows/SAM
https://github.com/presidential-innovation-fellows/fbo-parser  ftp://ftp.fbo.gov/

 https://github.com/GSA/catalog-db
 https://github.com/GSA/catalog-deploy
 https://github.com/GSA/api-documentation-template-old


## Data Validation Sources
https://strategicsourcing.gov/about-data-dashboards-and-reports

On GSAAdvantage
---------------
/advantage/catalog
/advantage/catalog/product_detail.do?contractNumber=GS-06F-0052R&itemNumber=70006459310&mfrName=3M
/advantage/catalog/product_detail.do?contractNumber=GS-07F-203AA&itemNumber=MMMMRL38150DD&mfrName=3M%2FC0MMERCLAL+TAPE+DLV.+SPILL+PADS+DIV
/advantage/catalog/product_detail.do?contractNumber=GS-35F-0443T&itemNumber=KSE1840%2F128&mfrName=KINGSTON
/advantage/catalog/product_detail.do?gsin=1100 00009 96553
/advantage/catalog/product_detail.do?gsin=11000 00012 9556
/advantage/catalog/product_detail.do?gsin=11000019481346
/advantage/s/mfr.do?q=1:4*&listFor=#{letter}
/advantage/s/mfr.do?s=4&q=1:4ADV.BUI.301618*&c=100&listFor=A
/advantage/s/mfr.do?s=4&q=1:4ADV.BUI.301618*&c=100&listFor=All
/advantage/s/search.do?db=0&q=23%3A3XDDDDD&searchType=0&s=4
/advantage/s/search.do?q=1:4*&q=28:5#{mfr}
/advantage/s/search.do?q=9,8:1PP454P&s=0&c=1&searchType=0
/advantage/s/search.do?q=9,8:1PP454P&s=0&c=10&searchType=1
/advantage/s/search.do?q=23:3XDDDDD&q=1:4ELIB.SRV.380.*&s=12&c=100&db=1
/advantage/s/search.do?q=28:53M&q=14:7900000000&q=0:2keyWord&s=9&searchType=0&c=100
/advantage/s/vnd.do?q=searchType=2&listFor=B
/advantage/s/search.do?q=28:5ABILITYONE-OUTLOOK-NEBRASKA%2C+INC.&q=14:7900000000&c=100&s=9&p=1

<select name="cat"
<option value="">All Categories</option>
<option value="q=1:4ADV.BUI.*">Building &amp; Industrial</option>
<option value="q=1:4ADV.ELE.*">Electronics &amp; Technology</option>
<option value="q=1:4ADV.FAC.*">Facilities &amp; Supplies</option>
<option value="q=1:4ADV.FUR.*">Furniture &amp; Furnishings</option>
<option value="q=5:5JANSAN">Janitorial and Sanitation Supplies</option>
<option value="q=1:4ADV.LAW.*">Law Enforcement, Fire &amp; Security</option>
<option value="q=5:5MRO">Maintenance, Repair and Operations</option>
<option value="q=1:4ADV.OEQ.*">Office Equipment</option>
<option value="q=1:4ADV.OFF.*">Office Supplies</option>
<option value="q=1:4ADV.FSSI.*">Office Supplies &amp; Equipment FSSI</option>
<option value="q=1:4ADV.SCI.*">Scientific &amp; Medical</option>
<option value="q=1:4ADV.TOO.*">Tools, Paint &amp; Recreational</option>
<option value="q=1:4ADV.VEH.*">Vehicles &amp; Equipment</option>

https://www.gsaelibrary.gsa.gov/ElibMain/contractorList.do?contractorListFor=A


https://github.com/zdavatz/spreadsheet/blob/master/GUIDE.md
Universal Product Codes (UPC) and Manufacturer Part Number (MPN)


 | [Jenkins](hudson.govconsvcs.com:8080)




https://github.com/18F/bpa-fedramp-dashboard/blob/master/Pre-Solicitation-Documents/RFQ_ID09160019.md
https://opendata.stackexchange.com/questions/4164/fedbizopps-raw-data-api


Government OpenSource
https://github.com/GSA
https://github.com/18F/Mario
https://github.com/seanherron/gsa-advantage-scrape
https://github.com/18F/gsa-advantage-scrape
in case you wanted the same thing except separate files and a little more confusing
https://github.com/18F/gsa-advantage-scrape/blob/master/src/gsa_advantage.py
some logic behind scraping could come in handy token_get

Im just going to put these here

GSIN
with a product "GSIN" number you should be able to get information on related products, Im going to paste from here  
http://www.gtin.info/upc/

### GTIN DEFINITION : INFORMATION

![![img](http://www.gtin.info/wp-content/uploads/2013/12/diagram_data_structures1.png)diagram_data_structures](http://www.gtin.info/wp-content/uploads/2013/12/diagram_data_structures1.png)

The Vendor Support center links to this site specifically : http://www.gtin.info/

GTIN describes a family of GS1 (EAN.UCC) global data structures that employ 14 digits and can be encoded into various types of data carriers. Currently, GTIN is used exclusively within bar codes, but it could also be used in other data carriers such as radio frequency identification (RFID). The GTIN is only a term and does not impact any existing standards, nor does it place any additional requirements on scanning hardware. For North American companies, the UPC is an existing form of the GTIN.

The family of data structures (not symbologies) comprising GTIN include:

*   GTIN-12 (UPC-A): this is a 12-digit number used primarily in North America
*   GTIN-8 (EAN/UCC-8): this is an 8-digit number used predominately outside of North America
*   GTIN-13 (EAN/UCC-13): this is a 13-digit number used predominately outside of North America
*   GTIN-14 (EAN/UCC-14 or ITF-14): this is a 14-digit number used to identify trade items at various packaging levels

### The GTIN Family of Data Structures

![GTIN](http://gtin.info/wp-content/uploads/2013/12/diagram_gtin_fam.png)





### Data Structure / Data Storage Examples

GTIN is term referring to how the data is stored, i.e., padding the item number with zeroes to a uniform length. Most scanners in use will already scan any bar code within the GTIN family. The storage of the numbers is the issue being addressed.

![diagram_data_structures](http://www.gtin.info/wp-content/uploads/2013/12/diagram_data_structures1.png)

To view the GTIN Management Standard from GS1, click [here](http://www.gs1.org/sites/default/files/docs/barcodes/GS1_GTIN_Management_Standard.pdf ).

To learn about GS1 and additional barcode/numbering requirements, click [here](http://www.gs1-us.info/). [www.gs1-us.info](http://www.gs1-us.info) is our tutorial website for companies who require UPC numbers. [www.databar-barcode.info](http://www.databar-barcode.info) is our newest educational website covering GS1 Databar.

