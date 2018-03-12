/// @function fingerprint_md5()
/// @description Use various system configuration settings to fingerprint user

//
// Fingerprint is calculated by utilizing the following on all platforms:
// - Operating System
// - Browser
// - Display Width / Height
// - Are Shaders Supported?
// - Timezone
// - Gamepad Count (+ count of connected gamepads)
//
// On Windows-only, the following environment variables are used:
// - Username
// - Computer Name
// - Number of Processors
// - CPU Architecture, identifier, level and revision
// 

var buffer = buffer_create(256, buffer_grow, buffer_u8)

#region // Add Operating System
// NOTE(Jake): 2018-03-12 - Must be signed as "os_unknown" is -1
buffer_write(buffer, buffer_s32, os_type)
#endregion

#region // Add Browser
// NOTE(Jake): 2018-03-12 - Must be signed as "browser_not_a_browser" is -1
buffer_write(buffer, buffer_s32, os_browser)
#endregion

#region // Add Display Width / Height (uses browser dimensions in HTML5)
buffer_write(buffer, buffer_u32, display_get_width())
buffer_write(buffer, buffer_u32, display_get_height())
#endregion

#region // Add Is Shader Supported
buffer_write(buffer, buffer_u8, shaders_are_supported())
#endregion

#region // Add Timezone (hours from UTC, ie. Melbourne Australia == 11)

var datetime = date_current_datetime()
var originalTimezone = date_get_timezone()
date_set_timezone(timezone_local)
var hour_local = date_get_hour(datetime)
date_set_timezone(timezone_utc)
var hour_utc = date_get_hour(datetime)
date_set_timezone(originalTimezone)

// If in Melbourne Australia, this will be 11, ie. GMT+11
var utc_plus_hours = hour_local-hour_utc
buffer_write(buffer, buffer_s8, utc_plus_hours)

#endregion

#region // Add Gamepad Supported / Count
var gamepad_count = gamepad_get_device_count()
buffer_write(buffer, buffer_u16, gamepad_count)
var gamepad_connected_count = 0;
for (var i = 0; i < gamepad_count; i++) {
	gamepad_connected_count += gamepad_is_connected(i)
}
buffer_write(buffer, buffer_u16, gamepad_connected_count);
#endregion

#region // Add Windows-specific checks (uses environment_get_variable(), Windows-only function)
if os_type == os_windows &&
   os_browser == browser_not_a_browser {
	// Add username (example value: jordan)
	var username = environment_get_variable("USERNAME")
	if username != "" {
		buffer_write(buffer, buffer_string, username)	
	}
	
	// Add computer name (example value: DESKTOP-GH1TA)
	var computer_name = environment_get_variable("COMPUTERNAME")
	if computer_name != "" {
		buffer_write(buffer, buffer_string, computer_name)
	}
	
	// Add CPU count (example value: 4)
	var cpu_core_count = environment_get_variable("NUMBER_OF_PROCESSORS")
	if cpu_core_count != "" {
		buffer_write(buffer, buffer_string, cpu_core_count)	
	}
	
	// Add CPU architecture (example value: AMD64)
	var cpu_arch = environment_get_variable("PROCESSOR_ARCHITECTURE")
	if cpu_arch != "" {
		buffer_write(buffer, buffer_string, cpu_arch)
	}
	
	// Add CPU identifier (example value: Intel64 Family 6 Model 94 Stepping 3, GenuineIntel)
	var cpu_ident = environment_get_variable("PROCESSOR_IDENTIFIER")
	if cpu_ident != "" {
		buffer_write(buffer, buffer_string, cpu_ident)
	}
	
	// Add CPU level (example value: 6, x86 = 3,4,5. Alpha = 21064, MIPS = 3000 or 4000)
	var cpu_level = real(environment_get_variable("PROCESSOR_LEVEL"))
	if cpu_level != "" {
		buffer_write(buffer, buffer_string, cpu_level)
	}
	
	// Add CPU revision (example value: 5e03)
	var cpu_rev = environment_get_variable("PROCESSOR_REVISION")
	if cpu_rev != "" {
		buffer_write(buffer, buffer_string, cpu_rev)
	}
}
#endregion

var result = buffer_md5(buffer, 0, buffer_get_size(buffer))
buffer_delete(buffer)
return result
