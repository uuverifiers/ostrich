(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[0-9]{10}$|^\(0[1-9]{1}\)[0-9]{8}$|^[0-9]{8}$|^[0-9]{4}[ ][0-9]{3}[ ][0-9]{3}$|^\(0[1-9]{1}\)[ ][0-9]{4}[ ][0-9]{4}$|^[0-9]{4}[ ][0-9]{4}$
(assert (str.in_re X (re.union ((_ re.loop 10 10) (re.range "0" "9")) (re.++ (str.to_re "(0") ((_ re.loop 1 1) (re.range "1" "9")) (str.to_re ")") ((_ re.loop 8 8) (re.range "0" "9"))) ((_ re.loop 8 8) (re.range "0" "9")) (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re " ") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re " ") ((_ re.loop 3 3) (re.range "0" "9"))) (re.++ (str.to_re "(0") ((_ re.loop 1 1) (re.range "1" "9")) (str.to_re ") ") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re " ") ((_ re.loop 4 4) (re.range "0" "9"))) (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re " ") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; /^\u{2f}[0-9a-f]+$/iU
(assert (not (str.in_re X (re.++ (str.to_re "//") (re.+ (re.union (re.range "0" "9") (re.range "a" "f"))) (str.to_re "/iU\u{0a}")))))
; \-?(90|[0-8]?[0-9]\.[0-9]{0,6})\,\-?(180|(1[0-7][0-9]|[0-9]{0,2})\.[0-9]{0,6})
(assert (str.in_re X (re.++ (re.opt (str.to_re "-")) (re.union (str.to_re "90") (re.++ (re.opt (re.range "0" "8")) (re.range "0" "9") (str.to_re ".") ((_ re.loop 0 6) (re.range "0" "9")))) (str.to_re ",") (re.opt (str.to_re "-")) (re.union (str.to_re "180") (re.++ (re.union (re.++ (str.to_re "1") (re.range "0" "7") (re.range "0" "9")) ((_ re.loop 0 2) (re.range "0" "9"))) (str.to_re ".") ((_ re.loop 0 6) (re.range "0" "9")))) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
