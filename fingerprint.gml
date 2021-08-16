/// @description Use various system configuration settings to fingerprint user

// The fingerprint is calculated by writing the following to a buffer and retrieving an MD5 hash.

// - Operating system type, version and region
// - Are shaders supported?
// - Game specific data
// - Timezone
// - Language

// On Windows-only, the following environment variables are used:
// - Username
// - Computer name
// - CPU architecture, name, core count, level and revision

// On Linux-only, the following environment variables are used:
// - Username

function get_fingerprint() {
	var buffer = buffer_create(256, buffer_grow, buffer_u8);

	// Operating system
	buffer_write(buffer, buffer_s32, os_type);
	buffer_write(buffer, buffer_s32, os_version);
	buffer_write(buffer, buffer_s32, os_get_region());

	// Are shaders supported?
	buffer_write(buffer, buffer_u8, shaders_are_supported());

	// Game specific data
	buffer_write(buffer, buffer_s32, os_get_config());
	buffer_write(buffer, buffer_s32, GM_build_date);
	buffer_write(buffer, buffer_s32, GM_version);

	// Timezone
	var datetime = date_current_datetime();
	var originalTimezone = date_get_timezone();

	date_set_timezone(timezone_local);
	var hour_local = date_get_hour(datetime);

	date_set_timezone(timezone_utc);
	var hour_utc = date_get_hour(datetime);

	date_set_timezone(originalTimezone);

	buffer_write(buffer, buffer_s8, hour_local - hour_utc);

	//  Language
	buffer_write(buffer, buffer_s8, os_get_language());

	// WINDOWS SPECIFIC
	if (os_type == os_windows) {
		buffer_write(buffer, buffer_string, environment_get_variable("USERNAME"));
		buffer_write(buffer, buffer_string, environment_get_variable("COMPUTERNAME"));
		buffer_write(buffer, buffer_string, environment_get_variable("PROCESSOR_ARCHITECTURE"));
		buffer_write(buffer, buffer_string, environment_get_variable("PROCESSOR_IDENTIFIER"));
		buffer_write(buffer, buffer_string, environment_get_variable("NUMBER_OF_PROCESSORS"));
		buffer_write(buffer, buffer_string, environment_get_variable("PROCESSOR_LEVEL"));
		buffer_write(buffer, buffer_string, environment_get_variable("PROCESSOR_REVISION"));
	}

	// LINUX SPECIFIC
	if (os_type == os_linux) {
		buffer_write(buffer, buffer_string, environment_get_variable("USER"));
	}

	var result = buffer_md5(buffer, 0, buffer_get_size(buffer));
	buffer_delete(buffer);
	return result;
}