(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; User-Agent\x3A\dBarwww\x2Eaccoona\x2Ecom
(assert (str.in_re X (re.++ (str.to_re "User-Agent:") (re.range "0" "9") (str.to_re "Barwww.accoona.com\u{0a}"))))
; ^[2-9]{2}[0-9]{8}$
(assert (str.in_re X (re.++ ((_ re.loop 2 2) (re.range "2" "9")) ((_ re.loop 8 8) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(check-sat)
