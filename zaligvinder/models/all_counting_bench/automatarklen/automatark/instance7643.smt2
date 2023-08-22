(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (^\d{5}\x2D\d{3}$)
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 3 3) (re.range "0" "9")))))
; ^(((0|128|192|224|240|248|252|254).0.0.0)|(255.(0|128|192|224|240|248|252|254).0.0)|(255.255.(0|128|192|224|240|248|252|254).0)|(255.255.255.(0|128|192|224|240|248|252|254)))$
(assert (str.in_re X (re.++ (re.union (re.++ (re.union (str.to_re "0") (str.to_re "128") (str.to_re "192") (str.to_re "224") (str.to_re "240") (str.to_re "248") (str.to_re "252") (str.to_re "254")) re.allchar (str.to_re "0") re.allchar (str.to_re "0") re.allchar (str.to_re "0")) (re.++ (str.to_re "255") re.allchar (re.union (str.to_re "0") (str.to_re "128") (str.to_re "192") (str.to_re "224") (str.to_re "240") (str.to_re "248") (str.to_re "252") (str.to_re "254")) re.allchar (str.to_re "0") re.allchar (str.to_re "0")) (re.++ (str.to_re "255") re.allchar (str.to_re "255") re.allchar (re.union (str.to_re "0") (str.to_re "128") (str.to_re "192") (str.to_re "224") (str.to_re "240") (str.to_re "248") (str.to_re "252") (str.to_re "254")) re.allchar (str.to_re "0")) (re.++ (str.to_re "255") re.allchar (str.to_re "255") re.allchar (str.to_re "255") re.allchar (re.union (str.to_re "0") (str.to_re "128") (str.to_re "192") (str.to_re "224") (str.to_re "240") (str.to_re "248") (str.to_re "252") (str.to_re "254")))) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
