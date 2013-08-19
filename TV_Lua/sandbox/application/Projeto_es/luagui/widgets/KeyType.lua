--- KeyType enum.
require(SB_REQUIRE_LUAGUI .. "widgets.enum")

--- Enum that defines a key type.
--Those being:
--  <code>
--  CHARACTER_KEY,
--  COMPOSE_KEY,
--  EDITING_KEY,
--  LOCK_KEY,
--  MISC,
--  MODIFIER_KEY,</code>
--  or <code>NAVIGATION_KEY</code>.
KeyType = enum {
    'CHARACTER_KEY',
    'COMPOSE',
    'EDITING_KEY',
    'LOCK_KEY',
    'MISC',
    'MODIFIER_KEY',
    'NAVIGATION_KEY'
}

