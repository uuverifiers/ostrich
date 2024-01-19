(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; wp-includes\x2Ftheme\x2Ephp\x3F\s+TencentTraveler
(assert (str.in_re X (re.++ (str.to_re "wp-includes/theme.php?") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "TencentTraveler\u{0a}"))))
; /filename=[^\n]*\u{2e}afm/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".afm/i\u{0a}")))))
; ^07([\d]{3})[(\D\s)]?[\d]{3}[(\D\s)]?[\d]{3}$
(assert (str.in_re X (re.++ (str.to_re "07") ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re "(") (re.comp (re.range "0" "9")) (str.to_re ")") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re "(") (re.comp (re.range "0" "9")) (str.to_re ")") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
