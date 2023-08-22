(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; media\x2Edxcdirect\x2Ecom\.smx\?PASSW=SAHHost\x3AProAgentIDENTIFY
(assert (not (str.in_re X (str.to_re "media.dxcdirect.com.smx?PASSW=SAHHost:ProAgentIDENTIFY\u{0a}"))))
; ^(\d{1}|\d{2}|\d{3})(\.\d{3})*?$
(assert (not (str.in_re X (re.++ (re.union ((_ re.loop 1 1) (re.range "0" "9")) ((_ re.loop 2 2) (re.range "0" "9")) ((_ re.loop 3 3) (re.range "0" "9"))) (re.* (re.++ (str.to_re ".") ((_ re.loop 3 3) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
; ^\${1}[a-z]{1}[a-z\d]{0,6}$
(assert (str.in_re X (re.++ ((_ re.loop 1 1) (str.to_re "$")) ((_ re.loop 1 1) (re.range "a" "z")) ((_ re.loop 0 6) (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
