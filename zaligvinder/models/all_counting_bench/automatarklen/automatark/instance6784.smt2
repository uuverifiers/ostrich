(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^\d{4,}$|^[3-9]\d{2}$|^2[5-9]\d$
(assert (str.in_re X (re.union (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (re.* (re.range "0" "9"))) (re.++ (re.range "3" "9") ((_ re.loop 2 2) (re.range "0" "9"))) (re.++ (str.to_re "2") (re.range "5" "9") (re.range "0" "9") (str.to_re "\u{0a}")))))
; /^\/\d+$/Ui
(assert (str.in_re X (re.++ (str.to_re "//") (re.+ (re.range "0" "9")) (str.to_re "/Ui\u{0a}"))))
; e2give\.comConnectionSpywww\x2Eslinkyslate
(assert (not (str.in_re X (str.to_re "e2give.comConnectionSpywww.slinkyslate\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
