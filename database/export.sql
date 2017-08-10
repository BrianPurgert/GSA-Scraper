USE schedule70;
SELECT "Contractor_Name","Contractor_Details_URL","Contract_Number","Phone","Contractor_TC_Price_List","View_Catalog","State_Local","Small_Business","Other_Than_Small_Business","Women_Owned_Small_Business","Economically_Disadvantaged_Women_Owned_Small_Business","Woman_Owned_Business","Service_Disabled_Veteran_Owned_Small_Business","Veteran_Owned_Small_Business","SBA_Certified_Small_Disadvantaged_Business","SBA_Certified_8a_Firm","SBA_Certified_HUBZone_Firm","State","City"
UNION ALL
SELECT Contractor_Name,Contractor_Details_URL,Contract_Number,Phone,Contractor_TC_Price_List,View_Catalog,State_Local,Small_Business,Other_Than_Small_Business,Women_Owned_Small_Business,Economically_Disadvantaged_Women_Owned_Small_Business,Woman_Owned_Business,Service_Disabled_Veteran_Owned_Small_Business,Veteran_Owned_Small_Business,SBA_Certified_Small_Disadvantaged_Business,SBA_Certified_8a_Firm,SBA_Certified_HUBZone_Firm,State,City
FROM data WHERE State_Local = 1 INTO OUTFILE '/tmp/data.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';
