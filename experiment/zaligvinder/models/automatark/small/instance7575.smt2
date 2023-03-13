(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(smtp)\.([\w\-]+)\.[\w\-]{2,3}$
(assert (str.in_re X (re.++ (str.to_re "smtp.") (re.+ (re.union (str.to_re "-") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re ".") ((_ re.loop 2 3) (re.union (str.to_re "-") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "\u{0a}"))))
; /(^|&)destination_ip=[^&]*?(\u{60}|\u{24}\u{28}|%60|%24%28)/Pmi
(assert (str.in_re X (re.++ (str.to_re "/&destination_ip=") (re.* (re.comp (str.to_re "&"))) (re.union (str.to_re "`") (str.to_re "$(") (str.to_re "%60") (str.to_re "%24%28")) (str.to_re "/Pmi\u{0a}"))))
(check-sat)
