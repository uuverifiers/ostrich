(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; SecureNet.*\x2Fsearchfast\x2F
(assert (not (str.in_re X (re.++ (str.to_re "SecureNet") (re.* re.allchar) (str.to_re "/searchfast/\u{0a}")))))
; ^[0][5][0]-\d{7}|[0][5][2]-\d{7}|[0][5][4]-\d{7}|[0][5][7]-\d{7}$
(assert (str.in_re X (re.union (re.++ (str.to_re "050-") ((_ re.loop 7 7) (re.range "0" "9"))) (re.++ (str.to_re "052-") ((_ re.loop 7 7) (re.range "0" "9"))) (re.++ (str.to_re "054-") ((_ re.loop 7 7) (re.range "0" "9"))) (re.++ (str.to_re "057-") ((_ re.loop 7 7) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; /\u{2e}jpeg([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.jpeg") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
; DATencentTravelerWebConnLibHost\x3A
(assert (not (str.in_re X (str.to_re "DATencentTravelerWebConnLibHost:\u{0a}"))))
; /filename=[^\n]*\u{2e}afm/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".afm/i\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
