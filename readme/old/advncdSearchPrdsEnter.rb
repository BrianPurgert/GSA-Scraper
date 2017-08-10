


base_url    = "https://www.gsaadvantage.gov/"
search      = "advantage/s/search.do?"
def search_any(any_product_field)
  "q=0:1#{any_product_field}"
end

def socio_economic()

end

c="&q=19:1#{contract_number}"
c="&q=23:1#{category_name}"
c="&q=24:1#{contractor}"

m="&q=9,8:1#{manufacture_part_number}"
m="&q=10:1#{manufacturer}"

p="&q=11,12:0#{product_name_description}"
p="&q=11:1#{product_name}"



def sin_search(sin)
  "&q=20:1#{sin}"
end
# a="&q=0:2#{any_product_field}"

puts search_any 'apples'

#== Products  advncdSearchPrdsEnter.do

value = ''


value="0"# all_the_words
value="1"# the_exact_phrase
value="2"# any_the_words
value="3"# none_of_the_words

value=text

value="0"    any_product_field
value="9,8"  nsn_or_mfr_part_number
value="10"    #manufacturer
value="11"    #product_name
value="11,12" #product_name_or_description
value="19"    #contract_number
value="20"    #special_item_number
value="23"    #category_name
value="24"    #contractor
value="27"    #vendor_pn
advRecordNames.matchByCriteriaNamesIndexed[0]	select	2

advRecordNames.typedCriteriaInputNamesIndexed[0]	text			25	80



advRecordNames.fieldTypeCriteriaNamesIndexed[0]	select	0

cat	select
sortBy	select	0
itemsPerPage	select	25
minOrderAmount	select
moreThanPrice	text			8
lessThanPrice	text			8
photo	checkbox	5:5PHOTO
fobShipping	checkbox	34:5DE

'q=3:5BQ'
'q=3:5AQ'
'q=3:5BR'

'q=3:5BI,BJ,BK'
'q=3:5JJ'
'q=3:5AC'
'q=3:5FP'
'q=3:5BZ'
'q=3:5BH'
'q=3:5HZ'
'q=3:5BE'
'q=3:5AE'
'q=3:5EP'
'q=3:5AN'
'q=3:5AM'
'q=3:5AT'
'q=3:5SF'
'q=3:5BU'



limitBy	checkbox	q=5:5GGS
limitBy	checkbox	q=5:5VA
limitBy	checkbox	q=5:5JWOD
limitBy	checkbox	q=5:5UNICOR
limitBy	checkbox	q=5:5BPA
limitBy	checkbox	q=5:5JANSAN
limitBy	checkbox	q=5:5MRO

limitBy	checkbox	q=5:5OS3




# == Services == advAdvancedSearchServicesForm

advRecordNames.matchByCriteriaNamesIndexed[0]	select	2
advRecordNames.typedCriteriaInputNamesIndexed[0]	text			25	80
advRecordNames.fieldTypeCriteriaNamesIndexed[0]	select	0

cat	select
sortBy	select	0
itemsPerPage	select	25




# Products and Services
limitBy	checkbox	q=2:5s
limitBy	checkbox	q=2:5dv
limitBy	checkbox	q=2:5v
limitBy	checkbox	q=2:5w
limitBy	checkbox	q=2:5wo
limitBy	checkbox	q=2:5ew
limitBy	checkbox	q=2:5d
limitBy	checkbox	q=2:5h
limitBy	checkbox	q=2:58a

'q=3:5YY'
'q=3:5ZZ'
