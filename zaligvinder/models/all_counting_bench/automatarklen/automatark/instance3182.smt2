(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\u{2f}[A-F0-9]{158}/U
(assert (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 158 158) (re.union (re.range "A" "F") (re.range "0" "9"))) (str.to_re "/U\u{0a}"))))
; Fictional\sHost\x3AWordmyway\.com
(assert (not (str.in_re X (re.++ (str.to_re "Fictional") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "Host:Wordmyway.com\u{0a}")))))
; (^(2014)|^(2149))\d{11}$
(assert (str.in_re X (re.++ (re.union (str.to_re "2014") (str.to_re "2149")) ((_ re.loop 11 11) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
