(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^\D{0,2}[0]{0,3}[1]{0,1}\D{0,2}([2-9])(\d{2})\D{0,2}(\d{3})\D{0,2}(\d{3})\D{0,2}(\d{1})\D{0,2}$
(assert (not (str.in_re X (re.++ ((_ re.loop 0 2) (re.comp (re.range "0" "9"))) ((_ re.loop 0 3) (str.to_re "0")) (re.opt (str.to_re "1")) ((_ re.loop 0 2) (re.comp (re.range "0" "9"))) (re.range "2" "9") ((_ re.loop 2 2) (re.range "0" "9")) ((_ re.loop 0 2) (re.comp (re.range "0" "9"))) ((_ re.loop 3 3) (re.range "0" "9")) ((_ re.loop 0 2) (re.comp (re.range "0" "9"))) ((_ re.loop 3 3) (re.range "0" "9")) ((_ re.loop 0 2) (re.comp (re.range "0" "9"))) ((_ re.loop 1 1) (re.range "0" "9")) ((_ re.loop 0 2) (re.comp (re.range "0" "9"))) (str.to_re "\u{0a}")))))
; /\u{2e}rtf([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.rtf") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
