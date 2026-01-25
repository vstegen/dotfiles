#include QMK_KEYBOARD_H
#include "version.h"
#include "i18n.h"
#define MOON_LED_LEVEL LED_LEVEL
#ifndef ZSA_SAFE_RANGE
#define ZSA_SAFE_RANGE SAFE_RANGE
#endif

enum custom_keycodes {
  RGB_SLD = ZSA_SAFE_RANGE,
  MAC_SIRI,
};




const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {
  [0] = LAYOUT_voyager(
    KC_GRAVE,       KC_1,           KC_2,           KC_3,           KC_4,           KC_5,                                           KC_6,           KC_7,           KC_8,           KC_9,           KC_0,           KC_MINUS,       
    KC_HYPR,        KC_Q,           KC_W,           KC_E,           KC_R,           KC_T,                                           KC_Y,           KC_U,           KC_I,           KC_O,           KC_P,           KC_UNDS,        
    LT(2, KC_ESCAPE),KC_A,           KC_S,           KC_D,           KC_F,           KC_G,                                           KC_H,           KC_J,           KC_K,           KC_L,           KC_SCLN,        LT(6, KC_QUOTE),
    KC_LEFT_SHIFT,  MT(MOD_LGUI, KC_Z),MT(MOD_LALT, KC_X),MT(MOD_LCTL, KC_C),LT(3, KC_V),    LT(5, KC_B),                                    KC_N,           KC_M,           MT(MOD_RCTL, KC_COMMA),MT(MOD_LALT, KC_DOT),MT(MOD_RGUI, KC_SLASH),KC_RIGHT_SHIFT, 
                                                    LT(1, KC_BSPC), MT(MOD_LCTL, KC_TAB),                                LT(4, KC_ENTER),KC_SPACE
  ),
  [1] = LAYOUT_voyager(
    KC_MAC_UNDO,    KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,                                 KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, 
    KC_TRANSPARENT, KC_TRANSPARENT, KC_AT,          KC_LPRN,        KC_RPRN,        KC_PERC,                                        KC_PIPE,        KC_DLR,         KC_RABK,        KC_ASTR,        KC_SCLN,        KC_TRANSPARENT, 
    KC_GRAVE,       KC_LCBR,        KC_RCBR,        KC_LBRC,        KC_RBRC,        KC_AMPR,                                        KC_MINUS,       KC_EQUAL,       KC_PLUS,        KC_COLN,        KC_EXLM,        KC_DQUO,        
    KC_TRANSPARENT, KC_TILD,        KC_TRANSPARENT, KC_TRANSPARENT, KC_UNDS,        KC_HASH,                                        KC_QUES,        KC_CIRC,        KC_LABK,        KC_SLASH,       KC_BSLS,        KC_TRANSPARENT, 
                                                    KC_TRANSPARENT, KC_TRANSPARENT,                                 KC_TRANSPARENT, KC_TRANSPARENT
  ),
  [2] = LAYOUT_voyager(
    KC_TRANSPARENT, LGUI(LSFT(KC_3)),LGUI(LCTL(LSFT(KC_3))),LGUI(LSFT(KC_4)),LGUI(LCTL(LSFT(KC_4))),LGUI(LSFT(KC_5)),                                KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, 
    KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, LCTL(LSFT(KC_TAB)),LCTL(KC_TAB),   KC_MAC_UNDO,                                    KC_MAC_UNDO,    KC_MAC_PASTE,   KC_MAC_COPY,    KC_MAC_CUT,     LSFT(KC_MAC_UNDO),KC_INSERT,      
    KC_TRANSPARENT, KC_LEFT_GUI,    KC_LEFT_ALT,    KC_LEFT_SHIFT,  KC_LEFT_CTRL,   MAC_SIRI,                                       KC_LEFT,        KC_DOWN,        KC_UP,          KC_RIGHT,       KC_TRANSPARENT, KC_TRANSPARENT, 
    KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, LALT(LCTL(KC_SPACE)),                                KC_HOME,        KC_PGDN,        KC_PAGE_UP,     KC_END,         OSM(MOD_RALT),  KC_CAPS,        
                                                    LALT(KC_BSPC),  KC_DELETE,                                      KC_ENTER,       KC_SPACE
  ),
  [3] = LAYOUT_voyager(
    KC_TRANSPARENT, LALT(LGUI(LCTL(LSFT(KC_T)))),LCTL(KC_LEFT),  LCTL(KC_UP),    LCTL(KC_RIGHT), LCTL(KC_DOWN),                                  KC_TRANSPARENT, KC_LPRN,        KC_RPRN,        KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, 
    LCTL(KC_5),     LCTL(KC_4),     LCTL(KC_3),     LCTL(KC_2),     LCTL(KC_1),     KC_TRANSPARENT,                                 KC_MINUS,       KC_7,           KC_8,           KC_9,           KC_PERC,        KC_TRANSPARENT, 
    LCTL(KC_0),     LCTL(KC_9),     LCTL(KC_8),     LCTL(KC_7),     LCTL(KC_6),     KC_TRANSPARENT,                                 KC_PLUS,        KC_4,           KC_5,           KC_6,           KC_ASTR,        KC_UNDS,        
    KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,                                 KC_EQUAL,       KC_1,           KC_2,           KC_3,           KC_SLASH,       KC_COMMA,       
                                                    KC_TRANSPARENT, KC_TRANSPARENT,                                 KC_DOT,         KC_0
  ),
  [4] = LAYOUT_voyager(
    KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,                                 KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, 
    KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,                                 KC_TRANSPARENT, KC_MS_WH_DOWN,  KC_MS_UP,       KC_MS_WH_UP,    KC_TRANSPARENT, KC_TRANSPARENT, 
    KC_TRANSPARENT, KC_LEFT_GUI,    KC_LEFT_ALT,    KC_LEFT_SHIFT,  KC_LEFT_CTRL,   KC_TRANSPARENT,                                 KC_MS_WH_LEFT,  KC_MS_LEFT,     KC_MS_DOWN,     KC_MS_RIGHT,    KC_MS_WH_RIGHT, KC_APPLICATION, 
    KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,                                 KC_TRANSPARENT, KC_TRANSPARENT, KC_MS_BTN3,     KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, 
                                                    KC_MS_BTN1,     KC_MS_BTN2,                                     KC_TRANSPARENT, KC_TRANSPARENT
  ),
  [5] = LAYOUT_voyager(
    KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, LALT(LCTL(KC_U)),LALT(LCTL(KC_I)),KC_TRANSPARENT,                                 KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, 
    KC_TRANSPARENT, LALT(LCTL(KC_E)),LALT(LCTL(KC_G)),LALT(LCTL(KC_J)),LALT(LCTL(KC_K)),LALT(LCTL(KC_BSPC)),                                KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, 
    KC_TRANSPARENT, LALT(LCTL(KC_D)),LALT(LCTL(KC_T)),LALT(LCTL(KC_LEFT)),LALT(LCTL(KC_RIGHT)),LALT(LCTL(KC_ENTER)),                                KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, 
    KC_TRANSPARENT, LALT(LCTL(KC_F)),KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,                                 KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, 
                                                    KC_TRANSPARENT, KC_TRANSPARENT,                                 KC_TRANSPARENT, KC_TRANSPARENT
  ),
  [6] = LAYOUT_voyager(
    KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,                                 KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, 
    KC_TRANSPARENT, KC_F12,         KC_F7,          KC_F8,          KC_F9,          KC_TRANSPARENT,                                 KC_AUDIO_MUTE,  KC_AUDIO_VOL_DOWN,KC_AUDIO_VOL_UP,KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, 
    KC_TRANSPARENT, KC_F11,         KC_F4,          KC_F5,          KC_F6,          KC_TRANSPARENT,                                 KC_MEDIA_PREV_TRACK,KC_MEDIA_PLAY_PAUSE,KC_MEDIA_NEXT_TRACK,KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, 
    KC_TRANSPARENT, KC_F10,         KC_F1,          KC_F2,          KC_F3,          KC_TRANSPARENT,                                 KC_TRANSPARENT, KC_BRIGHTNESS_DOWN,KC_BRIGHTNESS_UP,KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, 
                                                    LALT(KC_BSPC),  KC_DELETE,                                      KC_TRANSPARENT, KC_TRANSPARENT
  ),
};



uint16_t get_tapping_term(uint16_t keycode, keyrecord_t *record) {
    switch (keycode) {
        case MT(MOD_LGUI, KC_Z):
            return TAPPING_TERM + 50;
        case MT(MOD_LALT, KC_X):
            return TAPPING_TERM + 50;
        case MT(MOD_LCTL, KC_C):
            return TAPPING_TERM + 50;
        case LT(3, KC_V):
            return TAPPING_TERM + 50;
        case LT(5, KC_B):
            return TAPPING_TERM + 80;
        case LT(6, KC_QUOTE):
            return TAPPING_TERM + 80;
        case KC_M:
            return TAPPING_TERM + 80;
        case MT(MOD_RCTL, KC_COMMA):
            return TAPPING_TERM + 50;
        case MT(MOD_LALT, KC_DOT):
            return TAPPING_TERM + 50;
        case MT(MOD_RGUI, KC_SLASH):
            return TAPPING_TERM + 50;
        case LT(4, KC_ENTER):
            return TAPPING_TERM + 80;
        default:
            return TAPPING_TERM;
    }
}




bool process_record_user(uint16_t keycode, keyrecord_t *record) {
  switch (keycode) {
    case MAC_SIRI:
      HCS(0xCF);

    case RGB_SLD:
      if (record->event.pressed) {
        rgblight_mode(1);
      }
      return false;
  }
  return true;
}


