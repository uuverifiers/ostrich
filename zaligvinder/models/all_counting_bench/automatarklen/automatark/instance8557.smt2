(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; [a-zA-Z][a-zA-Z0-9_\-\,\.]{5,31}
(assert (str.in_re X (re.++ (re.union (re.range "a" "z") (re.range "A" "Z")) ((_ re.loop 5 31) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_") (str.to_re "-") (str.to_re ",") (str.to_re "."))) (str.to_re "\u{0a}"))))
; /\.php\?j=1&k=[0-9](i=[0-9])?$/U
(assert (not (str.in_re X (re.++ (str.to_re "/.php?j=1&k=") (re.range "0" "9") (re.opt (re.++ (str.to_re "i=") (re.range "0" "9"))) (str.to_re "/U\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
