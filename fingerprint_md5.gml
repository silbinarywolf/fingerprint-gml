/// @function fingerprint_md5()
/// @description Use various system configuration settings to fingerprint user

//
// Fingerprint is calculated by utilizing the following:
// - Operating System
// - Browser
// - Display Width / Height
// - Are Shaders Supported?
// - Timezone
// - Gamepad Count (+ count of connected gamepads)
//
//

enum __FingerprintOS {
	Unknown      = 0,
	Windows      = 1,
	Android      = 2,
	Linux        = 3,
	MacOSX       = 4,
	iOS          = 5,
	WindowsPhone = 6,
	XboxOne      = 7,
	Playstation4 = 8,
}

enum __FingerprintBrowser {
	Unknown = 0,
	NotABrowser = 1,
	InternetExplorer = 2,
	InternetExplorerMobile = 3,
	Firefox = 4,
	Chrome = 5,
	Safari = 6,
	SafariMobile = 7,
	Opera = 8,
	WindowsStore = 9,
}

var buffer = buffer_create(256, buffer_grow, buffer_u8)

#region // Add Operating System
switch os_type {
	case os_windows:  buffer_write(buffer, buffer_u8, __FingerprintOS.Windows) break
	case os_android:  buffer_write(buffer, buffer_u8, __FingerprintOS.Android) break
	case os_linux:    buffer_write(buffer, buffer_u8, __FingerprintOS.Linux) break
	case os_macosx:   buffer_write(buffer, buffer_u8, __FingerprintOS.MacOSX) break
	case os_ios:      buffer_write(buffer, buffer_u8, __FingerprintOS.iOS) break
	case os_winphone: buffer_write(buffer, buffer_u8, __FingerprintOS.WindowsPhone) break
	case os_xboxone:  buffer_write(buffer, buffer_u8, __FingerprintOS.XboxOne) break
	case os_ps4:      buffer_write(buffer, buffer_u8, __FingerprintOS.Playstation4) break
	default:		  buffer_write(buffer, buffer_u8, __FingerprintOS.Unknown) break
}
#endregion

#region // Add Browser
switch os_browser {
	case browser_not_a_browser: buffer_write(buffer, buffer_u8, __FingerprintBrowser.NotABrowser) break
	case browser_ie:        buffer_write(buffer, buffer_u8, __FingerprintBrowser.InternetExplorer) break
	case browser_ie_mobile: buffer_write(buffer, buffer_u8, __FingerprintBrowser.InternetExplorerMobile) break
	case browser_firefox:   buffer_write(buffer, buffer_u8, __FingerprintBrowser.Firefox) break
	case browser_chrome:    buffer_write(buffer, buffer_u8, __FingerprintBrowser.Chrome) break
	case browser_safari:    buffer_write(buffer, buffer_u8, __FingerprintBrowser.Safari) break
	case browser_safari_mobile:    buffer_write(buffer, buffer_u8, __FingerprintBrowser.SafariMobile) break
	case browser_opera:     buffer_write(buffer, buffer_u8, __FingerprintBrowser.Opera) break
	case browser_windows_store:     buffer_write(buffer, buffer_u8, __FingerprintBrowser.WindowsStore) break
	default: buffer_write(buffer, buffer_u8, __FingerprintBrowser.Unknown) break
}
#endregion

#region // Add Display Width / Height (uses browser dimensions in HTML5)
buffer_write(buffer, buffer_u32, display_get_width())
buffer_write(buffer, buffer_u32, display_get_height())
#endregion

#region // Add Is Shader Supported
buffer_write(buffer, buffer_u8, shaders_are_supported())
#endregion

#region // Add Timezone (hours from UTC, ie. Melbourne Australia == 11)
//date_create_datetime(date_get_year(datetime), date_get_month(datetime), date_get_day(datetime), date_get_hour(datetime), date_get_minute(datetime), date_get_second(datetime))
var datetime = date_current_datetime()
var originalTimezone = date_get_timezone()
date_set_timezone(timezone_local)
var hourLocal = date_get_hour(datetime)
date_set_timezone(timezone_utc)
var hourUTC = date_get_hour(datetime)
date_set_timezone(originalTimezone)

// If in Melbourne Australia, this will be 11, ie. GMT+11
var utcPlusHours = hourLocal-hourUTC
buffer_write(buffer, buffer_s8, utcPlusHours)

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

var result = buffer_md5(buffer, 0, buffer_get_size(buffer))
buffer_delete(buffer)
return result
