(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(\d)?[ ]*[\(\.\-]?(\d{3})[\)\.\-]?[ ]*(\d{3})[\.\- ]?(\d{4})[ ]*(x|ext\.?)?[ ]*(\d{1,7})?$
(assert (str.in_re X (re.++ (re.opt (re.range "0" "9")) (re.* (str.to_re " ")) (re.opt (re.union (str.to_re "(") (str.to_re ".") (str.to_re "-"))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re ")") (str.to_re ".") (str.to_re "-"))) (re.* (str.to_re " ")) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re ".") (str.to_re "-") (str.to_re " "))) ((_ re.loop 4 4) (re.range "0" "9")) (re.* (str.to_re " ")) (re.opt (re.union (str.to_re "x") (re.++ (str.to_re "ext") (re.opt (str.to_re "."))))) (re.* (str.to_re " ")) (re.opt ((_ re.loop 1 7) (re.range "0" "9"))) (str.to_re "\u{0a}"))))
; ^([A-Za-z]\d[A-Za-z][-]?\d[A-Za-z]\d)
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}") (re.union (re.range "A" "Z") (re.range "a" "z")) (re.range "0" "9") (re.union (re.range "A" "Z") (re.range "a" "z")) (re.opt (str.to_re "-")) (re.range "0" "9") (re.union (re.range "A" "Z") (re.range "a" "z")) (re.range "0" "9")))))
; Host\x3AHANDYwww\x2Epurityscan\x2Ecom
(assert (str.in_re X (str.to_re "Host:HANDYwww.purityscan.com\u{0a}")))
; ^[A][Z](.?)[0-9]{4}$
(assert (not (str.in_re X (re.++ (str.to_re "AZ") (re.opt re.allchar) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
