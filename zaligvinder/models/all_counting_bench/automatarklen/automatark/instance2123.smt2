(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (\(")([0-9]*)(\")
(assert (str.in_re X (re.++ (str.to_re "(\u{22}") (re.* (re.range "0" "9")) (str.to_re "\u{22}\u{0a}"))))
; Windows\x2Fclient\x2FBlackreportc\.goclick\.comX-Sender\x3A
(assert (not (str.in_re X (str.to_re "Windows/client/Blackreportc.goclick.comX-Sender:\u{13}\u{0a}"))))
; ^[\w_.]{5,12}$
(assert (not (str.in_re X (re.++ ((_ re.loop 5 12) (re.union (str.to_re "_") (str.to_re ".") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "\u{0a}")))))
; \w+@\w+\.\w+
(assert (not (str.in_re X (re.++ (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "@") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re ".") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
