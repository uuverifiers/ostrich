(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /(^|&)destination_ip=[^&]*?(\u{60}|\u{24}\u{28}|%60|%24%28)/Pmi
(assert (not (str.in_re X (re.++ (str.to_re "/&destination_ip=") (re.* (re.comp (str.to_re "&"))) (re.union (str.to_re "`") (str.to_re "$(") (str.to_re "%60") (str.to_re "%24%28")) (str.to_re "/Pmi\u{0a}")))))
; ^-?([1]?[1-7][1-9]|[1]?[1-8][0]|[1-9]?[0-9])\.{1}\d{1,6}
(assert (not (str.in_re X (re.++ (re.opt (str.to_re "-")) (re.union (re.++ (re.opt (str.to_re "1")) (re.range "1" "7") (re.range "1" "9")) (re.++ (re.opt (str.to_re "1")) (re.range "1" "8") (str.to_re "0")) (re.++ (re.opt (re.range "1" "9")) (re.range "0" "9"))) ((_ re.loop 1 1) (str.to_re ".")) ((_ re.loop 1 6) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(check-sat)
