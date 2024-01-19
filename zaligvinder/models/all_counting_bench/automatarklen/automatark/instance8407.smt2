(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\u{2e}dcr([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.dcr") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
; ^[0][1-9]{2}(-)[0-9]{8}$  and  ^[0][1-9]{3}(-)[0-9]{7}$  and  ^[0][1-9]{4}(-)[0-9]{6}$
(assert (not (str.in_re X (re.++ (str.to_re "0") ((_ re.loop 2 2) (re.range "1" "9")) (str.to_re "-") ((_ re.loop 8 8) (re.range "0" "9")) (str.to_re "  and  0") ((_ re.loop 3 3) (re.range "1" "9")) (str.to_re "-") ((_ re.loop 7 7) (re.range "0" "9")) (str.to_re "  and  0") ((_ re.loop 4 4) (re.range "1" "9")) (str.to_re "-") ((_ re.loop 6 6) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; ^[0-9]*\/{1}[1-9]{1}[0-9]*$
(assert (not (str.in_re X (re.++ (re.* (re.range "0" "9")) ((_ re.loop 1 1) (str.to_re "/")) ((_ re.loop 1 1) (re.range "1" "9")) (re.* (re.range "0" "9")) (str.to_re "\u{0a}")))))
; pjpoptwql\u{2f}rlnjsportsHost\x3ASubject\u{3a}YAHOOdestroyed\u{21}
(assert (str.in_re X (str.to_re "pjpoptwql/rlnjsportsHost:Subject:YAHOOdestroyed!\u{0a}")))
; ^(000-)(\\d{5}-){2}\\d{3}$
(assert (not (str.in_re X (re.++ (str.to_re "000-") ((_ re.loop 2 2) (re.++ (str.to_re "\u{5c}") ((_ re.loop 5 5) (str.to_re "d")) (str.to_re "-"))) (str.to_re "\u{5c}") ((_ re.loop 3 3) (str.to_re "d")) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
