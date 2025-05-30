resource "microsoft365wp_device_management_configuration_policy" "typed4" {
  name = "TF  Typed 4 (macOS)"

  platforms    = "macOS"
  technologies = "mdm,appleRemoteManagement"

  settings = [
    { instance = {
      definition_id = "com.apple.tcc.configuration-profile-policy_com.apple.tcc.configuration-profile-policy"
      group_collection = { values = [
        {
          children = [
            {
              definition_id = "com.apple.tcc.configuration-profile-policy_services"
              group_collection = { values = [{
                children = [
                  {
                    definition_id = "com.apple.tcc.configuration-profile-policy_services_accessibility"
                    group_collection = { values = [{
                      children = [
                        {
                          definition_id = "com.apple.tcc.configuration-profile-policy_services_accessibility_item_allowed"
                          choice        = { value = { value = "com.apple.tcc.configuration-profile-policy_services_accessibility_item_allowed_true" } }
                        },
                        {
                          definition_id = "com.apple.tcc.configuration-profile-policy_services_accessibility_item_authorization"
                          choice        = { value = { value = "com.apple.tcc.configuration-profile-policy_services_accessibility_item_authorization_0" } }
                        },
                        {
                          definition_id = "com.apple.tcc.configuration-profile-policy_services_accessibility_item_coderequirement"
                          simple        = { value = { string = { value = "identifier \"com.microsoft.teams\" and anchor apple generic and certificate 1[field.1.2.840.113635.100.6.2.6] /* exists */ and certificate leaf[field.1.2.840.113635.100.6.1.13] /* exists */ and certificate leaf[subject.OU] = UBF8T346G9" } } }
                        },
                        {
                          definition_id = "com.apple.tcc.configuration-profile-policy_services_accessibility_item_identifier"
                          simple        = { value = { string = { value = "com.microsoft.teams" } } }
                        },
                        {
                          definition_id = "com.apple.tcc.configuration-profile-policy_services_accessibility_item_identifiertype"
                          choice        = { value = { value = "com.apple.tcc.configuration-profile-policy_services_accessibility_item_identifiertype_0" } }
                        },
                        {
                          definition_id = "com.apple.tcc.configuration-profile-policy_services_accessibility_item_staticcode"
                          choice        = { value = { value = "com.apple.tcc.configuration-profile-policy_services_accessibility_item_staticcode_false" } }
                        },
                      ]
                    }, ] }
                  },
                ] }, ]
              }
            },
          ]
        }, ]
      } }
    },
  ]
}
