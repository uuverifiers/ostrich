(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (\d{1,3},(\d{3},)*\d{3}(\.\d{1,3})?|\d{1,3}(\.\d{3})?)$
(assert (not (str.in_re X (re.++ (re.union (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ",") (re.* (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ","))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9"))))) (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 3 3) (re.range "0" "9")))))) (str.to_re "\u{0a}")))))
; YAHOO.*Host\x3A.*\x2Fcs\x2Fpop4\x2F
(assert (str.in_re X (re.++ (str.to_re "YAHOO") (re.* re.allchar) (str.to_re "Host:") (re.* re.allchar) (str.to_re "/cs/pop4/\u{0a}"))))
; /\u{28}compatible\u{3b}[A-Z]*\u{3b}\u{29}\u{0d}\u{0a}/H
(assert (str.in_re X (re.++ (str.to_re "/(compatible;") (re.* (re.range "A" "Z")) (str.to_re ";)\u{0d}\u{0a}/H\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
