
resource "microsoft365wp_device_configuration" "windows10_general" {
  display_name = "Windows 10 General"
  windows10_general = {
    screen_capture_blocked = true
  }
}