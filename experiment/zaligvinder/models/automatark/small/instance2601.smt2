(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; [1-9][0-9]
(assert (str.in_re X (re.++ (re.range "1" "9") (re.range "0" "9") (str.to_re "\u{0a}"))))
; (^[A-Z]{1,2}[0-9]{1,}:{1}[A-Z]{1,2}[0-9]{1,}$)|(^\$(([A-Z])|([a-z])){1,2}([0-9]){1,}:{1}\$(([A-Z])|([a-z])){1,2}([0-9]){1,}$)|(^\$(([A-Z])|([a-z])){1,2}(\$){1}([0-9]){1,}:{1}\$(([A-Z])|([a-z])){1,2}(\$){1}([0-9]){1,}$)
(assert (not (str.in_re X (re.union (re.++ ((_ re.loop 1 2) (re.range "A" "Z")) (re.+ (re.range "0" "9")) ((_ re.loop 1 1) (str.to_re ":")) ((_ re.loop 1 2) (re.range "A" "Z")) (re.+ (re.range "0" "9"))) (re.++ (str.to_re "$") ((_ re.loop 1 2) (re.union (re.range "A" "Z") (re.range "a" "z"))) (re.+ (re.range "0" "9")) ((_ re.loop 1 1) (str.to_re ":")) (str.to_re "$") ((_ re.loop 1 2) (re.union (re.range "A" "Z") (re.range "a" "z"))) (re.+ (re.range "0" "9"))) (re.++ (str.to_re "\u{0a}$") ((_ re.loop 1 2) (re.union (re.range "A" "Z") (re.range "a" "z"))) ((_ re.loop 1 1) (str.to_re "$")) (re.+ (re.range "0" "9")) ((_ re.loop 1 1) (str.to_re ":")) (str.to_re "$") ((_ re.loop 1 2) (re.union (re.range "A" "Z") (re.range "a" "z"))) ((_ re.loop 1 1) (str.to_re "$")) (re.+ (re.range "0" "9")))))))
; Test\d+DesktopAddressIDENTIFY666User-Agent\x3A\x5BStatic
(assert (not (str.in_re X (re.++ (str.to_re "Test") (re.+ (re.range "0" "9")) (str.to_re "DesktopAddressIDENTIFY666User-Agent:[Static\u{0a}")))))
(check-sat)
