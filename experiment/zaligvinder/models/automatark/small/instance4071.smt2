(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (^([1-3]{1}[0-9]{0,}(\.[0-9]{1})?|0(\.[0-9]{1})?|[4]{1}[0-9]{0,}(\.[0]{1})?|5(\.[5]{1}))$)
(assert (str.in_re X (re.++ (re.union (re.++ ((_ re.loop 1 1) (re.range "1" "3")) (re.* (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 1) (re.range "0" "9"))))) (re.++ (str.to_re "0") (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 1) (re.range "0" "9"))))) (re.++ ((_ re.loop 1 1) (str.to_re "4")) (re.* (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 1) (str.to_re "0"))))) (re.++ (str.to_re "5.") ((_ re.loop 1 1) (str.to_re "5")))) (str.to_re "\u{0a}"))))
; Host\u{3a}\dATTENTION\x3A[^\n\r]*From\x3AUser-Agent\x3A
(assert (str.in_re X (re.++ (str.to_re "Host:") (re.range "0" "9") (str.to_re "ATTENTION:") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "From:User-Agent:\u{0a}"))))
(check-sat)
