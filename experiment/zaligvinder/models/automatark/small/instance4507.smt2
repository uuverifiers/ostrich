(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[0-9]{6}-[0-9pPtTfF][0-9]{3}$
(assert (not (str.in_re X (re.++ ((_ re.loop 6 6) (re.range "0" "9")) (str.to_re "-") (re.union (re.range "0" "9") (str.to_re "p") (str.to_re "P") (str.to_re "t") (str.to_re "T") (str.to_re "f") (str.to_re "F")) ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; /\u{2e}setTimeOut\s*\u{28}\s*[\u{22}\u{27}][^\u{28}]+?\u{2e}closeDoc\s*\u{28}[^\u{29}]*?\u{29}[^\u{28}]+?\u{2e}openDoc\s*\u{28}[^\u{29}]*?\u{29}[^\u{29}]*?[\u{22}\u{27}]\s*,\s*[^\u{29}]*?\u{29}/i
(assert (str.in_re X (re.++ (str.to_re "/.setTimeOut") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "(") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.union (str.to_re "\u{22}") (str.to_re "'")) (re.+ (re.comp (str.to_re "("))) (str.to_re ".closeDoc") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "(") (re.* (re.comp (str.to_re ")"))) (str.to_re ")") (re.+ (re.comp (str.to_re "("))) (str.to_re ".openDoc") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "(") (re.* (re.comp (str.to_re ")"))) (str.to_re ")") (re.* (re.comp (str.to_re ")"))) (re.union (str.to_re "\u{22}") (str.to_re "'")) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re ",") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.* (re.comp (str.to_re ")"))) (str.to_re ")/i\u{0a}"))))
; ^([a-zA-Z0-9])+\\{1}([a-zA-Z0-9])+$
(assert (str.in_re X (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) ((_ re.loop 1 1) (str.to_re "\u{5c}")) (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "\u{0a}"))))
; ^((0[1-9])|(1[0-2]))$
(assert (not (str.in_re X (re.++ (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "2"))) (str.to_re "\u{0a}")))))
; DigExtNetBus\x5BStatic
(assert (str.in_re X (str.to_re "DigExtNetBus[Static\u{0a}")))
(check-sat)
