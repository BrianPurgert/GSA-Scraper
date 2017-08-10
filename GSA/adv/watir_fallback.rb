def test_mfr_list(gsa_a)
  gsa_a.mft_table_element.links.each do |link|
    href_mfr = REGEX_QUERY.match(link.href)
    # link.flash
    link.flash
    name_mfr = link.text
    e_products = link.parent.following_sibling
    e_products.flash
    n_products = e_products.text
    n_products = n_products.delete('()')
    @queue << [name_mfr,href_mfr,n_products]
  end
end