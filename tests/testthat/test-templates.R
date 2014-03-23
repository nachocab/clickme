context("Installed templates")

for(template in plain_list_templates()){
    test_template(template)
}
