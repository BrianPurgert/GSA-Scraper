myTable td
endpoint_base = 'http://www.gsaelibrary.gsa.gov/ElibMain/sinDetails.do?executeQuery=YES&scheduleNumber=70&flag=&filter=&specialItemNumber='
# https://www.gsaelibrary.gsa.gov/ElibMain/contractorInfo.do?contractNumber=GS-30F-0013T&contractorName=E-ONE%2C+INC.&executeQuery=YES
# https://www.gsaadvantage.gov/ref_text/GS30F0013T/GS30F0013T_online.htm
# https://www.gsaelibrary.gsa.gov/ElibMain/contractorInfo.do?contractNumber=GS-30F-0005R&contractorName=EMERGENCY+VEHICLES%2C+INC.&executeQuery=YES
# https://www.gsaadvantage.gov/ref_text/GS30F0005R/GS30F0005R_online.htm
# https://www.gsaelibrary.gsa.gov/ElibMain/contractorInfo.do?contractNumber=GS-30F-0001N&contractorName=FERRARA+FIRE+APPARATUS%2C+INC.%2C&executeQuery=YES
# https://www.gsaelibrary.gsa.gov/ElibMain/contractorInfo.do?contractNumber=GS-30F-0028U&contractorName=FIREMATIC+SUPPLY+CO.%2C+INC.&executeQuery=YES
# https://www.gsaadvantage.gov/ref_text/GS30F0028U/GS30F0028U_online.htm
# https://www.gsaelibrary.gsa.gov/ElibMain/contractorInfo.do?contractNumber=GS-30F-0002V&contractorName=GERLING+AND+ASSOCIATES%2C+INC.&executeQuery=YES
# s	https://www.gsaelibrary.gsa.gov/ElibMain/BIAction.do
# https://www.gsaadvantage.gov/ref_text/GS30F0002V/GS30F0002V_online.htm

# DB.create_table?(:ICOLORS) do
# 	column :CONTNUM      ,String,           size: 12               ,null: false
#
#
# 	column :MFGPART      ,String,           size: 40               ,null: false
# 	scheduleNumber
# 	column :SCHEDCAT     ,String,           size: 10
# 	column :VENDNAME     ,String,           size: 35
# 	column :GSIN          ,String,           size: 15              ,null: false
#
# 	column :MFGNAME      ,String,           size: 40               ,null: false
# 	column :SCHEDCAT     ,String,           size: 10
# 	column :VENDNAME     ,String,           size: 35
# 	column :SIN          ,String,           size: 15              ,null: false
# end