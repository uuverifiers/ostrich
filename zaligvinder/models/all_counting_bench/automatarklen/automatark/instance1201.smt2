(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; <!--[\\.|\\W|\\w]*?-->
(assert (str.in_re X (re.++ (str.to_re "<!--") (re.* (re.union (str.to_re "\u{5c}") (str.to_re ".") (str.to_re "|") (str.to_re "W") (str.to_re "w"))) (str.to_re "-->\u{0a}"))))
; ProSpywww\x2Eemp3finder\x2Ecomwww
(assert (str.in_re X (str.to_re "ProSpywww.emp3finder.comwww\u{0a}")))
; ^((([A-PR-UWYZ](\d([A-HJKSTUW]|\d)?|[A-HK-Y]\d([ABEHMNPRVWXY]|\d)?))\s*(\d[ABD-HJLNP-UW-Z]{2})?)|GIR\s*0AA)$
(assert (not (str.in_re X (re.++ (re.union (re.++ (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.opt (re.++ (re.range "0" "9") ((_ re.loop 2 2) (re.union (str.to_re "A") (str.to_re "B") (re.range "D" "H") (str.to_re "J") (str.to_re "L") (str.to_re "N") (re.range "P" "U") (re.range "W" "Z"))))) (re.union (re.range "A" "P") (re.range "R" "U") (str.to_re "W") (str.to_re "Y") (str.to_re "Z")) (re.union (re.++ (re.range "0" "9") (re.opt (re.union (re.range "A" "H") (str.to_re "J") (str.to_re "K") (str.to_re "S") (str.to_re "T") (str.to_re "U") (str.to_re "W") (re.range "0" "9")))) (re.++ (re.union (re.range "A" "H") (re.range "K" "Y")) (re.range "0" "9") (re.opt (re.union (str.to_re "A") (str.to_re "B") (str.to_re "E") (str.to_re "H") (str.to_re "M") (str.to_re "N") (str.to_re "P") (str.to_re "R") (str.to_re "V") (str.to_re "W") (str.to_re "X") (str.to_re "Y") (re.range "0" "9")))))) (re.++ (str.to_re "GIR") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "0AA"))) (str.to_re "\u{0a}")))))
; Host\u{3a}[^\n\r]*A-311\s+lnzzlnbk\u{2f}pkrm\.finSubject\u{3a}Basic
(assert (not (str.in_re X (re.++ (str.to_re "Host:") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "A-311") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "lnzzlnbk/pkrm.finSubject:Basic\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
