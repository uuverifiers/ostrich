(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[SC]{2}[0-9]{6}$
(assert (str.in_re X (re.++ ((_ re.loop 2 2) (re.union (str.to_re "S") (str.to_re "C"))) ((_ re.loop 6 6) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; ^(\w+)s?[:]\/\/(\w+)?[.]?(\w+)[.](\w+)$
(assert (not (str.in_re X (re.++ (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.opt (str.to_re "s")) (str.to_re "://") (re.opt (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")))) (re.opt (str.to_re ".")) (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re ".") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "\u{0a}")))))
; \x7D\x7BSysuptime\x3A\d+\x2Fcommunicatortb
(assert (not (str.in_re X (re.++ (str.to_re "}{Sysuptime:") (re.+ (re.range "0" "9")) (str.to_re "/communicatortb\u{0a}")))))
; \x2APORT1\x2AWarezX-Mailer\x3ASnake\x2Fbonzibuddy\x2F
(assert (str.in_re X (str.to_re "*PORT1*WarezX-Mailer:\u{13}Snake/bonzibuddy/\u{0a}")))
(assert (> (str.len X) 10))
(check-sat)
