(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}skm/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".skm/i\u{0a}")))))
; e2give\.comADRemoteHost\x3A
(assert (str.in_re X (str.to_re "e2give.comADRemoteHost:\u{0a}")))
; myInstance\.myMethod(.*)\(.*myParam.*\)
(assert (not (str.in_re X (re.++ (str.to_re "myInstance.myMethod") (re.* re.allchar) (str.to_re "(") (re.* re.allchar) (str.to_re "myParam") (re.* re.allchar) (str.to_re ")\u{0a}")))))
; ^(([a-zA-Z]:)|(\\{2}\w+)\$?)(\\(\w[\w].*))+(.pdf)$
(assert (not (str.in_re X (re.++ (re.union (re.++ (re.union (re.range "a" "z") (re.range "A" "Z")) (str.to_re ":")) (re.++ (re.opt (str.to_re "$")) ((_ re.loop 2 2) (str.to_re "\u{5c}")) (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))))) (re.+ (re.++ (str.to_re "\u{5c}") (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")) (re.* re.allchar))) (str.to_re "\u{0a}") re.allchar (str.to_re "pdf")))))
(assert (> (str.len X) 10))
(check-sat)
