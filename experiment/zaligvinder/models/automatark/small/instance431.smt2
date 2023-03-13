(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; www\x2Ericercadoppia\x2Ecom[^\n\r]*xml\s+User-Agent\x3A
(assert (str.in_re X (re.++ (str.to_re "www.ricercadoppia.com") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "xml") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "User-Agent:\u{0a}"))))
; [\t ]+
(assert (not (str.in_re X (re.++ (re.+ (re.union (str.to_re "\u{09}") (str.to_re " "))) (str.to_re "\u{0a}")))))
; (0?[1-9]|[12][0-9]|3[01])[/ -](0?[1-9]|1[12])[/ -](19[0-9]{2}|[2][0-9][0-9]{2})
(assert (str.in_re X (re.++ (re.union (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (re.union (str.to_re "1") (str.to_re "2")) (re.range "0" "9")) (re.++ (str.to_re "3") (re.union (str.to_re "0") (str.to_re "1")))) (re.union (str.to_re "/") (str.to_re " ") (str.to_re "-")) (re.union (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (str.to_re "1") (re.union (str.to_re "1") (str.to_re "2")))) (re.union (str.to_re "/") (str.to_re " ") (str.to_re "-")) (re.union (re.++ (str.to_re "19") ((_ re.loop 2 2) (re.range "0" "9"))) (re.++ (str.to_re "2") (re.range "0" "9") ((_ re.loop 2 2) (re.range "0" "9")))) (str.to_re "\u{0a}"))))
; ^[1-9]{1}$|^[1-4]{1}[0-9]{1}$|^50$
(assert (not (str.in_re X (re.union ((_ re.loop 1 1) (re.range "1" "9")) (re.++ ((_ re.loop 1 1) (re.range "1" "4")) ((_ re.loop 1 1) (re.range "0" "9"))) (str.to_re "50\u{0a}")))))
(check-sat)
