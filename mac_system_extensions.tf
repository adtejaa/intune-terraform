resource "microsoft365wp_device_configuration" "macos_extensions" {
  display_name = "TF Test macOS Extensions"
  macos_extensions = {
    kernel_extensions_allowed = [
      {
        bundle_id       = "com.company_1.application_a"
        team_identifier = ""
      }
    ]
    system_extensions_block_override = true
  }

   assignments = [
    { target = { group = { group_id = "d798b855-15f8-4d15-8f65-52046f83a6e7" } } },
  ]
}
