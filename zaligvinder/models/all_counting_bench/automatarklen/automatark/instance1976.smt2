(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\u{2e}mid([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.mid") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
; Host\x3A\s+Online\s+ocllceclbhs\u{2f}gth
(assert (not (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Online") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "ocllceclbhs/gth\u{0a}")))))
; ^\d* \d*\/{1}\d*$|^\d*$
(assert (str.in_re X (re.union (re.++ (re.* (re.range "0" "9")) (str.to_re " ") (re.* (re.range "0" "9")) ((_ re.loop 1 1) (str.to_re "/")) (re.* (re.range "0" "9"))) (re.++ (re.* (re.range "0" "9")) (str.to_re "\u{0a}")))))
; \.exe\s+v2\x2E0\s+smrtshpr-cs-
(assert (str.in_re X (re.++ (str.to_re ".exe") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "v2.0") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "smrtshpr-cs-\u{13}\u{0a}"))))
; ^04[0-9]{8}
(assert (str.in_re X (re.++ (str.to_re "04") ((_ re.loop 8 8) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
