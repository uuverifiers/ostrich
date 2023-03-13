(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; nethttp\x3A\x2F\x2FsupremetoolbarPORT\x3D
(assert (not (str.in_re X (str.to_re "nethttp://supremetoolbarPORT=\u{0a}"))))
; ^[AaWaKkNn][a-zA-Z]?[0-9][a-zA-Z]{1,3}$
(assert (not (str.in_re X (re.++ (re.union (str.to_re "A") (str.to_re "a") (str.to_re "W") (str.to_re "K") (str.to_re "k") (str.to_re "N") (str.to_re "n")) (re.opt (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.range "0" "9") ((_ re.loop 1 3) (re.union (re.range "a" "z") (re.range "A" "Z"))) (str.to_re "\u{0a}")))))
; ^(((0|128|192|224|240|248|252|254).0.0.0)|(255.(0|128|192|224|240|248|252|254).0.0)|(255.255.(0|128|192|224|240|248|252|254).0)|(255.255.255.(0|128|192|224|240|248|252|254)))$
(assert (not (str.in_re X (re.++ (re.union (re.++ (re.union (str.to_re "0") (str.to_re "128") (str.to_re "192") (str.to_re "224") (str.to_re "240") (str.to_re "248") (str.to_re "252") (str.to_re "254")) re.allchar (str.to_re "0") re.allchar (str.to_re "0") re.allchar (str.to_re "0")) (re.++ (str.to_re "255") re.allchar (re.union (str.to_re "0") (str.to_re "128") (str.to_re "192") (str.to_re "224") (str.to_re "240") (str.to_re "248") (str.to_re "252") (str.to_re "254")) re.allchar (str.to_re "0") re.allchar (str.to_re "0")) (re.++ (str.to_re "255") re.allchar (str.to_re "255") re.allchar (re.union (str.to_re "0") (str.to_re "128") (str.to_re "192") (str.to_re "224") (str.to_re "240") (str.to_re "248") (str.to_re "252") (str.to_re "254")) re.allchar (str.to_re "0")) (re.++ (str.to_re "255") re.allchar (str.to_re "255") re.allchar (str.to_re "255") re.allchar (re.union (str.to_re "0") (str.to_re "128") (str.to_re "192") (str.to_re "224") (str.to_re "240") (str.to_re "248") (str.to_re "252") (str.to_re "254")))) (str.to_re "\u{0a}")))))
; ^[0-9]{4}\s{0,2}[a-zA-z]{2}$
(assert (str.in_re X (re.++ ((_ re.loop 4 4) (re.range "0" "9")) ((_ re.loop 0 2) (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 2 2) (re.union (re.range "a" "z") (re.range "A" "z"))) (str.to_re "\u{0a}"))))
(check-sat)
