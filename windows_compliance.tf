resource "microsoft365wp_device_compliance_policy" "win10" {
  display_name               = "Windows 10"
  scheduled_actions_for_rule = [{ scheduled_action_configurations = [{}] }]
  windows10 = {
    bitlocker_enabled = false
  }
  assignments = [
    { target = { all_devices = {} } },
    { target = { all_licensed_users = {} } },
    { target = { exclusion_group = { group_id = "298fded6-b252-4166-a473-f405e935f58d" } } },
  ]
}