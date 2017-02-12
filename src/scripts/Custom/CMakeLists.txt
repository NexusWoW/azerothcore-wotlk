# Copyright (C) 
#
# This file is free software; as a special exception the author gives
# unlimited permission to copy and/or distribute it, with or without
# modifications, as long as this notice is preserved.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY, to the extent permitted by law; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

set(scripts_STAT_SRCS
  ${scripts_STAT_SRCS}
  ${AC_SCRIPTS_DIR}/Custom/custom_rates.cpp
  ${AC_SCRIPTS_DIR}/Custom/Crossfaction/Crossfaction.cpp
  ${AC_SCRIPTS_DIR}/Custom/Crossfaction/Crossfaction.h
)

AC_ADD_SCRIPT_LOADER("Custom" "ScriptLoader.h")

message("  -> Prepared: Custom")
