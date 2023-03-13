(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; User-Agent\x3A\d+PortaURLSSKC\u{7c}roogoo\u{7c}\.cfgmPOPrtCUSTOMPal
(assert (str.in_re X (re.++ (str.to_re "User-Agent:") (re.+ (re.range "0" "9")) (str.to_re "PortaURLSSKC|roogoo|.cfgmPOPrtCUSTOMPal\u{0a}"))))
; User-Agent\x3AUser-Agent\x3Awp-includes\x2Ftheme\x2Ephp\x3Fframe_ver2
(assert (str.in_re X (str.to_re "User-Agent:User-Agent:wp-includes/theme.php?frame_ver2\u{0a}")))
; ^((1[1-9]|2[03489]|3[0347]|5[56]|7[04-9]|8[047]|9[018])\d{8}|(1[2-9]\d|[58]00)\d{6}|8(001111|45464\d))$
(assert (not (str.in_re X (re.++ (re.union (re.++ (re.union (re.++ (str.to_re "1") (re.range "1" "9")) (re.++ (str.to_re "2") (re.union (str.to_re "0") (str.to_re "3") (str.to_re "4") (str.to_re "8") (str.to_re "9"))) (re.++ (str.to_re "3") (re.union (str.to_re "0") (str.to_re "3") (str.to_re "4") (str.to_re "7"))) (re.++ (str.to_re "5") (re.union (str.to_re "5") (str.to_re "6"))) (re.++ (str.to_re "7") (re.union (str.to_re "0") (re.range "4" "9"))) (re.++ (str.to_re "8") (re.union (str.to_re "0") (str.to_re "4") (str.to_re "7"))) (re.++ (str.to_re "9") (re.union (str.to_re "0") (str.to_re "1") (str.to_re "8")))) ((_ re.loop 8 8) (re.range "0" "9"))) (re.++ (re.union (re.++ (str.to_re "1") (re.range "2" "9") (re.range "0" "9")) (re.++ (re.union (str.to_re "5") (str.to_re "8")) (str.to_re "00"))) ((_ re.loop 6 6) (re.range "0" "9"))) (re.++ (str.to_re "8") (re.union (str.to_re "001111") (re.++ (str.to_re "45464") (re.range "0" "9"))))) (str.to_re "\u{0a}")))))
; /filename=[^\n]*\u{2e}mid/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".mid/i\u{0a}"))))
(check-sat)
