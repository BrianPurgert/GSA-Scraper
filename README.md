GSA Advantage Scraper
===========



## Overview

## Purpose



|      |      |      |      |
| ---- | ---- | ---- | ---- |
|      |      |      |      |
|      |      |      |      |
|      |      |      |      |
|      |      |      |      |
|      |      |      |      |
|      |      |      |      |
|      |      |      |      |


# Links
## Directly Related
 | [Jenkins](hudson.govconsvcs.com:8080)



## Because Im using this file for my book marks

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

