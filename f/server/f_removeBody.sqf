// F3 - Automatic Body Removal
// Credits: Please see the F3 online manual (http://www.ferstaberinde.com/f3/en/)
// ====================================================================================

// SERVER CHECK
// Ensure this script only executes on the server:

if !(isServer) exitWith {};

// ====================================================================================

// DECLARE VARIABLES AND FUNCTIONS

private ["_body","_wait","_distance","_pos","_nearPlayers","_nearUnits","_check"];

// ====================================================================================

// WAIT FOR COMMON LOCAL VARIABLES TO BE SET
// Before executing this script, we wait for the script 'f_setLocalVars.sqf' to run:

waitUntil {scriptDone f_script_setLocalVars};

// SET KEY VARIABLES
// The body to remove is passed to this script by the event handler itself. The time to sleep and minimal distance to remove are defined by global variables

_body = _this;
_wait = f_removeBodyDelay;
_distance = f_removeBodyDistance;

waitUntil  {!isNull _body};

_pos = getPos _body;
_nearPlayers = [objNull];

// ====================================================================================

// WAITING UNTIL ALL CONDITIONS ARE MET
// While there's at least 1 player within the minimal radius around the body the script sleeps the designated time.

while {count _nearPlayers > 0} do {
	_nearUnits = nearestObjects [_pos, ["CAManBase","Car"], _distance];
	_nearPlayers = [];
	{if (isPlayer _x) then {_nearPlayers = _nearPlayers + [_x]};} forEach _nearUnits;
	sleep _wait;
};

// ====================================================================================

// REMOVE GROUP AND BODY
// We check if anyone in the body's group is alive and if not delete the group
// Afterwards the body is deleted

_check = {alive _x}  count (units (group _body));
if (_check == 0) then {deleteGroup (group _body)};
deleteVehicle _body;

if (true) exitWith {};
