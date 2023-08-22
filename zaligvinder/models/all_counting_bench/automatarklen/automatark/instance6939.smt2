(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\u{2e}afm([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.afm") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
; /filename=[^\n]*\u{2e}flac/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".flac/i\u{0a}")))))
; ([0-9]{11}$)|(^[7-9][0-9]{9}$)
(assert (str.in_re X (re.union ((_ re.loop 11 11) (re.range "0" "9")) (re.++ (str.to_re "\u{0a}") (re.range "7" "9") ((_ re.loop 9 9) (re.range "0" "9"))))))
; ^([0-9]{0,2})-([0-9]{0,2})-([0-9]{0,4})$
(assert (str.in_re X (re.++ ((_ re.loop 0 2) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 0 2) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 0 4) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
