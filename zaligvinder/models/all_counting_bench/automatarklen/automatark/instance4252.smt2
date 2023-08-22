(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; are\d+X-Mailer\u{3a}+\d+v=User-Agent\u{3a}
(assert (not (str.in_re X (re.++ (str.to_re "are") (re.+ (re.range "0" "9")) (str.to_re "X-Mailer") (re.+ (str.to_re ":")) (re.+ (re.range "0" "9")) (str.to_re "v=User-Agent:\u{0a}")))))
; (.|[\r\n]){1,5}
(assert (str.in_re X (re.++ ((_ re.loop 1 5) (re.union re.allchar (str.to_re "\u{0d}") (str.to_re "\u{0a}"))) (str.to_re "\u{0a}"))))
; ^([A-Z]{0,3}?[0-9]{9}($[0-9]{0}|[A-Z]{1}))
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") ((_ re.loop 0 3) (re.range "A" "Z")) ((_ re.loop 9 9) (re.range "0" "9")) (re.union ((_ re.loop 0 0) (re.range "0" "9")) ((_ re.loop 1 1) (re.range "A" "Z"))))))
; \A([0-9a-zA-Z_]{1,15})|(@([0-9a-zA-Z_]{1,15}))\Z
(assert (not (str.in_re X (re.union ((_ re.loop 1 15) (re.union (re.range "0" "9") (re.range "a" "z") (re.range "A" "Z") (str.to_re "_"))) (re.++ (str.to_re "\u{0a}@") ((_ re.loop 1 15) (re.union (re.range "0" "9") (re.range "a" "z") (re.range "A" "Z") (str.to_re "_"))))))))
(assert (> (str.len X) 10))
(check-sat)
