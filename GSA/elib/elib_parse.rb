def corporation_info(contractor_doc)
  corp = {}
  corp[:VENDNAME]
  corp[:DIVISION]
  corp[:V_STR1]
  corp[:V_STR2]
  corp[:V_CITY]
  corp[:V_STATE]
  corp[:V_CTRY]
  corp[:V_ZIP]
  corp[:V_PHONE]
  corp[:V_FAX]
  corp[:V_WWW]
  corp[:V_EMAIL]
  corp[:PASSWORD]
  corp[:DUNS_NO]
  corp

end

def contract_info(contractor_doc)
  contract = {}
  contract[:CONTNUM]
  contract[:SCHEDCAT]
  contract[:A_NAME]
  contract[:A_PHONE]
  contract[:A_FAX]
  contract[:C_DELIV]
  contract[:MIN_ORD]
  contract[:PRMPT_DISC]
  contract[:PRMPT_DAYS]
  contract[:PPOINT]
  contract[:PPOINT2]
  contract[:FOB_AK]
  contract[:FOB_HI]
  contract[:FOB_PR]
  contract[:FOB_US]
  contract[:EFF_DATE]
  contract[:WARNUMBER]
  contract[:WARPERIOD]
  contract[:REV_NUM]
  contract[:CAT_MODS]
  contract[:LEADTIME]
  contract[:A_EMAIL]
  contract[:REF_FILE]
  contract
end