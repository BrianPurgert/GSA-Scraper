Issue #20 Validate Data per URL
----


- [x] @mentions, #refs, [links](), **formatting**, and <del>tags</del> supported
- [x] list syntax required (any unordered or ordered list supported)
- [x] this is a complete item
- [ ] this is an incomplete item


I believe this should be done before be I start work on the UI. The scraper is setup to perform searches on smaller manufactures to bigger manufactures, which results in the manufactures like the ones below being searched last. So I just  how important the data validation is to us. The larger Manufactures are likely to run into a problems. right now the script grabs a list of mfrs and checks them out and assumes that the search will go without problems.

Im still researching this so I'll update this as Im sure on a good solution. [Scrape Amazon](https://blog.hartleybrody.com/scrape-amazon/) has some good strategies
_____
## Task
- [ ] change check_out to status_id with code
- [ ] add last_low_price, which is the lowest priced product the seen for that manufacture


mfr
---
```sql
SELECT * FROM `mft_data`.`mfr` ORDER BY `item_count` DESC LIMIT 1000
```
| name | href_name | last_updated | last_search | item_count | change | ~~check_out~~ status_id | last_low_price |
| --- | --- | --- | --- | ---: | ---: | ---: | ---: |
| YAMAHA | YAMAHA | 2017-05-19 19:39:43 | 2017-05-19 19:39:43 | 320819 | 0 | 0 |
| 3M | 3M | 2017-05-19 20:20:37 | 2017-05-19 20:20:37 | 192811 | 0 | 1 |
| BRADY | BRADY | 2017-05-19 20:20:23 | 2017-05-19 20:20:23 | 128404 | 0 | 1 |
| JOHNSON CONTROLS | JOHNSON+CONTROLS | 2017-05-20 21:57:40 | 2017-05-20 21:57:40 | 62641 | 0 | 1 |
| OSG | OSG | 2017-05-19 20:22:43 | 2017-05-19 20:22:43 | 58565 | 0 | 1 |
| JOHN WILEY & SONS INC | JOHN+WILEY+%26+SONS+INC | 2017-05-20 21:57:39 | 2017-05-20 21:57:39 | 49811 | 0 | 1 |
| DELL | DELL | 2017-05-20 02:29:49 | 2017-05-20 02:29:49 | 44068 | 0 | 1 |
| PRATT LAMBERT | PRATT+LAMBERT | 2017-05-19 19:57:53 | 2017-05-19 19:57:53 | 42919 | 0 | 1 |
| USP | USP | 2017-05-20 03:36:45 | 2017-05-20 03:36:45 | 36896 | 0 | 1 |
| DELL MARKETING | DELL+MARKETING | 2017-05-20 02:29:52 | 2017-05-20 02:29:52 | 36008 | 0 | 1 |
| DELL, INC. | DELL%2C+INC. | 2017-05-20 02:29:53 | 2017-05-20 02:29:53 | 35800 | 0 | 1 |
| HP | HP | 2017-05-20 21:56:22 | 2017-05-20 21:56:22 | 34215 | 0 | 1 |
| BRADY SPC ABSORBENTS | BRADY+SPC+ABSORBENTS | 2017-05-19 20:20:30 | 2017-05-19 20:20:30 | 33328 | 0 | 1 |
| VERMONT GAGE | VERMONT+GAGE | 2017-05-20 03:31:19 | 2017-05-20 03:31:19 | 32832 | 0 | 1 |
| GRAINGER | GRAINGER | 2017-05-20 03:34:47 | 2017-05-20 03:34:47 | 31180 | 0 | 1 |
| HEWLETT PACKARD ENTERPRISE | HEWLETT+PACKARD+ENTERPRISE | 2017-05-20 21:54:42 | 2017-05-20 21:54:42 | 25888 | 0 | 1 |
| MSC | MSC | 2017-05-19 17:02:35 | 2017-05-19 17:02:35 | 25749 | 0 | 1 |
| YORK SOURCE 1 | YORK+SOURCE+1 | 2017-05-19 19:28:40 | 2017-05-19 19:28:40 | 22053 | 0 | 1 |
| JSI | JSI | 2017-05-20 21:58:45 | 2017-05-20 21:58:45 | 21613 | 0 | 1 |
| XPLORE TECHNOLOGIES | XPLORE+TECHNOLOGIES | 2017-05-19 19:28:33 | 2017-05-19 19:28:33 | 21246 | 0 | 1 |
| OLYMPUS AMERICA INC | OLYMPUS+AMERICA+INC | 2017-05-19 20:16:41 | 2017-05-19 20:16:41 | 20502 | 0 | 1 |
| JS PRODUCTS, INC | JS+PRODUCTS%2C+INC | 2017-05-20 21:58:45 | 2017-05-20 21:58:45 | 20295 | 0 | 1 |

mfr_parts
---
```sql
SELECT  `mfr`,  `mpn`,  `name`,  `href_name`,  `low_price`,  LEFT(`desc`, 256),  `last_updated`,  `status_id`,  `sources` FROM `mft_data`.`mfr_parts` ORDER BY `last_updated` DESC LIMIT 1000
```
| mfr | mpn | name | href_name | low_price | desc | last_updated | status_id | sources |
| --- | --- | --- | --- | --- | --- | --- | ---: | ---: |
| RUBBERMAID COMMERICAL PRODUCTS | RCPD25100WH | MOP,SUPER STITCH,BLE,WE | /advantage/catalog/product_detail.do?gsin=11000011317548 | 5.77 | MOP,SUPER STITCH,BLE,WE. Over weight and over size items are subject to additional shipping cost, Please contact us for a freight quote. Over weight and over size items are subject... | 2017-05-30 16:40:43 | 0 | 15 |
| RUBBERMAID COMMERICAL PRODUCTS | RCPD25106BE | MOP,SUPER STITCH, BLEN,BE | /advantage/catalog/product_detail.do?gsin=11000011317550 | 4.72 | MOP,SUPER STITCH, BLEN,BE. Over weight and over size items are subject to additional shipping cost, Please contact us for a freight quote. Over weight and over size items are subje... | 2017-05-30 16:40:43 | 0 | 15 |
| RUBBERMAID COMMERICAL PRODUCTS | RCP 2886 CLE | SCOOP,UTIL,BOUNCER,64OZ,CLR | /advantage/catalog/product_detail.do?gsin=11000004889450 | 7.92 | SCOOP,UTIL,BOUNCER,64OZ,CLR. Over weight and over size items are subject to additional shipping cost, Please contact us for a freight quote. Over weight and over size items are sub... | 2017-05-30 16:40:43 | 0 | 27 |
| RUBBERMAID COMMERICAL PRODUCTS | RCP9B6000BLA | PAN,DUST,22",BLK | /advantage/catalog/product_detail.do?gsin=11000016352458 | 10.67 | PAN,DUST,22",BLK. Over weight and over size items are subject to additional shipping cost, Please contact us for a freight quote. Over weight and over size items are subject to add... | 2017-05-30 16:40:43 | 0 | 3 |
| TRAFFIC AND PARKING CONTROL, I | 114213 | Bumper Guard 39-3/8 in x 2-7/1 | /advantage/catalog/product_detail.do?gsin=11000039884567 | 123.21 | Bumper Guard Black/Yellow Overall Length 39-3/8 In. Overall Height 2-7/16 In. M ounting Method Self Adhesive Material Polyurethane Foam 114213 TRAFFIC AND PARKING CONTROL, INC. 24P... | 2017-05-30 16:40:43 | 0 | 10 |
| TRAFFIC AND PARKING CONTROL, I | 114214 | Bumper Guard Corner Polyuretha | /advantage/catalog/product_detail.do?gsin=11000039911075 | 400.58 | Bumper Guard Corner Polyurethane Foam Material Height In.) 1-9/16 Black/Yellow Connector Type Self Adhesive 114214 TRAFFIC AND PARKING CONTROL, INC. 24PK38 | 2017-05-30 16:40:43 | 0 | 10 |




  status_code
 1. Started
 2. Finished
 and either add another column to the manufacturer list with the last url scraped for that manufacture or another table with a list of urls crawled. The urls are interchangeable with
