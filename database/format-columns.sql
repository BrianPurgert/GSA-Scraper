-- ********************
-- Script to create / format columns for GSA eLibrary data.
-- ********************

USE schedule70;

-- Change State_Local_Auth to a Boolean.
ALTER TABLE data add State_Local BOOLEAN;
UPDATE data SET State_Local = 0;
UPDATE data SET State_Local = 1 WHERE State_Local_Auth IS NOT NULL;

-- Clearn up value in Category column
UPDATE data SET Category = REPLACE(Category,'+',' ');

-- Break out socio-economic indicator classification into separate columns.
ALTER TABLE data add Small_Business BOOLEAN;
UPDATE data SET Small_Business = 0;
UPDATE data SET Small_Business = 1 WHERE LOCATE('s', Socio_Economic_Indicators) > 0;

ALTER TABLE data add Other_Than_Small_Business BOOLEAN;
UPDATE data SET Other_Than_Small_Business = 0;
UPDATE data SET Other_Than_Small_Business = 1 WHERE LOCATE('o', Socio_Economic_Indicators) > 0;

ALTER TABLE data add  Women_Owned_Small_Business BOOLEAN;
UPDATE data SET Women_Owned_Small_Business = 0;
UPDATE data SET Women_Owned_Small_Business = 1 WHERE LOCATE('wo', Socio_Economic_Indicators) > 0;

ALTER TABLE data add Economically_Disadvantaged_Women_Owned_Small_Business BOOLEAN;
UPDATE data SET Economically_Disadvantaged_Women_Owned_Small_Business = 0;
UPDATE data SET Economically_Disadvantaged_Women_Owned_Small_Business = 1 WHERE LOCATE('ew', Socio_Economic_Indicators) > 0;

ALTER TABLE data add Woman_Owned_Business BOOLEAN;
UPDATE data SET Woman_Owned_Business = 0;
UPDATE data SET Woman_Owned_Business = 1 WHERE Women_Owned_Small_Business = 1 OR Economically_Disadvantaged_Women_Owned_Small_Business = 1;

ALTER TABLE data add Service_Disabled_Veteran_Owned_Small_Business BOOLEAN;
UPDATE data SET Service_Disabled_Veteran_Owned_Small_Business = 0;
UPDATE data SET Service_Disabled_Veteran_Owned_Small_Business = 1 WHERE LOCATE('dv', Socio_Economic_Indicators) > 0;

ALTER TABLE data add Veteran_Owned_Small_Business BOOLEAN;
UPDATE data SET Veteran_Owned_Small_Business = 0;
UPDATE data SET Veteran_Owned_Small_Business = 1 WHERE Socio_Economic_Indicators LIKE '%v' OR Socio_Economic_Indicators LIKE '%v/%';

ALTER TABLE data add SBA_Certified_Small_Disadvantaged_Business BOOLEAN;
UPDATE data SET SBA_Certified_Small_Disadvantaged_Business = 0;
UPDATE data SET SBA_Certified_Small_Disadvantaged_Business = 1 WHERE Socio_Economic_Indicators LIKE '%d' OR Socio_Economic_Indicators LIKE '%d/%';

ALTER TABLE data add SBA_Certified_8a_Firm BOOLEAN;
UPDATE data SET SBA_Certified_8a_Firm = 0;
UPDATE data SET SBA_Certified_8a_Firm = 1 WHERE LOCATE('8a', Socio_Economic_Indicators) > 0;

ALTER TABLE data add SBA_Certified_HUBZone_Firm BOOLEAN;
UPDATE data SET SBA_Certified_HUBZone_Firm = 0;
UPDATE data SET SBA_Certified_HUBZone_Firm = 1 WHERE LOCATE('h', Socio_Economic_Indicators) > 0;

-- Add base URL to fields with URL fragments.
ALTER TABLE data MODIFY Contractor_Details_URL VARCHAR(250);
UPDATE data SET Contractor_Details_URL = CONCAT('http://www.gsaelibrary.gsa.gov/ElibMain/', Contractor_Details_URL);

ALTER TABLE data MODIFY View_Catalog VARCHAR(110);
UPDATE data SET View_Catalog = CONCAT('http://www.gsaelibrary.gsa.gov/ElibMain/', View_Catalog);

-- Break out state and city into separate columns.
ALTER TABLE data ADD State CHAR(2);
UPDATE data SET State = SUBSTRING(Location, LOCATE(',', Location)+1, 2);

ALTER TABLE data ADD City VARCHAR(60);
UPDATE data SET City = SUBSTRING(Location, 1, LOCATE(',', Location)-2);

-- Clean up superfluous columns.
ALTER TABLE data DROP COLUMN State_Local_Auth;
ALTER TABLE data DROP COLUMN Location;
ALTER TABLE data DROP COLUMN Socio_Economic_Indicators;

-- Add primary key and indexes.
ALTER TABLE data ADD PRIMARY KEY (Category,Contract_Number);
ALTER TABLE data ADD INDEX (State);
ALTER TABLE data ADD INDEX (City);
