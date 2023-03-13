(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \u{22}Thewebsearch\.getmirar\.com
(assert (str.in_re X (str.to_re "\u{22}Thewebsearch.getmirar.com\u{0a}")))
; to\d+User-Agent\x3AFiltered
(assert (str.in_re X (re.++ (str.to_re "to") (re.+ (re.range "0" "9")) (str.to_re "User-Agent:Filtered\u{0a}"))))
; ^(([0-9]{2})|([a-zA-Z][0-9])|([a-zA-Z]{2}))[0-9]{6}$
(assert (str.in_re X (re.++ (re.union ((_ re.loop 2 2) (re.range "0" "9")) (re.++ (re.union (re.range "a" "z") (re.range "A" "Z")) (re.range "0" "9")) ((_ re.loop 2 2) (re.union (re.range "a" "z") (re.range "A" "Z")))) ((_ re.loop 6 6) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(check-sat)
