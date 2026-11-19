/*
Copyright 2019 @foostan
Copyright 2020 Drashna Jaelre <@drashna>

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

#include "config.h"
#include QMK_KEYBOARD_H
#include "action_tapping.h"

const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {
    // BASE
    [0] = LAYOUT_split_3x6_3_ex2(
      HYPR_T(KC_GRAVE),    KC_Q,    KC_W,    KC_E,    KC_R,    KC_T, KC_UNDS,        KC_BSPC,      KC_Y,    KC_U,    KC_I,    KC_O,   KC_P,  MEH_T(KC_MINS),
      LT(4, KC_ESCAPE),    KC_A,    KC_S,    KC_D,    LT(7, KC_F),    KC_G, KC_RPRN,        KC_UNDS,      KC_H,    KC_J,    KC_K,    KC_L, KC_SCLN, KC_QUOT,
      KC_LEFT_SHIFT,    LGUI_T(KC_Z),    LALT_T(KC_X),    LCTL_T(KC_C),    KC_V,    LT(5, KC_B),                         KC_N,    KC_M, RCTL_T(KC_COMMA),  RALT_T(KC_DOT), RGUI_T(KC_SLSH),  KC_RIGHT_SHIFT,
                                          XXXXXXX,   LT(3, KC_BSPC),  LT(1, KC_TAB),    LT(6, KC_ENT), KC_SPC, XXXXXXX
  ),
    // SYMBOLS
    [1] = LAYOUT_split_3x6_3_ex2(
      _MAC_UNDO,    KC_COMMA,    KC_AT,    KC_LPRN,        KC_RPRN,        KC_PERC, KC_COMMA,                        KC_1,      KC_PIPE,        KC_DLR,         KC_RABK,        KC_ASTR,        KC_SCLN,  KC_COMMA,
      KC_GRAVE,    KC_LCBR,    KC_RCBR,  KC_LBRC,        KC_RBRC,        KC_AMPR,  KC_2,                    KC_0,           KC_MINUS,       KC_EQUAL,       KC_PLUS,        KC_COLN,        KC_EXLM,        KC_DQUO,
    XXXXXXX, KC_TILD,        XXXXXXX, XXXXXXX, KC_UNDS,        KC_HASH,                                        KC_QUES,        KC_CIRC,        KC_LABK,        KC_SLASH,       LGUI_T(KC_BSLS),        KC_GRAVE,
                                          _______,   _______,  _______,     MO(2),   KC_SPC, _______
  ),
    // MACROS
    [2] = LAYOUT_split_3x6_3_ex2(
      XXXXXXX,    XXXXXXX,    XXXXXXX,    XXXXXXX,    XXXXXXX,    XXXXXXX, XXXXXXX,        XXXXXXX,    KC_F12,    KC_F7,    KC_F8,    KC_F9,    XXXXXXX, XXXXXXX,
      XXXXXXX,    KC_LEFT_GUI,    KC_LEFT_ALT,    KC_LEFT_SHIFT,    KC_LEFT_CTRL,    XXXXXXX, XXXXXXX,        XXXXXXX,    KC_F11,    KC_F4,    KC_F5,    KC_F6,    XXXXXXX, XXXXXXX,
      XXXXXXX,    XXXXXXX,    XXXXXXX,    XXXXXXX,    XXXXXXX,    XXXXXXX,                             KC_F10,    KC_F1,    KC_F2,    KC_F3,    XXXXXXX, XXXXXXX,
                                          _______,   _______,  _______,     _______,   _______, _______
  ),
    // NUM + FN
    [3] = LAYOUT_split_3x6_3_ex2(
       XXXXXXX,  _SCR_PREV_AREA, _SCR_FULL, _SCR_WIN, _SCR_AREA, _SCR_OPT,  KC_BSPC,        KC_LBRC,      KC_SLASH,    KC_7,    KC_8,    KC_9,   KC_MINUS,  KC_PERC,
      KC_F11,    LGUI_T(KC_F1),    LALT_T(KC_F2),    LSFT_T(KC_F3),    LCTL_T(KC_F4),    KC_F5, XXXXXXX,       KC_RBRC,      KC_UNDS,    KC_4,    KC_5,    KC_6, KC_PLUS, KC_ASTR,
      KC_F12,    KC_F6,    KC_F7,    KC_F8,    KC_F9,    KC_F10,       KC_0,    KC_1, KC_2,  KC_3, KC_EQUAL,  XXXXXXX,
                                          KC_DOT,   KC_COMMA,  KC_BSPC,     KC_BSPC,   KC_COMMA, KC_DOT
  ),
    // PKR
    [4] = LAYOUT_split_3x6_3_ex2(
    XXXXXXX,  _STAGE_MNG,   _APP_WINDOW,  _SPACE_LEFT,  _SPACE_RIGHT,   _MISSION_CONTROL,  XXXXXXX,                     KC_RIGHT_ALT,        _MAC_UNDO, _MAC_PASTE, _MAC_COPY, _MAC_CUT, _MAC_REDO, KC_INSERT,
    XXXXXXX, KC_LEFT_GUI,    KC_LEFT_ALT,    KC_LEFT_SHIFT,  KC_LEFT_CTRL,   XXXXXXX, XXXXXXX,       XXXXXXX,     KC_LEFT,        KC_DOWN,        KC_UP,          KC_RIGHT,       XXXXXXX, XXXXXXX,
    XXXXXXX, XXXXXXX, XXXXXXX, _TAB_PREV, _TAB_NEXT, _LANG,                                KC_HOME,        KC_PGDN,        KC_PAGE_UP,     KC_END,         OSM(MOD_RALT),  KC_CAPS,
                                           KC_RIGHT_ALT,  KC_DELETE, LALT(KC_BSPC),                                    KC_ENT,   KC_SPC,  KC_RIGHT_ALT
  ),
    // WIN
    [5] = LAYOUT_split_3x6_3_ex2(
      XXXXXXX,    _WIN_L_1_3,    _WIN_L_2_3,    _WIN_UL,    _WIN_UR,    XXXXXXX, XXXXXXX,                XXXXXXX,      XXXXXXX,    KC_VOLD,    KC_AUDIO_MUTE,    KC_VOLU,   XXXXXXX,  XXXXXXX,
      XXXXXXX,    _WIN_C_1_3,    _WIN_RESTORE,    _WIN_LEFT,    _WIN_RIGHT,    _WIN_MAX, XXXXXXX,        XXXXXXX,      XXXXXXX,    KC_MEDIA_PREV_TRACK,    KC_MEDIA_PLAY_PAUSE,    KC_MEDIA_NEXT_TRACK, XXXXXXX, XXXXXXX,
      XXXXXXX,    _WIN_R_1_3,    _WIN_R_2_3,    _WIN_LL,    _WIN_LR,    XXXXXXX,                                       XXXXXXX,    KC_BRIGHTNESS_DOWN, XXXXXXX,  KC_BRIGHTNESS_UP, XXXXXXX,  XXXXXXX,
                                          _______,   _______,  _______,     _______,   _______, _______
  ),
    // MOUSE
    // XXXXXXX
    // _______
    [6] = LAYOUT_split_3x6_3_ex2(
    XXXXXXX,    XXXXXXX,    MS_ACL2,    MS_ACL1,    MS_ACL0,    XXXXXXX, XXXXXXX,                       MS_BTN4,    XXXXXXX,      MS_WHLU,  MS_UP,       XXXXXXX,    XXXXXXX, XXXXXXX,
    XXXXXXX, KC_LEFT_GUI,    KC_LEFT_ALT,    KC_LEFT_SHIFT,  KC_LEFT_CTRL,   XXXXXXX,  XXXXXXX,         MS_BTN5,  MS_WHLL,  MS_LEFT,     MS_DOWN,     MS_RGHT,    MS_WHLR, KC_APPLICATION,
    XXXXXXX,    XXXXXXX,    XXXXXXX,    XXXXXXX,    XXXXXXX,    XXXXXXX,                                               XXXXXXX, MS_WHLD, MS_BTN3,     XXXXXXX, XXXXXXX, XXXXXXX,
                                           _______,         MS_BTN2,     MS_BTN1,                                     _______, _______, _______
  ),
    // NUM + FN
    [7] = LAYOUT_split_3x6_3_ex2(
      XXXXXXX,  XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX,  XXXXXXX,                                 KC_BSPC,      KC_SLASH,    KC_7,    KC_8,    KC_9,   KC_MINUS,  KC_PERC,
      XXXXXXX,    XXXXXXX,    XXXXXXX,    LGUI_T(KC_UNDS), XXXXXXX,   XXXXXXX, XXXXXXX,       KC_UNDS,      KC_ASTR,    KC_4,    KC_5,    KC_6, KC_PLUS, KC_COLN,
      XXXXXXX,    XXXXXXX,    XXXXXXX,    XXXXXXX,    XXXXXXX,    XXXXXXX,                                       KC_0,    KC_1, KC_2,  KC_3, KC_EQUAL,  XXXXXXX,
                                     XXXXXXX,   KC_COMMA, KC_DOT,                                              KC_ENT,   KC_SPC, XXXXXXX
  ),
};

uint16_t get_tapping_term(uint16_t keycode, keyrecord_t *record) {
    switch (keycode) {
        case LGUI_T(KC_Z):
            return TAPPING_TERM + 50; // 170
        case LALT_T(KC_X):
            return TAPPING_TERM + 50; // 170
        case LCTL_T(KC_C):
            return TAPPING_TERM + 50; // 170
        case LT(5, KC_B):
            return TAPPING_TERM + 80; // 200
        case RCTL_T(KC_COMMA):
            return TAPPING_TERM + 50; // 170
        case RALT_T(KC_DOT):
            return TAPPING_TERM + 50; // 170
        case RGUI_T(KC_SLASH):
            return TAPPING_TERM + 50; // 170
        case LT(6, KC_ENTER):
            return TAPPING_TERM + 80; // 200
        case LT(3, KC_BSPC):
            return TAPPING_TERM + 50; // 170
        case LT(7, KC_F):
            return TAPPING_TERM + 80; // 200
        default:
            return TAPPING_TERM;
    }
}

