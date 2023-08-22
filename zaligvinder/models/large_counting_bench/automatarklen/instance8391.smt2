(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (^(09|9)[1][1-9]\\d{7}$)|(^(09|9)[3][12456]\\d{7}$)
(assert (str.in_re X (re.union (re.++ (re.union (str.to_re "09") (str.to_re "9")) (str.to_re "1") (re.range "1" "9") (str.to_re "\u{5c}") ((_ re.loop 7 7) (str.to_re "d"))) (re.++ (str.to_re "\u{0a}") (re.union (str.to_re "09") (str.to_re "9")) (str.to_re "3") (re.union (str.to_re "1") (str.to_re "2") (str.to_re "4") (str.to_re "5") (str.to_re "6")) (str.to_re "\u{5c}") ((_ re.loop 7 7) (str.to_re "d"))))))
; ^[ .a-zA-Z0-9:-]{1,150}$
(assert (not (str.in_re X (re.++ ((_ re.loop 1 150) (re.union (str.to_re " ") (str.to_re ".") (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re ":") (str.to_re "-"))) (str.to_re "\u{0a}")))))
; /filename=[^\n]*\u{2e}zip/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".zip/i\u{0a}"))))
; ^[1-4]{1}[0-9]{4}(-)?[0-9]{7}(-)?[0-9]{1}$
(assert (not (str.in_re X (re.++ ((_ re.loop 1 1) (re.range "1" "4")) ((_ re.loop 4 4) (re.range "0" "9")) (re.opt (str.to_re "-")) ((_ re.loop 7 7) (re.range "0" "9")) (re.opt (str.to_re "-")) ((_ re.loop 1 1) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(assert (< 200 (str.len X)))
(check-sat)
