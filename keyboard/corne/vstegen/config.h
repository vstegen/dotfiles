/*
This is the c configuration file for the keymap

Copyright 2012 Jun Wako <wakojun@gmail.com>
Copyright 2015 Jack Humbert

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#pragma once

//#define USE_MATRIX_I2C

//#define QUICK_TAP_TERM 0
//#define TAPPING_TERM 100

#define TAPPING_TERM_PER_KEY

#undef COMBO_TERM
#define COMBO_TERM 40

#undef TAPPING_TERM
#define TAPPING_TERM 120

#define PERMISSIVE_HOLD

// accelerated mouse mode
#undef MOUSEKEY_INTERVAL
#define MOUSEKEY_INTERVAL 16

#undef MOUSEKEY_DELAY
#define MOUSEKEY_DELAY 0

#undef MOUSEKEY_WHEEL_DELAY
#define MOUSEKEY_WHEEL_DELAY 0

#undef MOUSEKEY_MAX_SPEED
#define MOUSEKEY_MAX_SPEED 6

#undef MOUSEKEY_TIME_TO_MAX
#define MOUSEKEY_TIME_TO_MAX 64

#undef MOUSEKEY_WHEEL_DELAY
#define MOUSEKEY_WHEEL_DELAY 10

#undef MOUSEKEY_WHEEL_INTERVAL
#define MOUSEKEY_WHEEL_INTERVAL 80

#undef MOUSEKEY_WHEEL_MAX_SPEED
#define MOUSEKEY_WHEEL_MAX_SPEED 8

#undef MOUSEKEY_WHEEL_TIME_TO_MAX
#define MOUSEKEY_WHEEL_TIME_TO_MAX 40

// without holding keys, it has mouse acceleration
#define MK_COMBINED
// constant mouse speed mode
// #define MK_3_SPEED
// #define MK_MOMENTARY_ACCEL

#define MK_C_OFFSET_0 1
#define MK_C_INTERVAL_0 32
#define MK_W_OFFSET_0 1
#define MK_W_INTERVAL_0 180

#define MK_C_OFFSET_1 4
#define MK_C_INTERVAL_1 16
#define MK_W_OFFSET_1 1
#define MK_W_INTERVAL_1 120

#define MK_C_OFFSET_UNMOD 16
#define MK_C_INTERVAL_UNMOD 16
#define MK_W_OFFSET_UNMOD 1
#define MK_W_INTERVAL_UNMOD 40

#define MK_C_OFFSET_2 32
#define MK_C_INTERVAL_2 16
#define MK_W_OFFSET_2 1
#define MK_W_INTERVAL_2 60

#define _STAGE_MNG HYPR(KC_T)
#define _SPACE_LEFT LCTL(KC_LEFT)
#define _MISSION_CONTROL LCTL(KC_UP)
#define _SPACE_RIGHT LCTL(KC_RIGHT)
#define _APP_WINDOW LCTL(KC_DOWN)
#define _SCR_FULL LSG(KC_3)
#define _SCR_WIN LCSG(KC_3)
#define _SCR_PREV_AREA LSG(KC_4)
#define _SCR_AREA LCSG(KC_4)
#define _SCR_OPT LSG(KC_5)
#define _MAC_REDO LSFT(MAC_UNDO)
#define _TAB_PREV LCS(KC_TAB)
#define _TAB_NEXT LCTL(KC_TAB)
#define _LANG LCA(KC_SPACE)
#define _WIN_L_1_3 LCA(KC_D)
#define _WIN_C_1_3 LCA(KC_F)
#define _WIN_R_1_3 LCA(KC_G)
#define _WIN_L_2_3 LCA(KC_E)
#define _WIN_R_2_3 LCA(KC_T)
#define _WIN_LEFT LCA(KC_LEFT)
#define _WIN_RIGHT LCA(KC_RIGHT)
#define _WIN_MAX LCA(KC_ENTER)
#define _WIN_RESTORE LCA(KC_BSPC)
#define _WIN_UL LCA(KC_U)
#define _WIN_UR LCA(KC_I)
#define _WIN_LL LCA(KC_J)
#define _WIN_LR LCA(KC_K)

#define HCS(report) host_consumer_send(record->event.pressed ? report : 0); return false


#ifdef RGBLIGHT_ENABLE
    #define RGBLIGHT_EFFECT_BREATHING
    #define RGBLIGHT_EFFECT_RAINBOW_MOOD
    #define RGBLIGHT_EFFECT_RAINBOW_SWIRL
    #define RGBLIGHT_EFFECT_SNAKE
    #define RGBLIGHT_EFFECT_KNIGHT
    #define RGBLIGHT_EFFECT_CHRISTMAS
    #define RGBLIGHT_EFFECT_STATIC_GRADIENT
    #define RGBLIGHT_EFFECT_RGB_TEST
    #define RGBLIGHT_EFFECT_ALTERNATING
    #define RGBLIGHT_EFFECT_TWINKLE
    #define RGBLIGHT_LIMIT_VAL 120
    #define RGBLIGHT_HUE_STEP 10
    #define RGBLIGHT_SAT_STEP 17
    #define RGBLIGHT_VAL_STEP 17
#endif
