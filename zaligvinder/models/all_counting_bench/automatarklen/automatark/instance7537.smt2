(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[0-9a-zA-z]{3}$
(assert (not (str.in_re X (re.++ ((_ re.loop 3 3) (re.union (re.range "0" "9") (re.range "a" "z") (re.range "A" "z"))) (str.to_re "\u{0a}")))))
; (\b)(\w+(\b|\n|\s)){3}
(assert (not (str.in_re X (re.++ ((_ re.loop 3 3) (re.++ (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.union (str.to_re "\u{0a}") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")))) (str.to_re "\u{0a}")))))
; /\u{2e}setTimeOut\s*\u{28}\s*[\u{22}\u{27}][^\u{28}]+?\u{2e}closeDoc\s*\u{28}[^\u{29}]*?\u{29}[^\u{28}]+?\u{2e}openDoc\s*\u{28}[^\u{29}]*?\u{29}[^\u{29}]*?[\u{22}\u{27}]\s*,\s*[^\u{29}]*?\u{29}/i
(assert (str.in_re X (re.++ (str.to_re "/.setTimeOut") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "(") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.union (str.to_re "\u{22}") (str.to_re "'")) (re.+ (re.comp (str.to_re "("))) (str.to_re ".closeDoc") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "(") (re.* (re.comp (str.to_re ")"))) (str.to_re ")") (re.+ (re.comp (str.to_re "("))) (str.to_re ".openDoc") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "(") (re.* (re.comp (str.to_re ")"))) (str.to_re ")") (re.* (re.comp (str.to_re ")"))) (re.union (str.to_re "\u{22}") (str.to_re "'")) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re ",") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.* (re.comp (str.to_re ")"))) (str.to_re ")/i\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
